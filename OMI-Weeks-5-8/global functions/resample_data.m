% Resamples the data in different ways depending on the input of type.
% Type = '0' takes the most recent event.
% Type = '1' linear interpolates the data.

function [Values_resample,DateTime_resample] = resample_data(Values,DateTime,fs,type,selected_features)

if type == 1
    
    % Resample using built in resample function. 
    [Values_resample,DateTime_resample] = resample(Values_selected,DateTime,fs);
    
end

% Resample by taking the previous event from the data.
% Includes all terms from values.
if type == 0
            
    % Finds the elapsed time between the start and end date.
    Time_diff = abs(etime(datevec(DateTime(1)),datevec(DateTime(end))));
    
    % Creates a vector of all the time increments. 
    % Conceptualy, creates a grid to map the data onto.
    Time_series = seconds(0:(1/fs):Time_diff);
    
    % Creates a grid containing each resample point.
    grid_time = datenum(DateTime(1)) + datenum(Time_series);
    
    for i = 1:length(grid_time)
       
        if (hour(grid_time(i)) + (minute(grid_time(i)))/60) > 16.5 || ...
           (hour(grid_time(i)) + (minute(grid_time(i)))/60) < 7.5 || ...
            weekday(grid_time(i)) == 1 || weekday(grid_time(i)) == 7
            
            grid_time(i) = 0;
            
        end
        
    end
    
    grid_time(grid_time == 0) = [];
    
    Values_resample = zeros(length(grid_time),size(Values,2));
    DateTime_resample = zeros(length(grid_time),1);
    
    % Resamples the data for each feature.
    for h = selected_features
                
        k = 1;
        
        % Goes through each grid component.
        for i = 1:length(grid_time)     
                                        
            for j = k:length(DateTime)
           
                if datenum(grid_time(i)) >= datenum(DateTime(j))

                    Values_resample(i,h) = Values(j,h);
                    
                    DateTime_resample(i) = grid_time(i);
                    
                else
                    
                    if j == 1
                        
                        % k term drastical reduce comutational time.
                        k = 1;
                        
                    else
                        
                        k = j - 1;
                    
                    end
                    
                    break

                end
                
            end
            
        end
        
    end
    
    % Removes all zero values from resampled data.
    Values_resample(all(Values_resample == 0,2),:) = [];
    DateTime_resample(all(DateTime_resample == 0,2),:) = [];
    
end
  
