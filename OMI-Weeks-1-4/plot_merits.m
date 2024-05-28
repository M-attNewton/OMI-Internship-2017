% Plots the merits as a function of time

function [merit_R_St,merit_R_resamplet,merit_R_filtert,merit_R_Bt,merit_R_Ft] = plot_merits(num_intervals,R_St,R_resamplet,R_filtert,R_Bt,R_Ft,interval_list)

% Pre-allocate the merit vectors
merit_R_St = zeros(num_intervals,1);
merit_R_resamplet = zeros(num_intervals,1);
merit_R_filtert = zeros(num_intervals,1);
merit_R_Bt = zeros(num_intervals,1);
merit_R_Ft = zeros(num_intervals,1);

% Metric to compare the correlation matrices by using differential entropy
for i = 1:num_intervals
    
    % Standard data
    if abs(-log(det(R_St(:,:,i)))) < 10^3 && abs(-log(det(R_St(:,:,i)))) > 0  % Gets rid of stupid values
    
        merit_R_St(i,1) = -log(det(R_St(:,:,i)));
        
    else
        
        merit_R_St(i,1) = 0;
        
    end
    
    % Resampled data
    if abs(-log(det(R_resamplet(:,:,i)))) < 10^3 && abs(-log(det(R_resamplet(:,:,i)))) > 0
    
        merit_R_resamplet(i,1) = -log(det(R_resamplet(:,:,i)));
        
    else
        
        merit_R_resamplet(i,1) = 0;
        
    end
    
    % Filtered data
    if abs(-log(det(R_filtert(:,:,i)))) < 10^3 && abs(-log(det(R_filtert(:,:,i)))) > 0
    
        merit_R_filtert(i,1) = -log(det(R_filtert(:,:,i)));
        
    else
        
        merit_R_filtert(i,1) = 0;
        
    end

    % Brownian data
    if abs(-log(det(R_Bt(:,:,i)))) < 10^3 && abs(-log(det(R_Bt(:,:,i)))) > 0
    
        merit_R_Bt(i,1) = -log(det(R_Bt(:,:,i)));
        
    else
        
        merit_R_Bt(i,1) = 0;
        
    end
    
    % Fourier data
     if abs(-log(det(R_Ft(:,:,i)))) < 10^3 && abs(-log(det(R_Ft(:,:,i)))) > 0
    
        merit_R_Ft(i,1) = -log(det(R_Ft(:,:,i)));
        
    else
        
        merit_R_Ft(i,1) = 0;
        
    end  
end

% Removes first value of interval list
interval_list(1) = [];

% Plot the merits over time
figure

plot(interval_list,real(merit_R_St),interval_list,real(merit_R_resamplet),interval_list,real(merit_R_filtert),interval_list,real(merit_R_Bt),interval_list,real(merit_R_Ft))

title('Differential entropy as a function of time')
xlabel('Date and Time')
ylabel('Differential entropy')
legend('Standard','Standard with resampling','Standard with resampling and filtering','Brownian','Fourier')

end

