% Uses Takaki Hayashi and Nakahiro Yoshidas method from their paper "On covariance
% estimation of non-sychronously observed diffusion processes" - 2005. Where the
% data is effectively resychonised through the overlapping changes between
% features.

% The funciton is titled "brownian estimator" as the method is based on
% brownian motion

function [R_B] = brownian_estimator(Values,selected_features)

% Takes the log of the Values and find the difference between the previous
% element and the current element (X(2)-X(1)) is the first element.  So the
% total size is reduced by one.
Values_lr = diff(log(Values));

% Matrix to contain the non-zero values of the Values_lr with the start and
% end of their time intevals (index values).
% Will be used to compare the values contained within it.
compare = zeros(size(Values_lr,1),2*size(Values,2));

% Checks wether there is any data to use.
if ~isempty(Values)

for j = 1:size(Values_lr,2)
    
    % Parameter to count the rows.
    n = 1;
    
    for i = 1:size(Values_lr,1)
    
        if Values_lr(i,j) ~= 0 && Values_lr(i,j) ~= -Inf ...
           && Values_lr(i,j) ~= Inf && ~isnan(Values_lr(i,j)) 
            
            compare(n,2*j-1) = Values_lr(i,j);  %Value to use           
                      
            compare(n,2*j) = i + 1;             %The index of the value
                    
            n = n + 1;
            
        end
        
    end
    
end
     
% Removes redundent rows from the compare matrix.
compare(all(compare == 0,2),:) = [];

% Add row at top of compare to make next section easier.
compare = [toeplitz(mod(0:0,2),mod(0:(2*size(Values,2)-1),2));compare];

% Preallocate correlation matrix.
R_B = zeros(size(Values,2),size(Values,2));

% Compare each feature to one another by using the time windows between
% each element relative to the different features.
for g = selected_features  
    
    for h = selected_features
               
        % Create matrix to hold overlapping terms that are to be summed.
        terms = zeros(10*max(size(compare)),1);
        
        % Parameter to add terms to "terms".
        n = 1;
        
        % Cycles through all the time elements of the feature g.
        for  i = 1:(size(compare,1) - 1)
            
            % Time boundaries on feature g.
            t1g = compare(i,2*g);
            t2g = compare(i+1,2*g);
        
            % Cycles through all the time elements of the feature h.
            for j = 1:(size(compare,1) - 1)
                               
                % Time boundaries on feature h.
                t1h = compare(j,2*h);
                t2h = compare(j+1,2*h);                
                                
                % h1 is between g1 and g2, h2 is outside or equal to g2.
                if t1h >= t1g && t1h < t2g && t2h >= t2g
                    
                    terms(n) = (compare(i+1,2*g-1))*(compare(j+1,2*h-1));
                    n = n + 1;
                    
                % h1 is between g1 and g2, h2 is inside g2.
                elseif t1h >= t1g && t1h < t2g && t2h < t2g
                    
                    terms(n) = (compare(i+1,2*g-1))*(compare(j+1,2*h-1));
                    n = n + 1;
                   
                % g1 is between h1 and h2, g2 is outside or equal to h2.    
                elseif t1g >= t1h && t1g < t2h && t2g >= t2h
                    
                    terms(n) = (compare(i+1,2*g-1))*(compare(j+1,2*h-1));
                    n = n + 1;
                    
                % g1 is between h1 and h2, g2 is inside h2.    
                elseif t1g >= t1h && t1g < t2h && t2g < t2h
                    
                    terms(n) = (compare(i+1,2*g-1))*(compare(j+1,2*h-1));
                    n = n + 1;
                
                % Outside the region of interest.    
                elseif t1h >= t2g
                    
                    break                    
                    
                end
                
            end                        
           
        end
        
        R_B(h,g) = sum(terms);
        
    end
    
end

% The estimator can be standardised to find the dependencies.

% Contains all the sigma terms corresponding to each feature.
sigma = zeros(size(Values,2),1);

for i = selected_features 
    
    X = compare(:,2*i-1);
      
    sigma(i) = (sum(X.^2))^0.5;
    
end

% Standardises the dependencies.
for j = selected_features
    
    for i = selected_features
        
        R_B(i,j) = (R_B(i,j))./(sigma(i)*sigma(j));
        
    end
    
end

% Only keeps the releveant selected features.
R_B2 = zeros(size(selected_features,2),size(selected_features,2));
n = 1;

for i = selected_features

    m = 1;

    for j = selected_features

        if isnan(R_B(i,j))

            R_B2(n,m) = 0;

            m = m + 1;

        else

            R_B2(n,m) = R_B(i,j);

            m = m + 1;

        end

    end

    n = n + 1;


end

R_B = R_B2;

else 
   
    R_B = zeros(size(selected_features,2),size(selected_features,2));
    
end


end



