%% draw fixation dot
% but with no flipping

% INPUTS:
% 1. p is a structure with fields
%     - 'window': main screen window
%     - 'dim.w': width of screen
%     - 'dim.h': height of screen

function pr_drawFixation(p)

tem = 3;  % radius of fixation circle
fromH = p.dim.w/2 - tem;
fromV = p.dim.h/2 - tem;
toH   = p.dim.w/2 + tem;
toV   = p.dim.h/2 + tem; 

Screen('FillOval', p.window , [0 0 0], [fromH fromV toH toV])

end