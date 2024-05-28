% Function to reorganise the features and relate them so they can be displayed in the matricies.
% Each row contains the corresponding feature related to the selected feature.  
% The row index is the number it will appear in the matricies.

function [relate_feature_list] = relate_feature_list(selected_features,feature_name_list)

for i = 1:length(selected_features)
   
    relate_feature_list(i,1) = feature_name_list(selected_features(i));
        
end

end