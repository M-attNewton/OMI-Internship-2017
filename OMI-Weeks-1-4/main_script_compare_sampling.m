% Main script to compare how the sampling frequncy effects the correlation
% (takes a long time)

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
Set_Date_2 = '05-Oct-2016 11:55:05';

% Choose features to look for dependencies
% The number in each catergory corresponds to the level
% Values must be between 1 and 10
select_ask_prices = [1:3];
select_bid_prices = [1:3];
select_ask_sizes = [1:3];
select_bid_sizes = [1:3];

% For varying time frequency select the range and step interval
fs_range = [1,5];
fs_step = 1;

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

%% Functions

% Calculates the correlation for a varying sampling frequency
[R_resampleSt,R_filterSt,largest_R_resampleSt,largest_R_filterSt] = ...
    calculate_correlations_vary_resampling(selected_features,num_max,Set_Date_1,Set_Date_2,...
    XOMMarketDepthOct2016_Values,DateTime_Con,fs,type,Time_interval,freq_fraction,filter_order,fs_range,fs_step);

% Plots the merits as a function of sampling window
% (only for resample and resample and filter corrleations)
[merit_R_resampleSt,merit_R_filterSt] = plot_merits_sample(fs_range,fs_step,R_resampleSt,R_filterSt);







