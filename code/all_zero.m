function [r]= all_zero(matrix)
%   Auxiliar function that finds if the matrix only has zeros by finding if
%   there is a 1 
%
for i=1:size(matrix,1)
    for j=1:size(matrix,2)
        if (matrix(i,j)==1)
            r=1;
            return;
        end
    end
end

r=0;
end