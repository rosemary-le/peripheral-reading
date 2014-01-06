clear;clc;
%% define path and toolboxes
path    = '/Users/wandell/rkimle/words_speed_LR/';
savedir = [path 'data/behavior/'];
cd([path '']);

%% add toolboxes

% already added through startup

% toolbox = '/media/DATA/Pro/Toolbox/';%
addpath(genpath('/Applications/Psychtoolbox/'));
% run('/Applications/Psychtoolbox/SetupPsychtoolbox.m');

%% Get subject's details
subject.id      = input('Subject id: ', 's');
subject.run     = input('Run (select stimuli 1:8): ', 's');
subject.fileName= [num2str(round(datenum(clock)*100000)) '_' subject.id '_' subject.run];

%% start psychtoolbox
debug = 0;
Sc=start_psychtb(debug);

%% Prepare experiment
mac.key1 = '1!';
mac.key2 = '2@';
mac.key3 = '3#';
mac.key4 = '4$';
mac.key5 = '5%';
mac.key6 = '6^';
mac.key7 = '7&';
mac.key8 = '8*';
mac.key9 = '9(';
mac.key0 = '0)';
mac.return = 'Return';
mac.delete = 'DELETE';

pc.key1 = 'ampersand';
pc.key2 = 'eacute';
pc.key3 = 'quotedbl';
pc.key4 = 'apostrophe';
pc.key5 = 'parenleft';
pc.key6 = 'minus';
pc.key7 = 'egrave';
pc.key8 = 'underscore';
pc.key9 = 'ccedilla';
pc.key0 = 'agrave';
pc.return = 'Return';
pc.delete = 'BackSpace';

keyboard = mac;

fontSize=100;
Screen('TextSize', Sc.window,fontSize);
Screen('TextFont', Sc.window,'Arial');

% specify inter trial interval, from button press to next trial
ITI     = 2.000;
% duration of instruction on the screen
T_instr = 3.000;
oval_s  = 2; % fixation dot


%%%% load directories with words:

count_stims=0;
a=dir('./stims/4l_cs');
stim_list=[]; % generate the stimuli list
path_list=[]; % where are these stimuli located
for k=4:length(a)
    count_stims=count_stims+1;
    path_list{count_stims}='./stims/4l_cs/';
    stim_list{count_stims}=a(k).name;
end
clear a
a=dir('./stims/4l_nonwords');
for k=4:length(a)
    count_stims=count_stims+1;
    path_list{count_stims}='./stims/4l_nonwords/';
    stim_list{count_stims}=a(k).name;
end
clear a
a=dir('./stims/4l_words');
for k=4:length(a)
    count_stims=count_stims+1;
    path_list{count_stims}='./stims/4l_words/';
    stim_list{count_stims}=a(k).name;
end
clear a
path_list{count_stims+1}='./stims/4l_mask/';
stim_list{count_stims+1}='mask1.png';

% note that stim_list has a strange order listing according to 1st number -
% always use the .png name to get to the correct file

total_nr_stims=size(stim_list,2);
pointers=NaN(total_nr_stims,1);
%-- load stims
for s = 1:size(stim_list,2)
    img = imread([path_list{s} stim_list{s}]);
    pointers(s) = Screen('MakeTexture',Sc.window,img);
    if pointers(s)==0 % check whether the stimulus was found
        disp(['error s=' int2str(s)])
    end
end

%% Generate Stimuli
%-- initialize result
[trials.resp_t trials.resp_b trials.code... 
    trials.time trials.event...
    trials.instr_time]=deal([]);

%-- Generate stimuli
trials = StimuliWordspeed(str2num(subject.run)); % get trials for run 1:2
%-- replace symbols by psychtoolbox texture
for t = 1:length(trials)
    for s = 1:length(trials(t).stim_list)
        % check stim_list
        for match = 1:size(stim_list,2)
            if strcmp(stim_list{match},trials(t).stim_list{s})
                trials(t).pointer(s) = pointers(match);
                break
            end
        end
    end
end

scale_ft=.30; % image scale factor % .18 before
run_nr=str2double(subject.run);
if ismember(run_nr,[1,2]) % left
    word_offset=[-28 0];
elseif ismember(run_nr,[3,4]) % right
    word_offset=[28 0];
elseif ismember(run_nr,[5,6]) % center
    word_offset=[0 0];
end

sz_img=[size(img,2) size(img,1)];
sz_img=scale_ft*sz_img;
center_word=center_sc+scale_ft*[-5 -15]; % center word not in middle of image
center_word=center_word+word_offset;
pos_img=[center_word-.5*sz_img center_word+.5*sz_img];


% puts an instruction on the screen to start the experiment
Screen('FillRect',Sc.window,[255 255 255], trig_rect);
Screen('DrawText',Sc.window, 'press ENTER to start',center_sc(1)/20,center_sc(2));
Screen('Flip',Sc.window);

wait = true;
disp('Press RETURN to continue');
while wait
    [unused unused button] = collect_response();
    if strcmp(button, 'Return'), wait = false;end
end


%% Display experiment
% FlushEvents

% INSTRUCTION 
Screen('DrawText',Sc.window, 'press 9 for word',center_sc(1)/20,center_sc(2)+50);
Screen('DrawText',Sc.window, 'press 1 for no word',center_sc(1)/20,center_sc(2)-50);
% Screen('FillRect',Sc.window,[255 255 255], trig_rect); % ECoG
instr_time1 = Screen('Flip',Sc.window);

% and blank after T_instr seconds
% Screen('FillRect',Sc.window,[0 0 0], trig_rect); % ECoG
instr_time2 = Screen('Flip',Sc.window,instr_time1+T_instr);
% blank with red dot for 1 sec before starting trial
% Screen('FillRect',Sc.window,[0 0 0], trig_rect); % ECoG
Screen('FillOval',Sc.window,[255 0 0], [center_sc-oval_s center_sc+oval_s]);
start_trialT=Screen('Flip',Sc.window,instr_time2+1);

for t = 1:length(trials)
    frame = 1;
    %%%%%%% BUTTON PRESS CONDITION
    
    %-- present stimuli 
    for s = 1:length(trials(t).pointer) 
        %-- prepare stimuli s
%         Screen('FillRect',Sc.window,[255 255 255], trig_rect); % ECoG
        if ismember(run_nr,[1,2,3,4]) % left/right % oval over image
            Screen('DrawTexture', Sc.window, trials(t).pointer(s),[],pos_img);
            Screen('FillOval',Sc.window,[255 0 0], [center_sc-oval_s center_sc+oval_s]);
        elseif ismember(run_nr,[5,6]) % center % oval under image
            Screen('FillOval',Sc.window,[255 0 0], [center_sc-oval_s center_sc+oval_s]);
            Screen('DrawTexture', Sc.window, trials(t).pointer(s),[],pos_img);
        end        
        %%% get time to show display:
        if t==1 && s==1 
            show_time=start_trialT+0.020; 
        elseif t>1 && s==1
            show_time=trials(t-1).time(end)+0.020;
        else % subsequent stims
            show_time=trials(t).time(frame-1)+trials(t).isi;
        end
        
        % wait in CPU time untill show time
        while GetSecs<show_time
            % could collect button press or something
            if GetSecs>show_time-0.010 % if we get within 20 ms
                WaitSecs(0.005);
                break
            end
        end
        %-- display on screen
        trials(t).time(frame) = Screen('Flip',Sc.window); % subtract 5 ms to not reach correct for refresh rate
        trials(t).event{frame} = 'stim';
        frame = frame+1;
    end 
        
    %-- present fixation dot - for ISI seconds after last stimulus (mask) 
    % prepare stimuli
%     Screen('FillRect',Sc.window,[0 0 0], trig_rect); % ECoG
    Screen('FillOval',Sc.window,[0 0 0], [center_sc-oval_s center_sc+oval_s]);
    % get show time
    show_time=trials(t).time(frame-1)+trials(t).isi;
    % wait in CPU time untill show time
    while GetSecs<show_time
        % could collect button press or something
        if GetSecs>show_time-0.020 % if we get within 20 ms
            WaitSecs(0.010);
            break
        end
    end
    % present stimuli:
    trials(t).time(frame) = Screen('Flip',Sc.window);
    trials(t).event{frame} = 'fix';
    frame = frame+1;
    
    %-- collect response - wait until button press
%     [resp t_resp code]  = collect_response();
    code = 0;
    while sum(code)<2
    [resp t_resp code]       = KbCheck(-1);
    trials(t).resp_t=t_resp-trials(t).time(frame-1); % after onset fixation cross
    trials(t).resp_b=code;
    end
    
%     Screen('FillRect',Sc.window,[0 0 0], trig_rect); % ECoG
    Screen('FillOval',Sc.window,[0 0 0], [center_sc-oval_s center_sc+oval_s]);
    trials(t).time(frame) = Screen('Flip',Sc.window,t_resp+ITI-0.01);
    trials(t).event{frame} = 'fix';

    %-- save results
    save([savedir subject.fileName '_' subject.run '.mat']);

end

% Screen('FillRect',Sc.window,[0 0 0], trig_rect); % ECoG
Screen('DrawText',Sc.window, 'the end...',center_sc(1)/20,center_sc(2));
Screen('Flip',Sc.window);

%%
%-- save final
save([savedir subject.fileName '_all.mat']);

% screen close all
sca;