% Calculates all dependecies along with a list of their most significant values, uses seperate intervals to compute dependencies. 
% Also creates a list of intervals to be used in the plots.

function [R_St,R_Sresamplet,R_Sfiltert,R_Bt,R_Ft,R_Ct,R_Cresamplet,R_Cfiltert,...
    largest_R_St,largest_R_Sresamplet,largest_R_Sfiltert,largest_R_Bt,largest_R_Ft,...
    largest_R_Ct,largest_R_Cresamplet,largest_R_Cfiltert] ...
    = calculate_all_dependencies_vary_time(selected_features,num_intervals,num_max,Set_Date_1,Set_Date_2, ...
    XOMMarketDepthOct2016_Values,DateTime_Con,fs,type,freq_fraction,filter_order)


% Pre-define matrices.
% Each array conatains each matrix, with the third dimension representing the different times.
R_St = zeros(size(selected_features,2),size(selected_features,2),num_intervals);
R_Sresamplet = zeros(size(selected_features,2),size(selected_features,2),num_intervals);
R_Sfiltert = zeros(size(selected_features,2),size(selected_features,2),num_intervals);
R_Bt = zeros(size(selected_features,2),size(selected_features,2),num_intervals);
R_Ft = zeros(size(selected_features,2),size(selected_features,2),num_intervals);
R_Ct = zeros(size(selected_features,2),size(selected_features,2),num_intervals);
R_Cresamplet = zeros(size(selected_features,2),size(selected_features,2),num_intervals);
R_Cfiltert = zeros(size(selected_features,2),size(selected_features,2),num_intervals);

largest_R_St = zeros(round(0.5*num_max),3,num_intervals);
largest_R_Sresamplet = zeros(round(0.5*num_max),3,num_intervals);
largest_R_Sfiltert = zeros(round(0.5*num_max),3,num_intervals);
largest_R_Bt = zeros(round(0.5*num_max),3,num_intervals);
largest_R_Ft = zeros(round(0.5*num_max),3,num_intervals);
largest_R_Ct = zeros(round(0.5*num_max),3,num_intervals);
largest_R_Cresamplet = zeros(round(0.5*num_max),3,num_intervals);
largest_R_Cfiltert = zeros(round(0.5*num_max),3,num_intervals);

% Runs each interval as a seperate loop.
for i = 1:num_intervals

X = ['Finding dependencies for interval number ', num2str(i)];    
disp(X);    
    
% Sorts the useful data into two matrices, Values containing all the feature numerical data, DateTime containing all the dates corresponding to the numerical data.
[Values,DateTime] = find_datetime_time_interval(Set_Date_1,Set_Date_2,XOMMarketDepthOct2016_Values,DateTime_Con,i,num_intervals);

% Resamples the data.
% Type = 0 ('event') takes the most recent event in the data.
% Type = 1 ('inter') linear interpolates the data.
[Values_resample,~] = resample_data(Values,DateTime,fs,type,selected_features);

% Filters the resampled data using a butterworth filter.
[Values_filter] = filter_data(filter_order,freq_fraction,Values_resample);

% Computes all dependency methods for the required data.
R_S = standard_correlation(Values,selected_features);
R_Sresample = standard_correlation(Values_resample,selected_features);
R_Sfilter = standard_correlation(Values_filter,selected_features);
R_B = brownian_estimator(Values,selected_features);
R_F = fourier_estimator(Values,DateTime,selected_features);
R_C = copula_estimator(Values,selected_features);
R_Cresample = copula_estimator(Values_resample,selected_features);
R_Cfilter = copula_estimator(Values_filter,selected_features);

% Puts the matricies in the 3D matrix with time.
R_St(:,:,i) = R_S;
R_Sresamplet(:,:,i) = R_Sresample;
R_Sfiltert(:,:,i) = R_Sfilter;
R_Bt(:,:,i) = R_B;
R_Ft(:,:,i) = R_F;
R_Ct(:,:,i) = R_C;
R_Cresamplet(:,:,i) = R_Cresample;
R_Cfiltert(:,:,i) = R_Cfilter;

% Finds the most signicant dependicies for each time interval.
largest_R_St(:,:,i) = find_largest_R(R_S,num_max);
largest_R_Sresamplet(:,:,i) = find_largest_R(R_Sresample,num_max);
largest_R_Sfiltert(:,:,i) = find_largest_R(R_Sfilter,num_max);
largest_R_Bt(:,:,i) = find_largest_R(R_B,num_max);
largest_R_Ft(:,:,i) = find_largest_R(R_F,num_max);
largest_R_Ct(:,:,i) = find_largest_R(R_C,num_max);
largest_R_Cresamplet(:,:,i) = find_largest_R(R_Cresample,num_max);
largest_R_Cfiltert(:,:,i) = find_largest_R(R_Cfilter,num_max);

X = ['Dependencies for intveral number ', num2str(i), ' found'];    
disp(X);  

end

% Lists the date and time of the intervals.
interval_list = find_intervals(Set_Date_1,Set_Date_2,DateTime_Con,num_intervals);

end

