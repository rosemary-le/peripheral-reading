function [] = pr_plot(subID)
% plotting results
%
% INPUT:
% 1. subject ID strings. Example: pr_plot('sub00')
% subID can also be a vector, in which case pr_plot will assume identical conditions and concatenate over results (shrinking error bars) 
%
% Rosemary Le, January 2014
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Load variables (and concatenate)
condition   = [];
actual      = []; 
subjectcell = []; 

for jj = 1:size(subID,1)
    
    ID = subID{jj};
    load(['./RESULTS/results_' num2str(ID)])
    load(['./SETTINGS/settings_' num2str(ID)])
   
    condition   = [condition, Response.actual.cond];
    actual      = [actual, Response.actual.letter(1,:)]; 
    subjectcell = [subjectcell, Response.subject(1,:)];
    
end

%% Extract (and concatenate) variables

subject         = zeros(1,length(actual));      % for conversion into double
numtrials       = length(actual);               % number of total trials 
numconds        = length(unique(condition));    % number of conditions
numtperc        = numtrials/numconds;           % number of trials per condition

for ii = 1:length(subjectcell)
    if subjectcell{ii} == 'g', subject(ii) = 1; end
    if subjectcell{ii} == 'h', subject(ii) = 2; end 
    if ~isequal(subjectcell{ii},'g') && ~isequal(subjectcell{ii},'h'),  subject(ii) = 0; end
end


xlabs = Exp.eccentricities(:,1);

%% plotting accuracy for each condition

acc_cond = zeros(1,length(numconds));   % a vector. ith element equals accuracy of ith condition
se_cond  = zeros(1,length(numconds));   % a vector. ith element equals standard error of ith condition.

csa = [condition' subject' actual'];    % concatenate these three
CSA = sortrows(csa,1);                  % sort by condition number (first row) 

for ii = 1:numconds
    tem = CSA(((ii-1)*numtperc+1):(numtperc*ii),:);                 % look at only the iith condition
    acc = sum(tem(:,2) == tem(:,3))/numtperc;                       % percentage correct
    acc_cond(ii) = acc;                                             % store in vector
    se_cond(ii)  = sqrt(acc_cond(ii)*(1-acc_cond(ii))./numtperc);   % standard error 
    se_cond(ii)  = sqrt((acc_cond(ii)*(1-acc_cond(ii)))/numtperc);                                                               
end

figure()
errorbar(acc_cond,se_cond, '-ok','markerfacecolor','k');
xlabel('Degrees from fovea')
ylabel('Accuracy')
grid('on')
set(gca,'XTick',1:numconds);
set(gca,'XTickLabel',[xlabs]);

% Graph labeing with only one dataset
if size(subID,1) == 1
    if size(Exp.scales,1) == 1 && size(Exp.durations,1) == 1
        title([num2str(subID{1}) '\newline Stimulus Duration: ' num2str(Exp.durations) ' sec'...
            '\newline Time to respond: ' num2str(Exp.dur.timeToRespond) ' sec'...
            '\newline Stimulus Scale: ' num2str(Exp.scales) ...
            '\newline # of trials per condition: ' num2str(numtperc)])
    end
end

% Graph labeing with more than one dataset
if size(subID,1) > 1
    l_subID = reshape(subID,1,size(subID,1));
    if size(Exp.scales,1) == 1 && size(Exp.durations,1) == 1
        title(['Stimulus Duration: ' num2str(Exp.durations) ' sec'...
            '\newline Time to respond: ' num2str(Exp.dur.timeToRespond) ' sec' ...
            '\newline Stimulus Scale: ' num2str(Exp.scales) ...
            '\newline # trials per condition: ' num2str(numtperc)])
    end
end

end