%% ------------------ CONSISTENCY OF FUTURE PROJECTIONS--------------------
% 
% This script calculates the consistency of future projections. SI values
% greater than or less than 3x std of the mean of the future projectios
% of the models of each CMIP phase are identified.
%
% Requirements: Statistical Toolbox; magchanges_*.mat (MAT7 script);
% prob_occurr*.mat (MAT3 script);
% 
%
% Borato, L., Fetter Filho, A.F.H., Silva, P.G., Mendez, F.J. 
% Characterization and future projections % of the Weather Types 
% over the South Atlantic Ocean. 2021.
% borato.luana@gmail.com
%% read files
clear

% use for CMIP5 scenarios (for CMIP6 scenarios use the read files below)
cd 'E:\CMIP5_scenarios\CMIP5_RCP26'
load 'magchanges_RCP26.mat'
load 'prob_occurr_RCP26.mat'
SI_RCP26 = SI_mag; 
names_RCP26 = model_name;
clear WT_ass_* model_name SI_mag

cd 'E:\CMIP5_scenarios\CMIP5_RCP45'
load 'magchanges_RCP45.mat'
load 'prob_occurr_RCP45.mat'
SI_RCP45 = SI_mag; 
names_RCP45 = model_name;
clear WT_ass_* model_name SI_mag

cd 'E:\CMIP5_scenarios\CMIP5_RCP85'
load 'magchanges_RCP85.mat'
load 'prob_occurr_RCP85.mat'
SI_RCP85 = SI_mag; 
names_RCP85 = model_name;
clear WT_ass_* model_name SI_mag

names = {names_RCP26, names_RCP45, names_RCP85};
SI = {SI_RCP26, SI_RCP45, SI_RCP85};

clearvars -except names SI

%% read files 

% % % use for CMIP6 scenarios
% % cd 'E:\CMIP6_scenarios\CMIP6_SSP1'
% % load 'magchanges_SSP1.mat'
% % load 'prob_occurr_SSP1.mat'
% % SI_SSP1 = SI_mag; 
% % names_SSP1 = model_name;
% % clear WT_ass_* model_name SI_mag
% % 
% % cd 'E:\CMIP6_scenarios\CMIP6_SSP2'
% % load 'magchanges_SSP2.mat'
% % load 'prob_occurr_SSP2.mat'
% % SI_SSP2 = SI_mag; 
% % names_SSP2 = model_name;
% % clear WT_ass_* model_name SI_mag
% % 
% % cd 'E:\CMIP6_scenarios\CMIP6_SSP3'
% % load 'magchanges_SSP3.mat'
% % load 'prob_occurr_SSP3.mat'
% % SI_SSP3 = SI_mag; 
% % names_SSP3 = model_name;
% % clear WT_ass_* model_name SI_mag
% % 
% % cd 'E:\CMIP6_scenarios\CMIP6_SSP5'
% % load 'magchanges_SSP5.mat'
% % load 'prob_occurr_SSP5.mat'
% % SI_SSP5 = SI_mag; 
% % names_SSP5 = model_name;
% % clear WT_ass_* model_name SI_mag
% % 
% % names = {names_SSP1, names_SSP2, names_SSP3, names_SSP5};
% % SI = {SI_SSP1, SI_SSP2, SI_SSP3, SI_SSP5};
% % 
% % clearvars -except names SI

%% statistics (mean & std)

SI_scenarios = []
for i = 1:size(names,2)
    SI_sce = cat(1,SI{1,i});
    SI_scenarios = [SI_scenarios; SI_sce];  
end

clear SI_sce

stdSI = nanstd(SI_scenarios,0,1); % std for each column/ period
meanSI = nanmean(SI_scenarios,1); % mean for each column/ period

lim = 3.*stdSI+mSI; % models with -lim > SI > +lim are inconsistent

z = repmat(zeros,size(SI{1,i}));
for i = 1:size(names,2)
    z = repmat(zeros,size(SI{1,i}));
    for j = 1:size(SI{1,i},2)
        posit = find(SI{1,i}(:,j) > lim(1,j));
        negat = find(SI{1,i}(:,j) < -lim(1,j));
        z(posit,j) = 1;
    end
    incons{1,i} =  z; 
    std_incons{1,i} = SI{1,i}(z(z==1),j); 
    incons_models{1,i} = names{1,i}(z(z==1),j); % model names
    
end

%replace SCENARIO to RCP or SSP
save inconsis_proj_SCENARIO.mat std_incons incons_models 
close all; clear; clc