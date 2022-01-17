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