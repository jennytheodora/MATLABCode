%% import data (FILL IN: file name and location)
clear all
clc

% import edf file
ftData = edf2fieldtrip('Octa Aulia.edf');
time_start = 116;

%% arranging data & apply filter 
% sampling freq
fs = ftData.fsample;

% select & visually inspect data (FILL IN: time start, duration)
% select time start (in seconds)
duration = 120;
time_end = time_start + duration; % 2 mins

ftData_sel = ftData;
ftData_sel.trial{1} = [];
ftData_sel.label = {};
ftData_sel.time = {};
ftData_sel.time{1} = linspace(0,duration,duration*fs);

% select channel
label = string(ftData.label)';
chansel = ["FP1", "FP2", "F3", "F4", "F7", "F8", "Fz", "T3", "T4", "T5", "T6", "C3", "C4", "P3", "P4", "Pz", "O1", "O2"];
for a = 1:length(chansel)
    idx = find(contains(lower(label),lower(chansel(a))));
    if idx
        ftData_sel.trial{1}(a,:) = ftData.trial{1}(idx(1),(time_start*fs)+1:time_end*fs);
    else
        ftData_sel.trial{1}(a,:) = ftData_sel.trial{1}(a-1,:)*NaN;
    end
end
ftData_sel.label = cellstr(chansel);

% apply filter 

% for visualization
chansel = 1; 
winsize = 1/3*fs; 

% HPF (fc = 1 Hz)
hpf_cutoff = 1;
norm_hpf_cutoff = hpf_cutoff / (0.5*ftData_sel.fsample);

% BSF 
bsf_cutoff = [49 51];
norm_bsf_cutoff = bsf_cutoff / (0.5*ftData_sel.fsample);

% LPF (fc = 45 Hz)
lpf_cutoff = 45;
norm_lpf_cutoff = lpf_cutoff / (0.5*ftData_sel.fsample);

order = 6;
order_bsf = 6;

ftDatafilt = ftData_sel;

for a = 1:size(ftData_sel.trial{1},1)
    % HPF
    [B,A] = butter(order,norm_hpf_cutoff,'high');
    hpf_data = filtfilt(B,A,ftData_sel.trial{1}(a,:));

    % BSF
    % first level
    [B,A] = butter(order_bsf,norm_bsf_cutoff,'stop');
    bsf_data = filtfilt(B,A,hpf_data);

    % LPF
    [B,A] = butter(order,norm_lpf_cutoff,'low');
    lpf_data = filtfilt(B,A,bsf_data);
    % lpf_data = filtfilt(B,A,hpf_data);

    ftDatafilt.trial{1}(a,:) = lpf_data;
    
    if (a == chansel)
        hpf_data_sel = hpf_data;
        bsf_data_sel = bsf_data;
        lpf_data_sel = lpf_data;
    end
end

cfg = [];
cfg.blocksize = 120; % num of seconds to display at once
cfg.continuous = 'yes'; % not yet cut into trials
cfg.plotlabels = 'some';
cfg.viewmode = 'vertical';
cfg.colorgroups = 'chantype';
cfg.demean = "yes";
ft_databrowser(cfg, ftDatafilt)

clearvars -except ftData ftDatafilt ftData_sel fs hpf_data_sel bsf_data_sel lpf_data_sel chansel winsize duration


% % plot filters effect 
% 
% figure(1);
% timedom_data = ftData_sel.trial{1}(chansel,:);
% [freqdom_data,freq] = pwelch(timedom_data,winsize,[],[],fs);
% subplot(2,1,1)
% plot(ftData_sel.time{1},timedom_data);
% xlabel("Time (s)"); ylabel("Amplitude");
% title("Time Domain")
% subplot(2,1,2)
% plot(freq,freqdom_data);
% xlabel("Frequency (Hz)"); ylabel("PSD (dB/Hz)");
% title("Frequency Domain")
% sgtitle("Raw Data")
% 
% figure(2);
% timedom_data = hpf_data_sel;
% [freqdom_data,freq] = pwelch(timedom_data,winsize,[],[],fs);
% subplot(2,1,1)
% plot(ftData_sel.time{1},timedom_data);
% xlabel("Time (s)"); ylabel("Amplitude");
% title("Time Domain")
% subplot(2,1,2)
% plot(freq,freqdom_data);
% xlabel("Frequency (Hz)"); ylabel("PSD (dB/Hz)");
% title("Frequency Domain")
% sgtitle("High-Pass Filtered Data (fc = 1 Hz)")
% 
% figure(3);
% timedom_data = bsf_data_sel;
% [freqdom_data,freq] = pwelch(timedom_data,winsize,[],[],fs);
% subplot(2,1,1)
% plot(ftData_sel.time{1},timedom_data);
% xlabel("Time (s)"); ylabel("Amplitude");
% title("Time Domain")
% subplot(2,1,2)
% plot(freq,freqdom_data);
% xlabel("Frequency (Hz)"); ylabel("PSD (dB/Hz)");
% title("Frequency Domain")
% sgtitle("Band-Stop Filtered Data (fc = [49 51] Hz)")
% 
% figure(4);
% timedom_data = lpf_data_sel;
% [freqdom_data,freq] = pwelch(timedom_data,winsize,[],[],fs);
% subplot(2,1,1)
% plot(ftData_sel.time{1},timedom_data);
% xlabel("Time (s)"); ylabel("Amplitude");
% title("Time Domain")
% subplot(2,1,2)
% plot(freq,freqdom_data);
% xlabel("Frequency (Hz)"); ylabel("PSD (dB/Hz)");
% title("Frequency Domain")
% sgtitle("High-Pass Filtered Data (fc = 100 Hz)")
% 
% clearvars -except ftData ftDatafilt ftData_sel fs duration

%% visual rejection 
clearvars -except ftDatafilt
data = ftDatafilt.trial{1}; % Select this when ICA is not applied

% assign to epochs (FILL IN: duration of epoch)
epoch_dur = 2; % in seconds
duration = 120; % in seconds
fs = ftDatafilt.fsample;
labels = ["FP1", "FP2", "F3", "F4", "F7", "F8", "Fz", "T3", "T4", "T5", "T6", "C3", "C4", "P3", "P4", "Pz", "O1", "O2"];

% assign data into trials 
data_trl = zeros(size(data,1),duration/epoch_dur,fs*epoch_dur);

for a = 1:size(data_trl,1)
    for b = 1:size(data_trl,2)
        data_trl(a,b,:) = (data(a,(b-1)*fs*epoch_dur+1:b*epoch_dur*fs));
    end
end

clear a b ftData

% preparing FieldTrip structure 
[Nchannel, Ntrial, Ntimept] = size(data_trl); 

for ntrial = 1:Ntrial
   	ftData.trial{ntrial} = squeeze(data_trl(:,ntrial,:)); % assign trial n (channel,timepoint) ke cell ke-n
	ftData.time{ntrial}  = linspace(0,epoch_dur,fs*epoch_dur);
end

channels=1:Nchannel;
ftData.label = cellstr(labels);
ftData.fsample = fs;
ftData.cfg = '';

% clearvars -except ftData ftDatafilt duration fs

% visual inspection 
cfg.method = 'channel';
cfg.eegscale = 1;
cfg.keepchannel = 'nan';
ftDatacleaned = ft_rejectvisual(cfg,ftData);

%% concatenate data 
count = 1;
cleancat_data = zeros(size(ftDatacleaned.trial{1},1),(size(ftDatacleaned.trial{1},2)*(size(ftDatacleaned.trial,2))));
for a = 1:size(ftDatacleaned.trial,2)
    cleancat_data(1:size(ftDatacleaned.trial{1},1),count:count+(fs*epoch_dur)-1) = ftDatacleaned.trial{a}.*[linspace(0,1,fs), linspace(1,0,fs)];
    count = count+fs*epoch_dur;
end

%% save 
clearvars -except labels ftDatacleaned cleancat_data fs
save pre_sbj_9