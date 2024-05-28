% Selects the relevenet features subject to the inputs in the main script

function [selected_features] = select_features(select_ask_prices, select_bid_prices, select_ask_sizes, select_bid_sizes)

if any(select_ask_prices < 1) || any(select_ask_prices > 10) || any(select_bid_prices < 1) || any(select_bid_prices > 10) || ...
        any(select_ask_sizes < 1) || any(select_ask_sizes > 10) || any(select_bid_sizes < 1) || any(select_bid_sizes > 10)
    
    error('Features to select must be between 1 and 10');    
    
else

    selected_features = [4*(select_bid_prices)-3, 4*(select_bid_sizes)-2, 4*(select_ask_prices)-1 4*(select_ask_sizes)];
    selected_features = sort(selected_features);

end

end
