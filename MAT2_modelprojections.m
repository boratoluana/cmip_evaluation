%% ----------------- MODEL PROJECTIONS -----------------------------
% 
% This script projects the data of each climate model on the weather types
% in the field of EOFs
%
% Requirements: Statistical Toolbox; gradient_press*.mat (MAT1 script); 
% Results.mat(WT_data directory)
%
% Borato, L., Fetter Filho, A.F.H., Silva, P.G., Mendez, F.J. 
% Characterization and future projections of the Weather Types 
% over the South Atlantic Ocean. 2021.
% borato.luana@gmail.com
%% read files

clear
% change the directory and/or scenario name to evaluate other scenarios
cd 'E:\CMIP5_historical\AS_CMIP5_historical'

load 'gradient_press_CMIP5_historical.mat';
psl_grad = gradient_press.psl_grad;
model_name = gradient_press.name;
nMD = size(psl_grad,1); %nMD number of models

cd 'E:\WT_data'

load 'Results.mat'
EOF = Results.ESTELA.EOF_e;
cen = Results.ESTELA.centroides_e;

nWT = size(cen,1); %nWT number of weather types

clear Results gradient_press

%% statistics
% normal distribution (mean 0, std 1)
for i = 1:nMD
    [nt,nx] = size(psl_grad{1,i});
    medias{1,i} = ones(nt,1)*mean(psl_grad{1,i},1);
    desvios{1,i} = ones(nt,1)*std(psl_grad{1,i});
    psl_grad_m0_d1{1,i} = (psl_grad{1,i}-medias{1,i})./desvios{1,i};
end

clear nt nx medias desvios psl_grad

%% data projection
for i = 1:nMD
    
    proj{1,i} = psl_grad_m0_d1{1,i}*EOF;
    [nt(i,1) trash] = size(proj{1,i});
    
end

clear ii EOF psl_grad_m0_d1 trash

%% associated weather types

% Euclidean distance between the projection and each weather type
% (represented by each centroide)
for k = 1:nMD
    for i = 1:nt(k,1) % time
        for j = 1:nWT % n weather types
            dist_euc{1,k}(i,j) = norm(cen(j,:)-proj{1,k}(i,:));
        end
    end
   end

clear cen proj 

for i = 1:nMD
    dist_euc{1,i} = permute(dist_euc{1,i},[2 1]);
end

% min distance & associated weather type

for k = 1:nMD
    for i = 1:nt(k,1)
        [min_dist{1,k}(:,i),WT_ass{1,k}(:,i)] = min(dist_euc{1,k}(:,i));
    end
end

%% save
cd 'E:\CMIP5_historical\AS_CMIP5_historical'

save min_dist_CMIP5historical.mat min_dist
save WT_ass_CMIP5historical.mat WT_ass model_name

close all; clear; clc