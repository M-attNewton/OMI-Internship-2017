% Copula estimator to measure the dependency between the different features. 
% The inbuild MATLAB function "copulafit" is used to find a student-t copula fit for the data. 
% Features that are too similar are removed when copulafit is run and added back into the dependency matrix afterwards.

% The understanding of copulas and the reasoning for using them in this context were obtained from the following papers.

% "Copulas: A persoanl view" - Paul Embrechts 2009.
% "A review of copula models for economic time series" - Andrew Patton 2012.
% "Modelling dependencies: An Overview" - Martyn Dorey & Phil Joubert 2005.

% The options at the top of this function are not intended for standard use, they have been left in incase the user would like to experiment with them!

function [R_C] = copula_estimator(Values,selected_features)

% Determines whether copulafit includes all features or just the selected features.
copula_all_features = 0;

% Determines whether the removed components are merged or just removed.
copula_merge = 0;

% Runs the pca analysis.
copula_pca = 0;

if copula_pca == 0
   
% Compute log returns.
Values_lr = diff(log(Values));

% Avoids issues with complex numbers.
Values_lr = real(Values_lr);  

if copula_all_features == 0
    
    % Converts the data into a scale for copulas using a kernel estimator.
    Values_ks = zeros(size(Values_lr,1),size(selected_features,1));
    
    n = 1;
    for i = selected_features   

        Values_ks(:,n) = ksdensity(Values_lr(:,i),Values_lr(:,i),'function','cdf');
        n = n + 1;

    end

end

if copula_all_features == 1 
         
    selected_features = 1:40;
    
    % Converts the data into a scale for copulas using a kernel estimator.
    Values_ks = zeros(size(Values_lr,1),size(selected_features,1));
    
    n = 1;
    for i = selected_features  

        Values_ks(:,n) = ksdensity(Values_lr(:,i),Values_lr(:,i),'function','cdf');
        n = n + 1;

    end
           
end

% Looks for data that is too similar using their mean squared error.
% If this is not done the columns in Values_ks will be too similar and the copulafit function will be rank defficient.
n = 1;
mark = zeros(size(Values_ks,2));

for i = 1:size(Values_ks,2)
    m = 2;
    for j = i:size(Values_ks,2)
        
        if j ~= i
        
            Values_ks_diff = Values_ks(:,i) - Values_ks(:,j);

            % Criteria to determine similarity.
            if mse(Values_ks_diff) < 5e-15  
                
                % Mark matrix to contain reference of columns to be removed 
                % for being too similar.
                 mark(n,1) = i;
                 mark(n,m) = j;
                 m = m + 1;
               

            end
            
        end
        
    end
    n = n + 1;
end

% Removes rows and columns that are all zeros.
mark(all(mark == 0,2),:) = [];
mark(:,all(mark == 0,1)) = [];

% Converts the marked columns from Values_ks to zero.
for i = 1:size(mark,1)
    
    for j = 2:size(mark,2)
        
        if mark(i,j) ~= 0
            
            % Merges the columns if the option is selected.
            if copula_merge == 1
               
                Values_ks(:,mark(i,1)) = (Values_ks(:,mark(i,1)) + Values_ks(:,mark(i,j)))/2;                
                
            end
        
            Values_ks(:,mark(i,j)) = 0;
                       
        end
        
    end
    
end

% Removes the zero columns (marked columns) from Values_ks.
Values_ks(:,all(Values_ks == 0,1)) = [];

% Parameter to determine if the copula fit has failed or not.
a = 0;
try 
    
    % Fits the data to the specified copula.
    % Could change approximateML to ML (Max liklihood).
    [Rho,~] = copulafit('t',Values_ks,'Method','ApproximateML');

catch
      
    a = 1;
    
    try
        
        % Looks for data that is too similar using a mean squared error.
        % If this is not done the columns in Values_ks will be too similar 
        % and the copulafit function will be rank defficient.
        n = 1;
        mark = zeros(size(Values_ks,2));

        for i = 1:size(Values_ks,2)
            m = 2;
            for j = i:size(Values_ks,2)

                if j ~= i

                    Values_ks_diff = Values_ks(:,i) - Values_ks(:,j);

                    if mse(Values_ks_diff) < 5e-14  

                        % Mark matrix to contain reference of columns to be removed
                        % for being too similar.
                         mark(n,1) = i;
                         mark(n,m) = j;
                         m = m + 1;


                    end

                end

            end
            n = n + 1;
        end

        % Removes rows and columns that are all zeros.
        mark(all(mark == 0,2),:) = [];
        mark(:,all(mark == 0,1)) = [];

        % Converts the marked columns from Values_ks to zero.
        for i = 1:size(mark,1)

            for j = 2:size(mark,2)

                if mark(i,j) ~= 0

                    % Merges the columns if the option is selected.
                    if copula_merge == 1

                        Values_ks(:,mark(i,1)) = (Values_ks(:,mark(i,1)) ...
                        + Values_ks(:,mark(i,j)))/2;                

                    end

                    Values_ks(:,mark(i,j)) = 0;

                end

            end

        end

        % Removes the zero columns (marked columns) from Values_ks.
        Values_ks(:,all(Values_ks == 0,1)) = [];
        
        % Fits the data to the specified copula.
        % Could change approximateML to ML (Max liklihood).
        [Rho,~] = copulafit('t',Values_ks,'Method','ApproximateML');
        
    catch
        
        a = 2;
        
    end

end

if a == 1
    
    % Looks for data that is too similar using a mean squared error.
    % If this is not done the columns in Values_ks will be too similar and the
    % copulafit function will be rank defficient.
    n = 1;
    mark = zeros(size(Values_ks,2));

    for i = 1:size(Values_ks,2)
        m = 2;
        for j = i:size(Values_ks,2)

            if j ~= i

                Values_ks_diff = Values_ks(:,i) - Values_ks(:,j);

                if mse(Values_ks_diff) < 5e-14  

                    % Mark matrix to contain reference of columns to be removed
                    % for being too similar.
                     mark(n,1) = i;
                     mark(n,m) = j;
                     m = m + 1;


                end

            end

        end
        n = n + 1;
    end

    % Removes rows and columns that are all zeros.
    mark(all(mark == 0,2),:) = [];
    mark(:,all(mark == 0,1)) = [];

    % Converts the marked columns from Values_ks to zero.
    for i = 1:size(mark,1)

        for j = 2:size(mark,2)

            if mark(i,j) ~= 0

                % Merges the columns if the option is selected.
                if copula_merge == 1

                    Values_ks(:,mark(i,1)) = (Values_ks(:,mark(i,1))...
                    + Values_ks(:,mark(i,j)))/2;                

                end

                Values_ks(:,mark(i,j)) = 0;

            end

        end

    end

    % Removes the zero columns (marked columns) from Values_ks.
    Values_ks(:,all(Values_ks == 0,1)) = [];

    % Fits the data to the specified copula.
    % Could change approximateML to ML (Max liklihood).
    [Rho,~] = copulafit('t',Values_ks,'Method','ApproximateML'); 

    % Dependency matrix calculated from copulas.
    R_C = 2.*asin(Rho)./pi;
    R_C2 = R_C;

    mark2 = mark(:,2:end);
    mark_unique = unique(mark2);
    mark_unique(mark_unique == 0) = [];

    % Add relvant vectors into the repeated gaps.
    for i = mark_unique.'

        [row,~] = find(mark == i,1,'last');
        R_C = [R_C(:,1:i-1) R_C(:,mark(row,1)) R_C(:,i:end)]; 
        R_C = [R_C(1:i-1,:); R_C(mark(row,1),:); R_C(i:end,:)];

    end
    
elseif a == 2
    
    R_C = ones(length(selected_features));
    
else

    % Dependency matrix calculated from copulas.
    R_C = 2.*asin(Rho)./pi;
    R_C2 = R_C;

    mark2 = mark(:,2:end);
    mark_unique = unique(mark2);
    mark_unique(mark_unique == 0) = [];

    % Add relvant vectors into the repeated gaps.
    for i = mark_unique.'

        [row,~] = find(mark == i,1,'last');
        R_C = [R_C(:,1:i-1) R_C(:,mark(row,1)) R_C(:,i:end)]; 
        R_C = [R_C(1:i-1,:); R_C(mark(row,1),:); R_C(i:end,:)];

    end

end

% This section is incomplete, the idea is to use pca analysis to determine whether the copula_fit will work.
% The code has been commented out for potential future improvements.
elseif copula_pca == 1
    
    Values_lr = diff(log(Values));
    [COEFF, SCORE, LATENT, TSQUARED, EXPLAINED, MU] = pca(Values_lr);

      
%     m = 1;
%     for i = 1:length(EXPLAINED)
%        
%         sum_exp = sum(EXPLAINED(1:i,1));
%         
%         if sum_exp < 99
%            
%             m = m + 1;
%             
%         end
%                        
%     end
%     
%     Values_lr_recon = SCORE(:,1:m)*COEFF(:,1:m)';
%         
%     Values_ks = zeros(size(Values_lr_recon,1),size(selected_features,1));
%         
%     % Converts the data into a scale for copulas using a kernel estimator
%     n = 1;
%     for i = selected_features   
% 
%         Values_ks(:,n) = ksdensity(Values_lr_recon(:,i),Values_lr_recon(:,i),'function','cdf');
%         n = n + 1;
% 
%     end
%     
%     [Rho,~] = copulafit('t',Values_ks,'Method','ApproximateML');  %ApproximateML or ML
% 
%     % Correlation matrix calculated from copulas
%     R_C = 2.*asin(Rho)./pi;


end

end


