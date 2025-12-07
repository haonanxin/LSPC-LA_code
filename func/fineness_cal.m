function [f] = fineness_cal(idx, label)
    n = length(idx);
    ans = 0;
    total = 0;
    for i = 1 : n - 1
        for j = i + 1 : n
            if(idx(i) == idx(j))
                total = total + 1;
                if(label(i)==label(j))
                    ans = ans + 1;
                end
            end
        end
    end
    f = ans / total;
end