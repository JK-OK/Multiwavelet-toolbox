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

function [c11, c12, d11, d12] = fast_DMWT(in, multiwavelet, varargin)
% fast_DMWT implements the discrete multiwavelet transform using the
% four-channel single filter bank, but without loading multiwavelet from
% string
% Input variables:
% in: input signal (must be dividable by 8)
% multiwavelet: multiwavelet used for implementing DMWT (as string)
% varargin: It is possible to define custom extension according to MATLAB
% extensions. If not defined then periodic extension will be used
% Output variables:
% c11, c12, d11, d12: multiscaling and multiwavelet coefficients
% Examples:
% [c11, c12, d11, d12] = DMWT(signal, 'DGHM');
% [c11, c12, d11, d12] = DMWT(signal, 'DB2', 'sym');

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
        ME = MException('IDMWT:wrongExtension', ...
            'Extension name doesnt exist!');
        throw(ME);
    end
end

% Checking if the input singal is dividable by 8
if ((mod(size(in, 2),8) ~= 0))
    ME = MException('IDMWT:wrongDataLength', ...
        'Input signal should be dividable by 8');
    throw(ME);
end

% Loading the four-channel single filter bank response coeficients
G0 = multiwavelet.S4KF{1};
G1 = multiwavelet.S4KF{2};
G2 = multiwavelet.S4KF{3};
G3 = multiwavelet.S4KF{4};

% applying the extension on input signal
ad = length(G0);
extin = wextend('ac', extension, in, ad);

% Calculating length of output signal after convolution and creating
% variables with calculated length
outLen = conv(extin(1, :), G0, 'full');
c11_c = zeros(size(extin, 1), size(outLen, 2));
c12_c = zeros(size(extin, 1), size(outLen, 2));
d11_c = zeros(size(extin, 1), size(outLen, 2));
d12_c = zeros(size(extin, 1), size(outLen, 2));

% Performing convolution of input signal and response coeficients of
% four-channel single filter bank
for i = 1:size(extin, 1)
    c11_c(i, :) = conv(extin(i, :), G0, 'full');
    c12_c(i, :) = conv(extin(i, :), G1, 'full');
    d11_c(i, :) = conv(extin(i, :), G2, 'full');
    d12_c(i, :) = conv(extin(i, :), G3, 'full');
end

% Removing applied extension
li = size(in, 2);
l = size(c11_c, 2);
o = (l - li -1 )/2;
c11_c = c11_c(:, o+2:end-o);
c12_c = c12_c(:, o+2:end-o);
d11_c = d11_c(:, o+2:end-o);
d12_c = d12_c(:, o+2:end-o);

% Calculating output coefficient length and creating variables with
% calculated length
outLen = downsample(c11_c(1, :), 4);
c11 = zeros(size(extin, 1), size(outLen, 2));
c12 = zeros(size(extin, 1), size(outLen, 2));
d11 = zeros(size(extin, 1), size(outLen, 2));
d12 = zeros(size(extin, 1), size(outLen, 2));

% Decimating output coeficient by decimation factor 4
for i = 1:size(extin, 1)
    c11(i, :) = downsample(c11_c(i, :), 4);
    c12(i, :) = downsample(c12_c(i, :), 4);
    d11(i, :) = downsample(d11_c(i, :), 4);
    d12(i, :) = downsample(d12_c(i, :), 4);
end

end

