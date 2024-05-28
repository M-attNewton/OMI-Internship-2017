% Should automatically create the subplots for the data

function [] = plot_levels_scatter_sub(Set_Date_1,Set_Date_2,XOMMarketDepthOct2016_Values,DateTime_Con,num_intervals,q,selected_features,feature_name_list,interval_list)

% Imports data to plot
[Values,DateTime] = find_datetime_no_interval(Set_Date_1,Set_Date_2,XOMMarketDepthOct2016_Values,DateTime_Con);

% Calculate number of features to use for subplots
k = 0;

for j = selected_features
    
    if mod(j,2) ~= 0
        
        k = k + 1;
        
    end
    
end

% Conditions used to determine the positions of the subplots
if k <= 2
    
    l = 1;
    m = 2;
    
elseif k > 2 && k <= 4
    
    l = 2;
    m = 2;
    
elseif k > 4 && k <= 6

    l = 2;
    m = 3;
    
elseif k > 6 && k <= 9 
    
    l = 3;
    m = 3;
    
elseif k > 9 && k <= 12
    
    l = 3;
    m = 4;
    
elseif k > 12 && k <= 16
    
    l = 4;
    m = 4;
    
elseif k > 16 && k <= 20
    
    l = 4;
    m = 5;  
    
end

% Vector to link the axes together
ax = zeros(k,1);

figure

n = 1;

for j = selected_features
    
    if mod(j,2) ~= 0
        
        ax(n) = subplot(l,m,n);
       
        n = n + 1;
        
        scatter(DateTime,Values(:,j),Values(:,j+1).^q, 'filled')
        
        hold on

        for i = 1:size(interval_list,2)

            x = interval_list(i);
            plot([x x],ylim,':k')
            hold on

        end
        
        title(feature_name_list(j))
        xlabel('Date and time')
        ylabel('Price of level')
                
    end
    
end

% Links the axes together so the values are easier to compare
linkaxes(ax,'y');


end