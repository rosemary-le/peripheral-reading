%% collect response from keyboard
% INPUT:
% 1. time (in seconds) that subject has to respond
% 2. time to start measuring (usually flip time)
% OUTPUT: 
% 1. response key
% 2. time to respond
% 3. timestamp of response

function [resp, timeElapsed, secs] = pr_collectResponse(timeLimit, timeStart)

% Start time
G = GetSecs;

% Record the response
while GetSecs - timeStart < timeLimit

    [keyIsDown, secs, keyCode] = KbCheck;

   if keyIsDown
       resp = KbName(keyCode);
       break % Only record the first keypress in the timeframe
   end

end

timeElapsed = secs - G; 


if ~keyIsDown
    resp = []; 
    timeElapsed = [];
end

% escape key quits the experiment
pr_escape(keyCode)

end