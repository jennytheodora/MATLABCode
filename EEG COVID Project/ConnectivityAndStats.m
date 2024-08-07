clear all
clc

% load data
% load('pre_vs_post_cleancat.mat')
load('cov_vs_noncov_cleancat_revised.mat')

data_1 = noncov;
data_2 = cov;

line_color_1 = [43 72 166]./255;
line_color_2 = [166 43 43]./255;

% biru abu [120 123 146], shade [184 188 199]
% merah abu [146 138 138], shade [198 183 183]
% biru [43 72 166], shade [185 220 255]
% merah [166 43 43], shade [255 208 208]

legend_1 = "Non-COVID";
legend_2 = "COVID";

%% cpcc 
cpcc_abs_1 = zeros(length(data_1),length(labels),length(labels));

for sbj_sel = 1:length(data_1)
    cleancat_data = data_1{sbj_sel};
    if (isempty(cleancat_data))
        cpcc_abs_1(sbj_sel,:,:) = NaN(7,7);
%         disp(sbj_sel)
    else
        for chan_1 = 1:length(labels) % channel
            hlbtrf_data_1 = hilbert(cleancat_data(chan_1,:));
            for chan_2 = 1:length(labels) % channel
                hlbtrf_data_2 = hilbert(cleancat_data(chan_2,:));
                try
                    cpcc_abs_1(sbj_sel,chan_1,chan_2) = fun_absCPCC(hlbtrf_data_1,hlbtrf_data_2);
                catch
                    cpcc_abs_1(sbj_sel,chan_1,chan_2) = NaN;
                end
            end
        end
    end
end

cpcc_abs_2 = zeros(length(data_2),length(labels),length(labels));

for sbj_sel = 1:length(data_2)
    cleancat_data = data_2{sbj_sel};
    if (isempty(cleancat_data))
        cpcc_abs_2(sbj_sel,:,:) = NaN(7,7);
%         disp(sbj_sel)
    else
        for chan_1 = 1:length(labels) % channel
            hlbtrf_data_1 = hilbert(cleancat_data(chan_1,:));
            for chan_2 = 1:length(labels) % channel
                hlbtrf_data_2 = hilbert(cleancat_data(chan_2,:));
                try
                    cpcc_abs_2(sbj_sel,chan_1,chan_2) = fun_absCPCC(hlbtrf_data_1,hlbtrf_data_2);
                catch
                    cpcc_abs_2(sbj_sel,chan_1,chan_2) = NaN;
                end
            end
        end
    end
end

%% plot cpcc all
for sbj_sel = 1:size(cpcc_abs_1,1)
    figure(sbj_sel)

    subplot(1,2,1)
    imagesc(squeeze(cpcc_abs_1(sbj_sel,:,:)))
    axis square
    xlabel("Channels","FontSize",13); ylabel("Channels","FontSize",13)
    colormap(jet)
    c=colorbar;
    c.Label.Position(1) = 4;
    caxis([0 1]);
    xticks(1:length(labels))
    xticklabels(labels)
    yticks(1:length(labels))
    yticklabels(labels)
    title("EC1","FontSize",15)
    % subtitle("(Abs-CPCC ≡ ISPC)","FontSize",13)
    a = get(gca,'XTickLabel');
    set(gca,'XTickLabel',a,'fontsize',13)

    subplot(1,2,2)
    imagesc(squeeze(cpcc_abs_2(sbj_sel,:,:)))
    axis square
    xlabel("Channels","FontSize",13); ylabel("Channels","FontSize",13)
    colormap(jet)
    c=colorbar;
    c.Label.Position(1) = 4;
    caxis([0 1]);
    xticks(1:length(labels))
    xticklabels(labels)
    yticks(1:length(labels))
    yticklabels(labels)
    title("EC1","FontSize",15)
    % subtitle("(Abs-CPCC ≡ ISPC)","FontSize",13)
    a = get(gca,'XTickLabel');
    set(gca,'XTickLabel',a,'fontsize',13)
end
%% cpcc avg plot
cpcc_avg_1 = squeeze(mean(cpcc_abs_1,1,"omitnan"));
cpcc_avg_2 = squeeze(mean(cpcc_abs_2,1,"omitnan"));

% plot
subplot(1,2,1)
imagesc(cpcc_avg_1)
axis square
xlabel("Channels","FontSize",15); ylabel("Channels","FontSize",15)
colormap(jet)
c=colorbar;
c.Label.String = ["Absolute CPCC"];
caxis([0 1]);
xticks(1:length(labels))
xticklabels(labels)
yticks(1:length(labels))
yticklabels(labels)
title(legend_1,"FontSize",15)
% subtitle("(Absolute CPCC)","FontSize",13)
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',15)

subplot(1,2,2)
imagesc(cpcc_avg_2)
axis square
xlabel("Channels","FontSize",15); ylabel("Channels","FontSize",15)
colormap(jet)
c=colorbar;
c.Label.String = ["Absolute CPCC"];
caxis([0 1]);
xticks(1:length(labels))
xticklabels(labels)
yticks(1:length(labels))
yticklabels(labels)
title(legend_2,"FontSize",15)
% subtitle("(Abs-CPCC ≡ ISPC)","FontSize",13)
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',15)


%% ttest
for chan_1 = 1:length(labels)
    for chan_2 = 1:length(labels)
        a = round(squeeze(cpcc_abs_1(:,chan_1,chan_2)),4);
        b = round(squeeze(cpcc_abs_2(:,chan_1,chan_2)),4);
        [~,pval(chan_1,chan_2),~,stats] = ttest2(a',b');
        tval(chan_1,chan_2) = stats.tstat;
    end
end

table = array2table(tval);
table.Properties.RowNames = labels;
table.Properties.VariableNames = labels;
% table = table(table,'VariableNames',{'My Table'}); % Nested table
disp(table)

%% tval plot
tval(isnan(tval))=0;
alpha_array = (tval<-2.12) | (tval>2.12);
alpha_array_1 = 0.3*double(~alpha_array);
alpha_array_2 = double(alpha_array);
alpha_array = alpha_array_1 + alpha_array_2;
alpha_array = alpha_array - triu(alpha_array);

imagesc(tval,'AlphaData',alpha_array)
axis square
xlabel("Channels","FontSize",13,"FontWeight","bold"); ylabel("Channels","FontSize",13,"FontWeight","bold")
% maxval = max(max(abs(tval)));
caxis([-5 5]);

colormap(parula)
c=colorbar();
% c=colorbar('Ticks',[-maxval,-maxval/2,0,maxval/2,maxval],'TickLabels',{int2str(-maxval),'Non-COVID > COVID','0','COVID > Non-COVID',int2str(maxval)});
c.Label.String = ["t-value"];
c.Label.Position(1) = 2;
c.FontSize = 13;
c.FontWeight= "bold";
% c.Ticks = [-maxval,-2.12,-maxval/2,0,maxval/2,2.12,maxval];
% c.TickLabels = [{int2str(-maxval),'','COVID > Non-COVID','0','Non-COVID > COVID','',int2str(maxval)}];
c.Ticks = [-5,(-5-2.12)/2,-2.12, 0, 2.12, (5+2.12)/2, 5];
c.TickLabels = [{int2str(-5),'COVID > Non-COVID','','0','','Non-COVID > COVID',int2str(5)}];

xticks(1:length(labels))
xticklabels(labels)     
yticks(1:length(labels))
yticklabels(labels)
title("Connectivity between groups")
% subtitle("(Absolute CPCC)","FontSize",13)
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',13)



%% save ttest
filename = 'T-test Connectivity.xlsx';
writetable(table,filename,'Sheet',2,'Range','B1')
