function [biGraph, anchorPoints] = randomAnchor(data, k)
    % data: 输入的数据样本，大小为 n x m，其中 n 是样本数，m 是特征维度
    % k: 锚点的数量
    
    % 1. 随机选择 k 个数据点作为锚点
    n = size(data, 1);  % 样本数
    randIdx = randperm(n, k);  % 从 n 个样本中随机选择 k 个索引
    anchorPoints = data(randIdx, :);  % 选择这些样本作为锚点
    
    % 2. 创建一个二部图，节点包括数据点和锚点
    biGraph = zeros(n, k);  % 初始化二部图矩阵，大小为 n x k
    
    % 3. 为每个数据点分配最近的锚点
    for i = 1:n
        % 计算当前数据点到每个锚点的欧氏距离
        distances = sqrt(sum((data(i, :) - anchorPoints).^2, 2));  % 计算与所有锚点的距离
        [~, idx] = min(distances);  % 找到最小距离的索引
        biGraph(i, idx) = 1;  % 将数据点 i 与最近的锚点连接
    end
    
end
