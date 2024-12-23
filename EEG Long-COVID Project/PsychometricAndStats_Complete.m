clear all
clc

load('psychometry_50b.mat')

%% initialize
% psy (moca, mmse, srq, srq1, srq3, srq4)
psy_cov = [moca_cov; mmse_cov; srq_cov; srq1_cov; srq3_cov; srq4_cov];
psy_longcov1 = [moca_longcov1; mmse_longcov1; srq_longcov1; srq1_longcov1; srq3_longcov1; srq4_longcov1];
psy_longcov2 = [moca_longcov2; mmse_longcov2; srq_longcov2; srq1_longcov2; srq3_longcov2; srq4_longcov2];
psy_longcov = [psy_longcov1,psy_longcov2];
psy_label = ["MoCA","MMSE","SRQ","SRQ-Psychological","SRQ-Psychotic","SRQ-PTSD"];

% legend
legend_1 = "COVID";
legend_2 = "Long-COVID";
legend_2a = "Long-COV (age < 50)";
legend_2b = "Long-COV (age ≥ 50)";

% color (1: blue, 2: red, 3: green)
color1_dark = [39, 103, 177]./255;
color1_light  = [117,166,225]./255;
color2_dark = [217,33,59]./255;
color2_light  = [239,149,162]./255;
color3_dark = [80, 178, 69]./255;
color3_light  = [156,214,150]./255;

destination = "D:\IMERI\Project dr. Yetti\Hasil\New Plots\Psychometrics";

%% boxplot
% cov vs. longcov
adj_data = [psy_cov,psy_longcov]';
group_inx = [1*ones(1,size(psy_cov,2)),2*ones(1,size(psy_longcov,2))]';
c = [color1_light;color2_light];

for a = 1:length(psy_label)
    fig = figure(a)
    nonnanidx = find(~isnan(adj_data(:,a)));
    h = daboxplot(adj_data(nonnanidx,a),'groups',group_inx(nonnanidx,1),'color',c,'whiskers',0,'scatter',1,'jitter',0,'scattersize',13,'scatteralpha',0.7);
    title(psy_label(a), 'FontSize', 18)
    ylim([0 1.2*round(max(adj_data(nonnanidx,a)))])
    set(gca, 'XTickLabel',{'',''}, 'FontSize', 18)

    % % save pic
    % temp=[char(destination),filesep,'BoxPlot_',char(psy_label(a)),'.png'];
    % saveas(gca,temp);
    % close(fig)
end

% cov vs. longcov (<50) vs. longcov (>=50)
adj_data = [psy_cov,psy_longcov1,psy_longcov2]';
group_inx = [1*ones(1,size(psy_cov,2)),2*ones(1,size(psy_longcov1,2)),3*ones(1,size(psy_longcov2,2))]';
c = [color1_light;color2_light;color3_light];

for a = 1:length(psy_label)
    fig = figure(a)
    nonnanidx = find(~isnan(adj_data(:,a)));
    h = daboxplot(adj_data(nonnanidx,a),'groups',group_inx(nonnanidx,1),'color',c,'whiskers',0,'scatter',1,'jitter',0,'scattersize',13,'scatteralpha',0.7);
    title(psy_label(a), 'FontSize', 18)
    ylim([0 1.2*round(max(adj_data(nonnanidx,a)))])
    set(gca, 'XTickLabel',{'',''}, 'FontSize', 18)

    % % save pic
    % temp=[char(destination),filesep,'BoxPlot50_',char(psy_label(a)),'.png'];
    % saveas(gca,temp);
    % close(fig)
end

%% barplot
% cov vs. longcov
y = [mean(psy_cov,2,"omitnan"),mean(psy_longcov,2,"omitnan")];

for a = 1:length(psy_label)
    err1(a) = std(psy_cov(a,:),'omitnan')/sqrt(length(psy_cov(a,:)));
    err2(a) = std(psy_longcov(a,:),'omitnan')/sqrt(length(psy_longcov(a,:)));
end
err = [err1;err2]';

for a = 1:length(y)
    fig = figure(a)
    b = bar([1,5],y(a,:));
    b.FaceColor = 'flat';
    b.CData(1,:) = color1_light;
    b.CData(2,:) = color2_light;

    hold on

    errorbar([1,5],y(a,:),err(a,:),'k','linestyle','none', 'HandleVisibility','off','LineWidth',1);
    hold off

    set(gca, 'XTickLabel',{"",""}, 'FontSize', 13)
    title(psy_label(a),"FontSize", 17,"FontWeight","bold");
    ylim([0 max(max(err(a,:)))+max(max(y(a,:)))*1.6]);

    % % save pic
    % temp=[char(destination),filesep,'BarPlot_',char(psy_label(a)),'.png'];
    % saveas(gca,temp);
    % close(fig)
end

% cov vs. longcov (<50) vs. longcov (>=50)
y = [mean(psy_cov,2,"omitnan"),mean(psy_longcov1,2,"omitnan"),mean(psy_longcov2,2,"omitnan")];

for a = 1:length(psy_label)
    err1(a) = std(psy_cov(a,:),'omitnan')/sqrt(length(psy_cov(a,:)));
    err2(a) = std(psy_longcov1(a,:),'omitnan')/sqrt(length(psy_longcov1(a,:)));
    err3(a) = std(psy_longcov2(a,:),'omitnan')/sqrt(length(psy_longcov2(a,:)));
end
err = [err1;err2;err3]';

for a = 1:length(y)
    fig = figure(a)

    b = bar([1,5,9],y(a,:));
    b.FaceColor = 'flat';
    b.CData(1,:) = color1_light;
    b.CData(2,:) = color2_light;
    b.CData(3,:) = color3_light;

    hold on

    errorbar([1,5,9],y(a,:),err(a,:),'k','linestyle','none', 'HandleVisibility','off','LineWidth',1);
    hold off

    set(gca, 'XTickLabel',{"","",""}, 'FontSize', 13)
    title(psy_label(a),"FontSize", 17,"FontWeight","bold");
    ylim([0 max(max(err(a,:)))+max(max(y(a,:)))*1.6]);

    % % save pic
    % temp=[char(destination),filesep,'BarPlot50_',char(psy_label(a)),'.png'];
    % saveas(gca,temp);
    % close(fig)
end

%% ranksum 2 groups
p_ranksum = NaN(1,6);
for a = 1:length(psy_label)
    p_ranksum(a) = ranksum(psy_cov(a,:),psy_longcov(a,:));
end

%% ranksum + fdr 2 groups
[~, ~, ~, p_ranksum_fdr] = fdr_bh(p_ranksum);

%% kruskal wallis 3 groups
maxdatalength = max([size(psy_cov,2),size(psy_longcov1,2),size(psy_longcov2,2)]);
p_kruskalwallis = NaN(1,6);

for a = 1:length(psy_label)
    % adjust vars to function: 23 (max size) x 3 (groups)
    adj_data = [psy_cov(a,:),NaN(1,maxdatalength-size(psy_cov,2));
        psy_longcov1(a,:),NaN(1,maxdatalength-size(psy_longcov1,2));
        psy_longcov2(a,:),NaN(1,maxdatalength-size(psy_longcov2,2))];
    p_kruskalwallis(a) = kruskalwallis(adj_data,[],'off');
end

%% kruskal wallis + fdr 3 groups
[~, ~, ~, p_kruskalwallis_fdr] = fdr_bh(p_kruskalwallis);

%% save tables
% ranksum
table = array2table(p_ranksum);
table.Properties.VariableNames = psy_label;
writetable(table,destination+"\P_RankSum.xlsx",'Range','A1')

% ranksum fdr
table = array2table(p_ranksum_fdr);
table.Properties.VariableNames = psy_label;
writetable(table,destination+"\P_RankSumFDR.xlsx",'Range','A1')

% kruskal wallis
table = array2table(p_kruskalwallis);
table.Properties.VariableNames = psy_label;
writetable(table,destination+"\P_KruskalWallis.xlsx",'Range','A1')

% kruskal wallis fdr
table = array2table(p_kruskalwallis_fdr);
table.Properties.VariableNames = psy_label;
writetable(table,destination+"\P_KruskalWallisFDR.xlsx",'Range','A1')