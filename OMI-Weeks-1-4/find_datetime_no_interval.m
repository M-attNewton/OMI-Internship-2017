% Finds columns corresonding to the two date and time inputs
% Reduces the data to only contain data between this time window

function [Values,DateTime] = find_datetime_no_interval(Set_Date_1,Set_Date_2,XOMMarketDepthOct2016_Values,DateTime_Con)

[~,t1] = min(abs(datenum(Set_Date_1) - datenum(DateTime_Con)));
[~,t2] = min(abs(datenum(Set_Date_2) - datenum(DateTime_Con)));

% Reducing the time range and makes easier to sort
Values = XOMMarketDepthOct2016_Values(t1:t2,:);
DateTime = DateTime_Con(t1:t2);

end

