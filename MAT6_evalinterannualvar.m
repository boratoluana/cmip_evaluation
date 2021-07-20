%% ------------ INTERANNUAL VARIABILITY PERFORMANCE EVALUATION ------------
% 
% This script calculates the standard deviation of scatter index (stdSI) 
% between the historical frequency of occurrence variability (represented by
% standard deviation of the annual values) simulated by the climate models,
% and the historical frequency of occurrence by the reanalysis data (also 
% represented by standard deviation of the annual values)
%
%
% Requirements: Statistical Toolbox; WT_ass*.mat (MAT2 script); 
% WT_ass_CFSR.mat(Data_results directory)
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

% divide by year 
a = find(time(:,2) == 1 & time(:,3) == 1); %month 1 day 1
a = [1; a];

nMD = size(WT_ass,2);
% standardize days in the year
mn = NaN(length(a),366); 
for k = 1:nMD
   WT_ass_pyear{1,k} = mn;
end

for k = 1:nMD
    for i = 1:length(a)
        if i == length(a)
            days_year{1,k}(i,1) = length(WT_ass{1,k}(a(i):end));
            WT_ass_pyear{1,k}(i,1:days_year{1,k}(i)) = WT_ass{1,k}(a(i):end);
            
        elseif i < length(a)
            days_year{1,k}(i,1) = length(WT_ass{1,k}(a(i):(a(i+1)-1)));
            WT_ass_pyear{1,k}(i,1:days_year{1,k}(i)) = WT_ass{1,k}(a(i):(a(i+1)-1));
            
        end
    end
end

nWT = 25;

% annual relative frequency of occurrence for each weather type (WT)
for k = 1:nMD
for yrs = 1:length(a)
    for i = 1:nWT
        b{yrs,i} = find(WT_ass_pyear{1,k}(yrs,:)==i);
        pSi{1,k}(yrs,i) = ((size(b{yrs,i},2))/days_year{1,k}(yrs,1))*100;
        
     end
end
end

clearvars -except pSi nMD model_name nWT

%% reference data 
cd 'E:\Data_results'
load 'WT_ass_CFSR.mat'

time = time_2004; WT_ass = WT_ass_CFSR_04;
clear time_2004 WT_ass_CFSR_04

% divide by year 
a = find(time(:,2) == 1 & time(:,3) == 1); %month 1 day 1
a = [1; a];

% standardize days in the year
WT_ass_CFSR_pyear = NaN(length(a),366);
for i = 1:length(a)
    if i == length(a)
        days_year(i,1) = length(WT_ass(a(i):end));
        WT_ass_CFSR_pyear(i,1:days_year(i)) = WT_ass(a(i):end);
        
    elseif i < length(a)
        days_year(i,1) = length(WT_ass(a(i):(a(i+1)-1)));
        WT_ass_CFSR_pyear(i,1:days_year(i)) = WT_ass(a(i):(a(i+1)-1));
        
    end
end

% annual relative frequency of occurrence for each weather type (WT)
for yrs = 1:length(a)
    for i = 1:nWT
        b{yrs,i} = find(WT_ass_CFSR_pyear(yrs,:)==i);
        pRi(yrs,i) = ((size(b{yrs,i},2))/days_year(yrs,1))*100;
        
     end
end

clearvars -except pSi pRi nWT nMD model_name

%% statistics 

% standard deviation of scatter index 

for k = 1:nMD
    stdSI{1,k} = (sqrt(sum((std(pRi,0,2)-std(pSi{1,k},0,2)).^2)/nWT))/(sum(std(pRi,0,2))/nWT);
end

stdSI = cell2mat(stdSI)';

load 'model_name_CMIP5historical.mat'
% organize the matrix in order of lower stdSI
T = table(model_name',stdSI);
T1 = sortrows(T,2);
stdSI_ord = table2array(T1(:,2));
names_ord = table2cell(T1(:,1)); 

clear T T1 model_name stdSI

%% figure

figure(1)  %complementary figure
set(gcf, 'Position', get(0, 'Screensize'));
b = barh(stdSI_ord(:,1),.5,'FaceColor',[.8 .8 .8],'EdgeColor', 'none')
set(gca,'YDir','reverse')
xlabel('\it Scatter index (SI)','FontName','Segoe UI','FontSize',20)
yticks([1:1:nMD])
yticklabels(names_ord)
g = get(gca,'YTickLabel');
set(gca,'YTickLabel',g,'FontName','Segoe UI','FontSize',18)
title('Interannual variability - CMIP5 Models','FontName','Segoe UI','FontSize',14)
box off
set(gca,'XGrid','on')
ax = gca
ax.GridLineStyle = '--'
ax.GridAlpha = .5

cd 'E:\CMIP5_historical\AS_CMIP5_historical'
saveas(gcf,'CMIP5historical_interanvar','jpeg')
save 'stdSI_CMIP5historical.mat' 'stdSI_ord' 'names_ord'

close all; clear; clc