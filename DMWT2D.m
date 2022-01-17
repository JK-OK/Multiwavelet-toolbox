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
% published in an article, then please consider citing our conference     %
% paper, from which this toolbox originates. You can find the citation at %
% https://github.com/JK-OK/Multiwavelet-toolbox                           %
% You can find there the contact information for authors as well.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function out = DMWT2D(in, multiwavelet, varargin)
% DMWT2D implements the discrete multiwavelet transform of a 2D signal
% using the four-channel single filter bank.
% Input variables:
% in: input 2D signal (both dimension must be dividable by 8)
% multiwavelet: multiwavelet used for implementing DMWT (as string)
% varargin: It is possible to define custom extension according to MATLAB
% extensions. If not defined then periodic extension will be used
% Output variables:
% out: transformed 2D signal
% Examples:
% output2D = DMWT2D(input2D, 'BAT02');
% output2D = DMWT2D(input2D, 'SA4', 'sp0');

% Applying DMWT on the row of a 2D signal
[c11, c12, d11, d12] = DMWT(in,multiwavelet,varargin{:});

% Connecting subbands and transpose
out = [c11, c12, d11, d12]';

% Applying DMWT on the colums of a 2D signal
[c11, c12, d11, d12] = DMWT(out,multiwavelet,varargin{:});

% Connecting subbands and transpose
out = [c11, c12, d11, d12]';

% If multiwavelet create subbands in different order then reorder it
if loadMW(multiwavelet).reorder == 1
    reo = divideToSub(out);
    reo = [reo(:, 4), reo(:, 1:3)];
    reo = [reo(4, :); reo(1:3, :)];
    out = mergeSub(reo);
end

end