% Filters the resampled data using a butterworth filter.

function [Values_filter] = filter_data(filter_order,freq_fraction,Values_resample)

% Butter function finds numerator and denomator of low pass Butterworth filter.
[butter_num, butter_den] = butter(filter_order,freq_fraction,'low');

% Checks whether resamples has any terms.
if ~isempty(Values_resample)

    % Add rows to set up inital conditions for filter.
    Values_resample = [zeros(100,size(Values_resample,2));Values_resample];
    
    for i = 1:100

        Values_resample(i,:) = Values_resample(101,:);

    end

    % Applies the Butterworth filter.
    Values_filter = filter(butter_num,butter_den,Values_resample,[],1);

    % Remove the rows that were to fix initial conditions.
    Values_filter(1:100,:) = [];
    
else
    
    Values_filter = [];
    
end

end
