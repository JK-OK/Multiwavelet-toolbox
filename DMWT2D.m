function out = DMWT2D(in, multiwavelet, varargin)
% DMWT2D implements the discrete multiwavelet transform of a 2D signal
% using the four-channel single filter bank.
% Input variables:
% in: input 2D signal (both dimension must be dividable by 8)
% multiwavelet: multiwavelet used for implementing DMWT (as string)
% varargin: It is possible to define custom extension according to MATLAB
% extensions. If not defined then periodic extension will be used
% Output variables:
% out: transformed 2D signal
% Examples:
% output2D = DMWT2D(input2D, 'BAT02');
% output2D = DMWT2D(input2D, 'SA4', 'sp0');

% Applying DMWT on the row of a 2D signal
[c11, c12, d11, d12] = DMWT(in,multiwavelet,varargin{:});

% Connecting subbands and transpose
out = [c11, c12, d11, d12]';

% Applying DMWT on the colums of a 2D signal
[c11, c12, d11, d12] = DMWT(out,multiwavelet,varargin{:});

% Connecting subbands and transpose
out = [c11, c12, d11, d12]';

% If multiwavelet create subbands in different order then reorder it
if loadMW(multiwavelet).reorder == 1
    reo = divideToSub(out);
    reo = [reo(:, 4), reo(:, 1:3)];
    reo = [reo(4, :); reo(1:3, :)];
    out = mergeSub(reo);
end

end