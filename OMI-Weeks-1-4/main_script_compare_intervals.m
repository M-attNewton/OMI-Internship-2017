% Main script to look at data in seperate time intervals, whilst comparing
% the raw data with resampled and filtered data and visualising the
% correlation matrices

%% Import data

% Used to speed up computing when data already exists as variable
if exist('XOMMarketDepthOct2016_Values','var') == 0
       
% Imports data from csv file
[XOMMarketDepthOct2016_Values,XOMMarketDepthOct2016_DateTime,XOMTransactionsOct2016,XOMTransactionsOct2016_DateTime] = import_data();

% Convert date and time to standard format
DateTime_Con = datetime(XOMMarketDepthOct2016_DateTime, 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss.SSS''Z', 'TimeZone', 'UTC');

end

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

% Function to compute most of the data using distinct time intervals
% Finds all correlations along with a list of the most significant values
[R_St,R_resamplet,R_filtert,R_Bt,R_Ft,largest_R_St,largest_R_resamplet,largest_R_filtert,largest_R_Bt,largest_R_Ft] ...
    = calculate_all_correlations(selected_features,num_intervals,num_max,Set_Date_1,Set_Date_2, ...
    XOMMarketDepthOct2016_Values,DateTime_Con,fs,type,Time_interval,freq_fraction,filter_order);

% List of names of each feature
[feature_name_list] = feature_name_list();

% Lists the date and time of the intervals
interval_list = find_intervals(Set_Date_1,Set_Date_2,DateTime_Con,num_intervals);

% Plots the price of the required level against time with the size of the
% line representing the size of each level on overlayed graph
% Dotted line represents the interval spacing
plot_levels_scatter(Set_Date_1,Set_Date_2,XOMMarketDepthOct2016_Values,DateTime_Con,num_intervals,q,selected_features,feature_name_list,interval_list);

% Same as above but in seperate subplots
% Dotted line represents the interval spacing
plot_levels_scatter_sub(Set_Date_1,Set_Date_2,XOMMarketDepthOct2016_Values,DateTime_Con,num_intervals,q,selected_features,feature_name_list,interval_list);

% Compares the sampling and filtering to raw data
plot_compare_sampling(Set_Date_1,Set_Date_2,XOMMarketDepthOct2016_Values,DateTime_Con,num_intervals,q,selected_features,feature_name_list,interval_list,fs,type,Time_interval,filter_order,freq_fraction);

% Plots the merits as a function of time
[merit_R_St,merit_R_resamplet,merit_R_filtert,merit_R_Bt,merit_R_Ft] = plot_merits(num_intervals,R_St,R_resamplet,R_filtert,R_Bt,R_Ft,interval_list);

% Plots a visualisation of the matrix
[str] = visualise_matries(R_St,R_resamplet,R_filtert,R_Bt,R_Ft,num_intervals,selected_features,feature_name_list);









