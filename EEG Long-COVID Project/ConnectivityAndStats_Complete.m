clear all
clc

load('cleancatData_50b.mat')

%% initialize
% data
data_1 = cleancatData_cov;
data_2a = cleancatData_longcov1;
data_2b = cleancatData_longcov2;
data_2 = [cleancatData_longcov1,cleancatData_longcov2];

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

destination = "D:\IMERI\Project dr. Yetti\Hasil\New Plots\Connectivity";

%% cpcc cov vs. longcov
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

%% ranksum cov vs. longcov
for chan_1 = 1:length(labels)
    for chan_2 = 1:length(labels)
        a = round(squeeze(cpcc_abs_1(:,chan_1,chan_2)),4);
        b = round(squeeze(cpcc_abs_2(:,chan_1,chan_2)),4);
        [p_ranksum1(chan_1,chan_2),~,stats] = ranksum(a',b');
        zval_1(chan_1,chan_2) = stats.zval;
    end
end

%% ranksum cov vs. longcov + fdr
[~, ~, ~, p_ranksum1_fdr] = fdr_bh(p_ranksum1);

%% cpcc longcov 1 vs. longcov 2
cpcc_abs_2a = zeros(length(data_2a),length(labels),length(labels));

for sbj_sel = 1:length(data_2a)
    cleancat_data = data_2a{sbj_sel};
    if (isempty(cleancat_data))
        cpcc_abs_2a(sbj_sel,:,:) = NaN(7,7);
%         disp(sbj_sel)
    else
        for chan_1 = 1:length(labels) % channel
            hlbtrf_data_1 = hilbert(cleancat_data(chan_1,:));
            for chan_2 = 1:length(labels) % channel
                hlbtrf_data_2 = hilbert(cleancat_data(chan_2,:));
                try
                    cpcc_abs_2a(sbj_sel,chan_1,chan_2) = fun_absCPCC(hlbtrf_data_1,hlbtrf_data_2);
                catch
                    cpcc_abs_2a(sbj_sel,chan_1,chan_2) = NaN;
                end
            end
        end
    end
end


cpcc_abs_2b = zeros(length(data_2b),length(labels),length(labels));

for sbj_sel = 1:length(data_2b)
    cleancat_data = data_2b{sbj_sel};
    if (isempty(cleancat_data))
        cpcc_abs_2b(sbj_sel,:,:) = NaN(7,7);
%         disp(sbj_sel)
    else
        for chan_1 = 1:length(labels) % channel
            hlbtrf_data_1 = hilbert(cleancat_data(chan_1,:));
            for chan_2 = 1:length(labels) % channel
                hlbtrf_data_2 = hilbert(cleancat_data(chan_2,:));
                try
                    cpcc_abs_2b(sbj_sel,chan_1,chan_2) = fun_absCPCC(hlbtrf_data_1,hlbtrf_data_2);
                catch
                    cpcc_abs_2b(sbj_sel,chan_1,chan_2) = NaN;
                end
            end
        end
    end
end


%% ranksum longcov 1 vs. longcov 2
for chan_1 = 1:length(labels)
    for chan_2 = 1:length(labels)
        a = round(squeeze(cpcc_abs_2a(:,chan_1,chan_2)),4);
        b = round(squeeze(cpcc_abs_2b(:,chan_1,chan_2)),4);
        [p_ranksum2(chan_1,chan_2),~,stats] = ranksum(a',b');
        zval_2(chan_1,chan_2) = stats.zval;
    end
end

%% ranksum longcov 1 vs. longcov 2 + fdr
[~, ~, ~, p_ranksum2_fdr] = fdr_bh(p_ranksum2);

%% zval plot
% cov vs. longcov
figure(1)
zval_1(isnan(zval_1))=0;
alpha_array = (zval_1<-1.96) | (zval_1>1.96);
alpha_array_1 = 0.3*double(~alpha_array);
alpha_array_2 = double(alpha_array);
alpha_array = alpha_array_1 + alpha_array_2;
alpha_array = alpha_array - triu(alpha_array);

imagesc(zval_1,'AlphaData',alpha_array)
axis square
xlabel("Channels","FontSize",13,"FontWeight","bold"); ylabel("Channels","FontSize",13,"FontWeight","bold")
caxis([-3.92 3.92]);

colormap(hsv)
c=colorbar();
c.Label.String = ["z-value"];
c.Label.Position(1) = 3;
c.FontSize = 13;
c.FontWeight= "bold";
c.Ticks = [-3.92,-2.94,-1.96, 0, 1.96, 2.94, 3.92];
c.TickLabels = [{int2str(-5),'Long-COVID > COVID','','0','','COVID > Long-COVID',int2str(5)}];

xticks(1:length(labels))
xticklabels(labels)     
yticks(1:length(labels))
yticklabels(labels)
title("Connectivity between groups")
subtitle("COVID vs. Long-COVID")
% subtitle("(Absolute CPCC)","FontSize",13)
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',13)

% longcov 1 vs. longcov 2
figure(2)
zval_2(isnan(zval_2))=0;
alpha_array = (zval_2<-1.96) | (zval_2>1.96);
alpha_array_1 = 0.3*double(~alpha_array);
alpha_array_2 = double(alpha_array);
alpha_array = alpha_array_1 + alpha_array_2;
alpha_array = alpha_array - triu(alpha_array);

imagesc(zval_2,'AlphaData',alpha_array)
axis square
xlabel("Channels","FontSize",13,"FontWeight","bold"); ylabel("Channels","FontSize",13,"FontWeight","bold")
caxis([-3.92 3.92]);

colormap(hsv)
c=colorbar();
c.Label.String = ["z-value"];
c.Label.Position(1) = 3;
c.FontSize = 13;
c.FontWeight= "bold";
c.Ticks = [-3.92,-2.94,-1.96, 0, 1.96, 2.94, 3.92];
c.TickLabels = [{int2str(-5),'LC(age < 50) > LC(age ≥ 50)','','0','','LC(age ≥ 50) > LC(age < 50)',int2str(5)}];

xticks(1:length(labels))
xticklabels(labels)     
yticks(1:length(labels))
yticklabels(labels)
title("Connectivity between groups")
subtitle("Long-COVID (age < 50) vs. Long-COVID (age ≥ 50)")
% subtitle("(Absolute CPCC)","FontSize",13)
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',13)

%% save tables
% table 1: pval ranksum cov vs. longcov
table = array2table(p_ranksum1');
table.Properties.VariableNames = labels;
writetable(table,destination+"\P_RanksumCovLongcov.xlsx",'Range','B1')
table = array2table(labels');
writetable(table,destination+"\P_RanksumCovLongcov.xlsx",'Range','A2', 'WriteVariableNames', false)

% table 2: pval ranksum cov vs. longcov fdr 
table = array2table(p_ranksum1_fdr');
table.Properties.VariableNames = labels;
writetable(table,destination+"\P_RanksumCovLongcovFDR.xlsx",'Range','B1')
table = array2table(labels');
writetable(table,destination+"\P_RanksumCovLongcovFDR.xlsx",'Range','A2', 'WriteVariableNames', false)

% table 3: pval ranksum longcov < 50 vs. longcov >= 50 
table = array2table(p_ranksum2');
table.Properties.VariableNames = labels;
writetable(table,destination+"\P_RanksumLongcov50.xlsx",'Range','B1')
table = array2table(labels');
writetable(table,destination+"\P_RanksumLongcov50.xlsx",'Range','A2', 'WriteVariableNames', false)

% table 4: pval ranksum longcov < 50 vs. longcov >= 50 fdr (8-electrode pairs row x 5-freqband column)
table = array2table(p_ranksum2_fdr');
table.Properties.VariableNames = labels;
writetable(table,destination+"\P_RanksumLongcov50FDR.xlsx",'Range','B1')
table = array2table(labels');
writetable(table,destination+"\P_RanksumLongcov50FDR.xlsx",'Range','A2', 'WriteVariableNames', false)

% table 5: zval cov vs. longcov
table = array2table(zval_1');
table.Properties.VariableNames = labels;
writetable(table,destination+"\ZValCovLongcov.xlsx",'Range','B1')
table = array2table(labels');
writetable(table,destination+"\ZValCovLongcov.xlsx",'Range','A2', 'WriteVariableNames', false)

% table 6: zval longcov < 50 vs. longcov >= 50
table = array2table(zval_2');
table.Properties.VariableNames = labels;
writetable(table,destination+"\ZValLongcov50.xlsx",'Range','B1')
table = array2table(labels');
writetable(table,destination+"\ZValLongcov50.xlsx",'Range','A2', 'WriteVariableNames', false)

% table 7: cpcc value cov
table = array2table(cpcc_abs_1');
table.Properties.VariableNames = labels;
writetable(table,destination+"\CPCCcov.xlsx",'Range','B1')
table = array2table(labels');
writetable(table,destination+"\CPCCcov.xlsx",'Range','A2', 'WriteVariableNames', false)

% table 8: cpcc value longcov
table = array2table(cpcc_abs_2');
table.Properties.VariableNames = labels;
writetable(table,destination+"\CPCClongcov.xlsx",'Range','B1')
table = array2table(labels');
writetable(table,destination+"\CPCClongcov.xlsx",'Range','A2', 'WriteVariableNames', false)

% table 9: cpcc value longcov < 50
table = array2table(cpcc_abs_2a');
table.Properties.VariableNames = labels;
writetable(table,destination+"\CPCClongcov1.xlsx",'Range','B1')
table = array2table(labels');
writetable(table,destination+"\CPCClongcov1.xlsx",'Range','A2', 'WriteVariableNames', false)

% table 10: cpcc value longcov >= 50
table = array2table(cpcc_abs_2b');
table.Properties.VariableNames = labels;
writetable(table,destination+"\CPCClongcov2.xlsx",'Range','B1')
table = array2table(labels');
writetable(table,destination+"\CPCClongcov2.xlsx",'Range','A2', 'WriteVariableNames', false)
