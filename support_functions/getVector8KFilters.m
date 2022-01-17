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

function vector8KFilters = getVector8KFilters(g0, g1)
% vector8KFilters calculates multi (vector) filters response
% coeficients
% Input variables:
% in: g0, g1 matrix impulse responses of Multiwavelet
% Output variables:
% vector8KFilters: multi (vector) filters response coeficients

% Creating output variable
vector8KFilters = cell(8,1);

% check input variables
if isempty(g0) || isempty(g1) || (size(g0, 2) ~= size(g1, 2))
   ME = MException('vector8KFilters:wrongInput', ...
        'Input matrices cannot be empty and need to be the same size!');
    throw(ME); 
end

% Creating temponary variables
f01 = zeros(1, size(g0, 2));
f02 = zeros(1, size(g0, 2));
f03 = zeros(1, size(g0, 2));
f04 = zeros(1, size(g0, 2));
f11 = zeros(1, size(g0, 2));
f12 = zeros(1, size(g0, 2));
f13 = zeros(1, size(g0, 2));
f14 = zeros(1, size(g0, 2));

try
    % Copy constants from matrix impulse responses to temponary variables.
    for i = 1:size(g0, 2)
        f01(i) = g0{i}(1, 1);
        f02(i) = g0{i}(1, 2);
        f03(i) = g0{i}(2, 1);
        f04(i) = g0{i}(2, 2);
        f11(i) = g1{i}(1, 1);
        f12(i) = g1{i}(1, 2);
        f13(i) = g1{i}(2, 1);
        f14(i) = g1{i}(2, 2);
    end

    % Saving values in temponary variables to output variable
    vector8KFilters{1} = f01;
    vector8KFilters{2} = f02;
    vector8KFilters{3} = f03;
    vector8KFilters{4} = f04;
    vector8KFilters{5} = f11;
    vector8KFilters{6} = f12;
    vector8KFilters{7} = f13;
    vector8KFilters{8} = f14;
    
catch err
    disp('Error while calculating filters!');
    errorMsg = getReport(err);
    disp(errorMsg);
    return;
end

end