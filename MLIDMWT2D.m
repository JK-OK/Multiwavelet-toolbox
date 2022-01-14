function out = MLIDMWT2D(in, multiwavelet, level, varargin)
% MLIDMWT2D implements multilevel inverse DMWT2D
% Input variables
% in: input 2D transformed signal
% multiwavelet: multiwavelet used for implementing DMWT (as string)
% level: required level of inverse transformation (1 to 4)
% varargin: It is possible to define custom extension according to MATLAB
% extensions. If not defined then periodic extension will be used
% Output variables:
% out: reconstructed 2D signal
% Examples:
% output2D = MLIDMWT2D(MLinput2D, 'BAT03', 2);
% output2D = MLIDMWT2D(MLinput2D, 'SA4', 3, 'asym');

% Checking required level
level = fix(level);
if (level <= 0) || (level >= 5)
    ME = MException('MLIDMWT2D:LevelOutOfRange',...
        'Transformation level can be in range from 1 to 4!');
    throw(ME);
end
% podľa požadovanej úrovne vykonaj
switch (level)
    case 1
        % For 1 level use the standart function
        out = IDMWT2D(in, multiwavelet, varargin{:});
    case 2
        % Checking the signal size
        if (size(in, 1) < 16 || size(in, 2) < 16)
            ME = MException('MLIDMWT2D:SignalSoSmall',...
                'For 2 level transform the input 2D signal must be at least 16x16!');
            throw(ME);
        end
        % moving variable
        out = in;
        % Calculating size of signal
        l = size(out, 1);
        k = size(out, 2);
        % creating new variable of max decomposition level
        new = out(1:l/2, 1:k/2);
        % Inverse transform of max decomposition level
        new = IDMWT2D(new, multiwavelet, varargin{:});
        % Inserting inverse transformed subband to output signal
        out(1:l/2, 1:k/2) = new;
        % Backwards dividing of the merged subband
        out = divideQ2D(out);
        % Last inverse transform
        out = IDMWT2D(out, multiwavelet, varargin{:});
    case 3
        % Same steps as for 2 level but with additional merging and
        % inverse transforming
        if (size(in, 1) < 32 || size(in, 2) < 32)
            ME = MException('MLIDMWT2D:SignalSoSmall',...
                'For 3 level transform the input 2D signal must be at least 32x32!');
            throw(ME);
        end
        % Calculating size of signal
        out = in;
        l = size(out, 1);
        k = size(out, 2);
        % creating new variables of decomposition levels
        new = out(1:l/2, 1:k/2);
        atr = new(1:l/4, 1:k/4);
        % Inverse transform of max decomposition level and dividing
        atr = IDMWT2D(atr, multiwavelet, varargin{:});
        new(1:l/4, 1:k/4) = atr;
        new = divideQ2D(new);
        % Inverse transform of second max decomposition level and dividing
        new = IDMWT2D(new, multiwavelet, varargin{:});
        out(1:l/2, 1:k/2) = new;
        out = divideQ2D(out);
        % Last inverse transform
        out = IDMWT2D(out, multiwavelet, varargin{:});
    case 4
        % Same steps as for 2 level but with additional merging and
        % inverse transforming
        if (size(in, 1) < 64 || size(in, 2) < 64)
            ME = MException('MLIDMWT2D:SignalSoSmall',...
                'For 4 level transform the input 2D signal must be at least 64x64!');
            throw(ME);
        end
        % Calculating size of signal
        out = in;
        l = size(out, 1);
        k = size(out, 2);
        % creating new variables of decomposition levels
        new = out(1:l/2, 1:k/2);
        atr = new(1:l/4, 1:k/4);
        shn = atr(1:l/8, 1:k/8);
        % Inverse transform of max decomposition level and dividing
        shn = IDMWT2D(shn, multiwavelet, varargin{:});
        atr(1:l/8, 1:k/8) = shn;
        atr = divideQ2D(atr);
        % Inverse transform of second max decomposition level and dividing
        atr = IDMWT2D(atr, multiwavelet, varargin{:});
        new(1:l/4, 1:k/4) = atr;
        new = divideQ2D(new);
        % Inverse transform of third max decomposition level and dividing
        new = IDMWT2D(new, multiwavelet, varargin{:});
        out(1:l/2, 1:k/2) = new;
        out = divideQ2D(out);
        % Last inverse transform
        out = IDMWT2D(out, multiwavelet, varargin{:});
    otherwise
end

end