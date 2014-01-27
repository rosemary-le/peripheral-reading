%% display every font available

fontlist = listfonts;
for i = 1:length(fontlist)
close all; img = renderText('Rosemary',fontlist{i}); imshow(img)
fontlist{i} % print the fontname
pause
end 

%% display all characters if a single font

img = renderText('abcdefghijklmnopqrstuvwxyz123456789*/-+!@#$%^&*()','Courier'); imshow(img)

%% randomly display words

% Work | Word presentation
numWordsInChunk = stimTime / (wordTime + waitTime);         % how many words to present within [stimTime] seconds?
randString = randi(numLibrary,[1,numWordsInChunk]);         % generate random number string to randomly choose words for a trial

for i = 1:numWordsInChunk
    rnum = randString(i);
    texind = eval(sprintf('tex_%i',rnum));
    Screen('FillRect',window,gray,[])
    Screen('DrawTexture',window, texind)
    Screen('Flip',window)
    WaitSecs(wordTime)
    
    Screen('FillRect',window,gray)
    Screen('Flip',window)
    WaitSecs(waitTime)
end

% Rest | Blank Gray Screen
Screen('FillRect',window,gray,[])
Screen('Flip',window)
WaitSecs(stimTime)

%% Images --> Textures
load words

for i = 1:length(words)
    word    = words{i};
    img     = imread(num2str(['./stimuli/word4/' word '.bmp']));
    pretex  = Screen('MakeTexture',window,img); 
    eval(sprintf('tex_%i = pretex;',i));
end

for i = 1:length(words)
    word    = words{i};
    img     = imread(num2str(['./stimuli/scramble40/' word '.bmp']));
    pretex  = Screen('MakeTexture',window,img); 
    eval(sprintf('tex40_%i = pretex;',i));
end

%%

Exp.scr.loc.fov.rect    = pr_makeRectCoord(Exp.scr.loc.fov.center,18,30);
Exp.scr.loc.r1.rect     = pr_makeRectCoord(Exp.scr.loc.r1.center,22,34);
Exp.scr.loc.r2.rect     = pr_makeRectCoord(Exp.scr.loc.r2.center,28,40);
Exp.scr.loc.r3.rect     = pr_makeRectCoord(Exp.scr.loc.r3.center,38,50);
Exp.scr.loc.l1.rect     = pr_makeRectCoord(Exp.scr.loc.l1.center,22,34);
Exp.scr.loc.l2.rect     = pr_makeRectCoord(Exp.scr.loc.l2.center,28,40);
Exp.scr.loc.l3.rect     = pr_makeRectCoord(Exp.scr.loc.l3.center,38,50);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% pr_main

%% Experiment: Letter Recognition in the Periphery. 
% 
% January 2014

%% EXPERIMENT SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear all; close all; 
Screen('CloseAll')
format long;

Exp.path = pr_rootPath; 

% define subID and computer | print to screen to check
Exp.sub.computer    = 'air';
Exp.sub.name        = ':)';
Exp.sub.ID          = 'victim00'; 
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
Exp.num.inRun           = 25; % real value: 20 or greater
Exp.num.beforeBreak     = Exp.num.inRun;

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

% Define actual conditions
Response.actual.cond = zeros(1,Exp.num.runs * Exp.num.inRun); 
for ii = 1:length(tem.rand)
    ind = tem.rand(ii);
    tem.a = Exp.num.inRun; 
    Response.actual.cond(1,tem.a*ii-(tem.a-1):tem.a*ii) = tem.list.cond(ind,:); 
end

%% initialize response structure
% first row indicates keyboard response
% second row indicates time to response

Response.subject = cell(2,Exp.num.inRun*Exp.num.runs);


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
    
    %% interstimulus resting screen
    
    if Exp.dur.interStim ~= 0
        Screen('FillRect', Exp.scr.window, Exp.color.gray)
        
        % Present fixation dot if not foveal condition
        if tem.cond ~=1, pr_drawFixation(Exp.scr); end
        
        tem.timeStart = Screen('Flip', Exp.scr.window, tem.timeStart + Exp.dur.interStim); 
    end
    
    %% Provide a break after every Exp.num.break trials
    % save the data as we go along
    save(['./RESULTS/results_' num2str(Exp.sub.ID) '.mat'],'Response')
    save(['./SETTINGS/settings_' num2str(Exp.sub.ID) '.mat'],'Exp')
    
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
 

%% Final Save

% save subject's response in RESULTS folder
save(['./RESULTS/' num2str(Exp.sub.ID) '.mat'],'Response')   

% save subject's settings in SETTINGS folder
save(['./SETTINGS/' num2str(Exp.sub.ID) '.mat'],'Exp')


%%
Response.subject = reshape(Response.subject, 3, Exp.num.inRun, Exp.num.runs); 
Response.actual.letter = reshape(Response.actual.letter, 2, Exp.num.inRun, Exp.num.runs); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% pr_main2

%% Experiment: Letter Recognition in the Periphery. 
% 
% January 2014

%% EXPERIMENT SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear all; close all; 
Screen('CloseAll')
format long;

Exp.path = pr_rootPath; 

% define subID and computer | print to screen to check
Exp.subject.computer    = 'air';
Exp.subject.name        = ':)';
Exp.subject.ID          = 'victim00'; 
Exp.subject.time        = clock;
Exp.type            = struct('task', 'Discriminate b/w 2 letters and pseudo letters', ...
                   'stimuli', 'Individual Letters', ...
                   'scaling', 'fixed', ...
                   'duration', 'fixed', ...
                   'eccentricity', [[-5,0];[0,0];[5,0]]);
               
% eccentricity refers to (x,y) point on the screen, origin is the center of the screen
     
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

%% define variables & intialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% everything defined in the dur structure is in seconds

Exp.num.runs            = 15; % 1 foveal condition, 7 conditions right, 7 conditions left
Exp.num.inRun           = 25; % real value: 20 or greater
Exp.num.inRun     = Exp.num.inRun;

Exp.dur.stim            = .2; 
Exp.dur.interStim       = 1; 
Exp.color.bg            = Exp.color.gray;

Exp.img.scale           = 0.3; % scaling is fixed
Exp.img.size            = [100 100]; 

%% define center screen coordinates (single point) for given conditions
% (x,y) coordinates

Exp.scr.loc.fov.center  = [Exp.scr.dim.w/2, Exp.scr.dim.h/2];    

Exp.scr.loc.r1.center   = pr_screenCoord(Exp.scr, 1,  0);         
Exp.scr.loc.r2.center   = pr_screenCoord(Exp.scr, 1.5,0);         
Exp.scr.loc.r3.center   = pr_screenCoord(Exp.scr, 2,  0);         
Exp.scr.loc.r4.center   = pr_screenCoord(Exp.scr, 2.5,0);         
Exp.scr.loc.r5.center   = pr_screenCoord(Exp.scr, 3,  0);         
Exp.scr.loc.r6.center   = pr_screenCoord(Exp.scr, 4,  0);         
Exp.scr.loc.r7.center   = pr_screenCoord(Exp.scr, 5,  0);         

Exp.scr.loc.l1.center   = pr_screenCoord(Exp.scr, -1, 0);         
Exp.scr.loc.l2.center   = pr_screenCoord(Exp.scr, -1.5, 0);       
Exp.scr.loc.l3.center   = pr_screenCoord(Exp.scr, -2, 0);         
Exp.scr.loc.l4.center   = pr_screenCoord(Exp.scr, -2.5, 0);       
Exp.scr.loc.l5.center   = pr_screenCoord(Exp.scr, -3, 0);         
Exp.scr.loc.l6.center   = pr_screenCoord(Exp.scr, -4, 0);         
Exp.scr.loc.l7.center   = pr_screenCoord(Exp.scr, -5, 0);         

%% define screen coordinates (rectangle) that image will occupy 
% [RectLeft RectTop RectRight RectBottom]

Exp.scr.loc.fov.rect    = pr_makeRectCoord(Exp.scr.loc.fov.center,Exp.img.size,Exp.img.scale);
Exp.scr.loc.r1.rect     = pr_makeRectCoord(Exp.scr.loc.r1.center,Exp.img.size, Exp.img.scale);
Exp.scr.loc.r2.rect     = pr_makeRectCoord(Exp.scr.loc.r2.center,Exp.img.size, Exp.img.scale);
Exp.scr.loc.r3.rect     = pr_makeRectCoord(Exp.scr.loc.r3.center,Exp.img.size, Exp.img.scale);
Exp.scr.loc.r4.rect     = pr_makeRectCoord(Exp.scr.loc.r4.center,Exp.img.size, Exp.img.scale);
Exp.scr.loc.r5.rect     = pr_makeRectCoord(Exp.scr.loc.r5.center,Exp.img.size, Exp.img.scale);
Exp.scr.loc.r6.rect     = pr_makeRectCoord(Exp.scr.loc.r6.center,Exp.img.size, Exp.img.scale);
Exp.scr.loc.r7.rect     = pr_makeRectCoord(Exp.scr.loc.r7.center,Exp.img.size, Exp.img.scale);

Exp.scr.loc.l1.rect     = pr_makeRectCoord(Exp.scr.loc.l1.center,Exp.img.size, Exp.img.scale);
Exp.scr.loc.l2.rect     = pr_makeRectCoord(Exp.scr.loc.l2.center,Exp.img.size, Exp.img.scale);
Exp.scr.loc.l3.rect     = pr_makeRectCoord(Exp.scr.loc.l3.center,Exp.img.size, Exp.img.scale);
Exp.scr.loc.l4.rect     = pr_makeRectCoord(Exp.scr.loc.l4.center,Exp.img.size, Exp.img.scale);
Exp.scr.loc.l5.rect     = pr_makeRectCoord(Exp.scr.loc.l5.center,Exp.img.size, Exp.img.scale);
Exp.scr.loc.l6.rect     = pr_makeRectCoord(Exp.scr.loc.l6.center,Exp.img.size, Exp.img.scale);
Exp.scr.loc.l7.rect     = pr_makeRectCoord(Exp.scr.loc.l7.center,Exp.img.size, Exp.img.scale);


%% randomly choose between 2 classes
% first row dinstinguishes between other or roman (1 = other, 2 = roman)
% second row distinguishes between the 26 letters

Response.actual.letter          = zeros(2, Exp.num.inRun*Exp.num.runs); 
Response.actual.letter(1,:)     = randi(2, 1, Exp.num.inRun*Exp.num.runs);
Response.actual.letter(2,:)     = randi(26, 1, Exp.num.inRun*Exp.num.runs);

%% Randomly choose conditions
% Exp.num.runs different conditions; each condition has Exp.num.inRun trials

tem.stream              = repmat((1:Exp.num.runs),1,Exp.num.inRun); 
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
DrawFormattedText(Exp.scr.window, 'Make your selection after the letter has disappeared from the screen.', 'center', Exp.scr.dim.h - 150, Exp.color.black)

Screen('Flip', Exp.scr.window)
pr_space()

%% Stimulus Screens % ---------------------------------------------------
% compile all the rectCoords here
tem.list.rectCoord = [Exp.scr.loc.fov.rect; Exp.scr.loc.r1.rect; Exp.scr.loc.r2.rect; Exp.scr.loc.r3.rect; ...
                    Exp.scr.loc.r4.rect; Exp.scr.loc.r5.rect;Exp.scr.loc.r6.rect; Exp.scr.loc.r7.rect;...
                    Exp.scr.loc.l1.rect; Exp.scr.loc.l2.rect; Exp.scr.loc.l3.rect; Exp.scr.loc.l4.rect; ...
                    Exp.scr.loc.l5.rect;Exp.scr.loc.l6.rect; Exp.scr.loc.l7.rect;]; 



%% start the loop!

for ii = 1: (Exp.num.runs*Exp.num.inRun)
    
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
    tem.rectCoord = tem.list.rectCoord(tem.cond,:);
    
    %% Determine the alphabet
    
    % if Greek
    if tem.alphabet == 1 
        Screen('DrawTexture', Exp.scr.window, Exp.stim.pseudo(tem.letterInd).tex, [], tem.rectCoord)
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
    tem.timeStart = Screen('Flip', Exp.scr.window, tem.timeStart + Exp.dur.interStim);
   
    
    %% interstimulus resting screen
    
    if Exp.dur.interStim ~= 0
        Screen('FillRect', Exp.scr.window, Exp.color.gray)
        
        % Present fixation dot if not foveal condition
        if tem.cond ~=1, pr_drawFixation(Exp.scr); end

        tem.timeStart = Screen('Flip', Exp.scr.window, tem.timeStart + Exp.dur.stim); 
    end
    
    %% collect response
    [tem.resp,tem.timeElapsed] = pr_collectResponse(Exp.dur.interStim, tem.timeStart);
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% pr_experiment    -- fixed interstimulus
%% Experiment: Letter Recognition in the Periphery. 
% January 2014

%% EXPERIMENT SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear all; close all; Screen('CloseAll')
format long;

Exp.path = pr_rootPath; 

% define subID and computer | print to screen to check
Exp.subject.computer    = 'air';
Exp.subject.name        = ':)';
Exp.subject.ID          = 'victim00'; 
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
    [0,0]; ...          
    [1,0]; ...          
    [2,0]; ...        
    [3,0]; ...          
    [4.5,0]; ...        
    [5,0]; ...          
    [7,0]; ...          
    [10,0]; ...          
    [-1,0]; ...         
    [-2,0]; ...       
    [-3,0]; ...         
    [-4.5,0]; ...       
    [-5,0]; ...         
    [-7,0]; ...         
    [-10,0]; ...         
    ]; 
  
% list of scalings
Exp.scales = [ ...        
    [0.25]; ...         
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
    [0.2]; ...
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

Exp.dur.interStim       = 1; 
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
    % tem.timeStart = Screen('Flip', Exp.scr.window, tem.timeStart + Exp.dur.interStim); % fixed interstimulus
    tem.timeStart = Screen('Flip', Exp.scr.window); % indefinite interstimulus
   
    
    %% interstimulus resting screen
    
    Screen('FillRect', Exp.scr.window, Exp.color.gray)

    % Present fixation dot if not foveal condition
    if tem.cond ~=1, pr_drawFixation(Exp.scr); end

    tem.timeStart = Screen('Flip', Exp.scr.window, tem.timeStart + tem.stimDur); 
    
    
    %% collect response
    [tem.resp,tem.timeElapsed] = pr_collectResponse(Exp.dur.interStim, tem.timeStart);
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


%% pr_analyze %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




function [] = pr_analyze(Response)
% plotting results 
%
% INPUT:
% 1. Response, a structure with the following fields
%
% Response
% 	
%     actual		
%             letter
%                 first row: 1 or 2 (1 = Greek, 2 = Roman)
%                 second row: integer denoting which character in the alphabet
% 
%             cond
%                 integer denoting condition
% 			
% 	subject
%             first row: g or h
%             second row: reaction time
%
% Written by Rosemary Le, January, 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% extract variables from structure

% Loop over the response structure and create a new concatenated variable


condition       = Response.actual.cond;
actual          = Response.actual.letter(1,:);
subjectcell     = Response.subject(1,:);
subject         = zeros(1,length(actual)); % conversion into double

numtrials       = length(actual);
numconds        = length(unique(condition));
numtperc        = numtrials/numconds;
% Trials per condition
n = numtrials./numconds;

for ii = 1:length(subjectcell)
    if subjectcell{ii} == 'g', subject(ii) = 1; end
    if subjectcell{ii} == 'h', subject(ii) = 2; end 
    if ~isequal(subjectcell{ii},'g') && ~isequal(subjectcell{ii},'h'),  subject(ii) = 0; end
end


% overall accuracy
% acc_overall = sum(subject == actual)/numtrials;


%% plotting accuracy for each condition

acc_cond = zeros(1,length(numconds));   % a vector. ith element equals accuracy of ith condition


csa = [condition' subject' actual'];    % concatenate these three
CSA = sortrows(csa,1);                  % sort by condition number (first row) 

for ii = 1:numconds
    tem = CSA(((ii-1)*numtperc+1):(numtperc*ii),:);     % look at only the iith condition
    acc = sum(tem(:,2) == tem(:,3))/numtperc;           % percentage correct
    acc_cond(ii) = acc;                                 % store in matrix
    % The standard error of a proportion is SE = ?[p(1 - p)/n]
    se_cond(ii)  = sqrt(acc_cond(ii)*(1-acc_cond(ii))./n);
end

figure()
%plot(acc_cond)
errorbar(acc_cond,se_cond, '-ok','markerfacecolor','k');
title('Percantage Correct by Condition')
xlabel('Degrees from fovea')
ylabel('Accuracy')
set(gca,'XTick',0:1:numconds);
grid('on')

end