% 

function [] = plot_compare_sampling(Set_Date_1,Set_Date_2,XOMMarketDepthOct2016_Values,DateTime_Con,num_intervals,q,selected_features,feature_name_list,interval_list,fs,type,Time_interval,filter_order,freq_fraction)

[Values,DateTime] = find_datetime_no_interval(Set_Date_1,Set_Date_2,XOMMarketDepthOct2016_Values,DateTime_Con);

% Resamples the data
% Type = 0 ('event') takes the most recent event in the data
% Type = 1 ('inter') linear interpolates the data
[Values_resample,DateTime_resample] = resample_data(Values,DateTime,fs,type,Set_Date_1,Set_Date_2,Time_interval,selected_features);

% Filters the data using a butterworth filter
[Values_filter] = filter_data(filter_order,freq_fraction,Values_resample);

% Add size values to the resampled and filtered matricies
selected_features2 = zeros(size(selected_features,1));
n = 1;

for j = selected_features
    
    if mod(j,2) ~= 0
        
        selected_features2(n) = j + 1;
        n = n + 1;
        
    end
    
end

n = 1;
for i = 1:size(selected_features,2)
    
    if mod(selected_features(i),2) ~= 0
        
        selected_features3(n) = selected_features(i);
        n = n + 1;
        
    end
    
end

[Values_resample2,DateTime_resample2] = resample_data(Values,DateTime,fs,type,Set_Date_1,Set_Date_2,Time_interval,selected_features2);
[Values_filter2] = filter_data(filter_order,freq_fraction,Values_resample2);

Values_resample = Values_resample + Values_resample2;
Values_filter = Values_filter + Values_filter2;

% Remove negative terms from filtered data
Values_filter(Values_filter < 0) = 0.0001;

ax = zeros(3,1);

figure

% Plots the raw data
ax(1) = subplot(3,1,1);

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

title('Prices of raw data')
xlabel('Date and time')
ylabel('Price of each level')

str = feature_name_list(selected_features3);
legend(str)

hold off

% Plots resampled data
ax(2) = subplot(3,1,2);

for j = selected_features
    
    if mod(j,2) ~= 0
        
        scatter(datetime(DateTime_resample,'ConvertFrom','datenum'),Values_resample(:,j),Values_resample(:,j+1).^q, 'filled')
        hold on
        
    end
    
end

hold on
% 
% for i = 1:size(interval_list,2)
%     
%     y = interval_list(i);
%     plot([y y],ylim,':k')
%     hold on
%     
% end

title('Prices of resampled data')
xlabel('Date and time')
ylabel('Price of each level')

str = feature_name_list(selected_features3);
legend(str)

hold off

ax(3) = subplot(3,1,3);

for j = selected_features
    
    if mod(j,2) ~= 0
        
        scatter(datetime(DateTime_resample,'ConvertFrom','datenum'),Values_filter(:,j),Values_filter(:,j+1).^q, 'filled')
        hold on
        
    end
    
end

hold on

% for i = 1:size(interval_list,2)
%     
%     z = interval_list(i);
%     plot([z z],ylim,':k')
%     hold on
%     
% end

title('Prices of resampled and filtered data')
xlabel('Date and time')
ylabel('Price of each level')

str = feature_name_list(selected_features3);
legend(str)

% Links the axes together so the values are easier to compare
linkaxes(ax,'y');




end
