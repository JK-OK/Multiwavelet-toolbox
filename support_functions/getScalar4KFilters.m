function Scalar4KFilters = getScalar4KFilters(g0, g1)
% Scalar4KFilters calculates four-channel single filter bank response
% coeficients
% Input variables:
% in: g0, g1 matrix impulse responses of Multiwavelet
% Output variables:
% Scalar4KFilters: scalar response coeficients of a four-channel single
% filter bank stored in cell variable

% Creating output variable
Scalar4KFilters = cell(4, 1);

% check input variables
if isempty(g0) || isempty(g1) || (size(g0, 2) ~= size(g1, 2))
    ME = MException('Scalar4KFilters:wrongInput', ...
        'Input matrices cannot be empty and need to be the same size!');
    throw(ME);
end

% Creating temponary variables
w0 = zeros(1, size(g0, 2)*2);
w1 = zeros(1, size(g0, 2)*2);
s0 = zeros(1, size(g0, 2)*2);
s1 = zeros(1, size(g0, 2)*2);
try
    % Copy constants from matrix impulse responses to temponary variables.
    for i = 1:size(g0, 2)
        s0(1, (i*2)) = g0{i}(1, 1);
        s0(1, (i*2)-1) = g0{i}(1, 2);
        s1(1, (i*2)) = g0{i}(2, 1);
        s1(1, (i*2)-1) = g0{i}(2, 2);

        w0(1, (i*2)) = g1{i}(1, 1);
        w0(1, (i*2)-1) = g1{i}(1, 2);
        w1(1, (i*2)) = g1{i}(2, 1);
        w1(1, (i*2)-1) = g1{i}(2, 2);
    end

    % Saving values in temponary variables to output variable
    Scalar4KFilters{1} = s0;
    Scalar4KFilters{2} = s1;
    Scalar4KFilters{3} = w0;
    Scalar4KFilters{4} = w1;

catch err
    disp('Error while creating scalar filters!');
    errorMsg = getReport(err);
    disp(errorMsg);
    return;
end

end