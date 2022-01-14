function out = divideQ2D(in)
% divideQ2D divide 2D signal with reduced scaling subbands to original
% subbands
% Input variables:
% in: Input transformed 2D signal with reduced scaling subband
% Output variables:
% out: Ouput transformed 2D signal with original scaling subbands

% Dividing subbands of transformed 2D signal with reduced subbands
Q = divideToSub(in);

% Choosing reduced subband of transformed 2D signal
all = [Q{1, 1}, Q{1, 2}; Q{2, 1}, Q{2, 2}];

% Dividing reduced subbands to 2 by undersampling rows
for i = 1:size(all, 1)
    a(i, :) = downsample(all(i, :), 2, 0);
    b(i, :) = downsample(all(i, :), 2, 1);
end

% Dividing reduced subbands to 4 by undersampling colums
for i = 1:size(a, 2)
    L1L1(:, i) = downsample(a(:, i), 2, 0);
    L2L1(:, i) = downsample(a(:, i), 2, 1);
    L1L2(:, i) = downsample(b(:, i), 2, 0);
    L2L2(:, i) = downsample(b(:, i), 2, 1);
end

% saving calculated subbands
Q{1, 1} = L1L1;
Q{1, 2} = L1L2;
Q{2, 1} = L2L1;
Q{2, 2} = L2L2;

% connecting all subbands back to trasnformed 2D signal
out = mergeSub(Q);

end