function out = mergeSub(in)
% mergeSub merges subbands of a 2D signal
% Input variables:
% in: transformed 2D signal divided into subbands saved in a cell variable
% Output variables:
% out: merged 2D signal

% Mergin subbands and saving them in variable out
out = [
    in{1, 1}, in{1, 2}, in{1, 3}, in{1, 4};
    in{2, 1}, in{2, 2}, in{2, 3}, in{2, 4};
    in{3, 1}, in{3, 2}, in{3, 3}, in{3, 4};
    in{4, 1}, in{4, 2}, in{4, 3}, in{4, 4};
];

end