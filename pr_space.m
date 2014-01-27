%% SPACEBAR key moves to the next screen 
% escape key will exit the experiment


function pr_space()

while 1
    [~,~,keyCode] = KbCheck;
    
    % escape key quits the experiment
    pr_escape(keyCode)
    
    if keyCode(KbName('space')) == 1 
        break
    end
        
end

end