%% ------------------- PERFORMANCE EVALUATION -----------------------------
% 
% This script calculates the scatter index (SI) and the relative entropy (RE)
% between the historical frequency of occurrence simulated by the climate
% models and the historical frequency of occurrence by the reanalysis data
%
%
% Requirements: Statistical Toolbox; prob_occurr_CFSR.mat(WT_data
% directory or MAT3b script); prob_occurr*.mat (MAT3 script);
% model_name.mat (WT_data directory % or MAT2 script 
% 'model_name cell' modified)
%
% Borato, L., Fetter Filho, A.F.H., Silva, P.G., Mendez, F.J. 
% Characterization and future projections % of the Weather Types 
% over the South Atlantic Ocean. 2021.
% borato.luana@gmail.com
%% read files
clear

cd 'E:\WT_data'
load 'prob_occurr_CFSR.mat'
pRi = n; clear n %pRi frequency of occurence from the CFSR (reanalysis) data

% change the directory to evaluate CMIP6 models
% unsupported analysis for scenarios
cd 'E:\CMIP5_historical\AS_CMIP5_historical'
load 'prob_occurr_CMIP5historical.mat';
pSi = n; clear n n2 %pSi frequency of occurrence from the model simulations

nWT = 25; %nWT number of weather types
nMD = size(pSi,2); %nMD number of models

%% statistics

% scatter index RMSE from Perez et al(2014)
for i = 1:nMD
    SI{1,i} = (sqrt(sum((pRi-pSi{1,i}).^2)/nWT))/(sum(pRi)/nWT); 
end


% relative entropy from Perez et al(2014)
for i = 1:nMD
    for k = 1:nWT
        %RE is sensitive to low frequencies,
        %so frequencies less than 0.5 are removed
        if pSi{1,i}(k) < 0.5
            pSi{1,i}(k) = NaN;
        end
    end
    
    RE{1,i} = sum(pRi.*log10(pRi./pSi{1,i}));
    
    REind{1,i} = (pRi.*log10(pRi./pSi{1,i}));
    medRE{1,i} = nanmean(REind{1,i}); %mean RE for each weather type
end

clearvars -except SI medRE nMD model_name
SI = cell2mat(SI)';
medRE = cell2mat(medRE)';

%% figure

% to the model_name array
cd 'E:\WT_data'
load 'model_name_CMIP5historical.mat'

% organize the matrix in order of lower SI
T = table(model_name',SI,medRE);
T1 = sortrows(T,2);
SI_RE = table2array(T1(:,2:3));
names_ord = table2cell(T1(:,1)); 

clear T T1 model_name 

figure(1) %complementary figure
set(gcf, 'Position', get(0, 'Screensize'));
b = barh(SI_RE(:,1),'FaceColor',[.8 .8 .8],'EdgeColor', 'none')
set(gca,'YDir','reverse')
xlim([0 .8])
xlabel('\it Relative Entropy (RE); Scatter index (SI)','FontName', 'Segoe UI','FontSize',20)
yticks([1:1:nMD])
yticklabels(names_ord)
g = get(gca,'YTickLabel');
set(gca,'YTickLabel',g,'FontName', 'Segoe UI','FontSize',18)
box off
set(gca,'XGrid','on')
ax = gca
ax.GridLineStyle = '--'
ax.GridAlpha = .5
hold on
plot(SI_RE(:,2),1:length(SI_RE),'k.','MarkerSize',20)
legend('SI','RE')
hold off

clearvars -except SI_RE names_ord

cd 'E:\CMIP5_historical\AS_CMIP5_historical'
save 'SI_RE_CMIP5historical.mat' SI_RE names_ord
saveas(gcf,'CMIP5historical_performance','jpeg')
close all; clear; clc