clear all
clc

%% MoCA
moca_cov = [29	25	30	29	30	30	29	28	28	29];
moca_noncov = [30	27	26	26	28	26	29	28];

[h,pval_moca] = ttest2(moca_cov,moca_noncov);

%% SRQ

srq_cov = [0	1	0	3	1	0	3	2	0	0];
srq_noncov = [0	1	3	10	3	3	3	1];

[h,pval_srq] = ttest2(srq_cov,srq_noncov);

%% Komponen MoCA
mocacomp_noncov(1,:) = [7	6	7	5	7	7	7];
mocacomp_cov(1,:) = [7	7	7	7	7	7	7	7	7];

mocacomp_noncov(2,:) = [6	6	6	5	6	6	6];
mocacomp_cov(2,:) = [5	5	6	6	6	6	6	6	5];

mocacomp_noncov(3,:) = [5	4	1	5	3	4	3];
mocacomp_cov(3,:) = [5	1	5	4	5	5	3	3	5];

mocacomp_noncov(4,:) = [6	5	6	5	6	6	6];
mocacomp_cov(4,:) = [6	6	6	6	6	6	6	6	6];

mocacomp_noncov(5,:) = [6	6	6	6	6	6	6];
mocacomp_cov(5,:) = [6	6	6	6	6	6	6	6	6];

mocaComp_labels = ["Executive & Visuospatial Score", "Language Score", "Memory Score","Attention Score","Orientation Score"];

%% BarPlot
data_1 = mocacomp_cov(5,:);
data_2 = mocacomp_noncov(5,:);
title_sel = mocaComp_labels(5);
ylim_sel = [0 8];
yticks_sel = [0 6];
legend_labels = ["COVID", "Non-COVID"];
line_color_1 = [181, 5, 14]./255;
line_color_2 = [43 72 166]./255;

mean_data_1 = mean(data_1);
mean_data_2 = mean(data_2);
std_data_1 = std(data_1);
std_data_2 = std(data_2);


b = bar([1,3],[mean_data_1;mean_data_2]);
b.FaceColor = 'flat';
b.CData(1,:) = [181, 5, 14]./255;
b.CData(2,:) = [22, 15, 163]./255;
hold on
scatter(1*ones(size(data_1)),data_1,100,'filled','MarkerFaceAlpha',0.7,'MarkerEdgeColor',line_color_1, 'MarkerFaceColor',[255 108 108]./255,'XJitter','density');
hold on
scatter(3*ones(size(data_2)),data_2,100,'filled','MarkerFaceAlpha',0.7,'MarkerEdgeColor',line_color_2, 'MarkerFaceColor',[185 220 255]./255,'XJitter','density');
hold on
errorbar([1,3],[mean_data_1;mean_data_2],[std_data_1;std_data_2],'k','linestyle','none','LineWidth',1.5);

legend("","","","SD")
xticklabels(legend_labels)
ylim(ylim_sel)
yticks(yticks_sel)
% yticklabels(yticks_sel)
set(gca,'FontSize', 20)
title(title_sel)


%% Age
age_cov = [29	39	29	32	31	27	27	23	23	23];
age_noncov = [25	26	33	24	33	28	31	24];

[h,pval_age] = ttest2(age_cov,age_noncov);

%% Gender
gen_cov = [3,7];
gen_noncov = [2,6];
[h_a,pval_gen,stats] = fishertest([gen_cov;gen_noncov]);

%% Education
% group
data_1 = [0	0	0	0	1	1	1	1	1	0	0	0	0	0	1	0	1	1];
% education level (0-4: SMA/SMK, D3, D4/S1, S2)
data_2 = [2	2	2	1	2	2	2	2	2	2	2	2	2	2	2	2	0	2];
% stats
[tbl, chi2, p] = crosstab(data_1,data_2);