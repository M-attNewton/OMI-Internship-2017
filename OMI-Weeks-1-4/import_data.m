% Imports all the data from asv file and puts the values (price and sizes)
% into a matrix and then the DateTime values into another matrix

function [XOMMarketDepthOct2016_Values,XOMMarketDepthOct2016_DateTime,XOMTransactionsOct2016,XOMTransactionsOct2016_DateTime] = import_data()

% Initialize variables.
filename = 'C:\Users\mnewton\Documents\MATLAB\Week 1\XOM_MarketDepth_Oct2016.csv';
delimiter = ',';
startRow = 3;

% Format for each line of text:
formatSpec = '%*q%*q%*q%*q%*q%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

% Open the text file.
fileID = fopen(filename,'r');

% Read columns of data according to the format.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

% Close the text file.
fclose(fileID);

% Create output variable
XOMMarketDepthOct2016_Values = [dataArray{1:end-1}];

% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;


% Initialize variables.
filename = 'C:\Users\mnewton\Documents\MATLAB\Week 1\XOM_MarketDepth_Oct2016.csv';
delimiter = ',';
startRow = 3;

% Format for each line of text:
formatSpec = '%*q%*q%*q%q%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%[^\n\r]';

% Open the text file.
fileID = fopen(filename,'r');

% Read columns of data according to the format.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

% Close the text file.
fclose(fileID);

% Create output variable
XOMMarketDepthOct2016_DateTime = [dataArray{1:end-1}];

% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;



% Initialize variables.
filename = 'C:\Users\mnewton\Documents\MATLAB\Week 2\Standard Correlation\XOM_Transactions_Oct2016.csv';
delimiter = ',';
startRow = 4;

% Format for each line of text:
formatSpec = '%*q%*q%*q%*q%*q%f%f%[^\n\r]';

% Open the text file.
fileID = fopen(filename,'r');

% Read columns of data according to the format.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

% Close the text file.
fclose(fileID);

% Create output variable
XOMTransactionsOct2016 = [dataArray{1:end-1}];

% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;



% Initialize variables.
filename = 'C:\Users\mnewton\Documents\MATLAB\Week 2\Standard Correlation\XOM_Transactions_Oct2016.csv';
delimiter = ',';
startRow = 4;

% Format for each line of text:
formatSpec = '%*q%*q%*q%q%*s%*s%*s%[^\n\r]';

% Open the text file.
fileID = fopen(filename,'r');

% Read columns of data according to the format.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

% Close the text file.
fclose(fileID);

% Create output variable
XOMTransactionsOct2016_DateTime = [dataArray{1:end-1}];

% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;


% Remove corrupted data
XOMMarketDepthOct2016_Values(isnan(XOMMarketDepthOct2016_Values)) = 0;
XOMMarketDepthOct2016_Values(abs(XOMMarketDepthOct2016_Values) > 10^20) = 0;

% Replaces zeros with the previous value
for j = 1:size(XOMMarketDepthOct2016_Values,2)
    
    for i = 1:size(XOMMarketDepthOct2016_Values,1)
        
        if XOMMarketDepthOct2016_Values(i,j) == 0
            
            XOMMarketDepthOct2016_Values(i,j) = XOMMarketDepthOct2016_Values(i-1,j);
            
        end
        
    end
    
end

end
