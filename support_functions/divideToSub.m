function out = divideToSub(in)
% divideToSub divides transformed 2D signal into subbands
% Input variables:
% in: transformed 2D signal
% Output variables:
% out: transformed 2D signal divided into subbands saved in a cell variable

% Creating output cell variable where subbands will be stored.
out = cell(4, 4);

% Calculating 2d signal size
x = size(in, 2);
y = size(in, 1);

% Calculating dividing step
stepx = x/4;
stepy = y/4;

% Dividing transformed 2D signal into subbands
for i = 1:4
    % Calculating x range
    ix = (stepx*(i-1)+1:stepx*i);
    for j = 1:4
        % Calculating y range
        iy = (stepy*(j-1)+1:stepy*j);
        % storing into output cell variable
        out{j, i} = in(iy, ix);
    end
end

end