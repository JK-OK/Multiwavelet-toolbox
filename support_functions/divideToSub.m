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