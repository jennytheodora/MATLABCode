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
legend_2 = "Long-COVID";
legend_2a = "Long-COVID (age < 50)";
legend_2b = "Long-COVID (age ≥ 50)";

% color (1: blue, 2: red, 3: green)
color1_dark = [39, 103, 177]./255;
color1_light  = [117,166,225]./255;
color2_dark = [217,33,59]./255;
color2_light  = [239,149,162]./255;
color3_dark = [80, 178, 69]./255;
color3_light  = [156,214,150]./255;

destination = "D:\IMERI\Project dr. Yetti\Hasil\New Plots\Asymmetry";

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

%% topoplot
load('28chans_EEGchanlocs.mat')
lbl = ["FP1","FP2","F3","F4","C3","C4","P3","P4","O1","O2","F7","F8","T3","T4","T5","T6","Fz","Cz","Pz","Oz","FC1","FC2","CP1","CP2","FC5","FC6","CP5","CP6"];

freqband_1_avg = squeeze(mean(freqband_1,1,"omitnan"));
freqband_2a_avg = squeeze(mean(freqband_2a,1,"omitnan"));
freqband_2b_avg = squeeze(mean(freqband_2b,1,"omitnan"));
freqband = ["Delta", "Theta", "Alpha", "Beta", "Gamma"];

freqband_1_trf = NaN(length(lbl),length(freqband));
freqband_2a_trf = NaN(length(lbl),length(freqband));
freqband_2b_trf = NaN(length(lbl),length(freqband));

for a = 1:length(labels)
    for b = 1:length(lbl)
        if (strcmpi(labels(a),lbl(b)))
            freqband_1_trf(b,:) = freqband_1_avg(a,:);
            freqband_2a_trf(b,:) = freqband_2a_avg(a,:);
            freqband_2b_trf(b,:) = freqband_2b_avg(a,:);
        end
    end
end

for a = 1:length(freqband)
    min_val = min([min(freqband_1_avg(:,a)) min(freqband_2a_avg(:,a)) min(freqband_2b_avg(:,a))]);
    max_val = max([max(freqband_1_avg(:,a)) max(freqband_2a_avg(:,a)) max(freqband_2b_avg(:,a))]);

    subplot(5,3,3*a-2)
    topoplotIndie(freqband_1_trf(:,a),sample_chanlocs)
    colormap(jet)
    clim([min_val max_val])
    c = colorbar;
    c.Label.String = [freqband(a), 'Relative PSD'];
    c.FontSize = 11;
    L=cellfun(@(x)sprintf('%.3f',x),num2cell(get(c,'xtick')),'Un',0);
    set(c,'xticklabel',L)
    set(c,'YTick',[min_val max_val])

    subplot(5,3,3*a-1)
    topoplotIndie(freqband_2a_trf(:,a),sample_chanlocs)
    colormap(hsv)
    clim([min_val max_val])
    c = colorbar;
    c.Label.String = [freqband(a), 'Relative PSD'];
    c.FontSize = 11;
    L=cellfun(@(x)sprintf('%.3f',x),num2cell(get(c,'xtick')),'Un',0);
    set(c,'xticklabel',L)
    set(c,'YTick',[min_val max_val])

    subplot(5,3,3*a)
    topoplotIndie(freqband_2b_trf(:,a),sample_chanlocs)
    colormap(hsv)
    clim([min_val max_val])
    c = colorbar;
    c.Label.String = [freqband(a), 'Relative PSD'];
    c.FontSize = 11;
    L=cellfun(@(x)sprintf('%.3f',x),num2cell(get(c,'xtick')),'Un',0);
    set(c,'xticklabel',L)
    set(c,'YTick',[min_val max_val])
end

%% asymmetry
% fp1_fp2 
asym_fp1fp2_1 = squeeze((freqband_1(:,2,:) - freqband_1(:,1,:))./(freqband_1(:,2,:) + freqband_1(:,1,:)));
asym_fp1fp2_2a = squeeze((freqband_2a(:,2,:) - freqband_2a(:,1,:))./(freqband_2a(:,2,:) + freqband_2a(:,1,:)));
asym_fp1fp2_2b = squeeze((freqband_2b(:,2,:) - freqband_2b(:,1,:))./(freqband_2b(:,2,:) + freqband_2b(:,1,:)));

% f3_f4
asym_f3f4_1 = squeeze((freqband_1(:,6,:) - freqband_1(:,4,:))./(freqband_1(:,6,:) + freqband_1(:,4,:)));
asym_f3f4_2a = squeeze((freqband_2a(:,6,:) - freqband_2a(:,4,:))./(freqband_2a(:,6,:) + freqband_2a(:,4,:)));
asym_f3f4_2b = squeeze((freqband_2b(:,6,:) - freqband_2b(:,4,:))./(freqband_2b(:,6,:) + freqband_2b(:,4,:)));

% f7_f8
asym_f7f8_1 = squeeze((freqband_1(:,7,:) - freqband_1(:,3,:))./(freqband_1(:,7,:) + freqband_1(:,3,:)));
asym_f7f8_2a = squeeze((freqband_2a(:,7,:) - freqband_2a(:,3,:))./(freqband_2a(:,7,:) + freqband_2a(:,3,:)));
asym_f7f8_2b = squeeze((freqband_2b(:,7,:) - freqband_2b(:,3,:))./(freqband_2b(:,7,:) + freqband_2b(:,3,:)));

% t3_t4
asym_t3t4_1 = squeeze((freqband_1(:,11,:) - freqband_1(:,8,:))./(freqband_1(:,11,:) + freqband_1(:,8,:)));
asym_t3t4_2a = squeeze((freqband_2a(:,11,:) - freqband_2a(:,8,:))./(freqband_2a(:,11,:) + freqband_2a(:,8,:)));
asym_t3t4_2b = squeeze((freqband_2b(:,11,:) - freqband_2b(:,8,:))./(freqband_2b(:,11,:) + freqband_2b(:,8,:)));

% t5_t6
asym_t5t6_1 = squeeze((freqband_1(:,16,:) - freqband_1(:,12,:))./(freqband_1(:,16,:) + freqband_1(:,12,:)));
asym_t5t6_2a = squeeze((freqband_2a(:,16,:) - freqband_2a(:,12,:))./(freqband_2a(:,16,:) + freqband_2a(:,12,:)));
asym_t5t6_2b = squeeze((freqband_2b(:,16,:) - freqband_2b(:,12,:))./(freqband_2b(:,16,:) + freqband_2b(:,12,:)));

% c3_c4
asym_c3c4_1 = squeeze((freqband_1(:,10,:) - freqband_1(:,9,:))./(freqband_1(:,10,:) + freqband_1(:,9,:)));
asym_c3c4_2a = squeeze((freqband_2a(:,10,:) - freqband_2a(:,9,:))./(freqband_2a(:,10,:) + freqband_2a(:,9,:)));
asym_c3c4_2b = squeeze((freqband_2b(:,10,:) - freqband_2b(:,9,:))./(freqband_2b(:,10,:) + freqband_2b(:,9,:)));

% p3_p4
asym_p3p4_1 = squeeze((freqband_1(:,15,:) - freqband_1(:,13,:))./(freqband_1(:,15,:) + freqband_1(:,13,:)));
asym_p3p4_2a = squeeze((freqband_2a(:,15,:) - freqband_2a(:,13,:))./(freqband_2a(:,15,:) + freqband_2a(:,13,:)));
asym_p3p4_2b = squeeze((freqband_2b(:,15,:) - freqband_2b(:,13,:))./(freqband_2b(:,15,:) + freqband_2b(:,13,:)));

% o1_o2
asym_o1o2_1 = squeeze((freqband_1(:,18,:) - freqband_1(:,17,:))./(freqband_1(:,18,:) + freqband_1(:,17,:)));
asym_o1o2_2a = squeeze((freqband_2a(:,18,:) - freqband_2a(:,17,:))./(freqband_2a(:,18,:) + freqband_2a(:,17,:)));
asym_o1o2_2b = squeeze((freqband_2b(:,18,:) - freqband_2b(:,17,:))./(freqband_2b(:,18,:) + freqband_2b(:,17,:)));

asym_1 = NaN([8,size(asym_fp1fp2_1)]);
asym_2a = NaN([8,size(asym_fp1fp2_2a)]);
asym_2b = NaN([8,size(asym_fp1fp2_2b)]);

asym_1(1,:,:) = asym_fp1fp2_1;
asym_2a(1,:,:) = asym_fp1fp2_2a;
asym_2b(1,:,:) = asym_fp1fp2_2b;

asym_1(2,:,:) = asym_f3f4_1;
asym_2a(2,:,:) = asym_f3f4_2a;
asym_2b(2,:,:) = asym_f3f4_2b;

asym_1(3,:,:) = asym_f7f8_1;
asym_2a(3,:,:) = asym_f7f8_2a;
asym_2b(3,:,:) = asym_f7f8_2b;

asym_1(4,:,:) = asym_t3t4_1;
asym_2a(4,:,:) = asym_t3t4_2a;
asym_2b(4,:,:) = asym_t3t4_2b;

asym_1(5,:,:) = asym_t5t6_1;
asym_2a(5,:,:) = asym_t5t6_2a;
asym_2b(5,:,:) = asym_t5t6_2b;

asym_1(6,:,:) = asym_c3c4_1;
asym_2a(6,:,:) = asym_c3c4_2a;
asym_2b(6,:,:) = asym_c3c4_2b;

asym_1(7,:,:) = asym_p3p4_1;
asym_2a(7,:,:) = asym_p3p4_2a;
asym_2b(7,:,:) = asym_p3p4_2b;

asym_1(8,:,:) = asym_o1o2_1;
asym_2a(8,:,:) = asym_o1o2_2a;
asym_2b(8,:,:) = asym_o1o2_2b;

asym_2 = [asym_2a,asym_2b];
assym_label = ["FP1 & FP2 Asymmetry","F3 & F4 Asymmetry","F7 & F8 Asymmetry","T3 & T4 Asymmetry","T5 & T6 Asymmetry","C3 & C4 Asymmetry","P3 & P4 Asymmetry","O1 & O2 Asymmetry"];


%% horizontal bar plot
for a = 1:8
    fig = figure(a);
    y1 = [mean(squeeze(asym_2a(a,:,:))',2,'omitnan')];
    y2 = [mean(squeeze(asym_2b(a,:,:))',2,'omitnan')];
    y = [y1,y2];
    
    b = barh(y,'grouped')
    b(1).FaceColor = color2_dark;
    b(2).FaceColor = color3_dark;
    
    set(gca, 'YTickLabel',{'Delta','Theta','Alpha','Beta','Gamma'}, 'FontSize', 20)
    set(gca,'xlim',[-0.3 0.3])
    set(gca,'Ydir','reverse')
    xticks([-0.3 -0.2 -0.1 0 0.1 0.2 0.3]); 
    xticklabels({'-0.3', '-0.2', '-0.1', '0', '0.1', '0.2', '0.3'});
    set(gca,'FontSize', 20)
    title(assym_label(a), 'FontSize', 20);
    
    % Error bar
    err1 = std(squeeze(asym_2a(a,:,:))',[],2,'omitnan')/sqrt(length(squeeze(asym_2a(a,:,:))'));
    err2 = std(squeeze(asym_2b(a,:,:))',[],2,'omitnan')/sqrt(length(squeeze(asym_2b(a,:,:))'));
    err = [err1,err2];
    
    hold on
    [ngroups,nbars] = size(y); % Calculate the number of groups and number of bars in each group
    
    x = nan(nbars, ngroups);
    for i = 1:nbars
        x(i,:) = b(i).XEndPoints;
    end
    
    errorbar(y,x',err,'k','horizontal','linestyle','none', 'HandleVisibility','off');
    hold off
  
    % % save pic
    % temp=[char(destination),filesep,'BarPlotLCCompar_',char(assym_label(a)),'.png'];
    % saveas(gca,temp);
    % close(fig)
end 

%% ranksum cov vs. longcov
p_ranksum1 = NaN(5,8);
for freqsel = 1:size(p_ranksum1,1)
    for pairsel = 1:size(p_ranksum1,2)
        p_ranksum1(freqsel,pairsel) = ranksum(squeeze(asym_1(pairsel,freqsel,:)),squeeze(asym_2(pairsel,freqsel,:)));
    end
end

%% ranksum cov vs. longcov + fdr
[~, ~, ~, p_ranksum1_fdr] = fdr_bh(p_ranksum1);

%% ranksum longcov 1 vs. longcov 2
p_ranksum2 = NaN(5,8);
for freqsel = 1:size(p_ranksum2,1)
    for pairsel = 1:size(p_ranksum2,2)
        p_ranksum2(freqsel,pairsel) = ranksum(squeeze(asym_2a(pairsel,freqsel,:)),squeeze(asym_2b(pairsel,freqsel,:)));
    end
end

%% ranksum longcov 1 vs. longcov 2 + fdr
[~, ~, ~, p_ranksum2_fdr] = fdr_bh(p_ranksum2);

%% save tables
freq_label = ["Delta","Theta","Alpha","Beta","Gamma"];

% table 1: pval ranksum cov vs. longcov (8-electrode pairs row x 5-freqband column)
table = array2table(p_ranksum1');
table.Properties.VariableNames = freq_label;
writetable(table,destination+"\P_RanksumCovLongcov.xlsx",'Range','B1')
table = array2table(erase(assym_label," Asymmetry")');
writetable(table,destination+"\P_RanksumCovLongcov.xlsx",'Range','A2', 'WriteVariableNames', false)

% table 2: pval ranksum cov vs. longcov fdr (8-electrode pairs row x 5-freqband column)
table = array2table(p_ranksum1_fdr');
table.Properties.VariableNames = freq_label;
writetable(table,destination+"\P_RanksumCovLongcovFDR.xlsx",'Range','B1')
table = array2table(erase(assym_label," Asymmetry")');
writetable(table,destination+"\P_RanksumCovLongcovFDR.xlsx",'Range','A2', 'WriteVariableNames', false)

% table 3: pval ranksum longcov < 50 vs. longcov >= 50 (8-electrode pairs row x 5-freqband column)
table = array2table(p_ranksum2');
table.Properties.VariableNames = freq_label;
writetable(table,destination+"\P_RanksumLongcov50.xlsx",'Range','B1')
table = array2table(erase(assym_label," Asymmetry")');
writetable(table,destination+"\P_RanksumLongcov50.xlsx",'Range','A2', 'WriteVariableNames', false)

% table 4: pval ranksum longcov < 50 vs. longcov >= 50 fdr (8-electrode pairs row x 5-freqband column)
table = array2table(p_ranksum2_fdr');
table.Properties.VariableNames = freq_label;
writetable(table,destination+"\P_RanksumLongcov50FDR.xlsx",'Range','B1')
table = array2table(erase(assym_label," Asymmetry")');
writetable(table,destination+"\P_RanksumLongcov50FDR.xlsx",'Range','A2', 'WriteVariableNames', false)