%% Break time. Please press the space bar to continue.
% INPUT:
% 1. screen pointer
% 2. time stamp that previous screen flipped
% 3. time that previous screen must be displayed

function pr_BreakScreen(scr, prevStartTime, prevElapse)
    
    Screen('FillRect',scr,[255 255 255])
    DrawFormattedText(scr,'Break time. Press the SPACEBAR to continue.','center','center')
    Screen('Flip', scr, prevStartTime + prevElapse)
    while 1
        [~,~,keyCode] = KbCheck;
        pr_escape(keyCode)
        if keyCode(KbName('space')) == 1,
            break
        end
    end

end