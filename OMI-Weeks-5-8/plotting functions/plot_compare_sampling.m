% A scatter plot showing the price of the selected levels against time, with the size of each line representing the size of each level. 
% Each subplot compares the effect sampling and filtering to raw data.

function [] = plot_compare_sampling(Set_Date_1,Set_Date_2,XOMMarketDepthOct2016_Values,DateTime_Con,circle_size,selected_features,feature_name_list,interval_list,fs,type,filter_order,freq_fraction)

[Values,DateTime] = find_datetime_no_interval(Set_Date_1,Set_Date_2,XOMMarketDepthOct2016_Values,DateTime_Con);

% Resamples the data.
% Type = 0 ('event') takes the most recent event in the data.
% Type = 1 ('inter') linear interpolates the data.
[Values_resample,DateTime_resample] = resample_data(Values,DateTime,fs,type,selected_features);

% Filters the data using a butterworth filter.
[Values_filter] = filter_data(filter_order,freq_fraction,Values_resample);

% Add size values to the resampled and filtered matricies.
selected_features2 = zeros(size(selected_features,1));
n = 1;

for j = selected_features
    
    if mod(j,2) ~= 0
        
        selected_features2(n) = j + 1;
        n = n + 1;
        
    end
    
end

% Creates feature list for legend.
n = 1;
for i = 1:size(selected_features,2)
    
    if mod(selected_features(i),2) ~= 0
        
        selected_features3(n) = selected_features(i);
        n = n + 1;
        
    end
    
end

% Resamples the extra required data.
[Values_resample2,~] = resample_data(Values,DateTime,fs,type,selected_features2);
[Values_filter2] = filter_data(filter_order,freq_fraction,Values_resample2);

% Superimposes the two data vectors together.
Values_resample = Values_resample + Values_resample2;
Values_filter = Values_filter + Values_filter2;

% Remove negative terms from filtered data.
Values_filter(Values_filter < 0) = 0.0001;

ax = zeros(3,1);

f3 = figure('Name','Scatter Comparing the Sampling of the Data','NumberTitle','off');
figure(f3)

% Plots the raw data.
ax(1) = subplot(3,1,1);

for j = selected_features
    
    if mod(j,2) ~= 0
        
        scatter(DateTime,Values(:,j),Values(:,j+1).^circle_size, 'filled')
        hold on
        
    end
    
end

hold on

% Overlays the interval list on the plot.
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

% Plots resampled data.
ax(2) = subplot(3,1,2);

for j = selected_features
    
    if mod(j,2) ~= 0
        
        scatter(datetime(DateTime_resample,'ConvertFrom','datenum'),Values_resample(:,j),Values_resample(:,j+1).^circle_size, 'filled')
        hold on
        
    end
    
end

hold on

% Converts interval list from datetime to datenum then back so that the time zones on the graph match.
interval_list = datenum(interval_list);
interval_list = datetime(interval_list,'ConvertFrom','datenum');

for i = 1:size(interval_list,2)
    
    y = interval_list(i);
    plot([y y],ylim,':k')
    hold on
    
end

title('Prices of resampled data')
xlabel('Date and time')
ylabel('Price of each level')

str = feature_name_list(selected_features3);
legend(str)

hold off

ax(3) = subplot(3,1,3);

for j = selected_features
    
    if mod(j,2) ~= 0
        
        scatter(datetime(DateTime_resample,'ConvertFrom','datenum'),Values_filter(:,j),Values_filter(:,j+1).^circle_size, 'filled')
        hold on
        
    end
    
end

hold on

for i = 1:size(interval_list,2)
    
    z = interval_list(i);
    plot([z z],ylim,':k')
    hold on
    
end

title('Prices of resampled and filtered data')
xlabel('Date and time')
ylabel('Price of each level')

str = feature_name_list(selected_features3);
legend(str)

% Links the axes together so the values are easier to compare.
linkaxes(ax,'y');

end
