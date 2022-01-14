function out = mergeQ2D(in)
% mergeQ2D performs reduction of scaling subbands, it is used in multi
% level 2D signal transform
% Input variables:
% in: input transformed 2D signal
% Output variables:
% out: output transformed 2D signal with reduced scaling subbands

% Dividing subbands of transformed 2D signal to subbands
Q = divideToSub(in);

% Choosing scaling subbands
L1L1 = Q{1, 1};
L1L2 = Q{1, 2};
L2L1 = Q{2, 1};
L2L2 = Q{2, 2};

% Interpolating subbands in rows
for i = 1:size(L1L1, 1)
    L1L1_a(i, :) = upsample(L1L1(i, :), 2, 0);
    L1L2_a(i, :) = upsample(L1L2(i, :), 2, 1);
    L2L1_a(i, :) = upsample(L2L1(i, :), 2, 0);
    L2L2_a(i, :) = upsample(L2L2(i, :), 2, 1);
end

% Interpolating subbands in colums
for i = 1:size(L1L1_a, 2)
    L1L1_b(:, i) = upsample(L1L1_a(:, i), 2, 0);
    L1L2_b(:, i) = upsample(L1L2_a(:, i), 2, 0);
    L2L1_b(:, i) = upsample(L2L1_a(:, i), 2, 1);
    L2L2_b(:, i) = upsample(L2L2_a(:, i), 2, 1);
end

% Merging intepolated subbands
all = L1L1_b + L1L2_b + L2L1_b + L2L2_b;

% Calculating size of subbands and step for dividng it
x = size(all, 2);
y = size(all, 1);
stepx = x/2;
stepy = y/2;

% Dividing reduced scaling subbands for purpose of merging it with already
% created function
for i = 1:2
    ix = (stepx*(i-1)+1:stepx*i);
    for j = 1:2
        iy = (stepy*(j-1)+1:stepy*j);
        Q{j, i} = all(iy, ix);
    end
end

% Merging all subbands to transformed 2D signal with reduced scaling
% subbands
out = mergeSub(Q);

end