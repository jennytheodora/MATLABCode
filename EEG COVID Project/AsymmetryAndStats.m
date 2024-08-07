%% Hemispheric asymmetry and statistics
clear all
clc

% load data
% load('pre_vs_post_psd.mat')
load('cov_vs_noncov_psd_revised.mat')

data_1 = noncov;
data_2 = cov;

legend_1 = "Non-COVID";
legend_2 = "COVID";

line_color_1 = [43 72 166]./255;
line_color_2 = [166 43 43]./255;

% biru abu [120 123 146], shade [184 188 199]
% merah abu [146 138 138], shade [198 183 183]
% biru [43 72 166], shade [185 220 255]
% merah [166 43 43], shade [255 208 208]

destination='D:\IMERI\Project dr. Winnu\Hasil\Revised\Asymmetry';

%% divide into frequency
clearvars -except data_1 data_2 freq labels destination legend_1 legend_2 line_color_1 line_color_2

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

%% topoplot
load('28chans_EEGchanlocs.mat')
lbl = ["FP1","FP2","F3","F4","C3","C4","P3","P4","O1","O2","F7","F8","T3","T4","T5","T6","Fz","Cz","Pz","Oz","FC1","FC2","CP1","CP2","FC5","FC6","CP5","CP6"];

freqband_1_avg = squeeze(mean(freqband_1,1,"omitnan"));
freqband_2_avg = squeeze(mean(freqband_2,1,"omitnan"));
freqband = ["Delta", "Theta", "Alpha", "Beta", "Gamma"];

freqband_1_trf = NaN(length(lbl),length(freqband));
freqband_2_trf = NaN(length(lbl),length(freqband));

for a = 1:length(labels)
    for b = 1:length(lbl)
        if (strcmpi(labels(a),lbl(b)))
            freqband_1_trf(b,:) = freqband_1_avg(a,:);
            freqband_2_trf(b,:) = freqband_2_avg(a,:);
        end
    end
end

for a = 1:length(freqband)
    min_val = min([min(freqband_1_avg(:,a)) min(freqband_2_avg(:,a))]);
    max_val = max([max(freqband_1_avg(:,a)) max(freqband_2_avg(:,a))]);

    subplot(5,2,2*a-1)
    topoplotIndie(freqband_1_trf(:,a),sample_chanlocs)
    colormap(jet)
    clim([min_val max_val])
    c = colorbar;
    c.Label.String = [freqband(a), 'PSD'];
    c.FontSize = 11;
    L=cellfun(@(x)sprintf('%.3f',x),num2cell(get(c,'xtick')),'Un',0);
    set(c,'xticklabel',L)
    set(c,'YTick',[min_val max_val])

    subplot(5,2,2*a)
    topoplotIndie(freqband_2_trf(:,a),sample_chanlocs)
    colormap(jet)
    clim([min_val max_val])
    c = colorbar;
    c.Label.String = [freqband(a), 'PSD'];
    c.FontSize = 11;
    L=cellfun(@(x)sprintf('%.3f',x),num2cell(get(c,'xtick')),'Un',0);
    set(c,'xticklabel',L)
    set(c,'YTick',[min_val max_val])
end

%% asymmetry
% fp1_fp2 
asym_fp1fp2_1 = squeeze((freqband_1(:,2,:) - freqband_1(:,1,:))./(freqband_1(:,2,:) + freqband_1(:,1,:)));
asym_fp1fp2_2 = squeeze((freqband_2(:,2,:) - freqband_2(:,1,:))./(freqband_2(:,2,:) + freqband_2(:,1,:)));

% f3_f4
asym_f3f4_1 = squeeze((freqband_1(:,4,:) - freqband_1(:,3,:))./(freqband_1(:,4,:) + freqband_1(:,3,:)));
asym_f3f4_2 = squeeze((freqband_2(:,4,:) - freqband_2(:,3,:))./(freqband_2(:,4,:) + freqband_2(:,3,:)));

% f7_f8
asym_f7f8_1 = squeeze((freqband_1(:,6,:) - freqband_1(:,5,:))./(freqband_1(:,6,:) + freqband_1(:,5,:)));
asym_f7f8_2 = squeeze((freqband_2(:,6,:) - freqband_2(:,5,:))./(freqband_2(:,6,:) + freqband_2(:,5,:)));

% t3_t4
asym_t3t4_1 = squeeze((freqband_1(:,9,:) - freqband_1(:,8,:))./(freqband_1(:,9,:) + freqband_1(:,8,:)));
asym_t3t4_2 = squeeze((freqband_2(:,9,:) - freqband_2(:,8,:))./(freqband_2(:,9,:) + freqband_2(:,8,:)));

% t5_t6
asym_t5t6_1 = squeeze((freqband_1(:,11,:) - freqband_1(:,10,:))./(freqband_1(:,11,:) + freqband_1(:,10,:)));
asym_t5t6_2 = squeeze((freqband_2(:,11,:) - freqband_2(:,10,:))./(freqband_2(:,11,:) + freqband_2(:,10,:)));

% c3_c4
asym_c3c4_1 = squeeze((freqband_1(:,13,:) - freqband_1(:,12,:))./(freqband_1(:,13,:) + freqband_1(:,12,:)));
asym_c3c4_2 = squeeze((freqband_2(:,13,:) - freqband_2(:,12,:))./(freqband_2(:,13,:) + freqband_2(:,12,:)));

% p3_p4
asym_p3p4_1 = squeeze((freqband_1(:,15,:) - freqband_1(:,14,:))./(freqband_1(:,15,:) + freqband_1(:,14,:)));
asym_p3p4_2 = squeeze((freqband_2(:,15,:) - freqband_2(:,14,:))./(freqband_2(:,15,:) + freqband_2(:,14,:)));

% o1_o2
asym_o1o2_1 = squeeze((freqband_1(:,18,:) - freqband_1(:,17,:))./(freqband_1(:,18,:) + freqband_1(:,17,:)));
asym_o1o2_2 = squeeze((freqband_2(:,18,:) - freqband_2(:,17,:))./(freqband_2(:,18,:) + freqband_2(:,17,:)));


%% ttest 
for a = 1:size(asym_fp1fp2_1,2)
    [h,pval_fp1fp2(a)] = ttest2(squeeze(asym_fp1fp2_1(:,a)), squeeze(asym_fp1fp2_2(:,a)));
    [h,pval_f3f4(a)] = ttest2(squeeze(asym_f3f4_1(:,a)), squeeze(asym_f3f4_2(:,a)));
    [h,pval_f7f8(a)] = ttest2(squeeze(asym_f7f8_1(:,a)), squeeze(asym_f7f8_2(:,a)));
    [h,pval_t3t4(a)] = ttest2(squeeze(asym_t3t4_1(:,a)), squeeze(asym_t3t4_2(:,a)));
    [h,pval_t5t6(a)] = ttest2(squeeze(asym_t5t6_1(:,a)), squeeze(asym_t5t6_2(:,a)));
    [h,pval_c3c4(a)] = ttest2(squeeze(asym_c3c4_1(:,a)), squeeze(asym_c3c4_2(:,a)));
    [h,pval_p3p4(a)] = ttest2(squeeze(asym_p3p4_1(:,a)), squeeze(asym_p3p4_2(:,a)));
    [h,pval_o1o2(a)] = ttest2(squeeze(asym_o1o2_1(:,a)), squeeze(asym_o1o2_2(:,a)));
end

%ttest table 
freqband = ["Delta", "Theta", "Alpha", "Beta", "Gamma"];
table = array2table([pval_fp1fp2',pval_f3f4',pval_f7f8',pval_t3t4',pval_t5t6',pval_c3c4',pval_p3p4',pval_o1o2']);
table.Properties.RowNames = freqband;
% table.Properties.VariableNames = ["FP1 - FP2 Asymmetry","F3 - F4 Asymmetry","F7 - F8 Asymmetry"];
% table = table(table,'VariableNames',{'FP1 - FP2 Asymmetry'}); % Nested table
disp(table)

%% ttest (each assym vs zeros)
for a = 1:length(freqband)
    [h,pval_fp1fp2_1(a)] = ttest2(squeeze(asym_fp1fp2_1(:,a)), zeros(size(squeeze(asym_fp1fp2_1(:,a)))));
    [h,pval_f3f4_1(a)] = ttest2(squeeze(asym_f3f4_1(:,a)), zeros(size(squeeze(asym_f3f4_1(:,a)))));
    [h,pval_f7f8_1(a)] = ttest2(squeeze(asym_f7f8_1(:,a)), zeros(size(squeeze(asym_f7f8_1(:,a)))));
    [h,pval_t3t4_1(a)] = ttest2(squeeze(asym_t3t4_1(:,a)), zeros(size(squeeze(asym_t3t4_1(:,a)))));
    [h,pval_t5t6_1(a)] = ttest2(squeeze(asym_t5t6_1(:,a)), zeros(size(squeeze(asym_t5t6_1(:,a)))));
    [h,pval_c3c4_1(a)] = ttest2(squeeze(asym_c3c4_1(:,a)), zeros(size(squeeze(asym_c3c4_1(:,a)))));
    [h,pval_p3p4_1(a)] = ttest2(squeeze(asym_p3p4_1(:,a)), zeros(size(squeeze(asym_p3p4_1(:,a)))));
    [h,pval_o1o2_1(a)] = ttest2(squeeze(asym_o1o2_1(:,a)), zeros(size(squeeze(asym_o1o2_1(:,a)))));

    [h,pval_fp1fp2_2(a)] = ttest2(squeeze(asym_fp1fp2_2(:,a)), zeros(size(squeeze(asym_fp1fp2_2(:,a)))));
    [h,pval_f3f4_2(a)] = ttest2(squeeze(asym_f3f4_2(:,a)), zeros(size(squeeze(asym_f3f4_2(:,a)))));
    [h,pval_f7f8_2(a)] = ttest2(squeeze(asym_f7f8_2(:,a)), zeros(size(squeeze(asym_f7f8_2(:,a)))));
    [h,pval_t3t4_2(a)] = ttest2(squeeze(asym_t3t4_2(:,a)), zeros(size(squeeze(asym_t3t4_2(:,a)))));
    [h,pval_t5t6_2(a)] = ttest2(squeeze(asym_t5t6_2(:,a)), zeros(size(squeeze(asym_t5t6_2(:,a)))));
    [h,pval_c3c4_2(a)] = ttest2(squeeze(asym_c3c4_2(:,a)), zeros(size(squeeze(asym_c3c4_2(:,a)))));
    [h,pval_p3p4_2(a)] = ttest2(squeeze(asym_p3p4_2(:,a)), zeros(size(squeeze(asym_p3p4_2(:,a)))));
    [h,pval_o1o2_2(a)] = ttest2(squeeze(asym_o1o2_2(:,a)), zeros(size(squeeze(asym_o1o2_2(:,a)))));
end

%ttest table 
freqband = ["Delta", "Theta", "Alpha", "Beta", "Gamma"];
table1 = array2table([pval_fp1fp2_1',pval_f3f4_1',pval_f7f8_1',pval_t3t4_1',pval_t5t6_1',pval_c3c4_1',pval_p3p4_1',pval_o1o2_1']);
table1.Properties.RowNames = freqband;
% table1.Properties.VariableNames = ["Low: FP1 - FP2 Asymmetry","Low: F3 - F4 Asymmetry","Low: F7 - F8 Asymmetry"];
% table = table(table,'VariableNames',{'FP1 - FP2 Asymmetry'}); % Nested table
disp(table1)

freqband = ["Delta", "Theta", "Alpha", "Beta", "Gamma"];
table2 = array2table([pval_fp1fp2_2',pval_f3f4_2',pval_f7f8_2',pval_t3t4_2',pval_t5t6_2',pval_c3c4_2',pval_p3p4_2',pval_o1o2_2']);
table2.Properties.RowNames = freqband;
% table2.Properties.VariableNames = ["Mod: FP1 - FP2 Asymmetry","Mod: F3 - F4 Asymmetry","Mod: F7 - F8 Asymmetry"];
% table = table(table,'VariableNames',{'FP1 - FP2 Asymmetry'}); % Nested table
disp(table2)

%% save ttest table to excel
filename = 'T-test Asymmetry.xlsx';
writetable(table,filename,'Sheet',1,'Range','B1')
writetable(table1,filename,'Sheet',2,'Range','B1')
writetable(table2,filename,'Sheet',3,'Range','B1')

%% horizontal bar plot
asym_fp1fp2_1 = asym_fp1fp2_1';
asym_fp1fp2_2 = asym_fp1fp2_2';
asym_f3f4_1 = asym_f3f4_1';
asym_f3f4_2 = asym_f3f4_2';
asym_f7f8_1 = asym_f7f8_1';
asym_f7f8_2 = asym_f7f8_2';
asym_t3t4_1 = asym_t3t4_1';
asym_t3t4_2 = asym_t3t4_2';
asym_t5t6_1 = asym_t5t6_1';
asym_t5t6_2 = asym_t5t6_2';
asym_c3c4_1 = asym_c3c4_1';
asym_c3c4_2 = asym_c3c4_2';
asym_p3p4_1 = asym_p3p4_1';
asym_p3p4_2 = asym_p3p4_2';
asym_o1o2_1 = asym_o1o2_1';
asym_o1o2_2 = asym_o1o2_2';


% FP1 & FP2
fig = figure(1);
y1 = [mean(asym_fp1fp2_1,2,'omitnan')];
y2 = [mean(asym_fp1fp2_2,2,'omitnan')];
y = [y1,y2];

b = barh(y,'grouped')
b(1).FaceColor = line_color_1;
b(2).FaceColor = line_color_2;

set(gca, 'YTickLabel',{'Delta','Theta','Alpha','Beta','Gamma'}, 'FontSize', 25)
set(gca,'xlim',[-0.2 0.2])
set(gca,'Ydir','reverse')
xticks([-0.2 -0.15 -0.1 -0.05 0 0.05 0.1 0.15 0.2]);
xticklabels({'-0.2', '-0.15', '-0.1', '-0.05', '0', '0.05', '0.1', '0.15', '0.2'});
xlabel("Laterality Value")
set(gca,'FontSize', 20)
title("FP1 & FP2 Asymmetry", 'FontSize', 25);

% Error bar
err1 = std(asym_fp1fp2_1,[],2,'omitnan')/sqrt(length(asym_fp1fp2_1));
err2 = std(asym_fp1fp2_2,[],2,'omitnan')/sqrt(length(asym_fp1fp2_2));
err = [err1,err2];

hold on
[ngroups,nbars] = size(y); % Calculate the number of groups and number of bars in each group

x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end

errorbar(y,x',err,'k','horizontal','linestyle','none', 'HandleVisibility','off');
hold off

temp=[destination,filesep,'BP_fp1fp2.png'];
saveas(gca,temp);
close(fig)

% F3 & F4
fig = figure(2)
y1 = [mean(asym_f3f4_1,2,'omitnan')];
y2 = [mean(asym_f3f4_2,2,'omitnan')];
y = [y1,y2];

b = barh(y,'grouped')
b(1).FaceColor = line_color_1;
b(2).FaceColor = line_color_2;

set(gca, 'YTickLabel',{'Delta','Theta','Alpha','Beta','Gamma'}, 'FontSize', 25)
set(gca,'xlim',[-0.2 0.2])
set(gca,'Ydir','reverse')
xticks([-0.2 -0.15 -0.1 -0.05 0 0.05 0.1 0.15 0.2]);
xticklabels({'-0.2', '-0.15', '-0.1', '-0.05', '0', '0.05', '0.1', '0.15', '0.2'});
xlabel("Laterality Value")
set(gca,'FontSize', 20)
title("F3 & F4 Asymmetry", 'FontSize', 25);

% Error bar
err1 = std(asym_f3f4_1,[],2,'omitnan')/sqrt(length(asym_f3f4_1));
err2 = std(asym_f3f4_2,[],2,'omitnan')/sqrt(length(asym_f3f4_2));
err = [err1,err2];

hold on
[ngroups,nbars] = size(y); % Calculate the number of groups and number of bars in each group

x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end

errorbar(y,x',err,'k','horizontal','linestyle','none', 'HandleVisibility','off');
hold off

temp=[destination,filesep,'BP_f3f4.png'];
saveas(gca,temp);
close(fig)

% F7 & F8
fig = figure(3)
y1 = [mean(asym_f7f8_1,2,'omitnan')];
y2 = [mean(asym_f7f8_2,2,'omitnan')];
y = [y1,y2];

b = barh(y,'grouped')
b(1).FaceColor = line_color_1;
b(2).FaceColor = line_color_2;

set(gca, 'YTickLabel',{'Delta','Theta','Alpha','Beta','Gamma'})
set(gca,'FontSize', 25)
set(gca,'xlim',[-0.2 0.2])
set(gca,'Ydir','reverse')
xticks([-0.2 -0.15 -0.1 -0.05 0 0.05 0.1 0.15 0.2]);
xticklabels({'-0.2', '-0.15', '-0.1', '-0.05', '0', '0.05', '0.1', '0.15', '0.2'});
xlabel("Laterality Value")
set(gca,'FontSize', 20)
title("F7 & F8 Asymmetry", 'FontSize', 25);

% Error bar
err1 = std(asym_f7f8_1,[],2,'omitnan')/sqrt(length(asym_f7f8_1));
err2 = std(asym_f7f8_2,[],2,'omitnan')/sqrt(length(asym_f7f8_2));
err = [err1,err2];

hold on
[ngroups,nbars] = size(y); % Calculate the number of groups and number of bars in each group

x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end

errorbar(y,x',err,'k','horizontal','linestyle','none', 'HandleVisibility','off');
hold off

temp=[destination,filesep,'BP_f7f8.png'];
saveas(gca,temp);
close(fig)

% T3 & T4
fig = figure(4)
data1 = asym_t3t4_1;
data2 = asym_t3t4_2;

y1 = [mean(data1,2,'omitnan')];
y2 = [mean(data2,2,'omitnan')];
y = [y1,y2];

b = barh(y,'grouped')
b(1).FaceColor = line_color_1;
b(2).FaceColor = line_color_2;

set(gca, 'YTickLabel',{'Delta','Theta','Alpha','Beta','Gamma'}, 'FontSize', 25)
set(gca,'xlim',[-0.2 0.2])
set(gca,'Ydir','reverse')
xticks([-0.2 -0.15 -0.1 -0.05 0 0.05 0.1 0.15 0.2]);
xticklabels({'-0.2', '-0.15', '-0.1', '-0.05', '0', '0.05', '0.1', '0.15', '0.2'});
xlabel("Laterality Value")
set(gca,'FontSize', 20)
title("T3 & T4 Asymmetry", 'FontSize', 25);

% Error bar
err1 = std(data1,[],2,'omitnan')/sqrt(length(data1));
err2 = std(data2,[],2,'omitnan')/sqrt(length(data2));
err = [err1,err2];

hold on
[ngroups,nbars] = size(y); % Calculate the number of groups and number of bars in each group

x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end

errorbar(y,x',err,'k','horizontal','linestyle','none', 'HandleVisibility','off');
hold off

temp=[destination,filesep,'BP_t3t4.png'];
saveas(gca,temp);
close(fig)

% T5 & T6
fig = figure(5)
data1 = asym_t5t6_1;
data2 = asym_t5t6_2;

y1 = [mean(data1,2,'omitnan')];
y2 = [mean(data2,2,'omitnan')];
y = [y1,y2];

b = barh(y,'grouped')
b(1).FaceColor = line_color_1;
b(2).FaceColor = line_color_2;

set(gca, 'YTickLabel',{'Delta','Theta','Alpha','Beta','Gamma'}, 'FontSize', 25)
set(gca,'xlim',[-0.2 0.2])
set(gca,'Ydir','reverse')
xticks([-0.2 -0.15 -0.1 -0.05 0 0.05 0.1 0.15 0.2]);
xticklabels({'-0.2', '-0.15', '-0.1', '-0.05', '0', '0.05', '0.1', '0.15', '0.2'});
xlabel("Laterality Value")
set(gca,'FontSize', 20)
title("T5 & T6 Asymmetry", 'FontSize', 25);

% Error bar
err1 = std(data1,[],2,'omitnan')/sqrt(length(data1));
err2 = std(data2,[],2,'omitnan')/sqrt(length(data2));
err = [err1,err2];

hold on
[ngroups,nbars] = size(y); % Calculate the number of groups and number of bars in each group

x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end

errorbar(y,x',err,'k','horizontal','linestyle','none', 'HandleVisibility','off');
hold off

temp=[destination,filesep,'BP_t5t6.png'];
saveas(gca,temp);
close(fig)

% C3 & C4
fig = figure(6)
data1 = asym_c3c4_1;
data2 = asym_c3c4_2;

y1 = [mean(data1,2,'omitnan')];
y2 = [mean(data2,2,'omitnan')];
y = [y1,y2];

b = barh(y,'grouped')
b(1).FaceColor = line_color_1;
b(2).FaceColor = line_color_2;

set(gca, 'YTickLabel',{'Delta','Theta','Alpha','Beta','Gamma'}, 'FontSize', 25)
set(gca,'xlim',[-0.2 0.2])
set(gca,'Ydir','reverse')
xticks([-0.2 -0.15 -0.1 -0.05 0 0.05 0.1 0.15 0.2]);
xticklabels({'-0.2', '-0.15', '-0.1', '-0.05', '0', '0.05', '0.1', '0.15', '0.2'});
xlabel("Laterality Value")
set(gca,'FontSize', 20)
title("C3 & C4 Asymmetry", 'FontSize', 25);

% Error bar
err1 = std(data1,[],2,'omitnan')/sqrt(length(data1));
err2 = std(data2,[],2,'omitnan')/sqrt(length(data2));
err = [err1,err2];

hold on
[ngroups,nbars] = size(y); % Calculate the number of groups and number of bars in each group

x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end

errorbar(y,x',err,'k','horizontal','linestyle','none', 'HandleVisibility','off');
hold off

temp=[destination,filesep,'BP_c3c4.png'];
saveas(gca,temp);
close(fig)

% P3 & P4
fig = figure(7)
data1 = asym_p3p4_1;
data2 = asym_p3p4_2;

y1 = [mean(data1,2,'omitnan')];
y2 = [mean(data2,2,'omitnan')];
y = [y1,y2];

b = barh(y,'grouped')
b(1).FaceColor = line_color_1;
b(2).FaceColor = line_color_2;

set(gca, 'YTickLabel',{'Delta','Theta','Alpha','Beta','Gamma'}, 'FontSize', 25)
set(gca,'xlim',[-0.2 0.2])
set(gca,'Ydir','reverse')
xticks([-0.2 -0.15 -0.1 -0.05 0 0.05 0.1 0.15 0.2]);
xticklabels({'-0.2', '-0.15', '-0.1', '-0.05', '0', '0.05', '0.1', '0.15', '0.2'});
xlabel("Laterality Value")
set(gca,'FontSize', 20)
title("P3 & P4 Asymmetry", 'FontSize', 25);

% Error bar
err1 = std(data1,[],2,'omitnan')/sqrt(length(data1));
err2 = std(data2,[],2,'omitnan')/sqrt(length(data2));
err = [err1,err2];

hold on
[ngroups,nbars] = size(y); % Calculate the number of groups and number of bars in each group

x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end

errorbar(y,x',err,'k','horizontal','linestyle','none', 'HandleVisibility','off');
hold off

temp=[destination,filesep,'BP_p3p4.png'];
saveas(gca,temp);
close(fig)

% O1 & O2
fig = figure(8)
data1 = asym_o1o2_1;
data2 = asym_o1o2_2;

y1 = [mean(data1,2,'omitnan')];
y2 = [mean(data2,2,'omitnan')];
y = [y1,y2];

b = barh(y,'grouped')
b(1).FaceColor = line_color_1;
b(2).FaceColor = line_color_2;

set(gca, 'YTickLabel',{'Delta','Theta','Alpha','Beta','Gamma'}, 'FontSize', 25)
set(gca,'xlim',[-0.2 0.2])
set(gca,'Ydir','reverse')
xticks([-0.2 -0.15 -0.1 -0.05 0 0.05 0.1 0.15 0.2]);
xticklabels({'-0.2', '-0.15', '-0.1', '-0.05', '0', '0.05', '0.1', '0.15', '0.2'});
xlabel("Laterality Value")
set(gca,'FontSize', 20)
title("O1 & O2 Asymmetry", 'FontSize', 25);

% Error bar
err1 = std(data1,[],2,'omitnan')/sqrt(length(data1));
err2 = std(data2,[],2,'omitnan')/sqrt(length(data2));
err = [err1,err2];

hold on
[ngroups,nbars] = size(y); % Calculate the number of groups and number of bars in each group

x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end

errorbar(y,x',err,'k','horizontal','linestyle','none', 'HandleVisibility','off');
hold off

temp=[destination,filesep,'BP_o1o2.png'];
saveas(gca,temp);
close(fig)
