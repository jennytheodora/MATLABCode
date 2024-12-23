clear all
clc

load('psd_50.mat')

%% initialize
% data
data_1 = permute(cell2mat(permute(norm_psd_avg_cov,[3,1,2])),[3,1,2]);
data_2a = permute(cell2mat(permute(norm_psd_avg_longcov1,[3,1,2])),[3,1,2]);
data_2b = permute(cell2mat(permute(norm_psd_avg_longcov2,[3,1,2])),[3,1,2]);
data_2 = [data_2a;data_2b];

% legend
legend_1 = "COVID";
legend_2a = "Long-COVID (age < 50)";
legend_2b = "Long-COVID (age ≥ 50)";
legend_2 = "Long-COVID";

% color (1: blue, 2: red, 3: green)
color1_dark = [39, 103, 177]./255;
color1_light  = [117,166,225]./255;
color2_dark = [217,33,59]./255;
color2_light  = [239,149,162]./255;
color3_dark = [80, 178, 69]./255;
color3_light  = [156,214,150]./255;

destination = "D:\IMERI\Project dr. Yetti\Hasil\New Plots\Spectrum";

%% divide into freq
delta_freq = [0 4];
theta_freq = [4 8];
alpha_freq = [8 12];
beta_freq = [12 30];
gamma_freq = [30 40];


for a = 1:size(data_1,1) % subject
    for b = 1:size(data_1,2) % channels
        delta = squeeze(data_1(a,b,find(freq==delta_freq(1),1):find(freq==delta_freq(2),1)));
        theta = squeeze(data_1(a,b,find(freq==theta_freq(1),1):find(freq==theta_freq(2),1)));
        alpha = squeeze(data_1(a,b,find(freq==alpha_freq(1),1):find(freq==alpha_freq(2),1)));
        beta = squeeze(data_1(a,b,find(freq==beta_freq(1),1):find(freq==beta_freq(2),1)));
        gamma = squeeze(data_1(a,b,find(freq==gamma_freq(1),1):find(freq==gamma_freq(2),1)));

        freqband_1(a,b,:) = [mean(delta),mean(theta),mean(alpha),mean(beta),mean(gamma)];
    end
end 

for a = 1:size(data_2,1) % subject
    for b = 1:size(data_2,2) % channels
        delta = squeeze(data_2(a,b,find(freq==delta_freq(1),1):find(freq==delta_freq(2),1)));
        theta = squeeze(data_2(a,b,find(freq==theta_freq(1),1):find(freq==theta_freq(2),1)));
        alpha = squeeze(data_2(a,b,find(freq==alpha_freq(1),1):find(freq==alpha_freq(2),1)));
        beta = squeeze(data_2(a,b,find(freq==beta_freq(1),1):find(freq==beta_freq(2),1)));
        gamma = squeeze(data_2(a,b,find(freq==gamma_freq(1),1):find(freq==gamma_freq(2),1)));

        freqband_2(a,b,:) = [mean(delta),mean(theta),mean(alpha),mean(beta),mean(gamma)];
    end
end

for a = 1:size(data_2a,1) % subject
    for b = 1:size(data_2a,2) % channels
        delta = squeeze(data_2a(a,b,find(freq==delta_freq(1),1):find(freq==delta_freq(2),1)));
        theta = squeeze(data_2a(a,b,find(freq==theta_freq(1),1):find(freq==theta_freq(2),1)));
        alpha = squeeze(data_2a(a,b,find(freq==alpha_freq(1),1):find(freq==alpha_freq(2),1)));
        beta = squeeze(data_2a(a,b,find(freq==beta_freq(1),1):find(freq==beta_freq(2),1)));
        gamma = squeeze(data_2a(a,b,find(freq==gamma_freq(1),1):find(freq==gamma_freq(2),1)));

        freqband_2a(a,b,:) = [mean(delta),mean(theta),mean(alpha),mean(beta),mean(gamma)];
    end
end

for a = 1:size(data_2b,1) % subject
    for b = 1:size(data_2b,2) % channels
        delta = squeeze(data_2b(a,b,find(freq==delta_freq(1),1):find(freq==delta_freq(2),1)));
        theta = squeeze(data_2b(a,b,find(freq==theta_freq(1),1):find(freq==theta_freq(2),1)));
        alpha = squeeze(data_2b(a,b,find(freq==alpha_freq(1),1):find(freq==alpha_freq(2),1)));
        beta = squeeze(data_2b(a,b,find(freq==beta_freq(1),1):find(freq==beta_freq(2),1)));
        gamma = squeeze(data_2b(a,b,find(freq==gamma_freq(1),1):find(freq==gamma_freq(2),1)));

        freqband_2b(a,b,:) = [mean(delta),mean(theta),mean(alpha),mean(beta),mean(gamma)];
    end
end

%% ranksum cov vs. longcov
for freqsel = 1:5
    for chansel = 1:length(labels)
        a = round(squeeze(freqband_2a(:,chansel,freqsel)),4);
        b = round(squeeze(freqband_2b(:,chansel,freqsel)),4);
        [p_ranksum2(chansel,freqsel),~,stats] = ranksum(a',b');
    end
end

%% ranksum cov vs. longcov + fdr
[~, ~, ~, p_ranksum2_fdr] = fdr_bh(p_ranksum2);

%% save tables
freq_labels = ["Delta","Theta","Alpha","Beta","Gamma"];

% table 1: pval ranksum longcov < 50 vs. longcov >= 50 
table = array2table(p_ranksum2);
table.Properties.VariableNames = freq_labels;
writetable(table,destination+"\P_RanksumLongcov50.xlsx",'Range','B1')
table = array2table(labels');
writetable(table,destination+"\P_RanksumLongcov50.xlsx",'Range','A2', 'WriteVariableNames', false)

% table 2: pval ranksum longcov < 50 vs. longcov >= 50 fdr (8-electrode pairs row x 5-freqband column)
table = array2table(p_ranksum2_fdr);
table.Properties.VariableNames = freq_labels;
writetable(table,destination+"\P_RanksumLongcov50FDR.xlsx",'Range','B1')
table = array2table(labels');
writetable(table,destination+"\P_RanksumLongcov50FDR.xlsx",'Range','A2', 'WriteVariableNames', false)
