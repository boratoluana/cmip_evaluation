%% ------------------------ MAGNITUDES OF CHANGES -------------------------
% 
% This script calculates the magnitude of changes in the relative
% frequencies of occurrence of each weather type, through the SI between
% the frequency of occurrence of the simulations in the reference period
% and the projections of the respective climate models
% In the case of interannual variability, stdSI is used
%
% Requirements: Statistical Toolbox; 
% prob_occurr_(historical and scenario)*.mat (MAT3 & MAT3a scripts); 
% ColorMap.mat (WT_data directory)
% 
%
% Borato, L., Fetter Filho, A.F.H., Silva, P.G., Mendez, F.J. 
% Characterization and future projections % of the Weather Types 
% over the South Atlantic Ocean. 2021.
% borato.luana@gmail.com
%% read files
clear

% reference period
% change the directory to evaluate CMIP6 models
cd 'E:\CMIP5_historical\AS_CMIP5_historical'
load 'prob_occurr_CMIP5historical.mat';
pS_hist = n;
names_hist = model_name;
clear n n2 model_name

% scenarios future projections
% change the directory and scenario name to evaluate other scenarios
cd 'E:\CMIP5_scenarios\CMIP5_RCP26'
load 'prob_occurr_RCP26.mat'
names_RCP26 = model_name;
clear WT_ass_* model_name

%% magnitudes of changes
[a,b] = ismember(names_hist,names_RCP26); % some models didn't run scenarios
clear b

pS_hist = pS_hist(a);
clear a names_hist

nMD = size(names_RCP26,2);
nWT = 25;

% magnitudes of changes short term
for i = 1:nMD
    SI_shrt(i) = (sqrt(sum((pS_hist{1,i}-pF_shrt{1,i}).^2)/nWT))/(sum(pS_hist{1,i})/nWT);
end

% magnitudes of changes mid-term
for i = 1:nMD
    SI_mid(i) = (sqrt(sum((pS_hist{1,i}-pF_mid{1,i}).^2)/nWT))/(sum(pS_hist{1,i})/nWT);
end

% magnitudes of changes long-term
for i = 1:nMD
    SI_lon(i) = (sqrt(sum((pS_hist{1,i}-pF_lon{1,i}).^2)/nWT))/(sum(pS_hist{1,i})/nWT);
end


SI_mag = [SI_shrt',SI_mid',SI_lon'];

clearvars -except SI_mag pF_* nMD

save magchanges_RCP26.mat SI_mag 
clear SI_mag
%% Changes (bias) in the relative frequency of occurrence of each weather type

nWT = 25;
% bias = projection - simulated(historical simulation)

% short term
for k = 1:nMD
    for i = 1:nWT
        mud_shrt{1,k}(i,1) = pF_shrt{1,k}(i,1) - pS_hist{1,k}(i,1);
    end
end

% models that agree on signal
sign_n = zeros(nWT,nMD);
for k = 1:nMD
    j{1,k} = find(mud_shrt{1,k} < 0); % negative positions
    sign_n((j{1,k}),k) = 1;
end

% models that agree with reduction
nn_shrt = nansum(sign_n,2); nn_shrt1 = reshape(nn_shrt,sqrt(nWT),sqrt(nWT));
% models that agree with increase
np_shrt = 25 - nn_shrt; np_shrt = reshape(np_shrt,sqrt(nWT),sqrt(nWT)); 

clear sign_n j

% models average
mshrt = cell2mat(mud_shrt);
mshrt = mean(mshrt,2);

n2_shrt = reshape(mshrt,sqrt(nWT),sqrt(nWT));
clearvars *shrt* -except n2_shrt nn* np*

% mid-term

for k = 1:nMD
    for i = 1:nWT
        mud_mid{1,k}(i,1) = pF_mid{1,k}(i,1) - pS_hist{1,k}(i,1);
    end
end

sign_n = zeros(nWT,nMD);
for k = 1:nMD
    j{1,k} = find(mud_mid{1,k} < 0); % negative positions
    sign_n((j{1,k}),k) = 1;
end

nn_mid = nansum(sign_n,2); nn_mid = reshape(nn_mid,sqrt(nWT),sqrt(nWT));
np_mid = 25 - nn_mid; np_mid = reshape(np_mid,sqrt(nWT),sqrt(nWT)); 

clear sign_n j

% models average
mmid = cell2mat(mud_mid);
mmid = mean(mmid,2);

n2_mid = reshape(mmid,sqrt(nWT),sqrt(nWT));
clearvars *mid* -except n2_mid nn* np*

% long-term

for k = 1:nMD
    for i = 1:nWT
        mud_lon{1,k}(i,1) = pF_lon{1,k}(i,1) - pS_hist{1,k}(i,1);
    end
end

sign_n = zeros(nWT,nMD);
for k = 1:nMD
    j{1,k} = find(mud_lon{1,k} < 0); % negative positions
    sign_n((j{1,k}),k) = 1;
end

nn_lon = nansum(sign_n,2); nn_lon = reshape(nn_lon,sqrt(nWT),sqrt(nWT));
np_lon = 25 - nn_lon; np_lon = reshape(np_lon,sqrt(nWT),sqrt(nWT)); 

clear sign_n j

% models average
mlon = cell2mat(mud_lon);
mlon = mean(mlon,2);

n2_lon = reshape(mlon,sqrt(nWT),sqrt(nWT));
clearvars *lon* -except n2* nn* np*

clear pS_hist 
%% figure 

name = reshape([1:nWT],sqrt(nWT),sqrt(nWT))';
n2 = {n2_shrt, n2_mid, n2_lon};
clear n2_*
prd = {'Short term (2015-2039)','Mid-term (2040-2069)','Long-term (2070-2100)'};

cd 'E:\WT_data'
load 'ColorMap.mat'

cd 'E:\CMIP5_scenarios\CMIP5_RCP26'

figure(1) %complementary figure
set(gcf, 'Position', get(0, 'Screensize'));
for k = 1:3
    subplot(1,3,k)
    image(n2{1,k},'CDataMapping','scaled')
    colorbar
    set(gca, 'xTick',[],'YTick',[])
    hold on;
    count=0;
    for i = 1:sqrt(nWT)
        for j = 1:sqrt(nWT)
            count=count+1;
            nu = n2{1,k}(i,j);
            val = num2str(nu,'%0.1f');
            text(j-0.4,i-0.3,[num2str(name(count))] ,'color','k','Fontsize', 20,'Fontname','Segoe UI')
            if np_shrt(i,j) >= 17
                plot(j,i, 'k.', 'MarkerSize', 20)
            elseif nn_shrt(i,j) >= 17
                plot(j,i,'k.', 'MarkerSize', 20)
            end
        end
    end
    colormap(mycmap)
    cbh = colorbar('YTick',-3:1:3,'YTickLabel', num2cell(-3:1:3),'Fontsize', 18, 'FontName', 'Segoe UI')
    cbh.Limits =([-3 3]);
    set(gca,'CLim',[-3 3]);
    axis image
    title([num2str(prd{1,k})],'FontName','Segoe UI','FontSize',20)
    hold off
end


saveas(gcf,'CMIP5rcp26_magchanges','jpeg')
close all; clear; clc

