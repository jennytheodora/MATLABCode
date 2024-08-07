%% 1. Load data
clear all 
clc

load psd_all.mat

%% COVID & Non-COVID index
longcov_idx = [1 2 3 4 10 11 12 13 14 16];
cov_idx = [5 6 7 8 9 15 17 18];

%% Pre vs. post (COVID & Non-COVID)
pre_cov = {};
pre_noncov = {};
post_cov = {};
post_noncov = {};

for a = 1:length(norm_psd_pre_avg) % menyesuaikan dg data pre
    if ismember(a,longcov_idx)
        pre_cov{end+1} = norm_psd_pre_avg{a};
        post_cov{end+1} = norm_psd_post_avg{a};
        disp(a)
    elseif ismember(a,cov_idx)
        pre_noncov{end+1} = norm_psd_pre_avg{a};
        post_noncov{end+1} = norm_psd_post_avg{a};
    end
end

pre_cov = cell2mat(permute(pre_cov,[3,1,2]));
pre_cov = permute(pre_cov,[3,1,2]);

post_cov = cell2mat(permute(post_cov,[3,1,2]));
post_cov = permute(post_cov,[3,1,2]);

pre_noncov = cell2mat(permute(pre_noncov,[3,1,2]));
pre_noncov = permute(pre_noncov,[3,1,2]);

post_noncov = cell2mat(permute(post_noncov,[3,1,2]));
post_noncov = permute(post_noncov,[3,1,2]);

%% save
clearvars -except freq labels pre_cov post_cov pre_noncov post_noncov
save pre_vs_post_psd

%%

%% 2. Load data
clear all 
clc

load psd_all.mat

%% COVID & Non-COVID index
longcov_idx = [1:31, 33:35];
cov_idx = [32, 36:47];

%% COVID vs. Non-COVID (post)
cov = {};
noncov = {};

for a = 1:length(norm_psd_post_avg) 
    if ismember(a,longcov_idx)
        cov{end+1} = norm_psd_post_avg{a};
        % disp(a)
    elseif ismember(a,cov_idx)
        noncov{end+1} = norm_psd_post_avg{a};
    end
end

cov = cell2mat(permute(cov,[3,1,2]));
cov = permute(cov,[3,1,2]);

noncov = cell2mat(permute(noncov,[3,1,2]));
noncov = permute(noncov,[3,1,2]);

%% save
clearvars -except freq labels cov noncov
save cov_vs_noncov_psd_revised

%% 
clear all
clc

load('pre_vs_post_psd.mat')
cov_diff = post_cov-pre_cov;
noncov_diff = post_noncov-pre_noncov;

save pre_vs_post_psd