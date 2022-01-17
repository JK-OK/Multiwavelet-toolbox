%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Multiwavelet toolbox, a toolbox for performing Multiwavelet transform   %
% Copyright (C) 2022  Jozef Kromka, Ondrej Kov·Ë                          %
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

% Defining default aproximation level for generating multiwavelet functions
% aproximation
aproxLevel = 10;

%% Creating DGHM MultiWavelet and filters

% Defining multiciplity of Multiwavelet
DGHM.r = 2;
% Defining multiwavelet name
DGHM.name = 'DGHM';
% Defining if Multiwavelet produce subbands in different order
DGHM.reorder = 0;
% Support constants used for derivating Multiwavelet matrix impulse responses
c = sqrt(2);
p = c/40;
% Defining Multiwavelet matrix impulse response g0
DGHM.g0{1} = p*[12, 16*c; -c, -6];
DGHM.g0{2} = p*[12, 0; 9*c, 20];
DGHM.g0{3} = p*[0, 0; 9*c, -6];
DGHM.g0{4} = p*[0, 0; -c, 0];
% Defining Multiwavelet matrix impulse response g1
DGHM.g1{1} = p*[-c, -6; 2, 6*c];
DGHM.g1{2} = p*[9*c, -20; -18, 0];
DGHM.g1{3} = p*[9*c, -6; 18, -6*c];
DGHM.g1{4} = p*[-c, 0; -2, 0];
% Clearing supporting constants
clear c p;
% Creating 8 scalar (vector) filters
DGHM.V8KF = getVector8KFilters(DGHM.g0, DGHM.g1);
% Calculating aproximation of Multiscaling and Multiwavelet funtions
[DGHM.phi, DGHM.psi, DGHM.phix, DGHM.psix] =...
    getMultiWaveletAproximation(DGHM.g0, DGHM.g1, DGHM.r, aproxLevel);
% Creating 4 filters of four-channel single filter bank
DGHM.S4KF = getScalar4KFilters(DGHM.g0, DGHM.g1);


%% Creating CL02 MultiWavelet and filters

CL02.r = 2;
CL02.name = 'CL02';
CL02.reorder = 1;

t = -sqrt(7)/4;
u = sqrt(2-4*t*t);
p = 1/(2*sqrt(2));

CL02.g0{1} = p*[1, 1; 2*t, 2*t];
CL02.g0{2} = p*[2, 0; 0, 2*u];
CL02.g0{3} = p*[1, -1; -2*t, 2*t];

CL02.g1{1} = p*[-1, -1; u, u];
CL02.g1{2} = p*[2, 0; 0, -4*t];
CL02.g1{3} = p*[-1, 1; -u, u];

clear t u p;

CL02.V8KF = getVector8KFilters(CL02.g0, CL02.g1);
[CL02.phi, CL02.psi, CL02.phix, CL02.psix] =...
    getMultiWaveletAproximation(CL02.g0, CL02.g1, CL02.r, aproxLevel);
CL02.S4KF = getScalar4KFilters(CL02.g0, CL02.g1);

%% Creating CL03 MultiWavelet and filters

CL03.r = 2;
CL03.name = 'CL03';
CL03.reorder = 1;

c0 = sqrt(2);
c1 = sqrt(6);
c2 = sqrt(10);
c3 = sqrt(15);
p = 1/(40*c0);

CL03.g0{1} = p*[10-3*c2, 5*c1-2*c3; 5*c1-3*c3, 5-3*c2];
CL03.g0{2} = p*[30+3*c2, 5*c1-2*c3; -5*c1-7*c3, 15-3*c2];
CL03.g0{3} = p*[30+3*c2, -5*c1+2*c3; 5*c1+7*c3, 15-3*c2];
CL03.g0{4} = p*[10-3*c2, -5*c1+2*c3; -5*c1+3*c3, 5-3*c2];

CL03.g1{1} = p*[5*c1-2*c3, -10+3*c2; -5+3*c2, 5*c1-3*c3];
CL03.g1{2} = p*[-5*c1+2*c3, 30+3*c2; 15-3*c2, 5*c1+7*c3];
CL03.g1{3} = p*[-5*c1+2*c3, -30-3*c2; -15+3*c2, 5*c1+7*c3];
CL03.g1{4} = p*[5*c1-2*c3, 10-3*c2; 5-3*c2, 5*c1-3*c3];

clear c0 c1 c2 c3 p;

CL03.V8KF = getVector8KFilters(CL03.g0, CL03.g1);
[CL03.phi, CL03.psi, CL03.phix, CL03.psix] =...
    getMultiWaveletAproximation(CL03.g0, CL03.g1, CL03.r, aproxLevel);
CL03.S4KF = getScalar4KFilters(CL03.g0, CL03.g1);

%% Creating SA4 MultiWavelet and filters

SA4.r = 2;
SA4.name = 'SA4';
SA4.reorder = 1;

c0 = 4+sqrt(15);
c1 = c0*c0;
p = (1/sqrt(2))*(1/(c1+1));

SA4.g0{1} = p*[1, c0; 1, -c0];
SA4.g0{2} = p*[c1, c0; -c1, c0];
SA4.g0{3} = p*[c1, -c0; c1, c0];
SA4.g0{4} = p*[1, -c0; -1, -c0];

SA4.g1{1} = p*[-c0, 1; -c0, -1];
SA4.g1{2} = p*[c0, -c1; -c0, -c1];
SA4.g1{3} = p*[c0, c1; c0, -c1];
SA4.g1{4} = p*[-c0 -1; c0, -1];

clear c0 c1 p;

SA4.V8KF = getVector8KFilters(SA4.g0, SA4.g1);
[SA4.phi, SA4.psi, SA4.phix, SA4.psix] =...
    getMultiWaveletAproximation(SA4.g0, SA4.g1, SA4.r, aproxLevel);
SA4.S4KF = getScalar4KFilters(SA4.g0, SA4.g1);

%% Creating BAT01 MultiWavelet and filters

BAT01.r = 2;
BAT01.name = 'BAT01';
BAT01.reorder = 0;

c = sqrt(7);
p0 = 1/(4*sqrt(2));
p1 = 1/4;

BAT01.g0{1} = p0*[0, 2+c; 0, 2-c];
BAT01.g0{2} = p0*[3, 1; 1, 3];
BAT01.g0{3} = p0*[2-c, 0; 2+c, 0];

BAT01.g1{1} = p1*[0, -2; 0, 1];
BAT01.g1{2} = p1*[2, 2; -c, c];
BAT01.g1{3} = p1*[-2, 0; -1, 0];

clear c p0 p1;

BAT01.V8KF = getVector8KFilters(BAT01.g0, BAT01.g1);
[BAT01.phi, BAT01.psi, BAT01.phix, BAT01.psix] =...
    getMultiWaveletAproximation(BAT01.g0, BAT01.g1, BAT01.r, aproxLevel);
BAT01.S4KF = getScalar4KFilters(BAT01.g0, BAT01.g1);

%% Creating BAT02 MultiWavelet and filters

BAT02.r = 2;
BAT02.name = 'BAT02';
BAT02.reorder = 0;

c = sqrt(31);
p0 = sqrt(2)/640;
p1 = 1/640;

BAT02.g0{1} = p0*[0, -31+c; 0, -13+3*c];
BAT02.g0{2} = p0*[93-13*c, 217+23*c; -1+c, 11-11*c];
BAT02.g0{3} = p0*[341-11*c, 23+7*c; 23+7*c, 341-11*c];
BAT02.g0{4} = p0*[11-11*c, -1+c; 217+23*c, 93-13*c];
BAT02.g0{5} = p0*[-13+3*c, 0; -31+c, 0];

BAT02.g1{1} = p1*[0, 92-12*c; 0, 94-14*c];
BAT02.g1{2} = p1*[44-4*c, -364+4*c; 18+2*c, -318+18*c];
BAT02.g1{3} = p1*[228+12*c, 228+12*c; 206+34*c, -206-34*c];
BAT02.g1{4} = p1*[-364+4*c, 44-4*c; 318-18*c, -18-2*c];
BAT02.g1{5} = p1*[92-12*c, 0; -94+14*c, 0];

clear c p0 p1;

BAT02.V8KF = getVector8KFilters(BAT02.g0, BAT02.g1);
[BAT02.phi, BAT02.psi, BAT02.phix, BAT02.psix] =...
    getMultiWaveletAproximation(BAT02.g0, BAT02.g1, BAT02.r, aproxLevel);
BAT02.S4KF = getScalar4KFilters(BAT02.g0, BAT02.g1);

%% Creating BAT03 MultiWavelet and filters

BAT03.r = 2;
BAT03.name = 'BAT03';
BAT03.reorder = 0;

c = sqrt(15199);
p0 = sqrt(2)/2232320;
p1 = 1/2232320;

BAT03.g0{1} =...
    p0*[0, -2989+97*c; 0, 12405-105*c];
BAT03.g0{2} =...
    p0*[537+69*c, -75969-525*c; -23505+195*c, 13769-43*c];
BAT03.g0{3} =...
    p0*[73925+551*c, 1202922-882*c; 22083-111*c, -192186+450*c];
BAT03.g0{4} =...
    p0*[901278+1638*c, 300050-1334*c; 300050-1334*c, 901278+1638*c];
BAT03.g0{5} =...
    p0*[-192186+450*c, 22083-111*c; 1202922-882*c, 73925+551*c];
BAT03.g0{6} =...
    p0*[13769-43*c, -23505+195*c; -75969-525*c, 537+69*c];
BAT03.g0{7} =...
    p0*[12405-105*c, 0; -2989+97*c, 0];

BAT03.g1{1} = p1*[0, -22968+264*c; 0, 24042-126*c];
BAT03.g1{2} = p1*[-9416+8*c, -96008-440*c; 15394-202*c, -51842-662*c];
BAT03.g1{3} = p1*[-62200-568*c, 1201328+304*c; -89738-482*c, 601228+2972*c];
BAT03.g1{4} = p1*[-1010736+432*c, -1010736+432*c; -1395108+1332*c, 1395108-1332*c];
BAT03.g1{5} = p1*[1201328+304*c, -62200-568*c; -601228-2972*c, 89738+482*c];
BAT03.g1{6} = p1*[-96008-440*c, -9416+8*c; 51842+662*c, -15394+202*c];
BAT03.g1{7} = p1*[-22968+264*c, 0; -24042+126*c, 0];

clear c p0 p1;

BAT03.V8KF = getVector8KFilters(BAT03.g0, BAT03.g1);
[BAT03.phi, BAT03.psi, BAT03.phix, BAT03.psix] =...
    getMultiWaveletAproximation(BAT03.g0, BAT03.g1, BAT03.r, aproxLevel);
BAT03.S4KF = getScalar4KFilters(BAT03.g0, BAT03.g1);

%% Creating HAAR MultiWavelet and filters

HAAR.r = 2;
HAAR.name = 'HAAR';
HAAR.reorder = 0;

c = 1/sqrt(2);

HAAR.g0{1} = c*[1, 0; -1/2, 1/2];
HAAR.g0{2} = c*[1, 0; 1/2, 1/2];

HAAR.g1{1} = c*[1/2, 1/2; 0, 1];
HAAR.g1{2} = c*[-1/2, 1/2; 0, -1];

HAAR.V8KF = getVector8KFilters(HAAR.g0, HAAR.g1);
[HAAR.phi, HAAR.psi, HAAR.phix, HAAR.psix] =...
    getMultiWaveletAproximation(HAAR.g0, HAAR.g1, HAAR.r, aproxLevel);
HAAR.S4KF = getScalar4KFilters(HAAR.g0, HAAR.g1);

HAAR.S4KF{2} = sqrt(2) * HAAR.S4KF{2};
HAAR.S4KF{3} = sqrt(2) * HAAR.S4KF{3};

clear c;

%% Creating DB2 MultiWavelet and filters

DB2.r = 2;
DB2.name = 'DB2';
DB2.reorder = 0;

[LoD,HiD] = wfilters('db2');

DB2.g0{1} = [LoD(1), LoD(2); 0, 0];
DB2.g0{2} = [LoD(3), LoD(4); LoD(1), LoD(2)];
DB2.g0{3} = [0, 0; LoD(3), LoD(4)];

DB2.g1{1} = [HiD(1), HiD(2); 0, 0];
DB2.g1{2} = [HiD(3), HiD(4); HiD(1), HiD(2)];
DB2.g1{3} = [0, 0; HiD(3), HiD(4)];

clear LoD HiD;

DB2.V8KF = getVector8KFilters(DB2.g0, DB2.g1);
[DB2.phi, DB2.psi, DB2.phix, DB2.psix] =...
    getMultiWaveletAproximation(DB2.g0, DB2.g1, DB2.r, aproxLevel);
DB2.S4KF = getScalar4KFilters(DB2.g0, DB2.g1);

%% Creating DB3 MultiWavelet and filters

DB3.r = 2;
DB3.name = 'DB3';
DB3.reorder = 0;

[LoD,HiD] = wfilters('db3');

DB3.g0{1} = [LoD(1), LoD(2); 0, 0];
DB3.g0{2} = [LoD(3), LoD(4); LoD(1), LoD(2)];
DB3.g0{3} = [LoD(5), LoD(6); LoD(3), LoD(4)];
DB3.g0{4} = [0, 0; LoD(5), LoD(6)];

DB3.g1{1} = [HiD(1), HiD(2); 0, 0];
DB3.g1{2} = [HiD(3), HiD(4); HiD(1), HiD(2)];
DB3.g1{3} = [HiD(5), HiD(6); HiD(3), HiD(4)];
DB3.g1{4} = [0, 0; HiD(5), HiD(6)];

clear LoD HiD;

DB3.V8KF = getVector8KFilters(DB3.g0, DB3.g1);
[DB3.phi, DB3.psi, DB3.phix, DB3.psix] =...
    getMultiWaveletAproximation(DB3.g0, DB3.g1, DB3.r, aproxLevel);
DB3.S4KF = getScalar4KFilters(DB3.g0, DB3.g1);

%% Creating DB4 MultiWavelet and filters

DB4.r = 2;
DB4.name = 'DB4';
DB4.reorder = 0;

[LoD,HiD] = wfilters('db4');

DB4.g0{1} = [LoD(1), LoD(2); 0, 0];
DB4.g0{2} = [LoD(3), LoD(4); LoD(1), LoD(2)];
DB4.g0{3} = [LoD(5), LoD(6); LoD(3), LoD(4)];
DB4.g0{4} = [LoD(7), LoD(8); LoD(5), LoD(6)];
DB4.g0{5} = [0, 0; LoD(7), LoD(8)];

DB4.g1{1} = [HiD(1), HiD(2); 0, 0];
DB4.g1{2} = [HiD(3), HiD(4); HiD(1), HiD(2)];
DB4.g1{3} = [HiD(5), HiD(6); HiD(3), HiD(4)];
DB4.g1{4} = [HiD(7), HiD(8); HiD(5), HiD(6)];
DB4.g1{5} = [0, 0; HiD(7), HiD(8)];

clear LoD HiD;

DB4.V8KF = getVector8KFilters(DB4.g0, DB4.g1);
[DB4.phi, DB4.psi, DB4.phix, DB4.psix] =...
    getMultiWaveletAproximation(DB4.g0, DB4.g1, DB4.r, aproxLevel);
DB4.S4KF = getScalar4KFilters(DB4.g0, DB4.g1);

%% Creating DB5 MultiWavelet and filters

DB5.r = 2;
DB5.name = 'DB5';
DB5.reorder = 0;

[LoD,HiD] = wfilters('db5');

DB5.g0{1} = [LoD(1), LoD(2); 0, 0];
DB5.g0{2} = [LoD(3), LoD(4); LoD(1), LoD(2)];
DB5.g0{3} = [LoD(5), LoD(6); LoD(3), LoD(4)];
DB5.g0{4} = [LoD(7), LoD(8); LoD(5), LoD(6)];
DB5.g0{5} = [LoD(9), LoD(10); LoD(7), LoD(8)];
DB5.g0{6} = [0, 0; LoD(9), LoD(10)];

DB5.g1{1} = [HiD(1), HiD(2); 0, 0];
DB5.g1{2} = [HiD(3), HiD(4); HiD(1), HiD(2)];
DB5.g1{3} = [HiD(5), HiD(6); HiD(3), HiD(4)];
DB5.g1{4} = [HiD(7), HiD(8); HiD(5), HiD(6)];
DB5.g1{5} = [HiD(9), HiD(10); HiD(7), HiD(8)];
DB5.g1{6} = [0, 0; HiD(9), HiD(10)];

clear LoD HiD;

DB5.V8KF = getVector8KFilters(DB5.g0, DB5.g1);
[DB5.phi, DB5.psi, DB5.phix, DB5.psix] =...
    getMultiWaveletAproximation(DB5.g0, DB5.g1, DB5.r, aproxLevel);
DB5.S4KF = getScalar4KFilters(DB5.g0, DB5.g1);

%% Creating DB6 MultiWavelet and filters

DB6.r = 2;
DB6.name = 'DB6';
DB6.reorder = 0;

[LoD,HiD] = wfilters('db6');

DB6.g0{1} = [LoD(1), LoD(2); 0, 0];
DB6.g0{2} = [LoD(3), LoD(4); LoD(1), LoD(2)];
DB6.g0{3} = [LoD(5), LoD(6); LoD(3), LoD(4)];
DB6.g0{4} = [LoD(7), LoD(8); LoD(5), LoD(6)];
DB6.g0{5} = [LoD(9), LoD(10); LoD(7), LoD(8)];
DB6.g0{6} = [LoD(11), LoD(12); LoD(9), LoD(10)];
DB6.g0{7} = [0, 0; LoD(11), LoD(12)];

DB6.g1{1} = [HiD(1), HiD(2); 0, 0];
DB6.g1{2} = [HiD(3), HiD(4); HiD(1), HiD(2)];
DB6.g1{3} = [HiD(5), HiD(6); HiD(3), HiD(4)];
DB6.g1{4} = [HiD(7), HiD(8); HiD(5), HiD(6)];
DB6.g1{5} = [HiD(9), HiD(10); HiD(7), HiD(8)];
DB6.g1{6} = [HiD(11), HiD(12); HiD(9), HiD(10)];
DB6.g1{7} = [0, 0; HiD(11), HiD(12)];

clear LoD HiD;

DB6.V8KF = getVector8KFilters(DB6.g0, DB6.g1);
[DB6.phi, DB6.psi, DB6.phix, DB6.psix] =...
    getMultiWaveletAproximation(DB6.g0, DB6.g1, DB6.r, aproxLevel);
DB6.S4KF = getScalar4KFilters(DB6.g0, DB6.g1);

%% Creating DB7 MultiWavelet and filters

DB7.r = 2;
DB7.name = 'DB7';
DB7.reorder = 0;

[LoD,HiD] = wfilters('db7');

DB7.g0{1} = [LoD(1), LoD(2); 0, 0];
DB7.g0{2} = [LoD(3), LoD(4); LoD(1), LoD(2)];
DB7.g0{3} = [LoD(5), LoD(6); LoD(3), LoD(4)];
DB7.g0{4} = [LoD(7), LoD(8); LoD(5), LoD(6)];
DB7.g0{5} = [LoD(9), LoD(10); LoD(7), LoD(8)];
DB7.g0{6} = [LoD(11), LoD(12); LoD(9), LoD(10)];
DB7.g0{7} = [LoD(13), LoD(14); LoD(11), LoD(12)];
DB7.g0{8} = [0, 0; LoD(13), LoD(14)];

DB7.g1{1} = [HiD(1), HiD(2); 0, 0];
DB7.g1{2} = [HiD(3), HiD(4); HiD(1), HiD(2)];
DB7.g1{3} = [HiD(5), HiD(6); HiD(3), HiD(4)];
DB7.g1{4} = [HiD(7), HiD(8); HiD(5), HiD(6)];
DB7.g1{5} = [HiD(9), HiD(10); HiD(7), HiD(8)];
DB7.g1{6} = [HiD(11), HiD(12); HiD(9), HiD(10)];
DB7.g1{7} = [HiD(13), HiD(14); HiD(11), HiD(12)];
DB7.g1{8} = [0, 0; HiD(13), HiD(14)];

clear LoD HiD;

DB7.V8KF = getVector8KFilters(DB7.g0, DB7.g1);
[DB7.phi, DB7.psi, DB7.phix, DB7.psix] =...
    getMultiWaveletAproximation(DB7.g0, DB7.g1, DB7.r, aproxLevel);
DB7.S4KF = getScalar4KFilters(DB7.g0, DB7.g1);

%% Creating DB8 MultiWavelet and filters

DB8.r = 2;
DB8.name = 'DB8';
DB8.reorder = 0;

[LoD,HiD] = wfilters('db8');

DB8.g0{1} = [LoD(1), LoD(2); 0, 0];
DB8.g0{2} = [LoD(3), LoD(4); LoD(1), LoD(2)];
DB8.g0{3} = [LoD(5), LoD(6); LoD(3), LoD(4)];
DB8.g0{4} = [LoD(7), LoD(8); LoD(5), LoD(6)];
DB8.g0{5} = [LoD(9), LoD(10); LoD(7), LoD(8)];
DB8.g0{6} = [LoD(11), LoD(12); LoD(9), LoD(10)];
DB8.g0{7} = [LoD(13), LoD(14); LoD(11), LoD(12)];
DB8.g0{8} = [LoD(15), LoD(16); LoD(13), LoD(14)];
DB8.g0{9} = [0, 0; LoD(15), LoD(16)];

DB8.g1{1} = [HiD(1), HiD(2); 0, 0];
DB8.g1{2} = [HiD(3), HiD(4); HiD(1), HiD(2)];
DB8.g1{3} = [HiD(5), HiD(6); HiD(3), HiD(4)];
DB8.g1{4} = [HiD(7), HiD(8); HiD(5), HiD(6)];
DB8.g1{5} = [HiD(9), HiD(10); HiD(7), HiD(8)];
DB8.g1{6} = [HiD(11), HiD(12); HiD(9), HiD(10)];
DB8.g1{7} = [HiD(13), HiD(14); HiD(11), HiD(12)];
DB8.g1{8} = [HiD(15), HiD(16); HiD(13), HiD(14)];
DB8.g1{9} = [0, 0; HiD(15), HiD(16)];

clear LoD HiD;

DB8.V8KF = getVector8KFilters(DB8.g0, DB8.g1);
[DB8.phi, DB8.psi, DB8.phix, DB8.psix] =...
    getMultiWaveletAproximation(DB8.g0, DB8.g1, DB8.r, aproxLevel);
DB8.S4KF = getScalar4KFilters(DB8.g0, DB8.g1);

%% Save wavelets

save('mw.mat');  