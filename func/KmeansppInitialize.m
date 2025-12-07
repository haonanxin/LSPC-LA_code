function [idx, centroids] = KmeansppInitialize(X, k)
    % X is the dataset (n x d) where n is the number of points and d is the dimension
    % k is the number of clusters
    % idx is the indicator matrix (n x 1), which shows the cluster assignment of each point

    n = size(X, 1);
    % Randomly select the first centroid
    centroids = zeros(k, size(X, 2));
    centroids(1, :) = X(randi(n), :);
    
    % Initialize the distance array
    D = inf(n, 1);
    
    % Select the remaining k-1 centroids
    for i = 2:k
        % Compute the distance from each point to the nearest centroid
        for j = 1:n
            D(j) = min(D(j), sum((X(j, :) - centroids(i-1, :)).^2));
        end
        
        % Choose the next centroid with a probability proportional to D^2
        D2 = D.^2;
        probs = D2 / sum(D2);
        cumulative_probs = cumsum(probs);
        r = rand();
        
        % Find the next centroid
        for j = 1:n
            if r < cumulative_probs(j)
                centroids(i, :) = X(j, :);
                break;
            end
        end
    end
    
    % Assign each point to the nearest centroid to form the indicator matrix
    idx = zeros(n, 1);
    for i = 1:n
        [~, idx(i)] = min(sum((X(i, :) - centroids).^2, 2));
    end
end
