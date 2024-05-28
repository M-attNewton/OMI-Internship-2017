% Finds columns corresonding to the two date and time inputs
% Reduces the data to only contain data between this time window

function [Values,DateTime] = find_datetime_interval_simple(Set_Date_1,Set_Date_2,XOMMarketDepthOct2016_Values,DateTime_Con,i,num_intervals)

% Work out interval
time_interval = (datenum(Set_Date_2) - datenum(Set_Date_1))/num_intervals;

% Finds start and end of each time interval
ti_start = datenum(Set_Date_1) + (i-1)*time_interval;
ti_end = datenum(Set_Date_1) + (i)*time_interval;

% Finds the closed DateTime to each start and end interval
[~,t1] = min(abs(ti_start - datenum(DateTime_Con)));
[~,t2] = min(abs(ti_end - datenum(DateTime_Con)));

% Reducing the time range and makes easier to sort
Values = XOMMarketDepthOct2016_Values(t1:t2,:);
DateTime = DateTime_Con(t1:t2);

end
