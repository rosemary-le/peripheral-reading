%% Experiment: Letter Recognition in the Periphery. 
% 
% January 2014

%% EXPERIMENT SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear all; close all; format long;
Exp.path = pr_rootPath; 

% define subID and computer | print to screen to check
Exp.sub.computer    = 'air';
Exp.sub.name        = ':)';
Exp.sub.ID          = 'victim00'; 
Exp.sub.time        = clock;
Exp.type            = struct('task', 'Discriminate b/w 2 alpahabets', ...
                   'stimuli', 'Individual Letters', ...
                   'scaling', 'fixed', ...
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
switch computer 
    case 'air'
        % Resolution: 1440 x 900
        % Monitor Size: 28.7 x 27.9
    case 'laptop'
        % Resolution: 1280 x 800
        % Monitor Size: 28.7 x 27.9

    case 'scanner'     
        % Resolution: 
        % Monitor:
        
    case 'vistalab'
        % Resolution: 
        % Monitor:
        
    case 'eyetracking'
        % Resolution: 
        % Monitor:

end

%% colors
Exp.color.gray = [128 128 128];
Exp.color.white = [255 255 255];
Exp.color.black = [0 0 0];

%% Psychtoolbox Screen Setup
clear screen
Exp.scr.main = 0; 
[Exp.scr.window,Exp.scr.rect.full] = Screen('OpenWindow',Exp.scr.main);
Exp.scr.dim.w = Exp.scr.rect.full(3);
Exp.scr.dim.h = Exp.scr.rect.full(4); 
HideCursor  

%% Images into textures

Exp.stim.greek = dir('stimuli/letters/Greek/*.png');

for ii = 1:length(Exp.stim.greek)
    tem.img = imread(['./stimuli/letters/Greek/' num2str(Exp.stim.greek(ii).name)]);
    Exp.stim.greek(ii).tex = Screen('MakeTexture', Exp.scr.window, tem.img);
end
 
Exp.stim.roman = dir('stimuli/letters/Roman/*.png');

for ii = 1:length(Exp.stim.roman)
    tem.img = imread(['./stimuli/letters/Roman/' num2str(Exp.stim.roman(ii).name)]);
    Exp.stim.roman(ii).tex = Screen('MakeTexture', Exp.scr.window, tem.img);
end



%% define variables & intialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% everything defined in the dur structure is in seconds

Exp.num.blocks          = 3; % number of retinal locations
Exp.num.factors         = 3; % number of different scalings
Exp.num.runs            = Exp.num.blocks * Exp.num.factors; 
Exp.num.inRun           = 5; % real value: 20 or greater
Exp.num.beforeBreak     = Exp.num.inRun;


Exp.dur.stim            = 1; 
Exp.color.bg            = Exp.color.gray;

%% define centers and destintationRects
% [RectLeft RectTop RectRight RectBottom]

% defining center point at each location on screen in (x,y) coordinates
Exp.scr.center.full     = [Exp.scr.dim.w/2, Exp.scr.dim.h/2];   % center of full screen
Exp.scr.center.fovea    = Exp.scr.center.full;                  % center of foveal vision, same as full screen
Exp.scr.center.r5       = [1690,Exp.scr.dim.h/2];
Exp.scr.center.l5       = [1190,Exp.scr.dim.h/2];


%% randomly choose between Greek or Roman letters
% first row dinstinguishes between greek or roman (1 = greek, 2 = roman)
% second row distinguishes between the 26 letters

Response.actual.letter          = zeros(2, Exp.num.inRun*Exp.num.runs); 
Response.actual.letter(1,:)     = randi(2, 1, Exp.num.inRun*Exp.num.runs);
Response.actual.letter(2,:)     = randi(26, 1, Exp.num.inRun*Exp.num.runs);


%% The Experiment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Instruction screen % ------------------------------------------------

Screen('TextSize', Exp.scr.window, 25)
DrawFormattedText(Exp.scr.window, WrapString('[More detailed instructions here]. Press the SPACEBAR to continue.'),'center','center')
Screen('Flip', Exp.scr.window)
pr_space()


%% Stimulus Screens % ---------------------------------------------------

% initialize start time
tem.timeStart = GetSecs;

for ii = 1: (Exp.num.runs*Exp.num.inRun)
    
    % Background screen
    Screen('FillRect', Exp.scr.window, Exp.color.bg, [])
    
    % Determine the letter
    tem.letterInd = ***
    
    
    %% Determine the alphabet
    % if Greek
    if Response.actual(1,ii) == 1 
        Screen('DrawTexture', Exp.scr.window, Exp.stim.greek(tem.letterInd).tex, [], tem.rectCoord)
    end
    
    % if Roman
    if Response.actual(1,ii) == 2 
        Screen('DrawTexture', Exp.scr.window, Exp.stim.roman(tem.letterInd).tex, [], tem.rectCoord)
    end
    
    % Flip
    tem.timeStart = Screen('Flip', Exp.scr.window, tem.timeStart + Exp.dur.stim);
   
    %% collect response
    [tem.resp,tem.timeElapsed] = pr_collectResponse(Exp.dur.stim, tem.timeStart);
    Response.subject{1,ii} = tem.resp; 
    Response.subject{2,ii} = tem.timeElapsed; 
    
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
DrawFormattedText(Exp.scr.window, '(Please press the SPACEBAR)', 'center', Exp.scr.dim.height/2 + 50, Exp.color.gray)
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
Response.subject = reshape(Response.subject, 2, Exp.num.inRun, Exp.num.runs); 
Response.actual.letter = reshape(Response.actual.letter, 2, Exp.num.inRun, Exp.num.runs); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% this is testing a color

clear screen
Exp.scr.main = 0; 
[Exp.scr.window,Exp.scr.rect.full] = Screen('OpenWindow',Exp.scr.main);
Exp.scr.dim.w = Exp.scr.rect.full(3);
Exp.scr.dim.h = Exp.scr.rect.full(4); 
HideCursor  

Screen('TextSize',Exp.scr.window,40)
DrawFormattedText(Exp.scr.window,'Hello','center','center', [0 100 140]);  
Screen('Flip', Exp.scr.window)
pr_space()  
 
Screen('CloseAll')