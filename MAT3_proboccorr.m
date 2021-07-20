%% --------------- RELATIVE FREQUENCY OF OCCURRENCE -----------------------
% 
% This script calculates the relative frequency of occurrence of each 
% weather type (WT) according to each climate model
%
% Requirements: Statistical Toolbox; WT_ass*.mat (MAT2 script); 
% ColorMap.mat (WT_data directory); model_name.mat (WT_data directory 
% or MAT2 script 'model_name cell' modified)
%
% To generate the figures contained in this script, we use a matrix with 
% just the name of the models. The matrix 'model_name', output of the 
% MAT2 script is related to the name of the model files. So, we provide the
% matrix with the model names used here in the WT_data directory. You can 
% also manually change your matrix according to the models used.
%
% Borato, L., Fetter Filho, A.F.H., Silva, P.G., Mendez, F.J. 
% Characterization and future projections % of the Weather Types 
% over the South Atlantic Ocean. 2021.
% borato.luana@gmail.com
%% read files
clear

% change the directory to evaluate CMIP6 models
% use MAT3a for scenarios
cd 'E:\CMIP5_historical\AS_CMIP5_historical'

load 'WT_ass_CMIP5historical.mat';

%% statistics 

nMD = size(WT_ass,2); %nMD number of models
nWT = 25; %nWT number of weather types

for i = 1:nMD
    nt(i,1) = length(WT_ass{1,i}');
end

% n = relative frequency of occurrence of each weather type 
for k = 1:nMD
    for i = 1:nWT
        a{1,k} = find(WT_ass{1,k}(1,:)==i);
        n{1,k}(i,1) = (length(a{1,k})/nt(nMD,1))*100;
    end
end

% rearrange the matrix to 5x5, in the same sequence as the weather types
for k = 1:nMD
    for i = 1:nWT
        n2{1,k} = reshape(n{1,k},sqrt(nWT),sqrt(nWT));
    end
end

%% figure
name = reshape([1:nWT],sqrt(nWT),sqrt(nWT))'; % to figure
ncol = round(nMD/6); % number of columns for the subplot

cd 'E:\WT_data'
load 'ColorMap.mat'

% plot all models frequency
for ii = 1:nMD
    figure(1) %complementary figure
    set(gcf, 'Position', get(0, 'Screensize'));
    subplot(6,ncol,ii)
    image(n2{1,ii},'CDataMapping','scaled')
    colorbar
    set(gca, 'xTick',[],'YTick',[])
    hold on;
    count=0;
    for i = 1:sqrt(nWT)
        for j = 1:sqrt(nWT)
            count=count+1;
            nu = n2{1,ii}(i,j);
            val = num2str(nu,'%0.1f');
            text(j-0.4,i-0.3,[num2str(name(count))] ,'color','k','Fontsize', 8,'Fontname','Segoe UI')
        end
    end
    colormap(mycmap)
    cbh = colorbar('YTick',1:2:11,'YTickLabel', num2cell(1:2:11),'Fontsize', 8, 'FontName', 'Segoe UI')
    colorbar(cbh,'off')
    title(num2str(model_name{ii}),'Fontsize',10,'FontName','Segoe UI')
end
pos = get(subplot(6,ncol,ncol),'Position')
% colorbar position [x position, y heigh, width, length]
cbg = colorbar('Position', [pos(1)+pos(3)+0.01  pos(2)-0.6  0.01  pos(2)-.2],'YTick',1:2:11,'YTickLabel', num2cell(1:2:11),'Fontsize', 12, 'FontName', 'Segoe UI')
suptitle('Relative frequency of occurrence - CMIP5 Models')

cd 'E:\CMIP5_historical\AS_CMIP5_historical'

saveas(gcf,'CMIP5historical_prob_occurr','jpeg')
close all; clearvars -except n n2 model_name

save prob_occurr_CMIP5historical.mat n model_name
close all; clear; clc