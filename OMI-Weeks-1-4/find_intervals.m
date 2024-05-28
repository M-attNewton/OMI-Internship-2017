% Finds the start and end of each interval

function [interval_list] = find_intervals(Set_Date_1,Set_Date_2,DateTime_Con,num_intervals)


k = 0;
for i = 1:num_intervals

% If on the same day
if day(datenum(Set_Date_2)) == day(datenum(Set_Date_1))  
    
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
        
        t11 = DateTime_Con(t1,:);
        t22 = DateTime_Con(t2,:);
    
        interval_list(i) = t11;
        interval_list(i+1) = t22;

    end
    
% If the end date is after the start date    
elseif day(datenum(Set_Date_2)) > day(datenum(Set_Date_1))
    
    % Finds the number of days between the start and the end
    day_diff = day(datenum(Set_Date_2)) - day(datenum(Set_Date_1));
    
    % Work out interval
    elapsed_time = datenum(Set_Date_2) - datenum(Set_Date_1);
    
    % Removes the deadtime
    relevant_time = elapsed_time - day_diff*(15/24);  
    
    % The time interval
    time_interval = (relevant_time)/num_intervals;
  
    ti_start = datenum(Set_Date_1) + (i-1)*time_interval + 15/24*k;
    ti_end = datenum(Set_Date_1) + (i)*time_interval + 15/24*k;
      
    % Check to see if start and end date are in the dead zone
    if hour(ti_end) + minute(ti_end)/60 > 16.5
        
        ti_end = ti_end + 15/24;
        k = k + 1; % counts the number of days past
        test_weekend = weekday(datestr(ti_end));
        
        if test_weekend == 1 
            
            ti_start = ti_start + 1;
            ti_end = ti_end + 1;
            
        elseif test_weekend == 7
            
            ti_start = ti_start + 2;
            ti_end = ti_end + 2;
            
        end          
                
    end       
    
    % Finds the closed DateTime to each start and end interval
    [~,t1] = min(abs(ti_start - datenum(DateTime_Con)));
    [~,t2] = min(abs(ti_end - datenum(DateTime_Con)));
    
    t11 = DateTime_Con(t1,:);
    t22 = DateTime_Con(t2,:);
    
    interval_list(i) = t11;
    interval_list(i+1) = t22;

end

end