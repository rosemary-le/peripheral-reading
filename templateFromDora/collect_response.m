function [resp t code]  = collect_response(delay)
if nargin == 0, delay = inf; end
%[key time code]  = collect_response(delay)

resp                        = 0; % response key
t                           = 0; % time of response
code                        = '';
while (sum(resp) == 0 || isempty(code)) && t <= delay
        [resp t code]       = KbCheck(-1);
        % translate
        code = KbName(code);
        % only take first response if multiple responses
        if ~iscell(code), code = {code}; end
        code = code{1};
end

% close if press escapce
if ~isempty(findstr(lower(code), 'esc'))
    sca;
end
% 
% %-- wait until release
% resp_release = resp;
% while sum(resp_release) ~= 0
%     [resp_release x name] = KbCheck(-1);
%     if sum(resp_release) == 1
%         if strcmp('',KbName(name))
%             resp_release = 0;
%         end
%     end
% end

%-- output default if no response before delay
if sum(resp) == 0
    resp = [];
    t = [];
    code = '';
end

end