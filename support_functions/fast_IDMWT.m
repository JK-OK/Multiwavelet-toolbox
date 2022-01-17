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

function out = fast_IDMWT(c11, c12, d11, d12, multiwavelet, varargin)
% IDMWT implements the inverse discrete multiwavelet transform using the
% four-channel single filter bank, but without loading multiwavelet from
% string
% Input variables:
% c11, c12, d11, d12: multiscaling and multiwavelet coefficients
% multiwavelet: multiwavelet used for implementing DMWT (as string)
% varargin: It is possible to define custom extension according to MATLAB
% extensions. If not defined then periodic extension will be used
% Output variables:
% out: output reconstructed signal
% Examples:
% output = IDMWT(c11, c12, d11, d12, 'CL02');
% output = IDMWT(c11, c12, d11, d12, 'BAT01', 'zpd');

% Handling the extension. If wasnt defined choose periodic, otherwise try
% to load defined extension. If defined extension doesnt exist throw and
% exception
if isempty(varargin)
    extension = 'per';
else
    extension = varargin{1};
    try
        wextend('ac', extension, [1 2 1], 2);
    catch 
        ME = MException('IDMWT:wrongExtension',...
            'Extension name doesnt exist!');
        throw(ME);
    end
end

% Calculating reconstructed signal length
orgSize = size(c11, 2)*4;

% Loading the four-channel single filter bank response coeficients
G0 = flip(multiwavelet.S4KF{1});
G1 = flip(multiwavelet.S4KF{2});
G2 = flip(multiwavelet.S4KF{3});
G3 = flip(multiwavelet.S4KF{4});

% applying the extension on input coeficients
ad = length(G0);
c11 = wextend('ac', extension, c11, ad);
c12 = wextend('ac', extension, c12, ad);
d11 = wextend('ac', extension, d11, ad);
d12 = wextend('ac', extension, d12, ad);

% Interpolating input coeficient by interpolation factor 4
c11 = upsample(c11', 4)';
c12 = upsample(c12', 4)';
d11 = upsample(d11', 4)';
d12 = upsample(d12', 4)';


% Calculating length of output signal after convolution and creating
% variables with calculated length
outLen = conv(c11(1, :), G0, 'full');
c11_i = zeros(size(c11, 1), size(outLen, 2));
c12_i = zeros(size(c12, 1), size(outLen, 2));
d11_i = zeros(size(d11, 1), size(outLen, 2));
d12_i = zeros(size(d12, 1), size(outLen, 2));

% Performing convolution of input coeficients and response coeficients of
% four-channel single filter bank
for j = 1:size(c11, 1)
    c11_i(j, :) = conv(c11(j, :), G0, 'full');
    c12_i(j, :) = conv(c12(j, :), G1, 'full');
    d11_i(j, :) = conv(d11(j, :), G2, 'full');
    d12_i(j, :) = conv(d12(j, :), G3, 'full');
end

% Removing applied extension
li = orgSize;
l = size(c11_i, 2);
o = (l - li -1 )/2;
c11_i = c11_i(:, o+1:end-o-1);
c12_i = c12_i(:, o+1:end-o-1);
d11_i = d11_i(:, o+1:end-o-1);
d12_i = d12_i(:, o+1:end-o-1);

% Reconstructing signal from calculated parts.
out = c11_i + c12_i + d11_i + d12_i;
end