%% -------- RELATIVE FREQUENCY OF OCCURRENCE (reanalysis data) ------------
% 
% This script calculates the relative frequency of occurrence of each 
% weather type (WT) according to the reanalysis data
%
% Requirements: Statistical Toolbox; Results*.mat (WT_data directory); 
% ColorMap.mat (WT_data directory)
%
% Borato, L., Fetter Filho, A.F.H., Silva, P.G., Mendez, F.J. 
% Characterization and future projections % of the Weather Types 
% over the South Atlantic Ocean. 2021.
% borato.luana@gmail.com
%% read files
clear

cd 'E:\WT_data'
load 'Results.mat'

WT_ass = double(Results.assigned_WT);
time =  double(Results.time);

clear Results

tvec = datevec(time);
a = find(tvec(:,1) == 2005 & tvec(:,2) == 12 & tvec(:,3) == 30);

WT_ass_CFSR = WT_ass(1:a);
time_CFSR = tvec(1:a,:);

clearvars -except WT_ass_CFSR time_CFSR
save WT_ass_CFSR.mat

WT_ass = WT_ass_CFSR;

%% statistics 
nWT = 25;
nt = length(time_CFSR);

% relative frequency of occurrence of each weather type
for i = 1:nWT
    a = find(WT_ass==i);
    n(i,1) = (length(a)/nt)*100;
end

save prob_occurr_CFSR.mat n

% seasonal relative frequency of occurrence 

%South summer (DEC, JAN, FEB)
a = find(time_CFSR(:,2)<3 | time_CFSR(:,2)>11);
for i = 1:nWT
    b = find(WT_ass(a)==i);
    nDJF(i) = length(b)/length(a)*100;
end

%South autumn (MAR, APR, MAY)
a = find(time_CFSR(:,2)>2 & time_CFSR(:,2)<6);
for i = 1:nWT
    b = find(WT_ass(a)==i);
    nMAM(i) = length(b)/length(a)*100
end

%South winter (JUN, JUL, AUG)
a = find(time_CFSR(:,2)>5 & time_CFSR(:,2)<9);
for i = 1:nWT
    b = find(WT_ass(a)==i);
    nJJA(i) = length(b)/length(a)*100
end

% South spring (SEP, OCT, NOV)
a = find(time_CFSR(:,2)>8 & time_CFSR(:,2)<12);
for i = 1:nWT
    b = find(WT_ass(a)==i);
    nSON(i) = length(b)/length(a)*100
end

save prob_occurr_seasonal_CFSR.mat nDJF nMAM nJJA nSON

%% figure historical frequency of occurrence 
n2 = reshape(n,sqrt(nWT),sqrt(nWT));
name = reshape([1:nWT],sqrt(nWT),sqrt(nWT))'; % to figure
load 'ColorMap.mat'

figure(1) %complementary figure
set(gcf, 'Position', get(0, 'Screensize'));
 image(n2,'CDataMapping','scaled') 
 colorbar
 set(gca, 'xTick',[],'YTick',[])
 hold on;
 count=0;
     for i = 1:sqrt(nWT)
         for j = 1:sqrt(nWT)
             count=count+1;
             nu = n2(i,j);
             val = num2str(nu,'%0.1f');
             text(j-0.4,i-0.3,['WT ',num2str(name(count))] ,'color','k','Fontsize', 20,'Fontname','Segoe UI')
         end
     end
  colormap(cool)
  cbh = colorbar('YTick',1:2:10,'YTickLabel', num2cell(1:2:10),'Fontsize', 18,'Fontname','Segoe UI')
set(gca,'CLim',[1 10])
axis image
title({'Relative frequency of occurrence'; 'Reanalysis data (CFSR historical)'},'Fontsize', 18,'Fontname','Segoe UI')

saveas(gcf,'CFSRreanalysis_prob_occurr','jpeg')
close all; clear; clc
