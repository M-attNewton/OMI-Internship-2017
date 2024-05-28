% Main script to compare how the correlation varries over a expanding time
% interval

%% User variables

% Set time intervals for data with the start and end date-
% Set date in format 'dd-MMM-yyyy hh:mm:ss'   e.g. '03-Oct-2016 07:33:57'
% Time must be between 07:30:00 and 16:30:00 as this is only when trading
% takes place
Set_Date_1 = '05-Oct-2016 08:40:50';
Set_Date_2 = '05-Oct-2016 15:55:05';
num_intervals = 4;

% Choose features to look for dependencies
% The number in each catergory corresponds to the level
% Values must be between 1 and 10
select_ask_prices = [1:3];
select_bid_prices = [1:3];
select_ask_sizes = [1:3];
select_bid_sizes = [1:3];

% Set sampling frequency for resampling
% Set time interval in seconds
Time_interval = 60;
fs = 1/Time_interval;
% Set type of resampling
% Type = '0' takes the most recent event
% Type = '1' linear interpolates the data
type = 0;

% Define frequency fraction and order of filter (butterworth filter)
freq_fraction = 0.25;
filter_order = 2;

% Find the greatest correlations by choosing the proportion of the number of correlated terms
prop = 0.5;

% Function to select the choosen features
[selected_features] = select_features(select_ask_prices,select_bid_prices,select_ask_sizes,select_bid_sizes);

num_max = round(prop*(max(size(selected_features)))^2);


% Parameter to determine the circle size on the plots
q = 0.55;

%% Functions

% Calculates the correlation for a varying time window, the start date is
% common for all data points and the duration of the interval is increased
[R_SWt,R_resampleWt,R_filterWt,R_BWt,R_FWt,largest_R_SWt,largest_R_resampleWt,largest_R_filterWt,largest_R_BWt,largest_R_FWt] ...
    = calculate_all_correlations_window(selected_features,num_intervals,num_max,Set_Date_1,Set_Date_2, ...
    XOMMarketDepthOct2016_Values,DateTime_Con,fs,type,Time_interval,freq_fraction,filter_order);

% Lists the date and time of the intervals
interval_list = find_intervals(Set_Date_1,Set_Date_2,DateTime_Con,num_intervals);

% Plots the merits as with a expanding window, (cumlative merit)
[merit_R_SWt,merit_R_resampleWt,merit_R_filterWt,merit_R_BWt,merit_R_FWt] = plot_merits_scale(num_intervals,R_SWt,R_resampleWt,R_filterWt,R_BWt,R_FWt,interval_list);




