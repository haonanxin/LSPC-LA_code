function [iter, obj, Q, S, P, total] = solve(X, M, gama, lambda, cluster)
% X(d*n): Input data matrix
% P(d*m): Anchor matrix
% Q(n*m): Fuzzy bipartite graph
% M(n*m): Bipartite graph
% S(m*c): Anchor point indication matrix



% Initialize Q
Q = M;
M_number=sum(M,1);

% Initialize P
P = getCenter(M, X');
P = P';

% Initialize S
A0 = selftuning(P', cluster);
F_init = n2hi(A0, cluster);
S = create_indicator_matrix(F_init,cluster);


K = diag(sum(M,1))^(-1);
B = X' * X;
G = K * K';

diff = P - X * Q * K;
obj(1) = sum(sum(diff.^2)) + gama * (trace(P * P') - trace(P * S / (S' * S)*S'*P')) + lambda * trace(Q'*Q);
total = 0;

T = 1;
for iter = 2:100
    %% update P

    R = (1 + gama).*eye(size(S,1)) - gama.*(S/(S'*S)) * S';
    P = X * Q * K / R;


    %% update Q
    N = 2 * K * P' * X;
    for j = 1 : size(Q, 2)
        A = G(j,j) .* B + lambda * eye(size(B,1));
        non_zero_indices = find(M(:,j));
        x = quadprog(2*A(non_zero_indices,non_zero_indices), -N(j,non_zero_indices)',[],[],ones(1, length(non_zero_indices)),M_number(j),zeros(length(non_zero_indices),1),M_number(j)*ones(length(non_zero_indices),1),[], optimset('Display', 'off'));
        Q(non_zero_indices, j) = x;
    end
    
    %% update S
    [S, o] = DPMKKM(P, S);


    %% calculate objective function value
    diff = P - X * Q * K;
    obj(iter) = sum(sum(diff.^2)) + gama * (trace(P * P') - trace(P * S / (S' * S)*S'*P')) + lambda * trace(Q'*Q);


    if obj(iter) > obj(iter-1)
        total = total + 1;
    end

    if iter > 2 && abs(obj(iter) - obj(iter - 1)) < 1e-3
        break;
    end
end

end