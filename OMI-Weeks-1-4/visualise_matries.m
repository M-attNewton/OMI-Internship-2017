% Visualises the matries over time

function [str] = visualise_matries(R_St,R_resamplet,R_filtert,R_Bt,R_Ft,num_intervals,selected_features,feature_name_list)

n = 1;
for i = 1:size(selected_features,2)
    
    if mod(selected_features(i),2) ~= 0
        
        selected_features2(n) = selected_features(i);
        n = n + 1;
        
    end
    
end

str = feature_name_list(selected_features2);

figure

z = 1;

while z == 1
    
    for i = 1:num_intervals
        
        subplot(2,3,1)
        imagesc(abs(R_St(:,:,i)));
        colormap(flipud(gray));
        
        R_S = R_St(:,:,i);
        
        textstrings = num2str(R_S(:),'%0.2f');
        textstrings = strtrim(cellstr(textstrings));

        [x,y] = meshgrid(1:size(R_St,1));
        hstrings = text(x(:),y(:),textstrings(:),'HorizontalAlignment','center');
        midvalue = mean(get(gca,'CLim'));
        textcolors = repmat(R_S(:) > midvalue,1,3);

        set(hstrings,{'Color'},num2cell(textcolors,2));
        %set(gca,1:size(R_St,1),'XTickLabel',{str},'YTick',1:size(R_St,1),'YTickLabel',{str},'TickLength',[0 0]);
        
        title('Standard')
        xlabel('Features')
        ylabel('Features')
        
        
        subplot(2,3,2)
        imagesc(abs(R_resamplet(:,:,i)));
        colormap(flipud(gray));
        
        R_resample = R_resamplet(:,:,i);
        
        textstrings = num2str(R_resample(:),'%0.2f');
        textstrings = strtrim(cellstr(textstrings));

        [x,y] = meshgrid(1:size(R_St,1));
        hstrings = text(x(:),y(:),textstrings(:),'HorizontalAlignment','center');
        midvalue = mean(get(gca,'CLim'));
        textcolors = repmat(R_resample(:) > midvalue,1,3);

        set(hstrings,{'Color'},num2cell(textcolors,2));
        %set(gca,1:size(R_St,1),'XTickLabel',{str},'YTick',1:size(R_St,1),'YTickLabel',{str},'TickLength',[0 0]);
        
        title('Standard with resampling')
        xlabel('Features')
        ylabel('Features')

        subplot(2,3,3)
        imagesc(abs(R_filtert(:,:,i)));
        colormap(flipud(gray));
        
        R_filter = R_filtert(:,:,i);
        
        textstrings = num2str(R_filter(:),'%0.2f');
        textstrings = strtrim(cellstr(textstrings));

        [x,y] = meshgrid(1:size(R_filtert,1));
        hstrings = text(x(:),y(:),textstrings(:),'HorizontalAlignment','center');
        midvalue = mean(get(gca,'CLim'));
        textcolors = repmat(R_filter(:) > midvalue,1,3);

        set(hstrings,{'Color'},num2cell(textcolors,2));
       % set(gca,1:size(R_St,1),'XTickLabel',{str},'YTick',1:size(R_St,1),'YTickLabel',{str},'TickLength',[0 0]);
        
        title('Standard with resampling and filtering')
        xlabel('Features')
        ylabel('Features')

        subplot(2,3,4)
        imagesc(abs(R_Bt(:,:,i)));
        colormap(flipud(gray));
        
        R_B = R_Bt(:,:,i);
        
        textstrings = num2str(R_B(:),'%0.2f');
        textstrings = strtrim(cellstr(textstrings));

        [x,y] = meshgrid(1:size(R_St,1));
        hstrings = text(x(:),y(:),textstrings(:),'HorizontalAlignment','center');
        midvalue = mean(get(gca,'CLim'));
        textcolors = repmat(R_B(:) > midvalue,1,3);

        set(hstrings,{'Color'},num2cell(textcolors,2));
        %set(gca,1:size(R_St,1),'XTickLabel',{str},'YTick',1:size(R_St,1),'YTickLabel',{str},'TickLength',[0 0]);
        
        title('Brownian')
        xlabel('Features')
        ylabel('Features')

        subplot(2,3,5)
        imagesc(abs(R_Ft(:,:,i)));    
        colormap(flipud(gray));
        
        R_F = R_Ft(:,:,i);
        
        textstrings = num2str(R_F(:),'%0.2f');
        textstrings = strtrim(cellstr(textstrings));

        [x,y] = meshgrid(1:size(R_St,1));
        hstrings = text(x(:),y(:),textstrings(:),'HorizontalAlignment','center');
        midvalue = mean(get(gca,'CLim'));
        textcolors = repmat(R_F(:) > midvalue,1,3);

        set(hstrings,{'Color'},num2cell(textcolors,2));
        %set(gca,1:size(R_St,1),'XTickLabel',{str},'YTick',1:size(R_St,1),'YTickLabel',{str},'TickLength',[0 0]);
        
        title('Fourier')
        xlabel('Features')
        ylabel('Features')
        
        pause(1);
        
    end
    
end



end



% 
% textstrings = num2str(R_St(:,:,i),'%0.2f');
% textstrings = strtrim(cellstr(textstrings));
% 
% [x,y] = meshgrid(1:size(R_St,1));
% hstrings = text(x(:),y(:),textstrings(:),'HorizontalAlignment','center');
% midvalue = mean(get(gca,'CLim'));
% textcolors = repmat(R_St(:,:,i) > midvalue,1,3);
% 
% set(hstrings,{'Color'},num2cell(textcolors,2));
% set(gca,1:size(R_St,1),'XTickLabel',{str},'YTick',1:size(R_St,1),'YTickLabel',{str},'TickLength',[0 0]);
