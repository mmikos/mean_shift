function [labels, peaks] = meanshift_opt(data, r)
%% Mean-shift - First speedup

% Mean-shift function, calls findpeak for each point and then assigns a label
% to each point according to its peak. Algorithm compares peaks after each call 
% to findpeak and merges similar peaks. Two peaks are considered to be the same 
% if the distance between them is smaller than r/2. If the peak of a data point 
% already exists in peaks matrix then its computed peak is discarded and it is 
% given the label of the associated peak in peaks.

% The first speedup associates each data point that is at a distance within the 
% search window to the peak with the cluster defined by that peak.

% Meanshift calls findpeak function that outputs found_distance vector that 
% contains indices of the datapoints at the radius r (within the search window) and 
% the associated peak.


% Parameters:
%       data: dataset or image
%       r: search window radius (number of clusters)

% Output:
%       labels: vector of labels for each data point
%       peaks:  matrix of density peaks associated with data points


 labels = zeros(1, size(data,2));

 [peak, found_distance] = findpeak(data, 1, r); 

 peaks(:, 1) = peak;

 label_count = 1;

 labels(found_distance) = label_count;     

 for idx = 1:length(data)

    if labels(idx) == 0

        [peak, found_distance] = findpeak(data, idx, r);

        for counter = 1:label_count

            if  all(abs(peaks(:, counter) - peak) < r/2) == 1

                labels(idx) = counter;

                labels(found_distance) = counter;

                break
            end
        end

        if labels(idx) == 0

            label_count = label_count + 1;

            peaks(:, label_count) = peak;

            labels(found_distance) = label_count;

        end

    end
end


