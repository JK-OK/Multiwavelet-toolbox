function out = TMLIDMWT(coef, multiwavelet, level, varargin)
% TMLIDMWT implements Symetric (Tree) inversed Multiwavelet transform of
% required level
% Input variables:
% coef: transformed coefficients obtained by TMLDMWT
% multiwavelet: multiwavelet used for implementing DMWT (as string)
% varargin: It is possible to define custom extension according to MATLAB
% extensions. If not defined then periodic extension will be used
% Output variables:
% out: reconstructed signal
% Examples:
% output = TMLIDMWT(InCoef, 'DB7', 2)
% output = TMLIDMWT(InCoef, 'BAT02', 5, 'asym')

% Load Multiwavelet from string representation
multiwavelet = loadMW(multiwavelet);

% Creating output variable and calculating number of coefficients
out = {};
n = size(coef, 1);

% Checking coefficients size
if mod(n, (2^(level+1))) ~= 0
    ME = MException('ITMLDMWT:wrongDataLength', ...
        ['Number of input coefficients must be dividable by 4,' ...
        ' and minimal number of input coefficients must be accroding to 2^(level+1)']);
    throw(ME);
end

% Perform for each level
for i = 1:level
    % Calculate size of output cell
    out = cell(n/2, 1);
    k = 1;
    % If it is there only 4 coefficients
    if n == 4
        % Perform IDMWT for last coefficients
        if multiwavelet.reorder == 0
            out = fast_IDMWT(coef{1}, coef{2}, coef{3}, coef{4}, multiwavelet, varargin{:});
        else
            out = fast_IDMWT(coef{2}, coef{3}, coef{4}, coef{1}, multiwavelet, varargin{:});
        end
    else
        % Perfrom IDMWT for each part of coefficients
        for j = 1:4:n
            if multiwavelet.reorder == 0
                temp = fast_IDMWT(coef{j}, coef{j+1}, coef{j+2}, coef{j+3}, multiwavelet, varargin{:});
            else
                temp = fast_IDMWT(coef{j+1}, coef{j+2}, coef{j+3}, coef{j}, multiwavelet, varargin{:});
            end
            out{k} = downsample(temp, 2, 0);
            out{k+1} = downsample(temp, 2, 1);
            k = k + 2;
        end
    end
    n = n / 2;
    coef = out;
end

end