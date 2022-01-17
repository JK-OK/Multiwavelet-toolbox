%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Multiwavelet toolbox, a toolbox for performing Multiwavelet transform   %
% Copyright (C) 2022  Jozef Kromka, Ondrej Kováč                          %
%                                                                         %
% This program is free software: you can redistribute it and/or modify    %
% it under the terms of the GNU General Public License as published by    %
% the Free Software Foundation, either version 3 of the License, or       %
% (at your option) any later version.                                     %
%                                                                         %
% This program is distributed in the hope that it will be useful,         %
% but WITHOUT ANY WARRANTY; without even the implied warranty of          %
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           %
% GNU General Public License for more details.                            %
%                                                                         %
% You should have received a copy of the GNU General Public License       %
% along with this program.  If not, see <https://www.gnu.org/licenses/>.  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If this software is used to make a contribution to the findings         %
% published in an article, then please consider citing our conference     %
% paper, from which this toolbox originates. You can find the citation at %
% https://github.com/JK-OK/Multiwavelet-toolbox                           %
% You can find there the contact information for authors as well.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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