% Does the same as the other ones but only for resampled and filter data

function [R_resampleSt,R_filterSt,largest_R_resampleSt,largest_R_filterSt] = ...
    calculate_correlations_vary_resampling(selected_features,num_max,Set_Date_1,Set_Date_2,...
    XOMMarketDepthOct2016_Values,DateTime_Con,fs,type,Time_interval,freq_fraction,filter_order,fs_range,fs_step)

% Finds the difference between the two sampling frequency ranges
relative_range = fs_range(2) - fs_range(1);

% Number of different frequencies to be used
num_freq = round(relative_range/fs_step);

% Predefine matrices
R_resampleSt = zeros(size(selected_features,2),size(selected_features,2),num_freq);
R_filterSt = zeros(size(selected_features,2),size(selected_features,2),num_freq);

largest_R_resampleSt = zeros(round(0.5*num_max),3,num_freq);
largest_R_filterSt = zeros(round(0.5*num_max),3,num_freq);

% Calls data to be used
[Values,DateTime] = find_datetime_no_interval(Set_Date_1,Set_Date_2,XOMMarketDepthOct2016_Values,DateTime_Con);

i = 1;

for fs = linspace(fs_range(1),fs_range(2),num_freq)
    
    [Values_resample,DateTime_resample] = resample_data(Values,DateTime,fs,type,Set_Date_1,Set_Date_2,Time_interval,selected_features);

    % Filters the data using a butterworth filter
	[Values_filter] = filter_data(filter_order,freq_fraction,Values_resample);
    
    R_resampleS = standard_correlation(Values_resample,selected_features);
    R_filterS = standard_correlation(Values_filter,selected_features);
    
    R_resampleSt(:,:,i) = R_resampleS;
    R_filterSt(:,:,i) = R_filterS;
    
    largest_R_resampleS = find_largest_R_S(R_resampleS,num_max);
    largest_R_filterS = find_largest_R_S(R_filterS,num_max);
    
    largest_R_resampleSt(:,:,i) = largest_R_resampleS;
    largest_R_filterSt(:,:,i) = largest_R_filterS;
    
    i = i + 1;
    
end


end
