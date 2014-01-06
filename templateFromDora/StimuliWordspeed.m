function trials = StimuliWordspeed(set)
%%%% this program specifies the trial structure
%%%% for the wordspeed experiment
%%%% D. Hermes 2013

% create list of all stimuli
if set==1 || set==3 || set==5 % USE WORDS AND CONSONANT STRINGS
    a=dir('./stims/4l_cs');
    stim_list=[];
    for k=4:length(a)
        stim_list{k-3}=a(k).name;
    end
    clear a

    a=dir('./stims/4l_words');
    target_list=[];
    for k=4:length(a)
        target_list{k-3}=a(k).name;
    end
    clear a
    % note that stim_list has a strange order listing according to 1st number
elseif set==2 || set==4 || set==6 % USE WORDS AND NONWORDS
    % create list of all stimuli
    a=dir('./stims/4l_nonwords');
    stim_list=[];
    for k=4:length(a)
        stim_list{k-3}=a(k).name;
    end
    clear a

    a=dir('./stims/4l_words');
    target_list=[];
    for k=4:length(a)
        target_list{k-3}=a(k).name;
    end
    clear a
    % note that
end

% set parameters

tr_isi=[1/2 1/3 1/4 1/5 1/6 1/10 1/20]; % 7 inter stimulus intervals
% if there are more than 9, change the number added to the condition code 

trial_length=1;% duration while stimuli are repeated 1 sec, mask before and after
nr_stims=floor(trial_length./tr_isi)+2; % +2 masks
 
% 7 isi types get labels 1:7
nr_reps=16; % 16 repeats of each trial
tr_cond=[zeros(nr_reps,1)+1; ...
    zeros(nr_reps,1)+2; ...
    zeros(nr_reps,1)+3; ...
    zeros(nr_reps,1)+4; ...
    zeros(nr_reps,1)+5; ...
    zeros(nr_reps,1)+6; ...
    zeros(nr_reps,1)+7];% labels for trials e.g. [1:8 1:8] conditions 1234567812345678

nr_trials=length(tr_cond); % nr of trials

[trials.nr trials.orig_nr trials.cond trials.isi ...
    trials.stim_order trials.stim_list]=deal([]);

for k=1:nr_trials % nr of trials
    trials(k).orig_nr=k;
    trials(k).cond=tr_cond(k); % decides speed
    trials(k).isi=tr_isi(tr_cond(k));
    
    % order of stims: mask, stims & target, mask
    trials(k).stim_order=zeros(nr_stims(trials(k).cond),1);
    %%%% MASKS
    trials(k).stim_order(1)=0;
    trials(k).stim_order(end)=0;
    %%%% STIMULI
    stims2use=randperm(length(stim_list));
    stims2use=stims2use(1:nr_stims(trials(k).cond)-2);
    trials(k).stim_order(2:end-1)=stims2use;
    
    % add target on even trials
    stims2use=randperm(nr_stims(trials(k).cond)-2);
    stims2use=stims2use(1);
    target_location=stims2use+1;
    %%%% TARGET
    if mod(k,2)==0
        % add target
        stims2use=randperm(length(target_list));
        stims2use=stims2use(1);
        trials(k).stim_order(target_location)=-stims2use;
        % add 10 to trial code if there is a target 
        trials(k).cond=10+trials(k).cond;
    end
    
    % enter correct stimuli in trials (in trial.stim_list)
    %%%% MASKS
    trials(k).stim_list=cell(length(trials(k).stim_order),1); % initialize trials.stim_list
    trials(k).stim_list{1}='mask1.png';
    trials(k).stim_list{end}='mask1.png';
    %%%% STIMULI % TARGET
    for s=2:length(trials(k).stim_list)-1
        if trials(k).stim_order(s)>0 % stimulus
            trials(k).stim_list{s}=stim_list(trials(k).stim_order(s));
        elseif trials(k).stim_order(s)<0 % target
            trials(k).stim_list{s}=target_list(-trials(k).stim_order(s));
        end
    end
end

%%%% PUT TRIALS IN RANDOM ORDER
% only do this after making all the trials, otherwise addding targets on
% the even trials does not work
trials=trials(randperm(nr_trials));

for k=1:length(trials)
    trials(k).nr=k;
end
