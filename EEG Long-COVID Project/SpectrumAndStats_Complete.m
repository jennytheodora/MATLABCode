clear all
clc

load('psd_50.mat')

%% initialize
% data
data_1 = permute(cell2mat(permute(norm_psd_avg_cov,[3,1,2])),[3,1,2]);
data_2 = permute(cell2mat(permute(norm_psd_avg_longcov1,[3,1,2])),[3,1,2]);
data_3 = permute(cell2mat(permute(norm_psd_avg_longcov2,[3,1,2])),[3,1,2]);

% legend
legend_1 = "COVID";
legend_2 = "Long-COVID (age < 50)";
legend_3 = "Long-COVID (age ≥ 50)";

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

for a = 1:size(data_3,1) % subject
    for b = 1:size(data_3,2) % channels
        delta = squeeze(data_3(a,b,find(freq==delta_freq(1),1):find(freq==delta_freq(2),1)));
        theta = squeeze(data_3(a,b,find(freq==theta_freq(1),1):find(freq==theta_freq(2),1)));
        alpha = squeeze(data_3(a,b,find(freq==alpha_freq(1),1):find(freq==alpha_freq(2),1)));
        beta = squeeze(data_3(a,b,find(freq==beta_freq(1),1):find(freq==beta_freq(2),1)));
        gamma = squeeze(data_3(a,b,find(freq==gamma_freq(1),1):find(freq==gamma_freq(2),1)));

        freqband_3(a,b,:) = [mean(delta),mean(theta),mean(alpha),mean(beta),mean(gamma)];
    end
end

%% spectrum plot
foi = [0 40];

for chansel = 1:length(labels)
    % data 1
    fig = figure(chansel);
    options.handle=figure(chansel);
    options.color_area = color1_light;
    options.color_line = color1_dark;

    options.alpha = 0.5;
    options.line_width = 2;
    options.error = 'sem';
    options.x_axis = freq(find(freq == foi(1),1):find(freq == foi(2),1));
    grandmean = rmmissing(squeeze(data_1(:,chansel,find(freq == foi(1),1):find(freq == foi(2),1))));
    plot_areaerrorbar(grandmean,options);

    hold on

    % data 2
    options.color_area = color2_light; 
    options.color_line = color2_dark;

    options.alpha = 0.5;
    options.line_width = 2;
    options.error = 'sem';
    options.x_axis = freq(find(freq == foi(1),1):find(freq == foi(2),1));
    grandmean = rmmissing(squeeze(data_2(:,chansel,find(freq == foi(1),1):find(freq == foi(2),1))));
    plot_areaerrorbar(grandmean,options);

    hold on

    % data 3
    options.color_area = color3_light; 
    options.color_line = color3_dark;

    options.alpha = 0.5;
    options.line_width = 2;
    options.error = 'sem';
    options.x_axis = freq(find(freq == foi(1),1):find(freq == foi(2),1));
    grandmean = rmmissing(squeeze(data_3(:,chansel,find(freq == foi(1),1):find(freq == foi(2),1))));
    plot_areaerrorbar(grandmean,options);

    % visuals
    title(labels(chansel),'FontSize',18)
    xlabel("Frequency (Hz)",'FontSize',18);ylabel("Relative PSD",'FontSize',18)
    % legend({'', legend_1, '', legend_2, '', legend_3},'location','northeast','FontSize',13)

    xlim(foi)
    % ylim([-0.06 0.06])
    % maxval_1 = max(max(squeeze(mean(data_1,1,'omitnan'))));
    % maxval_2 = max(max(squeeze(mean(data_2,1,'omitnan'))));
    % maxval = max([maxval_1 maxval_2]);
    % ylim([0 maxval*1.3])
    
    ax = gca;
    ax.XAxis.FontSize = 17;
    ax.YAxis.FontSize = 17;
    
    xline(4,'--',{'Delta'},'LabelHorizontalAlignment','left','HandleVisibility','off', 'FontSize', 15);
    xline(8,'--',{'Theta'},'LabelHorizontalAlignment','left','HandleVisibility','off', 'FontSize', 15);
    xline(12,'--',{'Alpha'},'LabelHorizontalAlignment','left','HandleVisibility','off', 'FontSize', 15);
    xline(30,'--',{'Beta'},'LabelHorizontalAlignment','left','HandleVisibility','off', 'FontSize', 15);
    xline(40,'--',{'Gamma'},'LabelHorizontalAlignment','left','HandleVisibility','off', 'FontSize', 15);

    % % save pic
    % temp=[char(destination),filesep,'Spectrum_',char(labels(chansel)),'.png'];
    % saveas(gca,temp);
    % close(fig)
end
%% bar plot
for chansel = 1:length(labels)
    fig = figure(chansel);

    mean_1 = squeeze(mean(freqband_1,1,"omitnan"));
    mean_2 = squeeze(mean(freqband_2,1,"omitnan"));
    mean_3 = squeeze(mean(freqband_3,1,"omitnan"));

    y = [mean_1(chansel,1), mean_2(chansel,1), mean_3(chansel,1);
        mean_1(chansel,2), mean_2(chansel,2), mean_3(chansel,2);
        mean_1(chansel,3), mean_2(chansel,3), mean_3(chansel,3);
        mean_1(chansel,4), mean_2(chansel,4), mean_3(chansel,4);
        mean_1(chansel,5), mean_2(chansel,5), mean_3(chansel,5)];

    b = bar(y);
    set(gca, 'XTickLabel',{'Delta','Theta','Alpha','Beta','Gamma'}, 'FontSize', 18)
    ylabel("Relative PSD","FontSize", 18);
    title(labels(chansel))

    b(1).FaceColor = color1_light;
    b(2).FaceColor = color2_light;
    b(3).FaceColor = color3_light;
    
    ax = gca;
    ax.XAxis.FontSize = 17;

    % legend(legend_1, legend_2, legend_3, 'FontSize',14)

    % Error bar
    err1 = squeeze(std(freqband_1(:,chansel,:),[],1,'omitnan')/sqrt(length(freqband_1(:,chansel,:))));
    err2 = squeeze(std(freqband_2(:,chansel,:),[],1,'omitnan')/sqrt(length(freqband_2(:,chansel,:))));
    err3 = squeeze(std(freqband_3(:,chansel,:),[],1,'omitnan')/sqrt(length(freqband_3(:,chansel,:))));

    err = [err1,err2,err3];
    ylim([0 max(max(err))+max(max(y))*1.1]); % pengali = berapa besar space di atas

    hold on
    [ngroups,nbars] = size(y); % Calculate the number of groups and number of bars in each group

    x = nan(nbars, ngroups);
    for i = 1:nbars
        x(i,:) = b(i).XEndPoints;
    end

    errorbar(x',y,err,'k','linestyle','none', 'HandleVisibility','off','LineWidth',1);
    hold off

    % % save pic
    % temp=[char(destination),filesep,'BarPlot_',char(labels(chansel)),'.png'];
    % saveas(gca,temp);
    % close(fig)
end

%% box plot
% adjust vars to toolbox
adj_data = [freqband_1;freqband_2;freqband_3];
group_inx = [1*ones(1,size(data_1,1)),2*ones(1,size(data_2,1)),3*ones(1,size(data_3,1))];
condition_names = ["Delta","Theta","Alpha","Beta","Gamma"];
group_names = [legend_1,legend_2,legend_3];
c = [color1_light;color2_light;color3_light];

for chansel = 1:length(labels)
    fig = figure(chansel);
    h = daboxplot(squeeze(adj_data(:,chansel,:)),'groups',group_inx,'xtlabels', condition_names,'color',c,'whiskers',0,'scatter',1,'jitter',0,'scattersize',13,'scatteralpha',0.7);
    % h = daboxplot(squeeze(adj_data(:,chansel,:)),'groups',group_inx,'xtlabels', condition_names,'color',c,'whiskers',1);
    set(gca, 'XTickLabel',{'Delta','Theta','Alpha','Beta','Gamma'}, 'FontSize', 18)
    ylabel("Relative PSD","FontSize", 18);
    title(labels(chansel))

    % % save pic
    % temp=[char(destination),filesep,'BoxPlot_',char(labels(chansel)),'.png'];
    % saveas(gca,temp);
    % close(fig)
end

%% one way anova
% https://www.mathworks.com/help/stats/anova1.html
maxdatalength = max([size(freqband_1,1),size(freqband_2,1),size(freqband_3,1)]);
p_anova = NaN(length(labels),5);

for freqsel = 1:5
    for chansel = 1:length(labels)
        % adjust vars to function: 23 (max size) x 3 (groups)
        adj_data = cat(2,[squeeze(freqband_1(:,chansel,freqsel));NaN((maxdatalength-size(freqband_1,1)),1)], ...
            [squeeze(freqband_2(:,chansel,freqsel));NaN((maxdatalength-size(freqband_2,1)),1)], ...
            [squeeze(freqband_3(:,chansel,freqsel));NaN((maxdatalength-size(freqband_3,1)),1)]);
        p_anova(chansel,freqsel) = anova1(adj_data,[],'off');
    end
end

%% one way anova with fdr
[~, ~, ~, p_anova_fdr] = fdr_bh(p_anova);

%% kruskal wallis
% https://www.mathworks.com/help/stats/kruskalwallis.html
maxdatalength = max([size(freqband_1,1),size(freqband_2,1),size(freqband_3,1)]);
p_kruskalwallis = NaN(length(labels),5);

for freqsel = 1:5
    for chansel = 1:length(labels)
        % adjust vars to function: 23 (max size) x 3 (groups)
        adj_data = cat(2,[squeeze(freqband_1(:,chansel,freqsel));NaN((maxdatalength-size(freqband_1,1)),1)], ...
            [squeeze(freqband_2(:,chansel,freqsel));NaN((maxdatalength-size(freqband_2,1)),1)], ...
            [squeeze(freqband_3(:,chansel,freqsel));NaN((maxdatalength-size(freqband_3,1)),1)]);
        p_kruskalwallis(chansel,freqsel) = kruskalwallis(adj_data,[],'off');
    end
end

%% kruskal wallis with fdr
[~, ~, ~, p_kruskalwallis_fdr] = fdr_bh(p_kruskalwallis);

%% save tables
% table 1: psd value (18-channels sheets: 5-psd per freqband row x 3-group column)
freq_labels = ["Delta","Theta","Alpha","Beta","Gamma"];
for freqsel = 1:5
    for chansel = 1:length(labels)
        table = array2table(freqband_1(:,chansel,freqsel));
        table.Properties.VariableNames = "COV";
        writetable(table,destination+"\"+freq_labels(freqsel)+".xlsx",'Sheet',labels(chansel),'Range','A1')
        table = array2table(freqband_2(:,chansel,freqsel));
        table.Properties.VariableNames = "LONGCOV (age < 50)";
        writetable(table,destination+"\"+freq_labels(freqsel)+".xlsx",'Sheet',labels(chansel),'Range','B1')
        table = array2table(freqband_3(:,chansel,freqsel));
        table.Properties.VariableNames = "LONGCOV (age ≥ 50)";
        writetable(table,destination+"\"+freq_labels(freqsel)+".xlsx",'Sheet',labels(chansel),'Range','C1')
    end
end

% table 2: pval one way anova (18-channel row x 5-freqband column)
table = array2table(p_anova);
table.Properties.VariableNames = freq_labels;
writetable(table,destination+"\P_Anova.xlsx",'Range','B1')
table = array2table(labels');
writetable(table,destination+"\P_Anova.xlsx",'Range','A2', 'WriteVariableNames', false)

% table 3: pval one way anova (fdr-corrected) (18-channel row x 5-freqband column)
table = array2table(p_anova_fdr);
table.Properties.VariableNames = freq_labels;
writetable(table,destination+"\P_AnovaFDR.xlsx",'Range','B1')
table = array2table(labels');
writetable(table,destination+"\P_AnovaFDR.xlsx",'Range','A2', 'WriteVariableNames', false)

% table 2: pval kruskal wallis (18-channel row x 5-freqband column)
table = array2table(p_kruskalwallis);
table.Properties.VariableNames = freq_labels;
writetable(table,destination+"\P_KruskalWallis.xlsx",'Range','B1')
table = array2table(labels');
writetable(table,destination+"\P_KruskalWallis.xlsx",'Range','A2', 'WriteVariableNames', false)

% table 3: pval kruskal wallis (fdr-corrected) (18-channel row x 5-freqband column)
table = array2table(p_kruskalwallis);
table.Properties.VariableNames = freq_labels;
writetable(table,destination+"\P_KruskalWallisFDR.xlsx",'Range','B1')
table = array2table(labels');
writetable(table,destination+"\P_KruskalWallisFDR.xlsx",'Range','A2', 'WriteVariableNames', false)
