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

function plotMultiWavelet(multiwavelet, varargin)
% plotMultiWavelet plots multiscaling and multiwavelet functions of
% required Multiwavelet
% Input variables:
% multiwavelet: Multiwavelet of which Multiscaling and Multiwavelet
% functions should be ploted
% varargin: Here can be custom aproximation level defined
% Examples:
% plotMultiWavelet('DGHM')
% plotMultiWavelet('HAAR', 3)

% Load Multiwavelet structure
multiwavelet = loadMW(multiwavelet);

% Check if user defined custom aproximation level
if isempty(varargin)
    % if not use default values
    phi1 = multiwavelet.phi(1, :);
    phi2 = multiwavelet.phi(2, :);
    psi1 = multiwavelet.psi(1, :);
    psi2 = multiwavelet.psi(2, :);
    phix = multiwavelet.phix;
    psix = multiwavelet.psix;
else
    % if yes check if it is a number and generate new aproximations
    if isnumeric(varargin{1})
        [phi, psi, phix, psix] = getMultiWaveletAproximation(multiwavelet.g0, multiwavelet.g1, multiwavelet.r, varargin{1});
        phi1 = phi(1, :);
        phi2 = phi(2, :);
        psi1 = psi(1, :);
        psi2 = psi(2, :);
    else
        ME = MException('plotMultiWavelet:wrongAproximationNumber', ...
            'Aproximation level needs to be a number bewtwen 1 and 20!');
        throw(ME);
    end
end

% Calculate max and min of all functions for bettwer view
maxp = max([phi1, phi2, psi1, psi2]) + 0.1;
minp = min([phi1, phi2, psi1, psi2]) - 0.1;
maxt = max([phix, psix]) + 0.1;
mint = min([phix, psix]) - 0.1;

% Plot first Multiscaling function
tiledlayout(2, 2);
nexttile;
plot(phix, phi1, 'LineWidth', 2);
hold on;
yline(0, 'LineWidth', 1);
hold off;
grid on;
ylim([minp, maxp]);
xlim([mint, maxt]);
xlabel("Time [s]");
ylabel("Amplitude");
title([multiwavelet.name + " Multiscaling function \phi_1"]);

% Plot Second Multiscaling function
nexttile;
plot(phix, phi2, 'LineWidth', 2);
hold on;
yline(0, 'LineWidth', 1);
hold off;
grid on;
ylim([minp, maxp]);
xlim([mint, maxt]);
xlabel("Time [s]");
ylabel("Amplitude");
title([multiwavelet.name + " Multiscaling function \phi_2"]);

% Plot first Multiwavelet function
nexttile;
plot(psix, psi1, 'LineWidth', 2);
hold on;
yline(0, 'LineWidth', 1);
hold off;
grid on;
ylim([minp, maxp]);
xlim([mint, maxt]);
xlabel("Time [s]");
ylabel("Amplitude");
title([multiwavelet.name + " Multiwavelet function \psi_1"]);

% Plot second Multiwavelet function
nexttile;
plot(psix, psi2, 'LineWidth', 2);
hold on;
yline(0, 'LineWidth', 1);
hold off;
grid on;
ylim([minp, maxp]);
xlim([mint, maxt]);
xlabel("Time [s]");
ylabel("Amplitude");
title([multiwavelet.name + " Multiwavelet function \psi_2"]);

end

