% Sorts the useful data into two matrices, Values containing all the feature numerical data, DateTime containing all the dates corresponding to the numerical data.
% Finds rows in datetime corresonding to the two date and time inputs.
% Reduces the data to only contain data between this time window.

function [Values,DateTime] = find_datetime_time_window(Set_Date_1,Set_Date_2,XOMMarketDepthOct2016_Values,DateTime_Con,i,num_intervals)

% Criteria to reject incorrect data.
if datenum(Set_Date_2) - datenum(Set_Date_1) < 0
    
    error('End date must be later than start date')
    
elseif hour(datenum(Set_Date_1)) + minute(datenum(Set_Date_1))/60 < 7.4 && hour(datenum(Set_Date_2)) + minute(datenum(Set_Date_2))/60 < 16.5  
        
        error('Start time must be later than 07:30:00')
        
elseif hour(datenum(Set_Date_1)) + minute(datenum(Set_Date_1))/60 > 7.4 && hour(datenum(Set_Date_2)) + minute(datenum(Set_Date_2))/60 > 16.5

        error('End time must be earlier than 16:30:00')
        
elseif hour(datenum(Set_Date_1)) + minute(datenum(Set_Date_1))/60 < 7.4 && hour(datenum(Set_Date_2)) + minute(datenum(Set_Date_2))/60 > 16.5
        
        error('Start time must be later than 07:30:00 and end time must be earlier than 16:30:00')

% If on the same day.
elseif day(datenum(Set_Date_2)) == day(datenum(Set_Date_1))  
    
    % If inside the times of the relevant data '03-Oct-2016 07:30:00' and
    % '03-Oct-2016 16:30:00'.
    if  hour(datenum(Set_Date_1)) + minute(datenum(Set_Date_1))/60 > 7.4 && hour(datenum(Set_Date_2)) + minute(datenum(Set_Date_2))/60 < 16.5  
        
        % Work out interval.
        time_interval = (datenum(Set_Date_2) - datenum(Set_Date_1))/num_intervals;

        % Finds start and end of each time interval.
        ti_start = datenum(Set_Date_1);
        ti_end = datenum(Set_Date_1) + (i)*time_interval;

        % Finds the closed DateTime to each start and end interval.
        [~,t1] = min(abs(ti_start - datenum(DateTime_Con)));
        [~,t2] = min(abs(ti_end - datenum(DateTime_Con)));

        % Reducing the time range and makes easier to sort.
        Values = XOMMarketDepthOct2016_Values(t1:t2,:);
        DateTime = DateTime_Con(t1:t2);
        

    end
    
% If the end date is after the start date.
elseif day(datenum(Set_Date_2)) > day(datenum(Set_Date_1))
    
    % Finds the number of days between the start and the end.
    day_diff = day(datenum(Set_Date_2)) - day(datenum(Set_Date_1));
    
    % Random variables to determine the number of weekends.
    x = Set_Date_1;
    num_weekend = 0;
    
    % Finds the number of weekends between the two intervals.
    while day(datenum(Set_Date_2)) > day(datenum(x))
        
        if weekday(x) == 1 
            
            num_weekend = num_weekend + 1;
            
            x = addtodate(datenum(x),1,'day');
            x = datestr(x);
            
        elseif weekday(x) == 7
            
            num_weekend = num_weekend + 2;
            
           x = addtodate(datenum(x),2,'day');
           x = datestr(x);
           
        else
        
            x = addtodate(datenum(x),1,'day');
            x = datestr(x);
        
        end
        
    end
    
    % The total time between the two dates.
    elapsed_time = datenum(Set_Date_2) - datenum(Set_Date_1);
    
    % Removes the deadtime, (when the market is closed).
    relevant_time = elapsed_time - (day_diff - num_weekend)*(15/24) - num_weekend;  
    
    % The time interval, (how long each interval should be.
    time_interval = (relevant_time)/num_intervals;
    
    % Create vector to contain all the time intervals.
    time_vec = zeros(i,1);
    time_vec(1) = datenum(Set_Date_1);
    
    % Inserts all the intervals into the vector
    for j = 1:i 
       
        time_vec(j+1) = datenum(Set_Date_1) + (j)*time_interval;
        
    end
  
    % Add a hours such that none of the components of time_vec fall in the deadtime.
    for j = 1:(i+1)
       
        if hour(time_vec(j)) + minute(time_vec(j))/60 > 16.5
           
            for k = j:(i+1)
               
                time_vec(k) = time_vec(k) + 15/24;
                
            end
            
        end
        
    end
    
   % Removes the weekend components of the deadtime.
    for j = 1:(i+1)
       
        if weekday(datestr(time_vec(j))) == 7
           
            for k = j:(i+1)
               
                time_vec(k) = time_vec(k) + 2;
                
            end
            
        end
        
    end

    % Set ti_start and ti_end as the last two components of the time_vec.
    ti_start = time_vec(1);
    ti_end = time_vec(length(time_vec));

    % Finds the closed DateTime to each start and end interval.
    [~,t1] = min(abs(ti_start - datenum(DateTime_Con)));
    [~,t2] = min(abs(ti_end - datenum(DateTime_Con)));

    % Reducing the time range and makes easier to sort.
    Values = XOMMarketDepthOct2016_Values(t1:t2,:);
    DateTime = DateTime_Con(t1:t2);
    
    
end

end

