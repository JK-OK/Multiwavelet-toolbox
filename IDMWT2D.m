function out = IDMWT2D(in, multiwavelet, varargin)
% DMWT2D implements the discrete multiwavelet transform of a 2D signal
% using the four-channel single filter bank.
% Input variables:
% in: input 2d transformed signal
% multiwavelet: multiwavelet used for implementing DMWT (as string)
% varargin: It is possible to define custom extension according to MATLAB
% extensions. If not defined then periodic extension will be used
% Output variables:
% out: reconstructed 2D signal
% Examples:
% reconstructed2D = IDMWT2D(transformed2D, 'CL03');
% reconstructed2D = IDMWT2D(transformed2D, 'DB3', 'sp1');

% If multiwavelet create subbands in different order then reorder it
if loadMW(multiwavelet).reorder == 1
    reo = divideToSub(in);
    reo = [reo(:, 2:4), reo(:, 1)];
    reo = [reo(2:4, :); reo(1, :)];
    in = mergeSub(reo);
end

% Dividing transponed input 2d signal to subbands
[c11, c12, d11, d12] = splitSubBand(in');

% Applying IDMWT on colums of a 2D signal
out = IDMWT(c11, c12, d11, d12, multiwavelet, varargin{:});

% Dividing transponed input 2d signal to subbands
[c11, c12, d11, d12] = splitSubBand(out');

% Applying IDMWT on rows of a 2D signal
out = IDMWT(c11, c12, d11, d12, multiwavelet, varargin{:});

end