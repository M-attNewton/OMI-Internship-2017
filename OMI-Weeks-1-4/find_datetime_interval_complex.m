% Finds columns corresonding to the two date and time inputs
% Reduces the data to only contain data between this time window

function [Values,DateTime,k,w] = find_datetime_interval_complex(Set_Date_1,Set_Date_2,XOMMarketDepthOct2016_Values,DateTime_Con,i,num_intervals,k,w)

if datenum(Set_Date_2) - datenum(Set_Date_1) < 0
    
    error('End date must be later than start date')
    
elseif hour(datenum(Set_Date_1)) + minute(datenum(Set_Date_1))/60 < 7.4 && hour(datenum(Set_Date_2)) + minute(datenum(Set_Date_2))/60 < 16.5  
        
        error('Start time must be later than 07:30:00')
        
elseif hour(datenum(Set_Date_1)) + minute(datenum(Set_Date_1))/60 > 7.4 && hour(datenum(Set_Date_2)) + minute(datenum(Set_Date_2))/60 > 16.5

        error('End time must be earlier than 16:30:00')
        
elseif hour(datenum(Set_Date_1)) + minute(datenum(Set_Date_1))/60 < 7.4 && hour(datenum(Set_Date_2)) + minute(datenum(Set_Date_2))/60 > 16.5
        
        error('Start time must be later than 07:30:00 and end time must be earlier than 16:30:00')

% If on the same day
elseif day(datenum(Set_Date_2)) == day(datenum(Set_Date_1))  
    
    % If inside the times of the relevant data '03-Oct-2016 07:30:00' and '03-Oct-2016 16:30:00'
    if  hour(datenum(Set_Date_1)) + minute(datenum(Set_Date_1))/60 > 7.4 && hour(datenum(Set_Date_2)) + minute(datenum(Set_Date_2))/60 < 16.5  
        
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
    
% If the end date is after the start date    
elseif day(datenum(Set_Date_2)) > day(datenum(Set_Date_1))
    
    % Finds the number of days between the start and the end
    day_diff = day(datenum(Set_Date_2)) - day(datenum(Set_Date_1));
    
    % Random variables to determine weekends
    x = Set_Date_1;
    num_weekend = 0;
    
    % Finds if interval goes over a weekend
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
    
    % Work out interval
    elapsed_time = datenum(Set_Date_2) - datenum(Set_Date_1);
    
    % Removes the deadtime
    relevant_time = elapsed_time - day_diff*(15/24) - num_weekend;  
    
    % The time interval
    time_interval = (relevant_time)/num_intervals;
  
    ti_start = datenum(Set_Date_1) + (i-1)*time_interval + 15/24*k + w;
    ti_end = datenum(Set_Date_1) + (i)*time_interval + 15/24*k + w;
      
    % Check to see if start and end date are in the dead zone
    if hour(ti_end) + minute(ti_end)/60 > 16.5
        
        ti_end = ti_end + 15/24;
        k = k + 1; % counts the number of days past
        test_weekend_start = weekday(datestr(ti_start));
        test_weekend_end = weekday(datestr(ti_end));
        
%         if test_weekend_start == 1 
%             
%             ti_start = ti_start + 1;
%             w = w + 1;
%             
%         elseif test_weekend_start == 7
%             
%             ti_start = ti_start + 2;
%             w = w + 1;
%             
%         end
            
        if test_weekend_end == 1 
            
            ti_end = ti_end + 1;
            w = w + 1;
            
        elseif test_weekend_end == 7
            
            ti_end = ti_end + 2;
            w = w + 2;
            
        end          
                
    end       
    
    % Finds the closed DateTime to each start and end interval
    [~,t1] = min(abs(ti_start - datenum(DateTime_Con)));
    [~,t2] = min(abs(ti_end - datenum(DateTime_Con)));

    % Reducing the time range and makes easier to sort
    Values = XOMMarketDepthOct2016_Values(t1:t2,:);
    DateTime = DateTime_Con(t1:t2);
    
    
end

end

