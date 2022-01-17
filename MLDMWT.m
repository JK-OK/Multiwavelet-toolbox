%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Multiwavelet toolbox, a toolbox for performing Multiwavelet transform   %
% Copyright (C) 2022  Jozef Kromka, Ondrej Kováč                          %
%                                                                         %
% This program is free software: you can redistribute it and/or modify    %
% it under the terms of the GNU General Public License as published by    %
% the Free Software Foundation, either version 3 of the License, or       %
% (at your option) any later version.                                     %
%                                                                         %
% This program is distributed in the hope that it will be useful,         %
% but WITHOUT ANY WARRANTY; without even the implied warranty of          %
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           %
% GNU General Public License for more details.                            %
%                                                                         %
% You should have received a copy of the GNU General Public License       %
% along with this program.  If not, see <https://www.gnu.org/licenses/>.  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If this software is used to make a contribution to the findings         %
% published in an article, then  please consider citing our conference    %
% paper, from which this toolbox originates. You can find the citation at %
% https://github.com/JK-OK/Multiwavelet-toolbox                           %
% You can find there the contact information for authors as well.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function coef = MLDMWT(in, multiwavelet, level, varargin)
% MLDMWT implements Multilevel Multiwavelet transform of required
% level
% Input variables:
% in: input signal (must be at least 4*2^level)
% multiwavelet: multiwavelet used for implementing DMWT (as string)
% varargin: It is possible to define custom extension according to MATLAB
% extensions. If not defined then periodic extension will be used
% Output variables:
% coef: ordered output coefficients stored in cell variable
% Examples:
% outCoef = MLDMWT(in, 'CL03', 3)
% outCoef = MLDMWT(in, 'BAT01', 4, 'zp0')

% Load Multiwavelet from string representation
multiwavelet = loadMW(multiwavelet);

% Creating output variable and calculating size of input signal
coef = {}; %#ok<NASGU>
n = size(in, 2);
% Checkig input signal size
n = n / 2;
for i = 2:level
    if mod(n, 8) ~= 0
        ME = MException('TMLDMWT:wrongDataLength', ...
            ['Minimul size of a input signal must be 4*2^level,' ...
            'and after dividing by 2 for each level the length must be dividable by 8.']);
        throw(ME);
    end
    n = n / 2;
end

% Perform first level of DMWT
if multiwavelet.reorder == 0
    [c11, c12, d11, d12] = fast_DMWT(in,multiwavelet,varargin{:});
else
    [c12, d11, d12, c11] = fast_DMWT(in,multiwavelet,varargin{:});
end
% organize coefficients
coef = {c11; c12; d11; d12};

% Perform for every level
for i = 2:level
    % Calculate number of coefficients and new number of coefficients
    n = size(coef, 1);
    newcoef = cell(n+2, 1);
    newcoef(3:end) = coef;
    k = 1;
    % merge c11 and c12 (d11 and d12) subbands and perfrom DMWT
    sub = upsample(coef{1}, 2, 0) + upsample(coef{2}, 2, 1);
    if multiwavelet.reorder == 0
        [c11, c12, d11, d12] = fast_DMWT(sub,multiwavelet,varargin{:});
    else
        [c12, d11, d12, c11] = fast_DMWT(sub,multiwavelet,varargin{:});
    end
    % Add coefficients to output variable
    newcoef{k} = c11;
    newcoef{k+1} = c12;
    newcoef{k+2} = d11;
    newcoef{k+3} = d12;
    coef = newcoef;
end

end
