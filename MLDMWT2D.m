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

function out = MLDMWT2D(in, multiwavelet, level, varargin)
% MLDMWT2D implements multilevel DMWT2D
% Input variables
% in: input 2D signal
% multiwavelet: multiwavelet used for implementing DMWT (as string)
% level: required level of transformation (1 to 4)
% varargin: It is possible to define custom extension according to MATLAB
% extensions. If not defined then periodic extension will be used
% Output variables:
% out: transformed 2D signal
% Examples:
% MLoutput2D = MLDMWT2D(input2D, 'DB4', 4);
% MLoutput2D = MLDMWT2D(input2D, 'DGHM', 2, 'sp0');

% Checking required level
level = fix(level);
if (level <= 0) || (level >= 5)
    ME = MException('MLDMWT2D:LevelOutOfRange',...
        'Transformation level can be in range from 1 to 4!');
    throw(ME);
end

% Depending on required level
switch (level)
    case 1
        % For 1 level use the standart function
        out = DMWT2D(in, multiwavelet, varargin{:});
    case 2
        % Checking the signal size
        if (size(in, 1) < 16 || size(in, 2) < 16)
            ME = MException('MLDMWT2D:SignalSoSmall',...
                'For 2 level transform the input 2D signal must be at least 16x16!');
            throw(ME);
        end
        % Performing first level of DMWT
        out = DMWT2D(in, multiwavelet, varargin{:});
        % Reduction of the L band
        out = mergeQ2D(out);
        % Calculating size of signal
        l = size(out, 1);
        k = size(out, 2);
        % creating new variable from reducted L band
        new = out(1:l/2, 1:k/2);
        % Transformation of reducted L band
        new = DMWT2D(new, multiwavelet, varargin{:});
        % Insertion of transformed L band to ouput transformed signal
        out(1:l/2, 1:k/2) = new;
    case 3
        % Same steps as for 2 level but with additional reducting and
        % transforming
        if (size(in, 1) < 32 || size(in, 2) < 32)
            ME = MException('MLDMWT2D:SignalSoSmall',...
                'For 3 level transform the input 2D signal must be at least 32x32!');
            throw(ME);
        end
        % Performing first level of DMWT
        out = DMWT2D(in, multiwavelet, varargin{:});
        out = mergeQ2D(out);
        l = size(out, 1);
        k = size(out, 2);
        new = out(1:l/2, 1:k/2);
        % Performing second level of DMWT
        new = DMWT2D(new, multiwavelet, varargin{:});
        new = mergeQ2D(new);
        atr = new(1:l/4, 1:k/4);
        % Performing thid level of DMWT
        atr = DMWT2D(atr, multiwavelet, varargin{:});
        % Insertion of transformed L bands to ouput transformed signal
        new(1:l/4, 1:k/4) = atr;
        out(1:l/2, 1:k/2) = new;
    case 4
        % Same steps as for 2 level but with additional reducting and
        % transforming
        if (size(in, 1) < 64 || size(in, 2) < 64)
            ME = MException('MLDMWT2D:SignalSoSmall',...
                'For 4 level transform the input 2D signal must be at least 64x64!');
            throw(ME);
        end
        % Performing first level of DMWT
        out = DMWT2D(in, multiwavelet, varargin{:});
        out = mergeQ2D(out);
        l = size(out, 1);
        k = size(out, 2);
        new = out(1:l/2, 1:k/2);
        % Performing second level of DMWT
        new = DMWT2D(new, multiwavelet, varargin{:});
        new = mergeQ2D(new);
        atr = new(1:l/4, 1:k/4);
        % Performing third level of DMWT
        atr = DMWT2D(atr, multiwavelet, varargin{:});
        atr = mergeQ2D(atr);
        shn = atr(1:l/8, 1:k/8);
        % Performing fourth level of DMWT
        shn = DMWT2D(shn, multiwavelet, varargin{:});
        % Insertion of transformed L bands to ouput transformed signal
        atr(1:l/8, 1:k/8) = shn;
        new(1:l/4, 1:k/4) = atr;
        out(1:l/2, 1:k/2) = new;
    otherwise
end

end