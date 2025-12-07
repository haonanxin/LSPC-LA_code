clear;clc;close all;
addpath("func");

dataset_name = 'olivetti';
data = load('data\olivetti.mat','X');
label = load('data\olivetti.mat','Y');

data = struct2cell(data);
label = struct2cell(label);
data = cell2mat(data);
label = cell2mat(label);

data = double(data);
data = mapminmax(data,0,1); 

data = data';
label = label';
% label = label + 1;
clusters = 10;
n = size(data,2);

anchor_num = round(0.4 * n);

gama = 10;
lambda = 0.01;

%% kmeans++ generate anchor
[idx, P1] = KmeansppInitialize(data',  anchor_num);
M = create_indicator_matrix(idx, anchor_num);

%% Optimization of LSPC-LA
[iter, obj, Q, S, P, total] = solve(data, M, gama, lambda, clusters);
                                               
F = M * S;
[~,max_F] = max(F,[],2);

result = ClusteringMeasure_new(label, max_F);

disp(['********************************************']);
disp(['Running on ',dataset_name,' to obtain ACC: ', num2str(result.ACC)]);
disp(['********************************************']);