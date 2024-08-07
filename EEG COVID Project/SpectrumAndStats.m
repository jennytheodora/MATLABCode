%% Spectrum & statistics
    
% load data
clear all
clc

% load('pre_vs_post_psd.mat')
load('cov_vs_noncov_psd_revised.mat')

data_1 = noncov;
data_2 = cov;

legend_1 = "Non-COVID";
legend_2 = "COVID";

line_color_1 = [43 72 166]./255;
sem_color_1  = [185 220 255]./255;
line_color_2 = [166 43 43]./255;
sem_color_2  = [255 208 208]./255;

% biru abu [120 123 146], shade [184 188 199]
% merah abu [146 138 138], shade [198 183 183]
% biru [43 72 166], shade [185 220 255]
% merah [166 43 43], shade [255 208 208]

destination='D:\IMERI\Project dr. Winnu\Hasil\Revised\Spectrum';

%% spectrum plot per individual
for chansel = 1:size(data_1,2)
    figure(chansel)
    
    maxval_1 = max(max(squeeze(data_1(:,chansel,:))));
    maxval_2 = max(max(squeeze(data_2(:,chansel,:))));
    maxval = max(maxval_1,maxval_2);
    
    subplot(1,2,1)
    for sbj_sel = 1:size(data_1,1)
        p_1 = plot(freq,squeeze(data_1(sbj_sel,chansel,:)));
        p_1.LineWidth = 1.5;
%         p_1.Color = line_color_1;
        title(legend_1)
        hold on
    end
    ylim([0 maxval*1.05])
    xlim([0 45])
    
    subplot(1,2,2)
    for sbj_sel = 1:size(data_2,1)
        p_2 = plot(freq,squeeze(data_2(sbj_sel,chansel,:)));
        p_2.LineWidth = 1.5;
%         p_2.Color = line_color_2;
        title(legend_2)
        hold on
    end
    ylim([0 maxval*1.05])
    xlim([0 40])
    
    sgtitle(labels(chansel))
end

%% spectrum plot 
foi = [0 40];

for chansel = 1:length(labels)
    fig = figure(chansel);
    options.handle=figure(chansel);
    options.color_area = sem_color_1;
    options.color_line = line_color_1;

    options.alpha = 0.5;
    options.line_width = 2;
    options.error = 'sem';
    options.x_axis = freq(find(freq == foi(1),1):find(freq == foi(2),1));
    grandmean = rmmissing(squeeze(data_1(:,chansel,find(freq == foi(1),1):find(freq == foi(2),1))));
%     grandmean = rmmissing(squeeze(log10(data_1(:,chansel,find(freq == foi(1),1):find(freq == foi(2),1)))));
    plot_areaerrorbar(grandmean,options);
    
    hold on
    
    options.color_area = sem_color_2; 
    options.color_line = line_color_2;

    options.alpha = 0.5;
    options.line_width = 2;
    options.error = 'sem';
    options.x_axis = freq(find(freq == foi(1),1):find(freq == foi(2),1));
    grandmean = rmmissing(squeeze(data_2(:,chansel,find(freq == foi(1),1):find(freq == foi(2),1))));
%     grandmean = rmmissing(log10(squeeze(data_2(:,chansel,find(freq == foi(1),1):find(freq == foi(2),1)))));
    plot_areaerrorbar(grandmean,options);

    title(labels(chansel),'FontSize',18)
    xlabel("Frequency (Hz)",'FontSize',18);ylabel("Normalized PSD",'FontSize',18)
    % xlabel("Frequency (Hz)",'FontSize',18);ylabel("PSD Difference",'FontSize',18)
    % legend({'', legend_1, '', legend_2},'location','northeast','FontSize',13)
    
    xlim(foi)
    % ylim([-0.06 0.06])
%     maxval_1 = max(max(squeeze(mean(data_1,1,'omitnan'))));
%     maxval_2 = max(max(squeeze(mean(data_2,1,'omitnan'))));
%     maxval = max([maxval_1 maxval_2]);
%     ylim([0 maxval*1.3])
    
    ax = gca;
    ax.XAxis.FontSize = 17;
    ax.YAxis.FontSize = 17;
    
    xline(4,'--',{'Delta'},'LabelHorizontalAlignment','left','HandleVisibility','off', 'FontSize', 15);
    xline(8,'--',{'Theta'},'LabelHorizontalAlignment','left','HandleVisibility','off', 'FontSize', 15);
    xline(12,'--',{'Alpha'},'LabelHorizontalAlignment','left','HandleVisibility','off', 'FontSize', 15);
    xline(30,'--',{'Beta'},'LabelHorizontalAlignment','left','HandleVisibility','off', 'FontSize', 15);
    xline(40,'--',{'Gamma'},'LabelHorizontalAlignment','left','HandleVisibility','off', 'FontSize', 15);

    % save pic
    temp=[destination,filesep,'spectrum_',num2str(chansel),'.png'];
    saveas(gca,temp);
    close(fig)
end

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

%% ttest 
for a = 1:size(freqband_1,2)
    for b = 1:size(freqband_1,3)
        nt_1 = normalitytest(freqband_1(:,a,b)');
        sprwlk_1(a,b) = nt_1(7,3);
        nt_2 = normalitytest(freqband_2(:,a,b)');
        sprwlk_2(a,b) = nt_2(7,3);
        [h,pval(a,b)] = ttest2(squeeze(freqband_1(:,a,b)), squeeze(freqband_2(:,a,b)));
        [h,pval2(a,b)] = ttest2(squeeze(freqband_1(:,a,b)), zeros(5,1));
        [h,pval3(a,b)] = ttest2(zeros(4,1), squeeze(freqband_2(:,a,b)));
    end
end

freqband = ["Delta", "Theta", "Alpha", "Beta", "Gamma"];
table = array2table(pval);
table.Properties.RowNames = labels;
table.Properties.VariableNames = freqband;
% table = table(table,'VariableNames',{'My Table'}); % Nested table
disp(table)

%% save ttest table to excel
filename = 'T-test.xlsx';
writetable(table,filename,'Sheet',5,'Range','B1')

%% bar plot 
for chansel = 1:length(labels)
    fig = figure(chansel);

    mean_1 = squeeze(mean(freqband_1,1,"omitnan"));
    mean_2 = squeeze(mean(freqband_2,1,"omitnan"));

    y = [mean_1(chansel,1), mean_2(chansel,1);
        mean_1(chansel,2), mean_2(chansel,2);
        mean_1(chansel,3), mean_2(chansel,3);
        mean_1(chansel,4), mean_2(chansel,4);
        mean_1(chansel,5), mean_2(chansel,5)];

    b = bar(y);
    set(gca, 'XTickLabel',{'Delta','Theta','Alpha','Beta','Gamma'}, 'FontSize', 18)
    ylabel("PSD","FontSize", 18);
    % ylabel("PSD Difference","FontSize", 18);
    title(labels(chansel))

    b(1).FaceColor = line_color_1;
    b(2).FaceColor = line_color_2;
    
    ax = gca;
    ax.XAxis.FontSize = 17;

%     legend(legend_1, legend_2 ,'FontSize',14)

    % Error bar
    err1 = squeeze(std(freqband_1(:,chansel,:),[],1,'omitnan')/sqrt(length(freqband_1(:,chansel,:))));
    err2 = squeeze(std(freqband_2(:,chansel,:),[],1,'omitnan')/sqrt(length(freqband_2(:,chansel,:))));

    err = [err1,err2];
    ylim([0 max(max(err))+max(max(y))*1.25]); % pengali = berapa besar space di atas
    % ylim([-0.035 0.035])

    hold on
    [ngroups,nbars] = size(y); % Calculate the number of groups and number of bars in each group

    x = nan(nbars, ngroups);
    for i = 1:nbars
        x(i,:) = b(i).XEndPoints;
    end

    errorbar(x',y,err,'k','linestyle','none', 'HandleVisibility','off','LineWidth',1);
    hold off

    % save pic
    temp=[destination,filesep,'BP_prepostdiff',num2str(chansel),'.png'];
    saveas(gca,temp);
    close(fig)
end

%% violin plot (alternative plot)
% Y=[rand(1000,1),gamrnd(1,2,1000,1),normrnd(10,2,1000,1),gamrnd(10,0.1,1000,1)];
Y = [squeeze(freqband_1(:,1,1)),squeeze(freqband_2(:,1,1))];
violin(Y,'xlabel',{'Low','Moderate'},'facecolor',[line_color_1;line_color_2],'edgecolor','k',...
'mc','k','medc',[])
legend([])
