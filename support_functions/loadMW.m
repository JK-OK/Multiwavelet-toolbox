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

