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

clear;
clc;

% Settings
plot_results = true;
maximalized_plot = true;

%% Preparing input signals
load kobe;
in1D = normalize(kobe(1:2048)');
load woman;
in2D = im2double(uint8(X));
clear kobe map X;
% in2D = imread("image.png");

%% DMWT and IDMWT Example

[c11, c12, d11, d12] = DMWT(in1D, 'DGHM');

if plot_results
    f = figure(1);
    if maximalized_plot
        f.WindowState = 'maximized';
    end
    t = tiledlayout(4, 1);
    title(t, "DMWT and IDMWT Example");
    nexttile;
    plot(c11);
    title("c_{11} coeficients");
    xlabel("Samples");
    ylabel("Amplitude");
    grid on;

    nexttile;
    plot(c12);
    title("c_{12} coeficients");
    xlabel("Samples");
    ylabel("Amplitude");
    grid on;

    nexttile;
    plot(d11);
    title("d_{11} coeficients");
    xlabel("Samples");
    ylabel("Amplitude");
    grid on;

    nexttile;
    plot(d12);
    title("d_{12} coeficients");
    xlabel("Samples");
    ylabel("Amplitude");
    grid on;
end

out1D = IDMWT(c11, c12, d11, d12, 'DGHM');

fprintf("SNR after IDMWT: %.3f\n", snr(in1D, in1D - out1D));

%% MLDMWT and MLIDMWT Example

coef = MLDMWT(in1D, 'BAT02', 3);

if plot_results
    f = figure(2);
    if maximalized_plot
        f.WindowState = 'maximized';
    end
    t = tiledlayout(8, 1);
    title(t, "MLDMWT and MLIDMWT Example");
    nexttile;
    plot(coef{1});
    title("c_{31} coeficients");
    xlabel("Samples");
    ylabel("Amplitude");
    grid on;

    nexttile;
    plot(coef{2});
    title("c_{32} coeficients");
    xlabel("Samples");
    ylabel("Amplitude");
    grid on;

    nexttile;
    plot(coef{3});
    title("d_{31} coeficients");
    xlabel("Samples");
    ylabel("Amplitude");
    grid on;

    nexttile;
    plot(coef{4});
    title("d_{32} coeficients");
    xlabel("Samples");
    ylabel("Amplitude");
    grid on;

    nexttile;
    plot(coef{5});
    title("d_{21} coeficients");
    xlabel("Samples");
    ylabel("Amplitude");
    grid on;

    nexttile;
    plot(coef{6});
    title("d_{22} coeficients");
    xlabel("Samples");
    ylabel("Amplitude");
    grid on;

    nexttile;
    plot(coef{7});
    title("d_{11} coeficients");
    xlabel("Samples");
    ylabel("Amplitude");
    grid on;

    nexttile;
    plot(coef{8});
    title("d_{12} coeficients");
    xlabel("Samples");
    ylabel("Amplitude");
    grid on;
end

out1D = MLIDMWT(coef, 'BAT02', 3);

fprintf("SNR after MLIDMWT: %.3f\n", snr(in1D, in1D - out1D));

%% TMLDMWT and TMLIDMWT Example

coef = TMLDMWT(in1D, 'CL02', 2);

if plot_results
    f = figure(3);
    if maximalized_plot
        f.WindowState = 'maximized';
    end
    t = tiledlayout(8, 1);
    title(t, "TMLDMWT and TMLIDMWT Example");
    nexttile;
    plot(coef{1});
    title("cc_{11} coeficients");
    xlabel("Samples");
    ylabel("Amplitude");
    grid on;

    nexttile;
    plot(coef{2});
    title("cc_{12} coeficients");
    xlabel("Samples");
    ylabel("Amplitude");
    grid on;

    nexttile;
    plot(coef{3});
    title("cd_{11} coeficients");
    xlabel("Samples");
    ylabel("Amplitude");
    grid on;

    nexttile;
    plot(coef{4});
    title("cd_{12} coeficients");
    xlabel("Samples");
    ylabel("Amplitude");
    grid on;

    nexttile;
    plot(coef{5});
    title("cd_{11} coeficients");
    xlabel("Samples");
    ylabel("Amplitude");
    grid on;

    nexttile;
    plot(coef{6});
    title("cd_{11} coeficients");
    xlabel("Samples");
    ylabel("Amplitude");
    grid on;

    nexttile;
    plot(coef{7});
    title("dd_{11} coeficients");
    xlabel("Samples");
    ylabel("Amplitude");
    grid on;

    nexttile;
    plot(coef{8});
    title("dd_{12} coeficients");
    xlabel("Samples");
    ylabel("Amplitude");
    grid on;
end

out1D = TMLIDMWT(coef, 'CL02', 2);

fprintf("SNR after TMLIDMWT: %.3f\n", snr(in1D, in1D - out1D));

%% DMWT2D and IDMWT2D Example

out2D = DMWT2D(in2D, 'DB2');

if plot_results
    f = figure(4);
    if maximalized_plot
        f.WindowState = 'maximized';
    end
    t = tiledlayout(2, 1);
    title(t, "DMWT2D and IDMWT2D Example");
    nexttile;
    imshow(in2D);
    title("Original image");

    nexttile;
    imshow(abs(out2D));
    title("Transformed image");
end

out2D = IDMWT2D(out2D, 'DB2');

[psnr2D, snr2D] = psnr(out2D, in2D);
fprintf("PSNR after IDMWT2D: %.3f\nSNR after IDMWT2D: %.3f\n", psnr2D, snr2D);

%% MLDMWT2D and MLIDMWT2D Example

out2D = MLDMWT2D(in2D, 'SA4', 3);

if plot_results
    f = figure(5);
    if maximalized_plot
        f.WindowState = 'maximized';
    end
    t = tiledlayout(2, 1);
    title(t, "MLDMWT2D and MLIDMWT2D Example");
    nexttile;
    imshow(in2D);
    title("Original image");

    nexttile;
    imshow(abs(out2D));
    title("Transformed image");
end

out2D = MLIDMWT2D(out2D, 'SA4', 3);

[psnr2D, snr2D] = psnr(out2D, in2D);
fprintf("PSNR after MLIDMWT2D: %.3f\nSNR after MLIDMWT2D: %.3f\n", psnr2D, snr2D);

%% DMWTMatrix Example 1D signal

n = size(in1D, 2);
mat = DMWTMatrix(n, 'HAAR', true);

out1D = (mat * in1D')';

if plot_results
    f = figure(6);
    if maximalized_plot
        f.WindowState = 'maximized';
    end
    t = tiledlayout(4, 1);
    title(t, "DMWTMatrix Example 1D signal");
    nexttile;
    plot(out1D(1:n/4));
    title("c_{11} coeficients");
    xlabel("Samples");
    ylabel("Amplitude");
    grid on;

    nexttile;
    plot(out1D(n/4+1:n/2));
    title("c_{12} coeficients");
    xlabel("Samples");
    ylabel("Amplitude");
    grid on;

    nexttile;
    plot(out1D(n/2+1:3*n/4));
    title("d_{11} coeficients");
    xlabel("Samples");
    ylabel("Amplitude");
    grid on;

    nexttile;
    plot(out1D(3*n/4+1:end));
    title("d_{12} coeficients");
    xlabel("Samples");
    ylabel("Amplitude");
    grid on;
end

out1D = (mat' * out1D')';

fprintf("SNR after transform using matrix: %.3f\n", snr(in1D, in1D - out1D));

%% DMWTMatrix Example 2D signal

n = size(in2D, 2);
mat = DMWTMatrix(n, 'DB4', true);

out2D = mat * in2D * mat';

if plot_results
    f = figure(7);
    if maximalized_plot
        f.WindowState = 'maximized';
    end
    t = tiledlayout(2, 1);
    title(t, "DMWTMatrix Example 2D signal");
    nexttile;
    imshow(in2D);
    title("Original image");

    nexttile;
    imshow(abs(out2D));
    title("Transformed image");
end

out2D = mat' * out2D * mat;

[psnr2D, snr2D] = psnr(out2D, in2D);
fprintf("PSNR after transform using matrix: %.3f\nSNR after transform using matrix: %.3f\n", psnr2D, snr2D);

%% getMultiWaveletAproximation and plotMultiWavelet Example

multiwavelet = loadMW('CL02');
[phi, psi, phix, psix] = getMultiWaveletAproximation(multiwavelet.g0, multiwavelet.g1, multiwavelet.r, 8);

if plot_results

    phi1 = phi(1, :);
    phi2 = phi(2, :);
    psi1 = psi(1, :);
    psi2 = psi(2, :);

    % Calculate max and min of all functions for bettwer view
    maxp = max([phi1, phi2, psi1, psi2]) + 0.1;
    minp = min([phi1, phi2, psi1, psi2]) - 0.1;

    f = figure(8);
    if maximalized_plot
        f.WindowState = 'maximized';
    end
    t = tiledlayout(2, 2);
    title(t, "plotMultiwavelet Example")
    nexttile;
    plot(phix, phi1, 'LineWidth', 2);
    hold on;
    yline(0, 'LineWidth', 1);
    hold off;
    grid on;
    ylim([minp, maxp]);
    xlabel("Time [s]");
    ylabel("Amplitude");
    title([multiwavelet.name + " Multiscaling function \phi_1"]);

    nexttile;
    plot(phix, phi2, 'LineWidth', 2);
    hold on;
    yline(0, 'LineWidth', 1);
    hold off;
    grid on;
    ylim([minp, maxp]);
    xlabel("Time [s]");
    ylabel("Amplitude");
    title([multiwavelet.name + " Multiscaling function \phi_2"]);

    nexttile;
    plot(psix, psi1, 'LineWidth', 2);
    hold on;
    yline(0, 'LineWidth', 1);
    hold off;
    grid on;
    ylim([minp, maxp]);
    xlabel("Time [s]");
    ylabel("Amplitude");
    title([multiwavelet.name + " Multiwavelet function \psi_1"]);

    nexttile;
    plot(psix, psi2, 'LineWidth', 2);
    hold on;
    yline(0, 'LineWidth', 1);
    hold off;
    grid on;
    ylim([minp, maxp]);
    xlabel("Time [s]");
    ylabel("Amplitude");
    title([multiwavelet.name + " Multiwavelet function \psi_2"]);

end

f = figure(9);
if maximalized_plot
    f.WindowState = 'maximized';
end
plotMultiWavelet('HAAR');