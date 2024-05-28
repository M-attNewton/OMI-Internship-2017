% A scatter plot showing the price of the selected levels against time, with the size of each line representing the size of each level. 
% All features are super-imposed on the same plot. 
% Dotted line represents the interval spacing.

function plot_levels_scatter(Set_Date_1,Set_Date_2,XOMMarketDepthOct2016_Values,DateTime_Con,circle_size,selected_features,feature_name_list,interval_list)

% Finds the date and time but does not consider the intervals and the time when the market is closed.
[Values,DateTime] = find_datetime_no_interval(Set_Date_1,Set_Date_2,XOMMarketDepthOct2016_Values,DateTime_Con);

f1 = figure('Name','Scatter of Selected Levels','NumberTitle','off');
figure(f1)

for j = selected_features
    
    % Only takes the odd terms.
    if mod(j,2) ~= 0    
        
        scatter(DateTime,Values(:,j),Values(:,j+1).^circle_size, 'filled')
        hold on
        
    end
    
end

hold on

% Plots the intervals on the graph.
for i = 1:size(interval_list,2)
    
    x = interval_list(i);
    plot([x x],ylim,':k')
    hold on
    
end

title('Price of selected levels against time where the line width represents size of the level')
xlabel('Date and time')
ylabel('Price of each level')

% Creates a vector to contain the inputs to the legend.
n = 1;
for i = 1:size(selected_features,2)
    
    if mod(selected_features(i),2) ~= 0
        
        selected_features2(n) = selected_features(i);
        n = n + 1;
        
    end
    
end

str = feature_name_list(selected_features2);
legend(str)

end
