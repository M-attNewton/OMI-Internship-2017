% Find the largest values of the correlation matrix to hence find the parameters with the greatest dependency.
% Largest_R has 1st column containing corresponding row and 2nd column contatins corresponding column. 3rd column containing largest values. 

function largest_R = find_largest_R(R,num_max)

% Remove diagonal as will always be of value one.
for i = 1:size(R,2)
    
    R(i,i) = R(i,i) - 1;        
    
end

% Pre-define matrices.
largest_R = zeros(num_max,3);

for i = 1:num_max
    
    % Finds max values.
    [~,I] = max(abs(R(:)));
    
    % Converts to row and column indecies.
    [I_row,I_col] = ind2sub(size(R),I);
    
    largest_R(i,1) = I_row;
    largest_R(i,2) = I_col;
    largest_R(i,3) = R(I_row,I_col);
    
    % Removes term that was used.
    R(I_row,I_col) = 0;
    
end

% Remove the repeated terms.
largest_R = largest_R .* toeplitz(mod(1:num_max,2),mod(1:1,2));

largest_R(~any(largest_R,2),:) = [];

end
