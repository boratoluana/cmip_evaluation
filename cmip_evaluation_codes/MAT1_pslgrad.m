%% ----------------- PRESSURE GRADIENT -----------------------------
% 
% This script calculates the atmospheric pressure gradient for all models
%
% Requirements: Statistical Toolbox, function dist2
%
% Borato, L., Fetter Filho, A.F.H., Silva, P.G., Mendez, F.J. 
% Characterization and future projections % of the Weather Types 
% over the South Atlantic Ocean. 2021.
% borato.luana@gmail.com
%% read files

clear
% change the directory and/or scenario name to evaluate other scenarios
cd 'E:\CMIP5_historical'

mkdir AS_CMIP5_historical
movefile dates_all*.nc AS_CMIP5_historical


models = dir;

for i = 1:size(models,1)
    arq_obs = ((fullfile([models(i).name])));
    psl{i} = ncread(arq_obs,'psl');
    lon = ncread(arq_obs,'lon');
    lat = ncread(arq_obs,'lat');
end

%% Calculates Dx e Dy
for m=1:length(lat)
   dx(m)=dist2([lat(m) lat(m)],[lon(3) lon(1)]).*1e3;
end

dy=dist2([lat(3) lat(1)],[lon(1) lon(1)]).*1e3;

%% Central difference Derivation
for i = 1 :size(models,1)
    for m=2:length(lat)-1
        for n=2:length(lon)-1
            grad_x{1,i}(n,m,:)=((psl{i}(n+1,m,:)-psl{i}(n-1,m,:))/dx(m)).^2;
            grad_y{1,i}(n,m,:)=((psl{i}(n,m-1,:)-psl{i}(n,m+1,:))/dy).^2;
        end
    end
    psl_grad{1,i} = grad_x{1,i}(2:end,2:end,:) + grad_y{1,i}(2:end,2:end,:);
    
end    

clearvars grad_x grad_y dx dy i m n arq_obs

%% Organizes files for next script 

cd 'F:\WTs'
load masc % the file contains the points over the ocean

for i = 1:size(models,1)
    
    psl_f{1,i} = psl{1,i}(2:end-1,2:end-1,:); % removes de first 
    % and last lat-lon that are lost during the calculation of the psl grad
    
    % Only at the points over the ocean
    [m,n,k] = size(psl_f{1,i});
    psl_t{1,i} = reshape(psl_f{1,i},[m*n k]);
    psl_sea{1,i} = psl_t{1,i}(masc,:); 
    psl_g{1,i} = reshape(psl_grad{1,i},[m*n k]);
    pslgrad_sea{1,i} = psl_g{1,i}(masc,:);
   
end

clearvars -except lat lon models psl_sea pslgrad_sea arq_obs
%% Prepare to save

gradient_press = struct('lat',[],'lon',[],'psl_grad',[],'name',[]);

list_models = struct2cell(models); 
gradient_press.name = list_models(1,:);
% removes de first and last lat-lon that are lost 
% during the calculation of the psl grad
gradient_press.lat = lat(2:end-1,:); 
gradient_press.lon = lon(2:end-1,:);


for i = 1:size(models,1)
   gradient_press.psl_grad{1,i} = cat(2,psl_sea{1,i}, pslgrad_sea{1,i});
end

clearvars -except gradient_press
save('gradient_press_CMIP5_historical.mat','gradient_press','-v7.3')

close all; clear; clc