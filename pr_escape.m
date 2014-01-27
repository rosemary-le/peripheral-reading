%% ESCAPE key quits the experiment
%
% can be used as a subfunction, in which case, provide keyCode as an
% argument
%
% can be used on its own, in which case, no arguments are needed


function pr_escape(keyCode)

if nargin == 0
    while 1
        [~,~,keyCode] = KbCheck;
        if keyCode(KbName('ESCAPE')) == 1 
            Screen('CloseAll')
        end
    end
end

if nargin == 1
   if keyCode(KbName('ESCAPE')) == 1
       Screen('CloseAll')
   end
end

end