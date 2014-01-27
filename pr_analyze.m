subID = ['sub08'];

% function [] = pr_plot(subID)
% plotting results
%
% INPUT:
% 1. subject ID strings. Example: pr_plot('sub00')
% subID can also be a vector, in which case, pr_plot will assume identical conditions and concatenate over results (shrinking error bars) 
%
% Rosemary Le, January 2014
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% if more than one subID is provided, check to make sure concatenation makes sense


%% concatenate (trivial if only one subID is provided)
load(['./RESULTS/results_' num2str(subID)])
load(['./SETTINGS/settings_' num2str(subID)])


condition       = Response.actual.cond;
actual          = Response.actual.letter(1,:);
subjectcell     = Response.subject(1,:);
subject         = zeros(1,length(actual));      % conversion into double

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
    tem = CSA(((ii-1)*numtperc+1):(numtperc*ii),:);     % look at only the iith condition
    acc = sum(tem(:,2) == tem(:,3))/numtperc;           % percentage correct
    acc_cond(ii) = acc;                                 % store in matrix
    % The standard error of a proportion is SE = [p(1 - p)/n]
    se_cond(ii)  = sqrt(acc_cond(ii)*(1-acc_cond(ii))./numtperc);
end

figure()
errorbar(acc_cond,se_cond, '-ok','markerfacecolor','k');
xlabel('Degrees from fovea')
ylabel('Accuracy')
grid('on')
set(gca,'XTick',0:1:numconds);
set(gca,'XTickLabel',[[0];xlabs]);

if size(Exp.scales,1) == 1 && size(Exp.durations,1) == 1
    title([num2str(subID) '\newline Stimulus Duration:' num2str(Exp.durations) ...
        '\newline Stimulus Scale:' num2str(Exp.scales)])
end

