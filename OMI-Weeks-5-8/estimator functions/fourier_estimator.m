% Uses a Fourier transform method from the paper " A Fourier transform method for nonparametric estimation of multivariate volatility" - Paul Malliavin and Maria Mancino (2009). 
% The Fourier transform is used to deal with the asychronisity of the time-series data.

% The following papers aided in providing a better understanding of this method:

% "Fourier method for the measurement of univariate and multivariate volatility in the presence of high frequency data" - Chanel Malherbe (2007).
% "Fourier series method for measurement of multivariate volatilites" - Paul Malliavin and Maria Elvira Mancino (2002).

function [R_F] = fourier_estimator(Values,DateTime,selected_features)

% Checks wether there is any data to use.
if ~isempty(Values)
    
% Rescale the timeperiod between 0 and 2pi.
DateTime_rescaled = zeros(size(DateTime,1),size(DateTime,2));

t1 = datenum(DateTime(1));
tn = datenum(DateTime(end));

for i = 1:size(DateTime_rescaled)
    
    DateTime_rescaled(i) = (2*pi*(datenum(DateTime(i)) - t1))/(tn - t1);
    
end

% The log values.
Values_l = log(Values);

% Number of Fourier coefficients to be calculated.
% These can be changed but have been kept constant since creating the function.
N = 1000;
nrfc = N/2;

% Number of Fourier coefficients to exclude from the beginning.
n0 = 1;

R_F = zeros(size(Values,2),size(Values,2));

% Cycles throught different features.
for h = selected_features
    
    % Matricies to contain all the fourier coefficients.
    fca1 = zeros(round(nrfc),1);
    fcb1 = zeros(round(nrfc),1);
    
    fca2 = zeros(round(nrfc),1);
    fcb2 = zeros(round(nrfc),1);
    
    % Cycles through all the values of k, calculated the fourier transfer
    % coefficeints for each k.
    for k = 1:round(nrfc)
        
        terms_cos = zeros(size(DateTime_rescaled,1),1);
        terms_sin = zeros(size(DateTime_rescaled,1),1);
        
        for i = 1:(size(DateTime_rescaled,1) - 1)
            
            terms_cos(i) = (cos(k*DateTime_rescaled(i)) - ...
                cos(k*DateTime_rescaled(i+1)))*Values_l(i,h);
            terms_sin(i) = (sin(k*DateTime_rescaled(i)) - ...
                sin(k*DateTime_rescaled(i+1)))*Values_l(i,h);
            
        end
        
        fca1(k,1) = (1/pi)*(sum(terms_cos));
        fcb1(k,1) = (1/pi)*(sum(terms_sin));
        
    end
    
    % Sums the fourier coeff, uses formula to find varaince.
    var1 = (pi^2/(nrfc + 1 - n0))*...
        (sum(fca1(n0:round(nrfc)).*fca1(n0:round(nrfc))) + ...
         sum(fcb1(n0:round(nrfc)).*fcb1(n0:round(nrfc))));

    % Cycles through the second features to be compared against the first.
    for g = selected_features
        
        % Repeats same calculation as above.
        for k = 1:round(nrfc)

            terms_cos = zeros(size(DateTime_rescaled,1),1);
            terms_sin = zeros(size(DateTime_rescaled,1),1);

            for i = 1:(size(DateTime_rescaled,1) - 1)

                terms_cos(i) = (cos(k*DateTime_rescaled(i)) - ...
                    cos(k*DateTime_rescaled(i+1)))*Values_l(i,g);
                terms_sin(i) = (sin(k*DateTime_rescaled(i)) - ...
                    sin(k*DateTime_rescaled(i+1)))*Values_l(i,g);

            end

            fca2(k,1) = (1/pi)*(sum(terms_cos));
            fcb2(k,1) = (1/pi)*(sum(terms_sin));

        end
        
        % Calculate the integrated volatility and covolatility over the
        % entire time window.
        covar = (pi^2/(nrfc + 1 - n0))*...
                (sum(fca1(n0:round(nrfc)).*fca2(n0:round(nrfc))) + sum(fcb1(n0:round(nrfc)).*fcb2(n0:round(nrfc))));
    
        var2 = (pi^2/(nrfc + 1 - n0))*...
               (sum(fca2(n0:round(nrfc)).*fca2(n0:round(nrfc))) + sum(fcb2(n0:round(nrfc)).*fcb2(n0:round(nrfc))));
    
       % Ignores terms that have zero varaince as it will create an error.
        if ((var1 > 0) && (var2 > 0))
            
            % Calculate the dependency matrix.
            R_F(h,g) = covar/(sqrt(var1*var2));
        
        else
            
            R_F(h,g) = 0;
        
        end
               
    end
    
end

% Only keeps the releveant terms.
R_F2 = zeros(size(selected_features,2),size(selected_features,2));
n = 1;

for i = selected_features

    m = 1;

    for j = selected_features

        if isnan(R_F(i,j))

            R_F2(n,m) = 0;

            m = m + 1;

        else

            R_F2(n,m) = R_F(i,j);

            m = m + 1;

        end

    end

    n = n + 1;


end

R_F = R_F2;


else
   
    R_F = zeros(size(selected_features,2),size(selected_features,2));
    
end


end

