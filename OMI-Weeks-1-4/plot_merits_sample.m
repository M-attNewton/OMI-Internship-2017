% Plots the merits as a function of time

function [merit_R_resampleSt,merit_R_filterSt] = plot_merits_sample(fs_range,fs_step,R_resampleSt,R_filterSt)

% Finds the difference between the two sampling frequency ranges
relative_range = fs_range(2) - fs_range(1);

% Number of different frequencies to be used
num_freq = round(relative_range/fs_step);

% Vector of all the frequencies used
fs = linspace(fs_range(1),fs_range(2),num_freq);

% Pre-allocate the merit vectors
merit_R_resampleSt = zeros(num_freq,1);
merit_R_filterSt = zeros(num_freq,1);

% Metric to compare the correlation matrices by using differential entropy
for i = 1:num_freq
        
    % Resampled data
    if abs(-log(det(R_resampleSt(:,:,i)))) < 10^3 && abs(-log(det(R_resampleSt(:,:,i)))) > 0
    
        merit_R_resampleSt(i,1) = -log(det(R_resampleSt(:,:,i)));
        
    else
        
        merit_R_resampleSt(i,1) = 0;
        
    end
    
    % Filtered data
    if abs(-log(det(R_filterSt(:,:,i)))) < 10^3 && abs(-log(det(R_filterSt(:,:,i)))) > 0
    
        merit_R_filterSt(i,1) = -log(det(R_filterSt(:,:,i)));
        
    else
        
        merit_R_filterSt(i,1) = 0;
        
    end

    
end

% Plot the merits over time
figure

plot(fs,real(merit_R_resampleSt),fs,real(merit_R_filterSt))

title('Differential entropy as a function of sampling frequency')
xlabel('Sampling frequency')
ylabel('Differential entropy')
legend('Standard with resampling','Standard with resampling and filtering')

end

