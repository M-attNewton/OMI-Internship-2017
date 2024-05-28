% A plots of the log determinant of each of the dependency matricies (merits) as a function of time. 
% Used to compare the dependency matricies.
% Merit is effectively a measure of off-diagonal mass.

function [merit_R_St,merit_R_Sresamplet,merit_R_Sfiltert,merit_R_Bt,...
    merit_R_Ft,merit_R_Ct,merit_R_Cresamplet,merit_R_Cfiltert]...
    = plot_merits_time(num_intervals,R_St,R_Sresamplet,R_Sfiltert,R_Bt,...
    R_Ft,R_Ct,R_Cresamplet,R_Cfiltert,interval_list,merits_time)

% Pre-allocate the merit vectors.
merit_R_St = zeros(num_intervals,1);
merit_R_Sresamplet = zeros(num_intervals,1);
merit_R_Sfiltert = zeros(num_intervals,1);
merit_R_Bt = zeros(num_intervals,1);
merit_R_Ft = zeros(num_intervals,1);
merit_R_Ct = zeros(num_intervals,1);
merit_R_Cresamplet = zeros(num_intervals,1);
merit_R_Cfiltert = zeros(num_intervals,1);

% Finds the merit for each time interval seperately.
for i = 1:num_intervals
    
    % Standard data.
    % Gets rid of stupid values
    if abs(-log(det(R_St(:,:,i)))) < 10^3 && abs(-log(det(R_St(:,:,i)))) > 0  
    
        merit_R_St(i,1) = -log(det(R_St(:,:,i)));
        
    else
        
        merit_R_St(i,1) = 0;
        
    end
    
    % Resampled data.
    if abs(-log(det(R_Sresamplet(:,:,i)))) < 10^3 && abs(-log(det(R_Sresamplet(:,:,i)))) > 0
    
        merit_R_Sresamplet(i,1) = -log(det(R_Sresamplet(:,:,i)));
        
    else
        
        merit_R_Sresamplet(i,1) = 0;
        
    end
    
    % Filtered data.
    if abs(-log(det(R_Sfiltert(:,:,i)))) < 10^3 && abs(-log(det(R_Sfiltert(:,:,i)))) > 0
    
        merit_R_Sfiltert(i,1) = -log(det(R_Sfiltert(:,:,i)));
        
    else
        
        merit_R_Sfiltert(i,1) = 0;
        
    end

    % Brownian data.
    if abs(-log(det(R_Bt(:,:,i)))) < 10^3 && abs(-log(det(R_Bt(:,:,i)))) > 0
    
        merit_R_Bt(i,1) = -log(det(R_Bt(:,:,i)));
        
    else
        
        merit_R_Bt(i,1) = 0;
        
    end
    
    % Fourier data.
     if abs(-log(det(R_Ft(:,:,i)))) < 10^3 && abs(-log(det(R_Ft(:,:,i)))) > 0
    
        merit_R_Ft(i,1) = -log(det(R_Ft(:,:,i)));
        
    else
        
        merit_R_Ft(i,1) = 0;
        
     end  
    
     % Copula data.
     if abs(-log(det(R_Ct(:,:,i)))) < 10^3 && abs(-log(det(R_Ct(:,:,i)))) > 0
    
        merit_R_Ct(i,1) = -log(det(R_Ct(:,:,i)));
        
     else
        
        merit_R_Ct(i,1) = 0;
        
     end
     
     % Copula resampled data.
     if abs(-log(det(R_Cresamplet(:,:,i)))) < 10^3 && abs(-log(det(R_Cresamplet(:,:,i)))) > 0
    
        merit_R_Cresamplet(i,1) = -log(det(R_Cresamplet(:,:,i)));
        
     else
        
        merit_R_Cresamplet(i,1) = 0;
        
     end
     
     % Copula resampled and filtered data.
     if abs(-log(det(R_Cfiltert(:,:,i)))) < 10^3 && abs(-log(det(R_Cfiltert(:,:,i)))) > 0
    
        merit_R_Cfiltert(i,1) = -log(det(R_Cfiltert(:,:,i)));
        
     else
        
        merit_R_Cfiltert(i,1) = 0;
        
     end
     
end

% Duplicates the last term of the merit vector.
merit_R_St = [merit_R_St;merit_R_St(end)];
merit_R_resamplet = [merit_R_Sresamplet;merit_R_Sresamplet(end)];
merit_R_filtert = [merit_R_Sfiltert;merit_R_Sfiltert(end)];
merit_R_Bt = [merit_R_Bt;merit_R_Bt(end)];
merit_R_Ft = [merit_R_Ft;merit_R_Ft(end)];
merit_R_Ct = [merit_R_Ct;merit_R_Ct(end)];
merit_R_Cresamplet = [merit_R_Cresamplet;merit_R_Cresamplet(end)];
merit_R_Cfiltert = [merit_R_Cfiltert;merit_R_Cfiltert(end)];

% Fixes issues with merits equaling zero that should be infinite by setting them to 1000.
merit_R_St(merit_R_St == 0) = 1000;
merit_R_Sresamplet(merit_R_Sresamplet == 0) = 1000;
merit_R_Sfiltert(merit_R_Sfiltert == 0) = 1000;
merit_R_Bt(merit_R_Bt == 0) = 1000;
merit_R_Ft(merit_R_Ft == 0) = 1000;
merit_R_Ct(merit_R_Ct == 0) = 1000;
merit_R_Cresamplet(merit_R_Cresamplet == 0) = 1000;
merit_R_Cfiltert(merit_R_Cfiltert == 0) = 1000;

if merits_time == 1
    
x = [merit_R_St,merit_R_resamplet,merit_R_filtert,merit_R_Bt,merit_R_Ft,merit_R_Ct,merit_R_Cresamplet,merit_R_Cfiltert];

% Plot the merits over time.
f4 = figure('Name','Differential Entropy as a Function of Time','NumberTitle','off');
figure(f4)

stairs(interval_list,x)

% Uncomment the below, to change between a stairs plot and a normal plot
%plot(interval_list,real(merit_R_St),real(merit_R_resamplet),real(merit_R_filtert),real(merit_R_Bt),real(merit_R_Ft),real(merit_R_Ct),real(merit_R_Cresamplet),real(merit_R_Cfiltert))

title('Differential entropy as a function of time')
xlabel('Date and Time')
ylabel('Differential entropy')
legend('Standard','Standard with resampling','Standard with resampling and filtering','Brownian','Fourier','Copula','Copula with resampling','Copula with resampling and filtering')

end

end

