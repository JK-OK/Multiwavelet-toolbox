function [c11, c12, d11, d12] = splitSubBand(in)
% splitSubBand splits connected subbands
% Input variables:
% in: connected subbands
% Output variables:
% c11, c12, d11, d12: divided subbands

% Calculating size of signal
w = size(in, 2);
% Dividing signal into subbands
c11 = in(:, 1:w/4);
c12 = in(:, w/4+1:w/2);
d11 = in(:, w/2+1:3*w/4);
d12 = in(:, 3*w/4+1:end);

end