% A plots of the log determinant of each of the dependency matricies (merits) as a function of sampling frequency (only for resample and resample and filter corrleations).

function [merit_R_SresampleSt,merit_R_SfilterSt,merit_R_CresampleSt,merit_R_CfilterSt] ...
    = plot_merits_resampling(fs_range,num_freq,R_SresampleSt,R_SfilterSt,R_CresampleSt,R_CfilterSt,merits_resampling)

% Vector of all the frequencies used.
fs = linspace(fs_range(1),fs_range(2),num_freq);

% Pre-allocate the merit vectors.
merit_R_SresampleSt = zeros(num_freq,1);
merit_R_SfilterSt = zeros(num_freq,1);
merit_R_CresampleSt = zeros(num_freq,1);
merit_R_CfilterSt = zeros(num_freq,1);

% Finds the merits for different resampling frequencies seperately.
for i = 1:num_freq
        
    % Resampled data.
    if abs(-log(det(R_SresampleSt(:,:,i)))) < 10^3 && abs(-log(det(R_SresampleSt(:,:,i)))) > 0
    
        merit_R_SresampleSt(i,1) = -log(det(R_SresampleSt(:,:,i)));
        
    else
        
        merit_R_SresampleSt(i,1) = 0;
        
    end
    
    % Filtered data.
    if abs(-log(det(R_SfilterSt(:,:,i)))) < 10^3 && abs(-log(det(R_SfilterSt(:,:,i)))) > 0
    
        merit_R_SfilterSt(i,1) = -log(det(R_SfilterSt(:,:,i)));
        
    else
        
        merit_R_SfilterSt(i,1) = 0;
        
    end
    
    % Copula resample data.
    if abs(-log(det(R_CresampleSt(:,:,i)))) < 10^3 && abs(-log(det(R_CresampleSt(:,:,i)))) > 0
    
        merit_R_CresampleSt(i,1) = -log(det(R_CresampleSt(:,:,i)));
        
    else
        
        merit_R_CresampleSt(i,1) = 0;
        
    end
    
    % Copula filtered data.
    if abs(-log(det(R_CfilterSt(:,:,i)))) < 10^3 && abs(-log(det(R_CfilterSt(:,:,i)))) > 0
    
        merit_R_CfilterSt(i,1) = -log(det(R_CfilterSt(:,:,i)));
        
    else
        
        merit_R_CfilterSt(i,1) = 0;
        
    end

    
end

% Plot the merits over time.
if merits_resampling == 1
    
f6 = figure('Name','Differential Entropy as a Function of Sampling Freqeuncy','NumberTitle','off');
figure(f6)

% Adds an extra term on the end of the vectors to help with stairs plot.
merit_R_SresampleSt = [merit_R_SresampleSt; merit_R_SresampleSt(end)];
merit_R_SfilterSt = [merit_R_SfilterSt; merit_R_SfilterSt(end)];
merit_R_CresampleSt = [merit_R_CresampleSt; merit_R_CresampleSt(end)];
merit_R_CfilterSt = [merit_R_CfilterSt; merit_R_CfilterSt(end)];

% Fixes issues with merits equaling zero that should be infinite but setting them to 1000.
merit_R_SresampleSt(merit_R_SresampleSt == 0) = 1000;
merit_R_SfilterSt(merit_R_SfilterSt == 0) = 1000;
merit_R_CresampleSt(merit_R_CresampleSt == 0) = 1000;
merit_R_CfilterSt(merit_R_CfilterSt == 0) = 1000;

% Adds an extra term and shifts the values so that the plot makes more sense.
fs_step = fs(2) - fs(1);
fs = fs.';
fs = [fs; (fs(end) + fs_step)];
fs = fs - (fs_step/2);
fs(fs < 0) = 0;

x = [merit_R_SresampleSt,merit_R_SfilterSt,merit_R_CresampleSt,merit_R_CfilterSt];

stairs(fs,x);

%plot(fs,real(merit_R_SresampleSt),fs,real(merit_R_SfilterSt),fs,real(merit_R_CresampleSt),fs,real(merit_R_CfilterSt))

title('Differential entropy as a function of sampling frequency')
xlabel('Sampling frequency')
ylabel('Differential entropy')
legend('Standard with resampling','Standard with resampling and filtering','Copula with resampling','Copula with resampling and filtering')

end

end

