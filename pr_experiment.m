%% Experiment: Letter Recognition in the Periphery. 
% January 2014

%% EXPERIMENT SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear all; close all; Screen('CloseAll')
format long;

Exp.path = pr_rootPath; 

% define subID and computer | print to screen to check
Exp.subject.computer    = 'air';
Exp.subject.name        = ':)';
Exp.subject.ID          = 'sub00'; 
Exp.subject.time        = clock;
Exp.subject.note        = ''; 
               
fprintf('computer = %s\n ID = %s\n', Exp.subject.computer, Exp.subject.ID)
pause 

%% Response keys and Keyboard setup
Exp.Kb.responseKeys = {'SPACE', 'ESCAPE','g','h'}; %
% KbName('KeyNamesOSX'); % will print out table of all keycode -> keyname mappings  

% acquire key codes that will be used
KbName('UnifyKeyNames');
Exp.Kb.CheckList = zeros(1,length(Exp.Kb.responseKeys));
for ii = 1:length(Exp.Kb.responseKeys)
    Exp.Kb.CheckList(ii) = KbName(Exp.Kb.responseKeys{ii}); 
end

% save time by restricting the keys that will be checked
RestrictKeysForKbCheck(Exp.Kb.CheckList);


%% Switch parameters according to which computer is in use

switch Exp.subject.computer 
    case 'air'
        Exp.scr.main = 0;
        Exp.scr.siz = [28.64707 17.9044242];    % screen size
        Exp.scr.res = [1440 900];               % resolution
        Exp.scr.vdist = 57;                     % viewing distance in cm
        
    case 'pro'
        Exp.scr.main = 0;
        Exp.scr.siz = [28.64707 17.9044242];    % screen size
        Exp.scr.res = [1280 800];               % resolution
        Exp.scr.vdist = 57;                     % viewing distance in cm
        
    case 'vistalab' % Dell
        Exp.scr.main = 1;
        Exp.scr.siz = [41.458 33.5614];         % screen size
        Exp.scr.res = [1344 1008];              % resolution
        Exp.scr.vdist = 57;                     % viewing distance in cm
        
    case 'eyetracking'
%         Exp.scr.main = 0;
%         Exp.scr.siz = [];               % screen size
%         Exp.scr.res = [];               % resolution
%         Exp.scr.vdist = [];             % viewing distance in cm
        
    case 'scanner'     
%         Exp.scr.main = 0;
%         Exp.scr.siz = [];               % screen size
%         Exp.scr.res = [];               % resolution
%         Exp.scr.vdist = [];             % viewing distance in cm

end

%% colors
Exp.color.gray  = [128 128 128];
Exp.color.white = [255 255 255];
Exp.color.black = [0 0 0];
Exp.color.teal  = [0 40 200]; 

%% Psychtoolbox Screen Setup
clear screen 
[Exp.scr.window,Exp.scr.rect.full] = Screen('OpenWindow',Exp.scr.main);
Exp.scr.dim.w = Exp.scr.rect.full(3);
Exp.scr.dim.h = Exp.scr.rect.full(4); 
HideCursor  

%% Images into textures
Exp.stim.pseudo = dir('stimuli/letters/RomanPseudo/*.jpg');

for ii = 1:length(Exp.stim.pseudo)
    tem.img = imread(['./stimuli/letters/RomanPseudo/' num2str(Exp.stim.pseudo(ii).name)]);
    Exp.stim.pseudo(ii).tex = Screen('MakeTexture', Exp.scr.window, tem.img);
    Exp.stim.pseudo(ii).size = size(tem.img);
end
 
Exp.stim.roman = dir('stimuli/letters/Roman/*.jpg');

for ii = 1:length(Exp.stim.roman)
    tem.img = imread(['./stimuli/letters/Roman/' num2str(Exp.stim.roman(ii).name)]);
    Exp.stim.roman(ii).tex = Screen('MakeTexture', Exp.scr.window, tem.img);
    Exp.stim.roman(ii).size = size(tem.img);
end

%% define experiment conditions

% list of eccentricities (centers)
Exp.eccentricities = [ ...
    [-10,0]; ...          
    [-7,0]; ...          
    [-5,0]; ...        
    [-4,0]; ...          
    [-3,0]; ...        
    [-2,0]; ...          
    [-1,0]; ...          
    [0,0]; ...          
    [1,0]; ...         
    [2,0]; ...       
    [3,0]; ...         
    [4,0]; ...       
    [5,0]; ...         
    [7,0]; ...         
    [10,0]; ...         
    ]; 
  
% list of scalings
Exp.scales = [ ...        
    [1]; ...         
    []; ...             
    []; ...             
    []; ...             
    []; ...             
    []; ...             
    []; ...            
    []; ...             
    []; ...            
    []; ...             
    ];
  
% list of stimulus durations
Exp.durations = [...
    [0.1]; ...
    []; ...
    []; ...
    []; ...
    []; ...
    []; ...
    []; ...
    []; ...
    ];


%% define screen coordinates that image will occupy for each condition

tem.imgsize = Exp.stim.roman(1).size; % assuming all images are same size 
tem.len.k   = size(Exp.durations,1);
tem.len.j   = size(Exp.scales,1);
tem.len.i   = size(Exp.eccentricities,1);

for kk = 1:size(Exp.durations)
    for jj = 1:size(Exp.scales,1)
        for ii = 1:size(Exp.eccentricities,1)

            ind = (kk-1)*tem.len.j*tem.len.i + (jj-1)*tem.len.i + ii;
            tem.s = Exp.scales(jj);
            tem.e = Exp.eccentricities(ii,:);
            tem.d = Exp.durations(kk);
            
            tem.rectCoord       = pr_makeRectCoord(pr_screenCoord(Exp.scr, tem.e(1), tem.e(2)), tem.imgsize, tem.s);
            Exp.cond(ind).rect  = tem.rectCoord;
            Exp.cond(ind).scale = tem.s; 
            Exp.cond(ind).ecc   = tem.e; 
            Exp.cond(ind).dur   = tem.d;  

        end
    end
end

%% define variables & intialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% everything defined in the dur structure is in seconds

Exp.num.conds           = length(Exp.cond); % number of conditions
Exp.num.trialspercond   = 50; 
Exp.num.totalTrials     = Exp.num.trialspercond * Exp.num.conds; 
Exp.num.inRun           = 50; 
Exp.num.runs            = Exp.num.totalTrials/Exp.num.inRun; 

Exp.dur.interStim       = .5;
Exp.dur.timeToRespond   = 5; 
Exp.color.bg            = Exp.color.gray;

Exp.img.scale           = 0.3; % scaling is fixed
Exp.img.size            = [100 100]; 

%% randomly choose between 2 classes
% first row dinstinguishes between other or roman (1 = other, 2 = roman)
% second row distinguishes between the 26 'letters'

Response.actual.letter          = zeros(2, Exp.num.totalTrials); 
Response.actual.letter(1,:)     = randi(2, 1, Exp.num.totalTrials);
Response.actual.letter(2,:)     = randi(26, 1, Exp.num.totalTrials);

%% Randomly choose conditions
% Exp.num.runs different conditions; each condition has Exp.num.inRun trials

tem.stream              = repmat((1:Exp.num.conds),1,Exp.num.trialspercond); 
Response.actual.cond    = Shuffle(tem.stream);

%% initialize response structure
% first row indicates keyboard response
% second row indicates time to response

Response.subject = cell(2,Exp.num.inRun*Exp.num.runs);

%% The Experiment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Instruction screens % ------------------------------------------------

% Screen('TextSize', Exp.scr.window, 30)
% DrawFormattedText(Exp.scr.window, 'Roman letters:', 'center', Exp.scr.dim.h/2 - 100, Exp.color.black)
% Screen('Flip', Exp.scr.window)
% pr_space()
% 
% Screen('TextSize', Exp.scr.window, 30)
% DrawFormattedText(Exp.scr.window, 'pseudo letters:', 'center', Exp.scr.dim.h/2 - 100, Exp.color.black)
% Screen('Flip', Exp.scr.window)
% WaitSecs(0.25);
% pr_space()

Screen('TextSize', Exp.scr.window, 30)
DrawFormattedText(Exp.scr.window, 'Press [g] for pseudo letters. \n Press [h] for Roman letters. \n', 'center', 'center', Exp.color.black, [],[],[],1.5)
Screen('TextSize', Exp.scr.window, 18)
DrawFormattedText(Exp.scr.window, '[Press the SPACEBAR to start the practice trials]', 'center', Exp.scr.dim.h - 60, Exp.color.gray)
DrawFormattedText(Exp.scr.window, 'Maintain fixation at all times.', 'center', Exp.scr.dim.h - 100, Exp.color.gray)
Screen('TextSize', Exp.scr.window,24)
DrawFormattedText(Exp.scr.window, 'Make your selection after the letter has disappeared from the screen.', 'center', Exp.scr.dim.h - 300, Exp.color.teal)

Screen('Flip', Exp.scr.window)
pr_space()

%% Stimulus Screens % ---------------------------------------------------


for ii = 1:Exp.num.totalTrials
    
    %% Fixation before starting each run
    if mod(ii-1,Exp.num.inRun) == 0
        
        Screen('FillRect', Exp.scr.window, Exp.color.bg, [])
        pr_drawFixation(Exp.scr)
        
        % intialize start time
        tem.timeStart = Screen('Flip', Exp.scr.window);
    end
    
    %% Backbuffer
    
    % Background screen color
    Screen('FillRect', Exp.scr.window, Exp.color.bg, [])
    
    % Grab the condition
    tem.cond = Response.actual.cond(ii);
    
    % Grab the alphabet and letter
    tem.alphabet  = Response.actual.letter(1,ii); 
    tem.letterInd = Response.actual.letter(2,ii);
    
    % Obtain rectCoords corresponding to condition
    tem.rectCoord = Exp.cond(tem.cond).rect; 
    
    %% Determine the stimulus presentation time
    tem.stimDur = Exp.cond(tem.cond).dur; 
    
    %% Determine the class and letter
    
    % if other
    if tem.alphabet == 1 
        Screen('DrawTexture', Exp.scr.window, Exp.stim.pseudo(tem.letterInd).tex, [], tem.rectCoord)
        % Present fixation dot if not foveal condition
        if tem.cond ~=1, pr_drawFixation(Exp.scr); end
    end
    
    % if Roman
    if tem.alphabet == 2 
        Screen('DrawTexture', Exp.scr.window, Exp.stim.roman(tem.letterInd).tex, [], tem.rectCoord)
        % Present fixation dot if not foveal condition
        if tem.cond ~=8, pr_drawFixation(Exp.scr); end
    end
    
    % Flip
    %tem.timeStart = Screen('Flip', Exp.scr.window, tem.timeStart + Exp.dur.interStim); % fixed interstimulus
    pr_drawFixation(Exp.scr) 
    tem.timeStart = Screen('Flip', Exp.scr.window, GetSecs + Exp.dur.interStim); % indefinite interstimulus
      
    
    %% interstimulus resting screen
    Screen('FillRect', Exp.scr.window, Exp.color.gray)

    % Present fixation dot if not foveal condition
    if tem.cond ~=8, pr_drawFixation(Exp.scr); end

    tem.timeStart = Screen('Flip', Exp.scr.window, tem.timeStart + tem.stimDur); 
    
    
    %% collect response
    [tem.resp,tem.timeElapsed, tem.timeStamp] = pr_collectResponse(Exp.dur.timeToRespond, tem.timeStart);
    Response.subject{1,ii} = tem.resp; 
    Response.subject{2,ii} = tem.timeElapsed;
    
    
    %% Provide a break after every Exp.num.break trials
    % save the data as we go along
    save(['./RESULTS/results_' num2str(Exp.subject.ID) '.mat'],'Response')
    save(['./SETTINGS/settings_' num2str(Exp.subject.ID) '.mat'],'Exp')
    
    if mod(ii,Exp.num.inRun) == 0,
        pr_BreakScreen(Exp.scr.window, tem.timeStart, Exp.dur.interStim)
    end
    
    
end


Screen('CloseAll')