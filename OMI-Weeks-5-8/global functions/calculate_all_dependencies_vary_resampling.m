% Calculates all dependecies along with a list of their most significant values, uses different resample rates to compute dependencies.

function [R_SresampleSt,R_SfilterSt,R_CresampleSt,R_CfilterSt,...
    largest_R_SresampleSt,largest_R_SfilterSt,largest_R_CresampleSt,largest_R_CfilterSt] = ...
    calculate_all_dependencies_vary_resampling(selected_features,num_max,Set_Date_1,Set_Date_2,...
    XOMMarketDepthOct2016_Values,DateTime_Con,type,freq_fraction,filter_order,fs_range,num_freq)

% Predefine matrices
R_SresampleSt = zeros(size(selected_features,2),size(selected_features,2),num_freq);
R_SfilterSt = zeros(size(selected_features,2),size(selected_features,2),num_freq);
R_CresampleSt = zeros(size(selected_features,2),size(selected_features,2),num_freq);
R_CfilterSt = zeros(size(selected_features,2),size(selected_features,2),num_freq);

largest_R_SresampleSt = zeros(round(0.5*num_max),3,num_freq);
largest_R_SfilterSt = zeros(round(0.5*num_max),3,num_freq);
largest_R_CresampleSt = zeros(round(0.5*num_max),3,num_freq);
largest_R_CfilterSt = zeros(round(0.5*num_max),3,num_freq);

% Calls data to be used.
[Values,DateTime] = find_datetime_no_interval(Set_Date_1,Set_Date_2,XOMMarketDepthOct2016_Values,DateTime_Con);

% Vector of all frequencies to be computed.
fs = linspace(fs_range(1),fs_range(2),num_freq);

for i = 1:length(fs)
    
    X = ['Finding dependencies for frequency ', num2str(fs(i))];    
    disp(X);    
    
    % Resamples the data at each frequency.
    [Values_resample,~] = resample_data(Values,DateTime,fs(i),type,selected_features);

    % Filters the data using a butterworth filter.
	[Values_filter] = filter_data(filter_order,freq_fraction,Values_resample);
      
    % Computes all dependency methods for the required data.
    R_SresampleS = standard_correlation(Values_resample,selected_features);
    R_SfilterS = standard_correlation(Values_filter,selected_features);
    R_CresampleS = copula_estimator(Values_resample,selected_features);
    R_CfilterS = copula_estimator(Values_filter,selected_features);
    
    % Puts the matricies in the 3D matrix with time.
    R_SresampleSt(:,:,i) = standard_correlation(Values_resample,selected_features);
    R_SfilterSt(:,:,i) = standard_correlation(Values_filter,selected_features);
    R_CresampleSt(:,:,i) = copula_estimator(Values_resample,selected_features);
    R_CfilterSt(:,:,i) = copula_estimator(Values_filter,selected_features);
        
    % Finds the most signicant dependicies for each time interval.
    largest_R_SresampleSt(:,:,i) = find_largest_R(R_SresampleS,num_max);
    largest_R_SfilterSt(:,:,i) = find_largest_R(R_SfilterS,num_max);
    largest_R_CresampleSt(:,:,i) = find_largest_R(R_CresampleS,num_max);
    largest_R_CfilterSt(:,:,i) = find_largest_R(R_CfilterS,num_max);
    
    X = ['Dependencies for frequency ', num2str(fs(i)), ' found'];    
    disp(X); 
        
end

end

