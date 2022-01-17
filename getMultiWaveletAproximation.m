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
% If you are using this toolbox in research, please consider citing our   %
% conference paper, from which this toolbox originates. You can find the  %
% citation at https://github.com/JK-OK/Multiwavelet-toolbox               %
% You can find the contact information for authors there as well.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [phi, psi, phix, psix] = getMultiWaveletAproximation(g0, g1, r, level)
% getMultiWaveletAproximation generates aproximation of multiscaling and
% multiwavelet functions
% Input variables:
% g0, g1: matrix impulse responses of Multiwavelet
% r: Multiwavelet multiciplity
% level: required aproximation level (max 20)
% Output variables:
% phi: Multiscaling functions
% psi: Multiwavelet functions
% phix: Multiscaling function time variable
% psix: Multiwavelet function time variable
% Examples:
% DGHM = loadMW('DGHM');
% [phi, psi, phix, psix] = getMultiWaveletAproximation(DGHM.g0, DGHM.g1, DGHM.r, 12)
% DB2 = loadMW('DB2');
% [phi, psi, phix, psix] = getMultiWaveletAproximation(DB2.g0, DB2.g1, DB2.r, 8)

% Calculating number of matrix impulse responses
matx = size(g0, 2);

% Creating temponary variable where the matrix impulse responses will be
% stored
G = zeros(r, r, matx);
H = zeros(r, r, matx);

% Storing the matrix impulse responses into temponary variables, for
% keeping the energy of matrix impulse responses they are multiplied with a
% square root of multiciplity r. It is done here so it is not needed to do
% later after each iteration
for i = 1:matx
    G(:, :, i) = g0{i}*sqrt(r);
    H(:, :, i) = g1{i}*sqrt(r);
end

% Beggining guess of iteration
phi = [0 1 0; 0 0 0];

% Perform iteration for required level - 1
for j = 1:level-1

    % for each matrix impulse response do
    for i = 1:matx

        % Perform matrix multiplication with the previous iteration
        a(:, :, i) = G(:, :, i) * phi;

        % Creating zeros before and after the results depending on which
        % impulse response was used.
        prefix = zeros(2, (i-1)*2^(j-1));
        suffix = zeros(2, (matx-i)*2^(j-1));

        % Saving to temponary variable
        newphi(:, :, i) = [prefix a(:, :, i) suffix];
    end

    % Adding all matrix multiplication results into one variable
    phi = zeros(size(newphi, 1), size(newphi, 2));
    for i = 1:matx
        phi = phi + newphi(:, :, i);
    end
    clear a newphi;
end
clear prefix suffix i j;

% Calculating last iteration of Multiscaling function
psi = phi;
for i = 1:matx

    % Perform matrix multiplication with the previous iteration
    a(:, :, i) = G(:, :, i) * phi;

    % Creating zeros before and after the results depending on which
    % impulse response was used.
    prefix = zeros(2, (i-1)*2^(level-1));
    suffix = zeros(2, (matx-i)*2^(level-1));

    % Saving to temponary variable
    newphi(:, :, i) = [prefix a(:, :, i) suffix];
end

% Adding all matrix multiplication results into one variable
phi = zeros(size(newphi, 1), size(newphi, 2));
for i = 1:matx
    phi = phi + newphi(:, :, i);
end
clear a newphi;
clear prefix suffix i;

% Calculating Multiwavelet function
for i = 1:matx

    % Perform matrix multiplication with the previous iteration but using
    % the g1 matrix impulse responses
    a(:, :, i) = H(:, :, i) * psi;

    % Creating zeros before and after the results depending on which
    % impulse response was used.
    prefix = zeros(2, (i-1)*2^(level-1));
    suffix = zeros(2, (matx-i)*2^(level-1));

    % Saving to temponary variable
    newphi(:, :, i) = [prefix a(:, :, i) suffix];
end

% Adding all matrix multiplication results into one variable
psi = zeros(size(newphi, 1), size(newphi, 2));
for i = 1:matx
    psi = psi + newphi(:, :, i);
end

% Creating time scales for multiwavelets depending on number of matrix
% impulse responses the multiwavelet contains
phix = 0:1/size(phi, 2)*(matx-1):matx-1-1/size(phi, 2)*(matx-1);
psix = phix;

end