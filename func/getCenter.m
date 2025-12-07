function C = getCenter(Z, X)
    % Z: 指示矩阵 (n x k)，n 是样本数量，k 是聚类数量
    % X: 样本特征矩阵 (n x m)，n 是样本数量，m 是特征维度
    
    [n, k] = size(Z); % 获取样本数量和聚类数量
    m = size(X, 2);   % 特征维度
    
    C = zeros(k, m);  % 初始化聚类中心矩阵 (k x m)
    
    for j = 1:k
        % 计算聚类 j 的样本特征和
        cluster_samples = X(Z(:, j) == 1, :);
        
        % 如果聚类中有样本，计算中心
        if ~isempty(cluster_samples)
            C(j, :) = mean(cluster_samples, 1);
        else
            % 处理无样本聚类的情况，这里设置为零向量
            C(j, :) = zeros(1, m);
        end
    end
end
