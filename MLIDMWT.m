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

function out = MLIDMWT(coef, multiwavelet, level, varargin)
% MLIDMWT implements Multilevel inversed Multiwavelet transform of
% required level
% Input variables:
% coef: transformed coefficients obtained by TMLDMWT
% multiwavelet: multiwavelet used for implementing DMWT (as string)
% varargin: It is possible to define custom extension according to MATLAB
% extensions. If not defined then periodic extension will be used
% Output variables:
% out: reconstructed signal
% Examples:
% output = MLIDMWT(InCoef, 'BAT01', 2)
% output = MLIDMWT(InCoef, 'DB5', 5, 'asym')

% Load Multiwavelet from string representation
multiwavelet = loadMW(multiwavelet);

% Creating output variable and calculating number of coefficients
out = {};
n = size(coef, 1);

% Checking coefficients size
if mod(n, (2*level+2)) ~= 0
    ME = MException('ITMLDMWT:wrongDataLength', ...
        ['Number of input coefficients must be dividable by 4,' ...
        ' and minimal number of input coefficients must be accroding to 2*level+2']);
    throw(ME);
end

% Perform for each level
for i = 1:level
    % Calculate size of output cell
    out = cell(n-2, 1);
    % If it is there only 4 coefficients
    if n == 4
        % Perform IDMWT for last coefficients
        if multiwavelet.reorder == 0
            out = fast_IDMWT(coef{1}, coef{2}, coef{3}, coef{4}, multiwavelet, varargin{:});
        else
            out = fast_IDMWT(coef{2}, coef{3}, coef{4}, coef{1}, multiwavelet, varargin{:});
        end
    else
        % Perfrom IDMWT for each part of coefficients
        if multiwavelet.reorder == 0
            temp = fast_IDMWT(coef{1}, coef{2}, coef{3}, coef{4}, multiwavelet, varargin{:});
        else
            temp = fast_IDMWT(coef{2}, coef{3}, coef{4}, coef{1}, multiwavelet, varargin{:});
        end
        out{1} = downsample(temp, 2, 0);
        out{2} = downsample(temp, 2, 1);
        out(3:end) = coef(5:end);
        n = n -2;
        coef = out;
    end

end

end
