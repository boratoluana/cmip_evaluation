%% ------------------ SEASONAL PERFORMANCE EVALUATION ----------------------
% 
% This script calculates the seasonal scatter index (SI) between the 
% historical frequency of occurrence simulated by the climate models and 
% the historical frequency of occurrence by the reanalysis data 
%
%
% Requirements: Statistical Toolbox; WT_ass*.mat (MAT2 script); 
% prob_occurr_seasonal_CFSR.mat(WT_data directory or MAT3b script);
% model_name.mat (WT_data directory or MAT2 script 
% 'model_name cell' modified)
%
% Borato, L., Fetter Filho, A.F.H., Silva, P.G., Mendez, F.J. 
% Characterization and future projections % of the Weather Types 
% over the South Atlantic Ocean. 2021.
% borato.luana@gmail.com
%% read files
clear

% change the directory to evaluate CMIP6 models
% unsupported analysis for scenarios
cd 'E:\CMIP5_historical\AS_CMIP5_historical'
load 'WT_ass_CMIP5historical.mat';

%time vector
time_srt = datenum([1979 02 01 00 00 00]);
time_end = datenum([2004 12 31 00 00 00]);
time = time_srt:1:time_end;

clearvars -except time WT_ass model_name

nMD = size(WT_ass,2);
nWT = 25;

for i = 1:nMD
    nt(i,1) = length(WT_ass{1,i}');
    WT_ass{1,i} = permute(WT_ass{1,i},[2 1]);
end

%% South summer (DEC, JAN, FEB)

a = find(time(:,2)<3 | time(:,2)>11);

for k = 1:nMD
    for i = 1:nWT
        if nt(k) == 9831
            b{1,k} = find(WT_ass{1,k}(a)==i);
        else
            x = find(a <= nt(k));
            b{1,k} = find(WT_ass{1,k}(a(1:length(x)))==i);
        end
        pSi_DJF{1,k}(i) = length(b{1,k})/nt(k,1)*100;
    end
    
end

clear a b x
%% South autumn (MAR, APR, MAY)

a = find(time(:,2)>2 | time(:,2)<6);

for k = 1:nMD
    for i = 1:nWT
        if nt(k) == 9831
            b{1,k} = find(WT_ass{1,k}(a)==i);
        else
            x = find(a <= nt(k));
            b{1,k} = find(WT_ass{1,k}(a(1:length(x)))==i);
        end
        pSi_MAM{1,k}(i) = length(b{1,k})/nt(k,1)*100;
    end
    
end

clear a b x

%% South winter (JUN,JUL,AUG)

a = find(time(:,2)>5 | time(:,2)<9);

for k = 1:nMD
    for i = 1:nWT
        if nt(k) == 9831
            b{1,k} = find(WT_ass{1,k}(a)==i);
        else
            x = find(a <= nt(k));
            b{1,k} = find(WT_ass{1,k}(a(1:length(x)))==i);
        end
        pSi_JJA{1,k}(i) = length(b{1,k})/nt(k,1)*100;
    end
    
end

clear a b x

%% South spring (SEP, OCT, NOV)

a = find(time(:,2)>8 | time(:,2)<12);

for k = 1:nMD
    for i = 1:nWT
        if nt(k) == 9831
            b{1,k} = find(WT_ass{1,k}(a)==i);
        else
            x = find(a <= nt(k));
            b{1,k} = find(WT_ass{1,k}(a(1:length(x)))==i);
        end
        pSi_SON{1,k}(i) = length(b{1,k})/nt(k,1)*100;
    end
    
end

clearvars -except pSi_DJF pSi_MAM pSi_JJA pSi_SON nMD nWT model_name

%% statistics 

cd 'E:\WT_data'
load 'prob_occurr_seasonal_CFSR.mat'

% scatter index
for i = 1:nMD
    SI_DJF{1,i} = (sqrt(sum((nDJF-pSi_DJF{1,i}).^2)/nWT))/(sum(nDJF)/nWT);
end

for i = 1:nMD
    SI_MAM{1,i} = (sqrt(sum((nMAM-pSi_MAM{1,i}).^2)/nWT))/(sum(nMAM)/nWT);
end

for i = 1:nMD
    SI_JJA{1,i} = (sqrt(sum((nJJA-pSi_JJA{1,i}).^2)/nWT))/(sum(nJJA)/nWT);
end

for i = 1:nMD
    SI_SON{1,i} = (sqrt(sum((nSON-pSi_SON{1,i}).^2)/nWT))/(sum(nSON)/nWT);
end

SI_DJF = cell2mat(SI_DJF)';
SI_MAM = cell2mat(SI_MAM)';
SI_JJA = cell2mat(SI_JJA)';
SI_SON = cell2mat(SI_SON)';

clearvars -except SI_* nMD model_name

%% figure

% to the model_name array
load 'model_name_CMIP5historical.mat'

figure(1)  %complementary figure
set(gcf, 'Position', get(0, 'Screensize'));
subplot(1,4,1)
b = barh(SI_DJF,0.5,'FaceColor',[.8 .8 .8],'EdgeColor', 'none')
set(gca,'YDir','reverse')
xlim([0 2])
xticks([.5:.5:1.5])
xlabel('\it Scatter index (SI)','FontName','Segoe UI','FontSize',16)
yticks([1:1:nMD])
yticklabels(model_name)
g = get(gca,'YTickLabel');
set(gca,'YTickLabel',g,'FontName','Segoe UI','FontSize',16)
box off
set(gca,'XGrid','on')
ax = gca
ax.GridLineStyle = '--'
ax.GridAlpha = .5
title('Summer (DJF)','FontName','Segoe UI','FontSize',18)

subplot(1,4,2)
b = barh(SI_MAM,.5,'FaceColor',[.8 .8 .8],'EdgeColor', 'none')
set(gca,'YDir','reverse')
xlim([0 2])
xticks([.5:.5:1.5])
k = get(gca,'XTickLabel')
set(gca,'XTickLabel',k,'FontName','Segoe UI','FontSize',16)
xlabel('\it Scatter index (SI)','FontName','Segoe UI','FontSize',16)
yticks([1:1:nMD])
set(gca,'YTickLabel',[]);
box off
set(gca,'XGrid','on')
ax = gca
ax.GridLineStyle = '--'
ax.GridAlpha = .5
title('Autumn (MAM)','FontName','Segoe UI','FontSize',18)

subplot(1,4,3)
b = barh(SI_JJA,.5,'FaceColor',[.8 .8 .8],'EdgeColor', 'none')
set(gca,'YDir','reverse')
xlim([0 2])
xticks([.5:.5:1.5])
k = get(gca,'XTickLabel')
set(gca,'XTickLabel',k,'FontName','Segoe UI','FontSize',16)
xlabel('\it Scatter index (SI)','FontName','Segoe UI','FontSize',16)
yticks([1:1:nMD])
set(gca,'YTickLabel',[]);
box off
set(gca,'XGrid','on')
ax = gca
ax.GridLineStyle = '--'
ax.GridAlpha = .5
title('Winter (JJA)','FontName','Segoe UI','FontSize',18)

subplot(1,4,4)
b = barh(SI_SON,.5,'FaceColor',[.8 .8 .8],'EdgeColor', 'none')
set(gca,'YDir','reverse')
xlim([0 2])
xticks([.5:.5:1.5])
k = get(gca,'XTickLabel')
set(gca,'XTickLabel',k,'FontName','Segoe UI','FontSize',16)
xlabel('\it Scatter index (SI)','FontName','Segoe UI','FontSize',16)
yticks([1:1:nMD])
set(gca,'YTickLabel',[]);
box off
set(gca,'XGrid','on')
ax = gca
ax.GridLineStyle = '--'
ax.GridAlpha = .5
title('Spring (SON)','FontName','Segoe UI','FontSize',18)
suptitle('Seasonal performance - CMIP5 Models')

cd 'E:\CMIP5_historical\AS_CMIP5_historical'
saveas(gcf,'CMIP5historical_seasonalperformance','jpeg')

close all
clearvars -except SI_* 
save 'SI_seasonal_CMIP5historical.mat'

close all; clear; clc