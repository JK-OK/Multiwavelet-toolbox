function mat = DMWTMatrix(n, multiwavelet, organized, varargin)
% DMWTMatrix creates DMWT transformation matrix of selected size and
% multiwavelet
% Input variables:
% n: required size of transformation matrix
% multiwavelet: multiwavelet used for creating transformation matrix
% organized: If selected True the coeficients of a matrix will be organized
% in following way 
% c11, c11, ..., c12, c12, ..., d11, d11, ..., d12, d12, ...
% if selected False then the coeficients of a matrix will be organized
% in following way 
% c11, c12, d11, d12, c11, c12, d11, d12, ...
% varargin: It is possible to define custom extension according to MATLAB
% extensions. If not defined then periodic extension will be used
% Output variables:
% mat: DMWT transformation matrix with size of n * n
% Examples:
% mat = DMWTMatrix(512, 'BAT03', true);
% mat = DMWTMatrix(64, 'DB6', false, 'ppd');

multiwavelet = loadMW(multiwavelet);

% Create eye matrix of required size
mat = eye(n);

% Create transformation matrix row by row
for i = 1:size(mat, 2)

    % Select one row of eye matrix and apply DMWT on it
    vec = mat(:, i);
    [c11, c12, d11, d12] = fast_DMWT(vec', multiwavelet,varargin{:});

    % Organize coefficient in required way.
    if organized
        vec = [c11, c12, d11, d12]';
%         vec = [upsample(c11, 2, 0) + upsample(c12, 2, 1), upsample(d11, 2, 0) + upsample(d12, 2, 1)];
    else
        vec = upsample(c11, 4, 0) + upsample(c12, 4, 1) + upsample(d11, 4, 2) + upsample(d12, 4, 3);
        vec = vec';
    end

    % Write organized coefficients to output matrix 
    mat(:, i) = vec;
end

end