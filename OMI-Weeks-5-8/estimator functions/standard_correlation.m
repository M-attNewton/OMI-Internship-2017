% Computes the linear correlation using the standard MATLAB function.

function R_S = standard_correlation(Values,selected_features)

% Checks wether there are any values to compare, returns a zero matrix otherwise.
if ~isempty(Values)

    % Return log difference.
    Values_lr = diff(log(Values));
    
    % Pre-allocate matrix.
    R_S = zeros(2*size(Values,2),2*size(Values,2));
    
    % Cycles through all features and find the corrcoef of each.
    for i = selected_features

        for j = selected_features

        R_S(2*i-1:2*i,2*j-1:2*j) = corrcoef(Values_lr(:,i),Values_lr(:,j));

        end

    end

    R_S2 = zeros(2*size(Values,2),2*size(Values,2));
    
    % Extracts the relevant element of each 2x2 matrix and puts it into a
    % smaller matrix.
    for i = selected_features

        for j = selected_features

            A = R_S(2*i-1:2*i,2*j-1:2*j);
            R_S2(i,j) = A(2,1);

        end
    end

    % Only keeps the releveant terms.
    R_S = zeros(size(selected_features,2),size(selected_features,2));

    n = 1;

    for i = selected_features

        m = 1;

        for j = selected_features

            if isnan(R_S2(i,j))

                R_S(n,m) = 0;

                m = m + 1;

            else

                R_S(n,m) = real(R_S2(i,j));

                m = m + 1;

            end

        end

        n = n + 1;
        
          
    end
    
else
   
    R_S = zeros(size(selected_features,2),size(selected_features,2));
    
end


end

