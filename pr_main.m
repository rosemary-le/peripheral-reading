%% Experiment: Letter Recognition in the Periphery. 
% 
% January 2014

%% EXPERIMENT SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear all; close all
wpPath = wp_rootPath; 

% define subID and computer | print to screen to check
Exp.sub.computer    = 'laptop';
Exp.sub.ID          = 'victim00'; 
Exp.sub.time        = clock;
Exp.type            = struct('task', 'Discriminate b/w 2 alpahabets', ...
                   'stimuli', 'Individual Letters', ...
                   'duration', 'fixed', ...
                   'eccentricity', [-5,0,5], ...
                   'angle','horizontal meridian');
                                            
fprintf('computer = %s\n ID = %s\n', Exp.sub.computer, Exp.sub.ID)
pause


%% Response keys and Keyboard setup
Exp.Kb.responseKeys = {'SPACE', 'ESCAPE','g','h'}; % <--
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

%% Pre-Experiment 
clear screen
Scr.main = 0; 
[Scr.window,Scr.rect] = Screen('OpenWindow',Scr.main);
Scr.dim.width = Scr.rect(3); 
Scr.dim.height = Scr.rect(4); 
HideCursor  

%% Images into textures
% tem.img = imread('./stimuli/letters/Greek/a.png');
% tem.tex = Screen('MakeTexture', Scr.window, tem.img);

Exp.stim.greek = dir('stimuli/letters/Greek/*.png');

for ii = 1:length(Exp.stim.greek)
    tem.img = imread(['./stimuli/letters/Greek/' num2str(Exp.stim.greek(ii).name)]);
    Exp.stim.greek(ii).tex = Screen('MakeTexture', Scr.window, tem.img);
end
 
Exp.stim.roman = dir('stimuli/letters/Roman/*.png');

for ii = 1:length(Exp.stim.roman)
    tem.img = imread(['./stimuli/letters/Roman/' num2str(Exp.stim.roman(ii).name)]);
    Exp.stim.roman(ii).tex = Screen('MakeTexture', Scr.window, tem.img);
end

%% The Experiment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% define variables
% everything defined in the dur structure is in milliseconds

Exp.num.blocks  = 3;

Exp.num.runs    = 4;
Exp.dur.stim    = 500; 

Exp.color.bg    = Exp.color.gray;


% stimulus screen
Screen('Flip', Scr.window)
Screen('FillRect', Scr.window, Exp.color.bg, [])
Screen('DrawTexture', Scr.window, Exp.stim.greek(1).tex)
WaitSecs(Exp.dur.stim/1000)

% rest screen
Screen('FillRect', Scr.window, Exp.color.bg, [])
Screen('Flip', Scr.window)
WaitSecs(Exp.dur.stim/1000)

% stimulus screen
Screen('Flip', Scr.window)
Screen('FillRect', Scr.window, Exp.color.bg, [])
Screen('DrawTexture', Scr.window, Exp.stim.greek(1).tex)
WaitSecs(Exp.dur.stim/1000)

% rest screen
Screen('FillRect', Scr.window, Exp.color.bg, [])
Screen('Flip', Scr.window)
WaitSecs(Exp.dur.stim/1000)


% Screen('DrawTexture',Scr.window, Exp.stim.greek(1).tex)
% Screen('Flip',Scr.window)
% WaitSecs(2)




%% End Experiment
Screen('CloseAll')