function [F, obj_] = DPMKKM(data, F)
% data - d*n
% F - Initialized indicator matrix - n*c
    K = data' * data;           % n*n
    fKf = sum(F .* (K * F))';
    ff = sum(F)';               % c*1 存储每一类的数量 提前计算F^TF

    m_all = vec2ind(F')';       % 转换为n*1的指示向量（one-hot）

    obj(1) = sum(fKf ./ ff);    % 计算一次目标函数
    obj_ = 0;
    for iter = 2:100
        for i = 1:size(F, 1)
            m = m_all(i);       % 第i个数据的类别    也表示目前在第m列为1
            if ff(m) == 1       % 若只有他一个 不作处理
                % avoid generating empty cluster
                continue;
            end

            % 有两种情况 当目前的位置s和m不相等  当目前的位置s和m相等
    
            Y_A = F' * K(:, i); 

            % 同时考虑了相等和不相等的情况
            fKf_s = fKf + 2 * Y_A + K(i, i);            % eq.31 目前的位置s和m不相等 大部分情况
            fKf_s(m) = fKf(m);                          % eq.29
            ff_k = ff + 1;                              % eq.32
            ff_k(m) = ff(m);                            % eq.30

            fKf_0 = fKf;                                % eq.24
            fKf_0(m) = fKf(m) - 2 * Y_A(m) + K(i, i);   % eq.26 目前的位置s和m相等  小部分情况
            ff_0 = ff;                                  % eq.25
            ff_0(m) = ff(m) - 1;                        % eq.27

            delta = fKf_s ./ ff_k - fKf_0 ./ ff_0;

            [~, p] = max(delta);    
            if p ~= m
                fKf([m, p]) = [fKf_0(m), fKf_s(p)];
                ff([m, p]) = [ff_0(m), ff_k(p)];

                F(i, [p, m]) = [1, 0];
                m_all(i) = p;
            end
        end
        obj(iter) = sum(fKf ./ ff);
        T = 1;
        if iter > 2 && (obj(iter) - obj(iter - 1)) / obj(iter - 1) < 1e-9
            obj_ = obj(iter);
            break;
        end
    end
end
