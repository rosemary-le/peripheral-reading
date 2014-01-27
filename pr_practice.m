%% Experiment: Letter Recognition in the Periphery. 
% 
% January 2014

%% EXPERIMENT SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear all; close all; 
Screen('CloseAll')
format long;

Exp.path = pr_rootPath; 

% define subID and computer | print to screen to check
Exp.sub.computer    = 'vistalab';
Exp.sub.name        = ':)';
Exp.sub.ID          = 'PRACTICE'; 
Exp.sub.time        = clock;
Exp.type            = struct('task', 'Discriminate b/w 2 alpahabets', ...
                   'stimuli', 'Individual Letters', ...
                   'scaling', 'varied', ...
                   'duration', 'fixed', ...
                   'eccentricity', [[-5,0];[0,0];[5,0]]);
               
% eccentricity refers to (x,y) point on the screen, origin is the center of the screen
     
fprintf('computer = %s\n ID = %s\n', Exp.sub.computer, Exp.sub.ID)
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
switch Exp.sub.computer 
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
Exp.color.gray = [128 128 128];
Exp.color.white = [255 255 255];
Exp.color.black = [0 0 0];

%% Psychtoolbox Screen Setup
clear screen 
[Exp.scr.window,Exp.scr.rect.full] = Screen('OpenWindow',Exp.scr.main);
Exp.scr.dim.w = Exp.scr.rect.full(3);
Exp.scr.dim.h = Exp.scr.rect.full(4); 
HideCursor  

%% Images into textures

Exp.stim.greek = dir('stimuli/letters/Greek/*.png');

for ii = 1:length(Exp.stim.greek)
    tem.img = imread(['./stimuli/letters/Greek/' num2str(Exp.stim.greek(ii).name)]);
    Exp.stim.greek(ii).tex = Screen('MakeTexture', Exp.scr.window, tem.img);
    Exp.stim.greek(ii).size = size(tem.img);
end
 
Exp.stim.roman = dir('stimuli/letters/Roman/*.png');

for ii = 1:length(Exp.stim.roman)
    tem.img = imread(['./stimuli/letters/Roman/' num2str(Exp.stim.roman(ii).name)]);
    Exp.stim.roman(ii).tex = Screen('MakeTexture', Exp.scr.window, tem.img);
    Exp.stim.roman(ii).size = size(tem.img);
end



%% define variables & intialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% everything defined in the dur structure is in seconds

Exp.num.runs            = 15; % 1 foveal condition, 7 conditions at each eccentric location
Exp.num.inRun           = 2; % real value: 20 or greater
Exp.num.beforeBreak     = 15;

Exp.dur.stim            = 1; 
Exp.dur.interStim       = 0.1; 
Exp.color.bg            = Exp.color.gray;

%% define center screen coordinates (single point) for given conditions
% (x,y) coordinates
Exp.scr.loc.fov.center  = [Exp.scr.dim.w/2, Exp.scr.dim.h/2];   % screen coordinates for foveal fixation
Exp.scr.loc.r1.center   = pr_screenCoord(Exp.scr, 5, 0);        % screen coordinates for 5 deg rightward, horizontal meridian
Exp.scr.loc.r2.center   = pr_screenCoord(Exp.scr, 5, 0);        % screen coordinates for 5 deg rightward, horizontal meridian
Exp.scr.loc.r3.center   = pr_screenCoord(Exp.scr, 5, 0);        % screen coordinates for 5 deg rightward, horizontal meridian
Exp.scr.loc.r4.center   = pr_screenCoord(Exp.scr, 5, 0);        % screen coordinates for 5 deg rightward, horizontal meridian
Exp.scr.loc.r5.center   = pr_screenCoord(Exp.scr, 5, 0);        % screen coordinates for 5 deg rightward, horizontal meridian
Exp.scr.loc.r6.center   = pr_screenCoord(Exp.scr, 5, 0);        % screen coordinates for 5 deg rightward, horizontal meridian
Exp.scr.loc.r7.center   = pr_screenCoord(Exp.scr, 5, 0);        % screen coordinates for 5 deg rightward, horizontal meridian

Exp.scr.loc.l1.center   = pr_screenCoord(Exp.scr, -5, 0);        % screen coordinates for 5 deg leftward, horizontal meridian
Exp.scr.loc.l2.center   = pr_screenCoord(Exp.scr, -5, 0);        % screen coordinates for 5 deg leftward, horizontal meridian
Exp.scr.loc.l3.center   = pr_screenCoord(Exp.scr, -5, 0);        % screen coordinates for 5 deg leftward, horizontal meridian
Exp.scr.loc.l4.center   = pr_screenCoord(Exp.scr, -5, 0);        % screen coordinates for 5 deg rightward, horizontal meridian
Exp.scr.loc.l5.center   = pr_screenCoord(Exp.scr, -5, 0);        % screen coordinates for 5 deg rightward, horizontal meridian
Exp.scr.loc.l6.center   = pr_screenCoord(Exp.scr, -5, 0);        % screen coordinates for 5 deg rightward, horizontal meridian
Exp.scr.loc.l7.center   = pr_screenCoord(Exp.scr, -5, 0);        % screen coordinates for 5 deg rightward, horizontal meridian


%% define screen coordinates (rectangle) that image will occupy 
% [RectLeft RectTop RectRight RectBottom]

Exp.scr.loc.fov.rect    = pr_makeRectCoord(Exp.scr.loc.fov.center,[115 60],.2);
Exp.scr.loc.r1.rect     = pr_makeRectCoord(Exp.scr.loc.r1.center,[115 60], .4);
Exp.scr.loc.r2.rect     = pr_makeRectCoord(Exp.scr.loc.r2.center,[115 60], .5);
Exp.scr.loc.r3.rect     = pr_makeRectCoord(Exp.scr.loc.r3.center,[115 60], .6);
Exp.scr.loc.r4.rect     = pr_makeRectCoord(Exp.scr.loc.r4.center,[115 60],.7);
Exp.scr.loc.r5.rect     = pr_makeRectCoord(Exp.scr.loc.r5.center,[115 60],.8);
Exp.scr.loc.r6.rect     = pr_makeRectCoord(Exp.scr.loc.r6.center,[115 60],.9);
Exp.scr.loc.r7.rect     = pr_makeRectCoord(Exp.scr.loc.r7.center,[115 60],1);

Exp.scr.loc.l1.rect     = pr_makeRectCoord(Exp.scr.loc.l1.center,[115 60],.4);
Exp.scr.loc.l2.rect     = pr_makeRectCoord(Exp.scr.loc.l2.center,[115 60],.5);
Exp.scr.loc.l3.rect     = pr_makeRectCoord(Exp.scr.loc.l3.center,[115 60],.6);
Exp.scr.loc.l4.rect     = pr_makeRectCoord(Exp.scr.loc.l4.center,[115 60],.7);
Exp.scr.loc.l5.rect     = pr_makeRectCoord(Exp.scr.loc.l5.center,[115 60],.8);
Exp.scr.loc.l6.rect     = pr_makeRectCoord(Exp.scr.loc.l6.center,[115 60],.9);
Exp.scr.loc.l7.rect     = pr_makeRectCoord(Exp.scr.loc.l7.center,[115 60],1);


%% randomly choose between Greek or Roman letters
% first row dinstinguishes between greek or roman (1 = greek, 2 = roman)
% second row distinguishes between the 26 letters

Response.actual.letter          = zeros(2, Exp.num.inRun*Exp.num.runs); 
Response.actual.letter(1,:)     = randi(2, 1, Exp.num.inRun*Exp.num.runs);
Response.actual.letter(2,:)     = randi(26, 1, Exp.num.inRun*Exp.num.runs);
 
%% define actual condition
% fov, r1,r1,r3,r4,r5,r6,r7,l1, l2, l3, l4, l5, l6, l7
% 1,    2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
tem.fov = repmat(1,1,Exp.num.inRun);
tem.r1  = repmat(2,1,Exp.num.inRun);
tem.r2  = repmat(3,1,Exp.num.inRun);
tem.r3  = repmat(4,1,Exp.num.inRun);
tem.r4  = repmat(5,1,Exp.num.inRun);
tem.r5  = repmat(6,1,Exp.num.inRun);
tem.r6  = repmat(7,1,Exp.num.inRun);
tem.r7  = repmat(8,1,Exp.num.inRun);
tem.l1  = repmat(9,1,Exp.num.inRun);
tem.l2  = repmat(10,1,Exp.num.inRun);
tem.l3  = repmat(11,1,Exp.num.inRun);
tem.l4  = repmat(12,1,Exp.num.inRun);
tem.l5  = repmat(13,1,Exp.num.inRun);
tem.l6  = repmat(14,1,Exp.num.inRun);
tem.l7  = repmat(15,1,Exp.num.inRun);

% randomize conditions
tem.rand = Shuffle(1:15); 

tem.list.cond = [tem.fov; tem.r1; tem.r2; tem.r3; tem.r4; tem.r5; tem.r6; tem.r7; ...
                 tem.l1; tem.l2; tem.l3; tem.l4; tem.l5; tem.l6; tem.l7];

Response.actual.cond = zeros(1,Exp.num.runs * Exp.num.inRun); 
for ii = 1:length(tem.rand)
    ind = tem.rand(ii);
    tem.a = Exp.num.inRun; 
    Response.actual.cond(1,tem.a*ii-(tem.a-1):tem.a*ii) = tem.list.cond(ind,:); 
end

%% initialize response structure
% first row indicates keyboard response
% second row indicates time to response
% third row indicates condition

Response.subject = cell(3,Exp.num.inRun*Exp.num.runs);

%% Practice Trials % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%% The Experiment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Instruction screens % ------------------------------------------------

% Screen('TextSize', Exp.scr.window, 30)
% DrawFormattedText(Exp.scr.window, 'Roman characters:', 'center', Exp.scr.dim.h/2 - 100, Exp.color.black)
% Screen('Flip', Exp.scr.window)
% pr_space()
% 
% Screen('TextSize', Exp.scr.window, 30)
% DrawFormattedText(Exp.scr.window, 'Greek characters:', 'center', Exp.scr.dim.h/2 - 100, Exp.color.black)
% Screen('Flip', Exp.scr.window)
% WaitSecs(0.25);
% pr_space()

Screen('TextSize', Exp.scr.window, 30)
DrawFormattedText(Exp.scr.window, 'Press [g] for Greek letters. \n Press [h] for Roman letters. \n', 'center', 'center', Exp.color.black, [],[],[],1.5)
Screen('TextSize', Exp.scr.window, 18)
DrawFormattedText(Exp.scr.window, '[Press the SPACEBAR to start the practice trials]', 'center', Exp.scr.dim.h - 60, Exp.color.gray)
DrawFormattedText(Exp.scr.window, 'Maintain fixation at all times.', 'center', Exp.scr.dim.h - 100, Exp.color.gray)
Screen('Flip', Exp.scr.window)
pr_space()


%% Stimulus Screens % ---------------------------------------------------
% compile all the rectCoords here
tem.list.rectCoord = [Exp.scr.loc.fov.rect; Exp.scr.loc.r1.rect; Exp.scr.loc.r2.rect; Exp.scr.loc.r3.rect; ...
                    Exp.scr.loc.r4.rect; Exp.scr.loc.r5.rect;Exp.scr.loc.r6.rect; Exp.scr.loc.r7.rect;...
                    Exp.scr.loc.l1.rect; Exp.scr.loc.l2.rect; Exp.scr.loc.l3.rect; Exp.scr.loc.l4.rect; ...
                    Exp.scr.loc.l5.rect;Exp.scr.loc.l6.rect; Exp.scr.loc.l7.rect;]; 



for ii = 1: (Exp.num.runs*Exp.num.inRun)
    
    %% Fixation before starting each run
    if mod(ii-1,Exp.num.beforeBreak) == 0
        
        % initialize start time
        tem.timeStart = GetSecs;
        
        Screen('FillRect', Exp.scr.window, Exp.color.bg, [])
        pr_drawFixation(Exp.scr)
        tem.timeStart = Screen('Flip', Exp.scr.window, tem.timeStart + Exp.dur.stim);
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
    tem.rectCoord = tem.list.rectCoord(tem.cond,:);
    
    %% Determine the alphabet
    
    % if Greek
    if tem.alphabet == 1 
        Screen('DrawTexture', Exp.scr.window, Exp.stim.greek(tem.letterInd).tex, [], tem.rectCoord)
        % Present fixation dot if not foveal condition
        if tem.cond ~=1, pr_drawFixation(Exp.scr); end
    end
    
    % if Roman
    if tem.alphabet == 2 
        Screen('DrawTexture', Exp.scr.window, Exp.stim.roman(tem.letterInd).tex, [], tem.rectCoord)
        % Present fixation dot if not foveal condition
        if tem.cond ~=1, pr_drawFixation(Exp.scr); end
    end
    
    % Flip
    tem.timeStart = Screen('Flip', Exp.scr.window, tem.timeStart + Exp.dur.stim);
   
    %% collect response
    [tem.resp,tem.timeElapsed] = pr_collectResponse(Exp.dur.stim, tem.timeStart);
    Response.subject{1,ii} = tem.resp; 
    Response.subject{2,ii} = tem.timeElapsed;
    Response.subject{3,ii} = tem.cond; 
    
    %% interstimulus resting screen
    
    if Exp.dur.interStim ~= 0
        Screen('FillRect', Exp.scr.window, Exp.color.gray)
        
        % Present fixation dot if not foveal condition
        if tem.cond ~=1, pr_drawFixation(Exp.scr); end
        
        tem.timeStart = Screen('Flip', Exp.scr.window, tem.timeStart + Exp.dur.interStim); 
    end
    
    %% Provide a break after every Exp.num.break trials
    
    if mod(ii,Exp.num.beforeBreak) == 0,
        pr_BreakScreen(Exp.scr.window)
        WaitSecs(0.25)
    end
    
    
end


%% Ending Screen % ------------------------------------------------------
Screen('FillRect', Exp.scr.window, Exp.color.white)
Screen('TextSize', Exp.scr.window, 24);
DrawFormattedText(Exp.scr.window, 'Thank you. This concludes the experiment.','center','center',[0 0 0]);
Screen('TextSize', Exp.scr.window, 18)
DrawFormattedText(Exp.scr.window, '(Please press the SPACEBAR)', 'center', Exp.scr.dim.h/2 + 50, Exp.color.gray)
Screen('Flip', Exp.scr.window);  
pr_space()


%% End Experiment
Screen('CloseAll')
 


%%
Response.subject = reshape(Response.subject, 3, Exp.num.inRun, Exp.num.runs); 
Response.actual.letter = reshape(Response.actual.letter, 2, Exp.num.inRun, Exp.num.runs); 

