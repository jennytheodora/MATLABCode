%% load data
clear all
clc

load('pre_data.mat')
load('post_data.mat')
clear fs

%% pre
psd_pre = {};
error_catch = [];

for sbj_sel = 1:size(pre_data.ftcleaned,2)
    data = pre_data.ftcleaned{sbj_sel}; 
    fs = data.fsample;
    winsize = fs/3;
    NFFT = fs/0.5; % freq resolution = 0.5 Hz
    overlap = 0; % no overlap

    try % to handle empty subjects
        for a = 1:size(data.trial,2) % surviving epochs
            for b = 1:size(data.trial{1},1) % channels
                try % to handle flat lines 
                    [psd,freq_all] = pwelch(data.trial{a}(b,:),winsize,overlap,NFFT,fs);
                    psd_pre{sbj_sel}(a,b,:) = psd(1:101);
                    freq = freq_all(1:101);
                catch % replace with NaN
                    psd_pre{sbj_sel}(a,b,:) = NaN(101,1);
                    error_catch(end+1) = sbj_sel;
                end
            end
        end
    catch
        error_catch(end+1) = sbj_sel;
        psd_pre{sbj_sel} = psd_pre{sbj_sel-1}*NaN;
        % average the psd over epochs
        psd_pre_avg{sbj_sel} = squeeze(mean(psd_pre{sbj_sel},1,'omitnan'));
        continue
    end
    % average the psd over epochs
    psd_pre_avg{sbj_sel} = squeeze(mean(psd_pre{sbj_sel},1,'omitnan'));

end

% normalize psd
norm_psd_pre_avg = psd_pre_avg;
for sbj_sel = 1:size(pre_data.ftcleaned,2)
    for a = 1:size(psd_pre_avg{sbj_sel},1) % channels
        x = sum(psd_pre_avg{sbj_sel}(a,:),'omitnan');
        norm_psd_pre_avg{sbj_sel}(a,:) = psd_pre_avg{sbj_sel}(a,:)./x;
    end
end

clear a b x winsize

% %% coba plot
% for sbj_sel = 1:size(pre_data.ftcleaned,2)
%     plot(freq,norm_psd_pre_avg{sbj_sel}(1,:));
%     hold on
% end

%% post
psd_post = {};
error_catch = [];

for sbj_sel = 1:size(post_data.ftcleaned,2)
    data = post_data.ftcleaned{sbj_sel}; 
    fs = data.fsample;
    winsize = fs/3;
    NFFT = fs/0.5; % freq resolution = 0.5 Hz
    overlap = 0; % no overlap

    try % to handle empty subjects
        for a = 1:size(data.trial,2) % surviving epochs
            for b = 1:size(data.trial{1},1) % channels
                try % to handle flat lines 
                    [psd,freq_all] = pwelch(data.trial{a}(b,:),winsize,overlap,NFFT,fs);
                    psd_post{sbj_sel}(a,b,:) = psd(1:101);
                    freq = freq_all(1:101);
                catch % replace with NaN
                    psd_post{sbj_sel}(a,b,:) = NaN(101,1);
                    error_catch(end+1) = sbj_sel;
                end
            end
        end
    catch
        error_catch(end+1) = sbj_sel;
        psd_post{sbj_sel} = psd_post{sbj_sel-1}*NaN;
        % average the psd over epochs
        psd_post_avg{sbj_sel} = squeeze(mean(psd_post{sbj_sel},1,'omitnan'));
        continue
    end
    % average the psd over epochs
    psd_post_avg{sbj_sel} = squeeze(mean(psd_post{sbj_sel},1,'omitnan'));

end

% normalize psd
norm_psd_post_avg = psd_post_avg;
for sbj_sel = 1:size(post_data.ftcleaned,2)
    for a = 1:size(psd_post_avg{sbj_sel},1) % channels
        x = sum(psd_post_avg{sbj_sel}(a,:),'omitnan');
        norm_psd_post_avg{sbj_sel}(a,:) = psd_post_avg{sbj_sel}(a,:)./x;
    end
end

clear a b x winsize

% %% coba plot
% for sbj_sel = 1:size(post_data.ftcleaned,2)
%     plot(freq,norm_psd_post_avg{sbj_sel}(1,:));
%     hold on
% end

%% save
clearvars -except freq labels norm_psd_pre_avg norm_psd_post_avg
save psd_all