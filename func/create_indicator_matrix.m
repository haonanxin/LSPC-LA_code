function Y = create_indicator_matrix(F,clusters)
    % 获取输入矩阵的大小
    n = length(F);

    % 创建一个 n x clusters 的零矩阵
    Y = zeros(n, clusters);

    % 遍历 F 矩阵，为 Y 中对应的位置赋值为 1
    for i = 1:n
        Y(i, F(i)) = 1;
    end
end
