function [r]= all_zero(matrix)

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