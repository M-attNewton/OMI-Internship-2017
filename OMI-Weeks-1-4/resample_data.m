% Resamples the data in different ways depending on the input of type
% Type = '0' takes the most recent event
% Type = '1' linear interpolates the data

function [Values_resample,DateTime_resample] = resample_data(Values,DateTime,fs,type,Set_Date_1,Set_Date_2,Time_interval,selected_features)

if type == 1
    
    % Resample using resample function 
    [Values_resample,DateTime_resample] = resample(Values_selected,DateTime,fs);
    
end

% Resample by taking the previous event from the data
% Includes all terms from values
if type == 0
            
    % Finds the elapsed time between the start and end date
    Time_diff = abs(etime(datevec(Set_Date_2),datevec(Set_Date_1)));
    
    % Creates a vector of all the time increments, conceptualy creates a
    % grid to map the data onto
    Time_series = seconds(0:(1/fs):Time_diff);
    
    grid_time = datenum(Set_Date_1) + datenum(Time_series);
    
    Values_resample = zeros(length(grid_time),size(Values,2));
    DateTime_resample = zeros(length(grid_time),1);
    
    for h = selected_features
                
        k = 1;
        
        for i = 1:length(grid_time)
                                        
            for j = k:length(DateTime)
           
                if datenum(grid_time(i)) >= datenum(DateTime(j))

                    Values_resample(i,h) = Values(j,h);
                    
                    DateTime_resample(i) = grid_time(i);
                    
                else
                    
                    if j == 1
                        
                        k = 1;
                        
                    else
                        
                        k = j - 1;
                    
                    end
                    
                    break

                end
            end
        end
    end
    
    Values_resample(all(Values_resample == 0,2),:) = [];
    DateTime_resample(all(DateTime_resample == 0,2),:) = [];
    
end
  



