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

function mat = DMWTMatrix(n, multiwavelet, organized, varargin)
% DMWTMatrix creates DMWT transformation matrix of selected size and
% multiwavelet
% Input variables:
% n: required size of transformation matrix
% multiwavelet: multiwavelet used for creating transformation matrix
% organized: If selected True the coeficients of a matrix will be organized
% in following way
% c11, c11, ..., c12, c12, ..., d11, d11, ..., d12, d12, ...
% if selected False then the coeficients of a matrix will be organized
% in following way
% c11, c12, d11, d12, c11, c12, d11, d12, ...
% varargin: It is possible to define custom extension according to MATLAB
% extensions. If not defined then periodic extension will be used
% Output variables:
% mat: DMWT transformation matrix with size of n * n
% Examples:
% mat = DMWTMatrix(512, 'BAT03', true);
% mat = DMWTMatrix(64, 'DB6', false, 'ppd');

multiwavelet = loadMW(multiwavelet);

% Create eye matrix of required size
mat = eye(n);

% Create transformation matrix row by row
for i = 1:size(mat, 2)

    % Select one row of eye matrix and apply DMWT on it
    vec = mat(:, i);
    if multiwavelet.reorder == 0
        [c11, c12, d11, d12] = fast_DMWT(vec',multiwavelet,varargin{:});
    else
        [c12, d11, d12, c11] = fast_DMWT(vec',multiwavelet,varargin{:});
    end

    % Organize coefficient in required way.
    if organized
        vec = [c11, c12, d11, d12]';
        %         vec = [upsample(c11, 2, 0) + upsample(c12, 2, 1), upsample(d11, 2, 0) + upsample(d12, 2, 1)];
    else
        vec = upsample(c11, 4, 0) + upsample(c12, 4, 1) + upsample(d11, 4, 2) + upsample(d12, 4, 3);
        vec = vec';
    end

    % Write organized coefficients to output matrix
    mat(:, i) = vec;
end

end