%% Introduction

% This main script is to compare all the methods of calculating dependency.
% It is possible for the user to selected which features are compared and a variety of graphs that compare the different methods.

%% User Select Parameters

% Set the overall time window for data that is to be analysied.
% Set date in format 'dd-MMM-yyyy hh:mm:ss' e.g. '03-Oct-2016 07:33:57'.
% Time must be between 07:30:00' and 16:30:00'.
% Date must be between 03-Oct-2016 and 28-Oct-2016.
Set_Date_1 = '03-Oct-2016 11:35:00';
Set_Date_2 = '03-Oct-2016 12:35:00';

% Set the number of intervals, that is the number of seperate time intervals to analysis the data seperately.
% Set as 1 if comparing the whole period.
num_intervals = 1;

% Choose which features that will be computed and hence dependencies calculated.
% The number in each catergory corresponds to the level.
% Values must be between 1 and 10 or empty.
select_ask_prices = [1:5];
select_bid_prices = [1:5];
select_ask_sizes = [1:5];
select_bid_sizes = [1:5];

% Function that re-orders the choosen features to make the code easier to work with.
[selected_features] = select_features...
(select_ask_prices,select_bid_prices,select_ask_sizes,select_bid_sizes);

% Set sampling frequency or time interval for the resample function.
% Time interval is in seconds.
time_interval = 1;
fs = 1/time_interval;
% Type = 0 ('event') takes the most recent event in the data.
% Type = 1 ('inter') linear interpolates the data.
type = 0;

% For the varying time frequency function, select the range and the number of frequencies to be evalulated.
fs_range = [0.01,15];
num_freq = 15;

% Define frequency fraction and order for the butterworth filter that is applied on the resampled data.
freq_fraction = 0.25;
filter_order = 2;

% A list is produced containing the most significant dependecies. 
% Select the proportional number of terms to be included in this list (or the maximum number).
prop = 0.5;
num_max = round(prop*(max(size(selected_features)))^2);

% Parameter to determine the circle size on the plots, (the size of the circles corresponds to bid/ask size).
circle_size = 0.55;

%% Select outputs

% A "1" indicates that the graph/method is to be plotted/included and a "0"
% indicates that it is not.

% A scatter plot showing the price of the selected levels against time, with the size of each line representing the size of each level. 
% All features are super-imposed on the same plot.
scatter_plot = 0;

% A scatter plot showing the price of the selected levels against time, with the size of each line representing the size of each level. 
% All features are ploted on seperate subplots.
scatter_plot_sub = 0;

% A scatter plot showing the price of the selected levels against time, with the size of each line representing the size of each level. 
% Each subplot compares the effect sampling and filtering to raw data.
compare_sampling = 0;

% A plots of the log determinant of each of the dependency matricies (merits) as a function of time.
merits_time = 0;

% A plots of the log determinant of each of the dependency matricies (merits) where the x-axis represents time as an expanding window (effectively a cumulative merit).
merits_scale = 0;

% A plots of the log determinant of each of the dependency matricies 
% (merits) as a function of sampling frequency (only for resample and 
% resample and filter corrleations)
merits_resampling = 1;

% A figure with a visualisation of each of the dependency matricies. 
% The time updates every 3 seconds, so to close the figure, call "ctrl-C" in the command window.
visualise_matrix = 0;

    % Select whether to evaulate varying: time, time window or resample.
    % Can only have one figure running at a time, so it is recommeneded that only one variable below is set to a "1".
    visualise_time = 1;
    visualise_scale = 0;
    visualise_resampling = 0;

% A summary of all the results with each dependency method in a seperate figure.
summarise_data = 0;

    % Select which methods to evaluate.
    summarise_standard = 1;
    summarise_standard_resample = 1;
    summarise_standard_filter = 1;
    summarise_brownian = 1;
    summarise_fourier = 1;
    summarise_copula = 1;
    summarise_copula_resample = 1;
    summarise_copula_filter = 1;
    
    % Select whether to evaulate varying: time, time window or resample.
    summarise_time = 1;
    summarise_scale = 1;
    summarise_resampling = 1;
  
%% Import data

% Saves time when data is already imported.
if exist('XOMMarketDepthOct2016_Values','var') == 0
       
disp('Importing data fromm csv file...');
    
% Imports data from csv file.
[XOMMarketDepthOct2016_Values,XOMMarketDepthOct2016_DateTime,...
XOMTransactionsOct2016,XOMTransactionsOct2016_DateTime] = ...
import_data();

% Convert date and time to standard format.
DateTime_Con = datetime(XOMMarketDepthOct2016_DateTime, 'InputFormat',...
'yyyy-MM-dd''T''HH:mm:ss.SSS''Z', 'TimeZone', 'UTC');

disp('Data imported');

else 
    
disp('Data already imported');
    
end
        
%% Functions

% Calculates all dependecies along with a list of their most significant values, uses seperate intervals to compute dependencies. 
% Also creates a list of intervals to be used in the plots.
if merits_time == 1 || (visualise_matrix == 1 && visualise_time == 1)...
   ||(summarise_data == 1 && summarise_time == 1)
    
disp('Calculating all dependencies for varying time...');    
    
[R_St,R_Sresamplet,R_Sfiltert,R_Bt,R_Ft,R_Ct,R_Cresamplet,R_Cfiltert,...
largest_R_St,largest_R_Sresamplet,largest_R_Sfiltert,largest_R_Bt,...
largest_R_Ft,largest_R_Ct,largest_R_Cresamplet,largest_R_Cfiltert] ...
= calculate_all_dependencies_vary_time...
(selected_features,num_intervals,num_max,Set_Date_1,Set_Date_2,...
XOMMarketDepthOct2016_Values,DateTime_Con,...
fs,type,freq_fraction,filter_order);

disp('All dependencies for varying time calculated');

end

% Calculates all dependecies along with a list of their most significant values, uses seperate intervals to compute dependencies.
if merits_scale == 1 || (visualise_matrix == 1 && visualise_scale == 1)...
   || (summarise_data == 1 && summarise_scale == 1)
    
disp('Calculating all dependencies for a varying time window...');     
    
[R_SWt,R_SresampleWt,R_SfilterWt,R_BWt,R_FWt,R_CWt,R_CresampleWt,...
R_CfilterWt,largest_R_SWt,largest_R_SresampleWt,largest_R_SfilterWt,...
largest_R_BWt,largest_R_FWt,largest_R_CWt,largest_R_CresampleWt,...
largest_R_CfilterWt] = ...
calculate_all_dependencies_vary_window...
(selected_features,num_intervals,...
num_max,Set_Date_1,Set_Date_2,XOMMarketDepthOct2016_Values,DateTime_Con,...
fs,type,freq_fraction,filter_order);

disp('All dependencies for a varying time window calculated');

end

% Calculates all dependecies along with a list of their most significant values, uses different resample rates to compute dependencies.
if merits_resampling == 1 ||...
   (visualise_matrix == 1 && visualise_resampling == 1) ||...
   (summarise_data == 1 && summarise_resampling == 1)
    
disp('Calculating all dependencies for a varying sampling frequency...');        
    
[R_SresampleSt,R_SfilterSt,R_CresampleSt,R_CfilterSt,largest_R_SresampleSt,...
largest_R_SfilterSt,largest_R_CresampleSt,largest_R_CfilterSt] = ...
calculate_all_dependencies_vary_resampling...
(selected_features,num_max,Set_Date_1,Set_Date_2,...
XOMMarketDepthOct2016_Values,DateTime_Con,type,...
freq_fraction,filter_order,fs_range,num_freq);

disp('All dependencies for a varying sampling frequency calculated');

end

% Contains a list of names of each feature.
[feature_name_list] = feature_name_list();

% Relates the row number to the feature number and name.
clear relate_feature_list;  % Without "clear" there will be an error.
[relate_feature_list] = relate_feature_list...
(selected_features,feature_name_list);

% Lists the date and time of the intervals.
[interval_list] = find_intervals...
(Set_Date_1,Set_Date_2,DateTime_Con,num_intervals);

disp('Creating required plots and compiling results...');

% A scatter plot showing the price of the selected levels against time, with the size of each line representing the size of each level. 
% All features are super-imposed on the same plot. 
% Dotted line represents the interval spacing.
if scatter_plot == 1
    
plot_levels_scatter...
(Set_Date_1,Set_Date_2,XOMMarketDepthOct2016_Values,DateTime_Con,...
circle_size,selected_features,feature_name_list,interval_list);

end

% A scatter plot showing the price of the selected levels against time, with the size of each line representing the size of each level. 
% All features are ploted on seperate subplots. 
% Dotted line represents the interval spacing.
if scatter_plot_sub == 1
    
plot_levels_scatter_sub...
(Set_Date_1,Set_Date_2,XOMMarketDepthOct2016_Values,DateTime_Con,...
circle_size,selected_features,feature_name_list,interval_list);

end

% A scatter plot showing the price of the selected levels against time, with the size of each line representing the size of each level. 
% Each subplot compares the effect sampling and filtering to raw data.
if compare_sampling == 1
    
plot_compare_sampling...
(Set_Date_1,Set_Date_2,XOMMarketDepthOct2016_Values,DateTime_Con,...
circle_size,selected_features,feature_name_list,interval_list,fs,...
type,filter_order,freq_fraction);

end

% A plot of the log determinant of each of the dependency matricies (merits) as a function of time.
if merits_time == 1 || (summarise_time == 1 && summarise_data == 1)
    
[merit_R_St,merit_R_Sresamplet,merit_R_Sfiltert,merit_R_Bt,merit_R_Ft,...
merit_R_Ct,merit_R_Cresamplet,merit_R_Cfiltert]...
= plot_merits_time...
(num_intervals,R_St,R_Sresamplet,R_Sfiltert,R_Bt,R_Ft,R_Ct,R_Cresamplet,...
R_Cfiltert,interval_list,merits_time);

end

% A plot of the log determinant of each of the dependency matricies (merits) where the x-axis represents time as an expanding window (effectively a cumulative merit).
if merits_scale == 1 || (summarise_scale == 1 && summarise_data == 1)
    
[merit_R_SWt,merit_R_SresampleWt,merit_R_SfilterWt,merit_R_BWt,...
merit_R_FWt,merit_R_CWt,merit_R_CresampleWt,merit_R_CfilterWt]...
= plot_merits_scale...
(num_intervals,R_SWt,R_SresampleWt,R_SfilterWt,R_BWt,...
R_FWt,R_CWt,R_CresampleWt,R_CfilterWt,interval_list,merits_scale);

end

% A plot of the log determinant of each of the dependency matricies (merits) as a function of sampling frequency (only for resample and resample and filter corrleations).
if merits_resampling == 1 ||...
   (summarise_resampling == 1 && summarise_data == 1)

[merit_R_SresampleSt,merit_R_SfilterSt,merit_R_CresampleSt,...
merit_R_CfilterSt] ...
= plot_merits_resampling...
(fs_range,num_freq,R_SresampleSt,R_SfilterSt,R_CresampleSt,R_CfilterSt,...
merits_resampling);

end

% A summary of all the results with each dependency method in a seperate figure. 
% Each function is for varying: time, time window or resample.
if summarise_time == 1 && summarise_data == 1

[str2] = summarise_results_time...
(largest_R_Bt,largest_R_Ct,largest_R_Sfiltert,largest_R_Ft,...
largest_R_Sresamplet,largest_R_St,largest_R_Cresamplet,largest_R_Cfiltert,...
merit_R_Bt,merit_R_Ct,merit_R_Sfiltert,merit_R_Ft,merit_R_Sresamplet,...
merit_R_St,merit_R_Cresamplet,merit_R_Cfiltert,...
R_Bt,R_Ct,R_Sfiltert,R_Ft,R_Sresamplet,R_St,R_Cresamplet,R_Cfiltert,...
summarise_data,summarise_standard,summarise_standard_resample,...
summarise_standard_filter,summarise_brownian,summarise_fourier,...
summarise_copula,summarise_copula_resample,summarise_copula_filter,...
relate_feature_list,interval_list);

end

if summarise_scale == 1 && summarise_data == 1
    
[str2] = summarise_results_scale...
(largest_R_BWt,largest_R_CWt,largest_R_SfilterWt,largest_R_FWt,...
largest_R_SresampleWt,largest_R_SWt,largest_R_CresampleWt,...
largest_R_CfilterWt,...
merit_R_BWt,merit_R_CWt,merit_R_SfilterWt,merit_R_FWt,...
merit_R_SresampleWt,merit_R_SWt,merit_R_CresampleWt,merit_R_CfilterWt,...
R_BWt,R_CWt,R_SfilterWt,R_FWt,R_SresampleWt,R_SWt,R_CresampleWt,...
R_CfilterWt,...
summarise_data,summarise_standard,summarise_standard_resample,...
summarise_standard_filter,summarise_brownian,summarise_fourier,...
summarise_copula,summarise_copula_resample,summarise_copula_filter,...
relate_feature_list,interval_list);

end

if summarise_resampling == 1 && summarise_data == 1
    
[str2] = summarise_results_resampling...
(largest_R_SfilterSt,largest_R_SresampleSt,largest_R_CresampleSt,...
largest_R_CfilterSt,...
merit_R_SfilterSt,merit_R_SresampleSt,merit_R_CresampleSt,merit_R_CfilterSt,...
R_SfilterSt,R_SresampleSt,R_CresampleSt,R_CfilterSt,...
summarise_data,summarise_standard_resample,summarise_standard_filter,...
summarise_copula_resample,summarise_copula_filter,...
relate_feature_list,fs_range,num_freq);

end

% A figure with a visualisation of each of the dependency matricies. 
% The time updates every 3 seconds, so to close the figure, call "ctrl-C"
% in the command window. Each function is for varying: time, time window or resample.
if visualise_matrix == 1 && visualise_time == 1
    
[str] = visualise_matrices_time...
(R_St,R_Sresamplet,R_Sfiltert,R_Bt,R_Ft,R_Ct,R_Cresamplet,R_Cfiltert,...
num_intervals,selected_features,feature_name_list,relate_feature_list);

end

if visualise_matrix == 1 && visualise_scale == 1
    
[str] = visualise_matrices_scale...
(R_SWt,R_SresampleWt,R_SfilterWt,R_BWt,R_FWt,R_CWt,R_CresampleWt,...
R_CfilterWt,num_intervals,selected_features,feature_name_list,...
relate_feature_list);

end

if visualise_matrix == 1 && visualise_resampling == 1
    
[str] = visualise_matrices_resampling...
(R_SresampleSt,R_SfilterSt,R_CresampleSt,R_CfilterSt,selected_features,...
feature_name_list,relate_feature_list);

end

disp('End of script');

% Matthew Newton
% August - October 2017
