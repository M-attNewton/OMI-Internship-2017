% Does the bulk of the calculation for finding the correlation with a
% varying time window


function [R_SWt,R_resampleWt,R_filterWt,R_BWt,R_FWt,largest_R_SWt,largest_R_resampleWt,largest_R_filterWt,largest_R_BWt,largest_R_FWt] ...
    = calculate_all_correlations_window(selected_features,num_intervals,num_max,Set_Date_1,Set_Date_2, ...
    XOMMarketDepthOct2016_Values,DateTime_Con,fs,type,Time_interval,freq_fraction,filter_order)


% Pre-define matrices
R_SWt = zeros(size(selected_features,2),size(selected_features,2),num_intervals);
R_resampleWt = zeros(size(selected_features,2),size(selected_features,2),num_intervals);
R_filterWt = zeros(size(selected_features,2),size(selected_features,2),num_intervals);
R_BWt = zeros(size(selected_features,2),size(selected_features,2),num_intervals);
R_FWt = zeros(size(selected_features,2),size(selected_features,2),num_intervals);

largest_R_SWt = zeros(round(0.5*num_max),3,num_intervals);
largest_R_resampleWt = zeros(round(0.5*num_max),3,num_intervals);
largest_R_filterWt = zeros(round(0.5*num_max),3,num_intervals);
largest_R_BWt = zeros(round(0.5*num_max),3,num_intervals);
largest_R_FWt = zeros(round(0.5*num_max),3,num_intervals);

k = 0; % Used to count the number of dats in find_datetime_C3
w = 0; % Used to count the number of weekend days in find_datetime_C3

for i = 1:num_intervals

% Puts data into two matrices, Values containing all the numerical data and
% DateTime containing all the dates
[Values,DateTime,k,w] = find_datetime_window(Set_Date_1,Set_Date_2,XOMMarketDepthOct2016_Values,DateTime_Con,i,num_intervals,k,w);

% Resamples the data
% Type = 0 ('event') takes the most recent event in the data
% Type = 1 ('inter') linear interpolates the data
[Values_resample,DateTime_resample] = resample_data(Values,DateTime,fs,type,Set_Date_1,Set_Date_2,Time_interval,selected_features);

% Filters the data using a butterworth filter
[Values_filter] = filter_data(filter_order,freq_fraction,Values_resample);

% Find large corrleation matrix between all parameters of data
R_SW = standard_correlation(Values,selected_features);
R_resampleW = standard_correlation(Values_resample,selected_features);
R_filterW = standard_correlation(Values_filter,selected_features);
R_BW = brownian_estimator(Values,selected_features);
R_FW = fourier_estimator(Values,DateTime,selected_features);

% Puts the matricies in the matrix with time
R_SWt(:,:,i) = R_SW;
R_resampleWt(:,:,i) = R_resampleW;
R_filterWt(:,:,i) = R_filterW;
if size(R_BW,2) == size(R_BWt,2)

    R_BWt(:,:,i) = R_BW;

end
R_FWt(:,:,i) = R_FW;

% Finds the most signicant dependicies for each time window
largest_R_SW = find_largest_R_S(R_SW,num_max);
largest_R_resampleW = find_largest_R_S(R_resampleW,num_max);
largest_R_filterW = find_largest_R_S(R_filterW,num_max);
largest_R_BW = find_largest_R_S(R_BW,num_max);
largest_R_FW = find_largest_R_S(R_FW,num_max);

% Puts the matrix in a matrix that contains all the times
largest_R_SWt(:,:,i) = largest_R_SW;
largest_R_resampleWt(:,:,i) = largest_R_resampleW;
largest_R_filterWt(:,:,i) = largest_R_filterW;
largest_R_BWt(:,:,i) = largest_R_BW;
largest_R_FWt(:,:,i) = largest_R_FW;


end

end