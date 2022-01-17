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

function multiwavelet = loadMW(multiwavelet_string)
%LOADMW loads multiwavelet from string
% Input variables:
% multiwavelet_string: Multiwavelet name in string format
% Output variables:
% multiwavelet: Multiwavelet data structure

multiwavelet_string = upper(multiwavelet_string);
mw = load("mw.mat");

switch multiwavelet_string
    case 'BAT01'
        multiwavelet = mw.BAT01;
    case 'BAT02'
        multiwavelet = mw.BAT02;
    case 'BAT03'
        multiwavelet = mw.BAT03;
    case 'CL02'
        multiwavelet = mw.CL02;
    case 'CL03'
        multiwavelet = mw.CL03;
    case 'DB2'
        multiwavelet = mw.DB2;
    case 'DB3'
        multiwavelet = mw.DB3;
    case 'DB4'
        multiwavelet = mw.DB4;
    case 'DB5'
        multiwavelet = mw.DB5;
    case 'DB6'
        multiwavelet = mw.DB6;
    case 'DB7'
        multiwavelet = mw.DB7;
    case 'DB8'
        multiwavelet = mw.DB8;
    case 'DGHM'
        multiwavelet = mw.DGHM;
    case 'HAAR'
        multiwavelet = mw.HAAR;
    case 'SA4'
        multiwavelet = mw.SA4;
    otherwise
        ME = MException('loadMW:wrongMultiwavelet', ...
            'Multiwavelet name is not right!');
        throw(ME);
end

end

