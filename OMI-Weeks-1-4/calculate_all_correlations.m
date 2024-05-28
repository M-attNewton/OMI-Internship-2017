% Does a large bulk of calculation, was cluttering up the main script so is
% now in a seperate function

function [R_St,R_resamplet,R_filtert,R_Bt,R_Ft,largest_R_St,largest_R_resamplet,largest_R_filtert,largest_R_Bt,largest_R_Ft] ...
    = calculate_all_correlations(selected_features,num_intervals,num_max,Set_Date_1,Set_Date_2, ...
    XOMMarketDepthOct2016_Values,DateTime_Con,fs,type,Time_interval,freq_fraction,filter_order)


% Pre-define matrices
R_St = zeros(size(selected_features,2),size(selected_features,2),num_intervals);
R_resamplet = zeros(size(selected_features,2),size(selected_features,2),num_intervals);
R_filtert = zeros(size(selected_features,2),size(selected_features,2),num_intervals);
R_Bt = zeros(size(selected_features,2),size(selected_features,2),num_intervals);
R_Ft = zeros(size(selected_features,2),size(selected_features,2),num_intervals);

largest_R_St = zeros(round(0.5*num_max),3,num_intervals);
largest_R_resamplet = zeros(round(0.5*num_max),3,num_intervals);
largest_R_filtert = zeros(round(0.5*num_max),3,num_intervals);
largest_R_Bt = zeros(round(0.5*num_max),3,num_intervals);
largest_R_Ft = zeros(round(0.5*num_max),3,num_intervals);

k = 0; % Used to count the number of dats in find_datetime_C3
w = 0; % Used to count the number of weekend days in find_datetime_C3

for i = 1:num_intervals

% Puts data into two matrices, Values containing all the numerical data and
% DateTime containing all the dates
[Values,DateTime,k,w] = find_datetime_interval_complex(Set_Date_1,Set_Date_2,XOMMarketDepthOct2016_Values,DateTime_Con,i,num_intervals,k,w);

% Resamples the data
% Type = 0 ('event') takes the most recent event in the data
% Type = 1 ('inter') linear interpolates the data
[Values_resample,DateTime_resample] = resample_data(Values,DateTime,fs,type,Set_Date_1,Set_Date_2,Time_interval,selected_features);

% Filters the data using a butterworth filter
[Values_filter] = filter_data(filter_order,freq_fraction,Values_resample);

% Find large corrleation matrix between all parameters of data
R_S = standard_correlation(Values,selected_features);
R_resample = standard_correlation(Values_resample,selected_features);
R_filter = standard_correlation(Values_filter,selected_features);
R_B = brownian_estimator(Values,selected_features);
R_F = fourier_estimator(Values,DateTime,selected_features);

% Puts the matricies in the matrix with time
R_St(:,:,i) = R_S;
R_resamplet(:,:,i) = R_resample;
R_filtert(:,:,i) = R_filter;
R_Bt(:,:,i) = R_B;
R_Ft(:,:,i) = R_F;

% Finds the most signicant dependicies for each time window
largest_R_S = find_largest_R_S(R_S,num_max);
largest_R_resample = find_largest_R_S(R_resample,num_max);
largest_R_filter = find_largest_R_S(R_filter,num_max);
largest_R_B = find_largest_R_S(R_B,num_max);
largest_R_F = find_largest_R_S(R_F,num_max);

% Puts the matrix in a matrix that contains all the times
largest_R_St(:,:,i) = largest_R_S;
largest_R_resamplet(:,:,i) = largest_R_resample;
largest_R_filtert(:,:,i) = largest_R_filter;
largest_R_Bt(:,:,i) = largest_R_B;
largest_R_Ft(:,:,i) = largest_R_F;


end

end
