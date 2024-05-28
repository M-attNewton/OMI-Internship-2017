% Plots the price of the required level against time with the size of the
% line representing the size of each level

function plot_levels_scatter(Set_Date_1,Set_Date_2,XOMMarketDepthOct2016_Values,DateTime_Con,num_intervals,q,selected_features,feature_name_list,interval_list)

[Values,DateTime] = find_datetime_no_interval(Set_Date_1,Set_Date_2,XOMMarketDepthOct2016_Values,DateTime_Con);

figure

for j = selected_features
    
    if mod(j,2) ~= 0
        
        scatter(DateTime,Values(:,j),Values(:,j+1).^q, 'filled')
        hold on
        
    end
    
end

hold on

for i = 1:size(interval_list,2)
    
    x = interval_list(i);
    plot([x x],ylim,':k')
    hold on
    
end

title('Price of selected levels against time where the line width represents size of the level')
xlabel('Date and time')
ylabel('Price of each level')

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