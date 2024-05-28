% A figure with a visualisation of each of the dependency matricies with varying frequency. 
% The time updates every 3 seconds, so to close the figure, call "ctrl-C"
% in the command window.

function [str] = visualise_matrices_resampling(R_Sresamplet,R_Sfiltert,...
    R_Cresamplet,R_Cfiltert,...
    selected_features,feature_name_list,relate_feature_list)

% Creates a list of all the selected features.    
n = 1;
for i = 1:size(selected_features,2)
    
    if mod(selected_features(i),2) ~= 0
        
        selected_features2(n) = selected_features(i);
        n = n + 1;
        
    end
    
end

% Creates a string vector of all the selected feature names.
str = feature_name_list(selected_features2);

% Inserts gaps into the vector so that they can be ploted on the figure.
n = 2;
m = 1;
for i = 1:length(relate_feature_list)
    
    relate_feature_list2(n) = relate_feature_list(i);
    relate_feature_list2(m) = '';
    n = n + 2;
    m = m + 2;
    
end

f9 = figure('Name','Visualisation of Varying Resampling','NumberTitle','off');

% Variable to keep code running.
z = 1;

% The code for each matrix is essentially the same but must be repeated to plot all of them.
while z == 1
    
    for i = 1:size(R_Sresamplet,3)
        
        % Creates new figure.
        figure(f9)
         
        % Each matrix to be ploted on a new subplot.
        subplot(2,2,1)
        
        % Plots the matrix as an image, with each value representing a
        % pixel.
        imagesc(abs(R_Sresamplet(:,:,i)));
        
        % Sets the axis of the matrix and relates it to the feature names.
        set(gca,'xtick',[0.5:0.5:size(R_Sresamplet,1)]);
        set(gca,'xticklabel',relate_feature_list2);
        xtickangle(90);
        set(gca,'ytick',[0.5:0.5:size(R_Sresamplet,1)]);
        set(gca,'yticklabel',relate_feature_list2);
      
        % Required due to notation issues.
        R_Sresample = R_Sresamplet(:,:,i);
        
        % Converts the numerical values into text, that are to be plotted.
        % on the figure.
        textstrings = num2str(R_Sresample(:),'%0.2f');
        textstrings = strtrim(cellstr(textstrings));

        % Creates a x-y grid equal to the size of the matrix.
        [x,y] = meshgrid(1:size(R_Sresamplet,1));
        
        % Alligns the grid with textstrings.
        hstrings = text(x(:),y(:),textstrings(:),'HorizontalAlignment','center');
        
        % Assigns the colours each grid square in accordance to the value
        % in the original matrix.
        midvalue = mean(get(gca,'CLim'));
        textcolors = repmat(R_Sresample(:) > midvalue,1,3);
        set(hstrings,{'Color'},num2cell(textcolors,2));
       
        title('Standard with resampling')
        
        % Comments are not repeated as are exactly the same.
        subplot(2,2,2)
        
        imagesc(abs(R_Sfiltert(:,:,i)));
        set(gca,'xtick',[0.5:0.5:size(R_Sfiltert,1)]);
        set(gca,'xticklabel',relate_feature_list2);
        xtickangle(90);
        set(gca,'ytick',[0.5:0.5:size(R_Sfiltert,1)]);
        set(gca,'yticklabel',relate_feature_list2);
        
        R_Sfilter = R_Sfiltert(:,:,i);
        
        textstrings = num2str(R_Sfilter(:),'%0.2f');
        textstrings = strtrim(cellstr(textstrings));

        [x,y] = meshgrid(1:size(R_Sfiltert,1));
        hstrings = text(x(:),y(:),textstrings(:),'HorizontalAlignment','center');
        midvalue = mean(get(gca,'CLim'));
        textcolors = repmat(R_Sfilter(:) > midvalue,1,3);

        set(hstrings,{'Color'},num2cell(textcolors,2));
  
        title('Standard with resampling and filtering')
     
        subplot(2,2,3)
        
        imagesc(abs(R_Cresamplet(:,:,i)));
        set(gca,'xtick',[0.5:0.5:size(R_Cresamplet,1)]);
        set(gca,'xticklabel',relate_feature_list2);
        xtickangle(90);
        set(gca,'ytick',[0.5:0.5:size(R_Cresamplet,1)]);
        set(gca,'yticklabel',relate_feature_list2);
        
        R_Cresample = R_Cresamplet(:,:,i);
        
        textstrings = num2str(R_Cresample(:),'%0.2f');
        textstrings = strtrim(cellstr(textstrings));

        [x,y] = meshgrid(1:size(R_Cresamplet,1));
        hstrings = text(x(:),y(:),textstrings(:),'HorizontalAlignment','center');
        midvalue = mean(get(gca,'CLim'));
        textcolors = repmat(R_Cresample(:) > midvalue,1,3);

        set(hstrings,{'Color'},num2cell(textcolors,2));
  
        title('Copula with resampling')
        
        subplot(2,2,4)
        
        imagesc(abs(R_Cfiltert(:,:,i)));
        set(gca,'xtick',[0.5:0.5:size(R_Cfiltert,1)]);
        set(gca,'xticklabel',relate_feature_list2);
        xtickangle(90);
        set(gca,'ytick',[0.5:0.5:size(R_Cfiltert,1)]);
        set(gca,'yticklabel',relate_feature_list2);
        
        R_Cfilter = R_Cfiltert(:,:,i);
        
        textstrings = num2str(R_Cfilter(:),'%0.2f');
        textstrings = strtrim(cellstr(textstrings));

        [x,y] = meshgrid(1:size(R_Cfiltert,1));
        hstrings = text(x(:),y(:),textstrings(:),'HorizontalAlignment','center');
        midvalue = mean(get(gca,'CLim'));
        textcolors = repmat(R_Cfilter(:) > midvalue,1,3);

        set(hstrings,{'Color'},num2cell(textcolors,2));
  
        title('Copula with resampling and filtering')
        
        pause(3);
        
    end
    
end

% Dummy variable to make function work.
str = 'done';   

end

