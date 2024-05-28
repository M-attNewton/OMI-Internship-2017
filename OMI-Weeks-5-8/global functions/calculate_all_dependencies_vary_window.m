% Calculates all dependecies along with a list of their most significant values, uses seperate intervals to compute dependencies.

function [R_SWt,R_SresampleWt,R_SfilterWt,R_BWt,R_FWt,R_CWt,R_CresampleWt,R_CfilterWt,...
    largest_R_SWt,largest_R_SresampleWt,largest_R_SfilterWt,largest_R_BWt,largest_R_FWt,...
    largest_R_CWt,largest_R_CresampleWt,largest_R_CfilterWt] ...
    = calculate_all_dependencies_vary_window(selected_features,num_intervals,num_max,Set_Date_1,Set_Date_2, ...
    XOMMarketDepthOct2016_Values,DateTime_Con,fs,type,freq_fraction,filter_order)


% Pre-define matrices.
R_SWt = zeros(size(selected_features,2),size(selected_features,2),num_intervals);
R_SresampleWt = zeros(size(selected_features,2),size(selected_features,2),num_intervals);
R_SfilterWt = zeros(size(selected_features,2),size(selected_features,2),num_intervals);
R_BWt = zeros(size(selected_features,2),size(selected_features,2),num_intervals);
R_FWt = zeros(size(selected_features,2),size(selected_features,2),num_intervals);
R_CWt = zeros(size(selected_features,2),size(selected_features,2),num_intervals);
R_CresampleWt = zeros(size(selected_features,2),size(selected_features,2),num_intervals);
R_CfilterWt = zeros(size(selected_features,2),size(selected_features,2),num_intervals);

largest_R_SWt = zeros(round(0.5*num_max),3,num_intervals);
largest_R_SresampleWt = zeros(round(0.5*num_max),3,num_intervals);
largest_R_SfilterWt = zeros(round(0.5*num_max),3,num_intervals);
largest_R_BWt = zeros(round(0.5*num_max),3,num_intervals);
largest_R_FWt = zeros(round(0.5*num_max),3,num_intervals);
largest_R_CWt = zeros(round(0.5*num_max),3,num_intervals);
largest_R_CresampleWt = zeros(round(0.5*num_max),3,num_intervals);
largest_R_CfilterWt = zeros(round(0.5*num_max),3,num_intervals);

for i = 1:num_intervals

X = ['Finding dependencies for window number ', num2str(i)];    
disp(X);  
    
% Puts data into two matrices, Values containing all the numerical data and DateTime containing all the dates.
[Values,DateTime] = find_datetime_time_window(Set_Date_1,Set_Date_2,XOMMarketDepthOct2016_Values,DateTime_Con,i,num_intervals);

% Resamples the data.
% Type = 0 ('event') takes the most recent event in the data.
% Type = 1 ('inter') linear interpolates the data.
[Values_resample,~] = resample_data(Values,DateTime,fs,type,selected_features);

% Filters the data using a butterworth filter.
[Values_filter] = filter_data(filter_order,freq_fraction,Values_resample);

% Computes all dependency methods for the required data.
R_SW = standard_correlation(Values,selected_features);
R_SresampleW = standard_correlation(Values_resample,selected_features);
R_SfilterW = standard_correlation(Values_filter,selected_features);
R_BW = brownian_estimator(Values,selected_features);
R_FW = fourier_estimator(Values,DateTime,selected_features);
R_CW = copula_estimator(Values,selected_features);
R_CresampleW = copula_estimator(Values_resample,selected_features);
R_CfilterW = copula_estimator(Values_filter,selected_features);

% Puts the matricies in the 3D matrix with time.
R_SWt(:,:,i) = R_SW;
R_SresampleWt(:,:,i) = R_SresampleW;
R_SfilterWt(:,:,i) = R_SfilterW;
R_BWt(:,:,i) = R_BW;
R_FWt(:,:,i) = R_FW;
R_CWt(:,:,i) = R_CW;
R_CresampleWt(:,:,i) = R_CresampleW;
R_CfilterWt(:,:,i) = R_CfilterW;

% Finds the most signicant dependicies for each time window.
largest_R_SWt(:,:,i) = find_largest_R(R_SW,num_max);
largest_R_SresampleWt(:,:,i) = find_largest_R(R_SresampleW,num_max);
largest_R_SfilterWt(:,:,i) = find_largest_R(R_SfilterW,num_max);
largest_R_BWt(:,:,i) = find_largest_R(R_BW,num_max);
largest_R_FWt(:,:,i) = find_largest_R(R_FW,num_max);
largest_R_CWt(:,:,i) = find_largest_R(R_CW,num_max);
largest_R_CresampleWt(:,:,i) = find_largest_R(R_CresampleW,num_max);
largest_R_CfilterWt(:,:,i) = find_largest_R(R_CfilterW,num_max);

X = ['Dependencies for window number ', num2str(i), ' found'];    
disp(X); 

end

end
