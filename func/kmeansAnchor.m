function [idx, biGraph, anchorPoints] = kmeansAnchor(data, k)
    % data: 输入的数据样本，大小为 n x m，其中 n 是样本数，m 是特征维度
    % k: 锚点的数量
    
    % 1. 使用 K-means 聚类来选择锚点
    [idx, anchorPoints] = kmeans(data, k);
    
    % 2. 创建一个二部图，节点包括数据点和锚点
    n = size(data, 1);  % 样本数
    biGraph = zeros(n, k);  % 初始化二部图矩阵，大小为 n x k
    
    % 3. 将数据点连接到对应的锚点
    for i = 1:n
        biGraph(i, idx(i)) = 1;  % 将数据点 i 与其所属的锚点连接
    end
end
