% Find the largest values of the correlation matrix to hence find the
% parameters with the most correlation
% Largest_R has 1st column containing largest values.  2nd column contains
% corresponding row and 3rd column contatins corresponding column.

function largest_R = find_largest_R_S(R,num_max)

% Remove autocorrelation
for i = 1:size(R,2)
    
    R(i,i) = R(i,i) - 1;        
    
end

largest_R = zeros(num_max,3);

for i = 1:num_max
    
    [M,I] = max(abs(R(:)));
    
    [I_row,I_col] = ind2sub(size(R),I);
    
    largest_R(i,1) = R(I_row,I_col);
    largest_R(i,2) = I_row;
    largest_R(i,3) = I_col;
    
    R(I_row,I_col) = 0;
    
end

% Remove the repeated terms
largest_R = largest_R .* toeplitz(mod(1:num_max,2),mod(1:1,2));

largest_R(~any(largest_R,2),:) = [];

end
