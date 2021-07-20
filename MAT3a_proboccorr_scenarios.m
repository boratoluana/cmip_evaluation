%% --- RELATIVE FREQUENCY OF OCCURRENCE (SCENARIOS - divided by period)----
%
% This script calculates the relative frequency of occurrence of each 
% weather type (WT) according to each scenario and time period
%
% Requirements: Statistical Toolbox; WT_ass*.mat (MAT2 script); 
% ColorMap.mat (WT_data directory)
%
% Borato, L., Fetter Filho, A.F.H., Silva, P.G., Mendez, F.J. 
% Characterization and future projections % of the Weather Types 
% over the South Atlantic Ocean. 2021.
% borato.luana@gmail.com
%% read files
clear

% change the directory and scenario name to evaluate other scenarios
cd 'E:\CMIP5_scenarios\CMIP5_RCP26' 
load 'WT_ass_RCP26.mat';

time_srt = datenum([2015 01 01 00 00 00]);
time_end = datenum([2100 12 31 00 00 00]);
time = time_srt:1:time_end;

clearvars -except WT_ass model_name time

shrt = find(time(:,1) == 2039 & time(:,2) == 12 & time(:,3) == 31);
mid = find(time(:,1) == 2069 & time(:,2) == 12 & time(:,3) == 31);
lon = find(time(:,1) == 2100 & time(:,2) == 12 & time(:,3) == 31);

nMD = size(WT_ass,2);

for i =1:nMD
   
    WT_ass_shrt{1,i} = WT_ass{1,i}(1:shrt);
    WT_ass_mid{1,i} = WT_ass{1,i}(shrt+1:mid);
    WT_ass_lon{1,i} = WT_ass{1,i}(mid+1:end);
      
end

clearvars shrt mid lon i
%% statistics 

nWT = 25;

% frequency of occurrence short term (2015-2039)
for k = 1:nMD
    for i = 1:nWT
        a{1,k} = find(WT_ass_shrt{1,k}(1,:)==i);
        pF_shrt{1,k}(i,1) = (length(a{1,k})/length(WT_ass_shrt{1,k}))*100;
    end
end

clear a


% frequency of occurrence mid-term (2040-2069)
for k = 1:nMD
    for i = 1:nWT
        a{1,k} = find(WT_ass_mid{1,k}(1,:)==i);
        pF_mid{1,k}(i,1) = (length(a{1,k})/length(WT_ass_mid{1,k}))*100;
    end
end

clear a


% frequency of occurrence long-term (2040-2069)
for k = 1:nMD
    for i = 1:nWT
        a{1,k} = find(WT_ass_lon{1,k}(1,:)==i);
        pF_lon{1,k}(i,1) = (length(a{1,k})/length(WT_ass_lon{1,k}))*100;
    end
end


clearvars -except WT_ass* pF* model_name
save prob_occurr_RCP26.mat WT_ass* pF* model_name

close all; clear; clc