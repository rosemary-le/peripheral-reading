function Sc = start_psychtb(debug)
if nargin < 1, debug = false; end
%% ---------------------- start psych toolbox ----------------------------

try    Screen('CloseAll'); end;                                             % reset psych toolbox

gamma       = 2.2;
contrastmax = 100;                                                          % maximal contrast = 100%, this is used for the test and dummy patches
Sc.ppd      = 30;                                                           % pixels per degree of visual angle (assuming ~60 cm between screen and participants' eyes)

%-- editable parameters
Sc.size = [400 400];                                                        % size of the screen
% Sc.size = [1440 900];                                                       % size of the screen
if debug
    Sc.position = [50 50 50+(Sc.size + 1)];                                          % screen position
else
    Sc.position = [];
end
Sc.bkgCol = [128 128 128];
Sc.nb = 1; % 1 for second screen
Sc.frameDuration = 1;                                                       % update screen every x refresh


% setup hardware
AssertOpenGL;
res = Screen('Resolution',Sc.nb);
res.width = Sc.size(1);
res.height = Sc.size(2);
[Sc.window, Sc.rect] = Screen('OpenWindow', Sc.nb, Sc.bkgCol,Sc.position);  % start psychtoobox window

[Sc.x,Sc.y] = Screen('WindowSize',Sc.window);
Sc.fps = Screen('FrameRate',Sc.window);
Sc.nbfi = Screen('GetFlipInterval',Sc.window,100,50e-6,10);
Priority(MaxPriority(Sc.window));
Screen('FillRect', Sc.window, Sc.bkgCol);                                   % fill background color
Screen('Flip',Sc.window);
Screen('ColorRange',Sc.window,1);
Screen('TextFont',Sc.window,'Calibri');
Screen('TextSize',Sc.window,round(1*Sc.ppd));


Sc.center = round(Sc.rect(3:4)./2);
Sc.center(1) = Sc.center(1) - 1;