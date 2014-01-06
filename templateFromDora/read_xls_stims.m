
% condition 1 and 5:
[num,txt,raw] = xlsread('./stimuli_V2.xlsx',1);
% num indicates which other trial is presented at that point, 
% not which trial number the equation is assigned;
probs.cond(1).problems=txt(num(:,7),:);
probs.cond(5).problems=txt(num(:,8),:);

% condition 2 and 6:
[num,txt,raw] = xlsread('./stimuli_V2.xlsx',2);

probs.cond(2).problems=txt(num(:,7),:);
probs.cond(6).problems=txt(num(:,8),:);

% condition 3 and 7:
[num,txt,raw] = xlsread('./stimuli_V2.xlsx',3);

probs.cond(3).problems=txt(num(:,7),:);
probs.cond(7).problems=txt(num(:,8),:);

% condition 4 and 8:
[num,txt,raw] = xlsread('./stimuli_V2.xlsx',4);

probs.cond(4).problems=txt(num(:,7),:);
probs.cond(8).problems=txt(num(:,8),:);

%% sequence for first 10 minutes:

[num,txt,raw] = xlsread('./stimuli_V2.xlsx',5);

tr_order    = [num(:,1); num(:,4); num(:,1); num(:,4)];
tr_pres_nr  = [num(:,2); 10+num(:,2); 20+num(:,2); 30+num(:,2)];

%%
% trials.problem
% trials.instr
% trials.target
% trials.cond
clear alltrials

nr_tr=320; % 20 repetitions of each

for k=1:nr_tr % 40 trials in 5 mins
    alltrials(k).cond = tr_order(k);
    for s=1:5
        alltrials(k).problem{s} = probs.cond(alltrials(k).cond).problems{tr_pres_nr(k),s};
    end
end

% instruction every 4 trials
for k=1:nr_tr % nr of trials
    if mod(k,4)==1
        if alltrials(k).cond<5
            alltrials(k).instr=1; % switch instruction to 1
        elseif alltrials(k).cond>4
            alltrials(k).instr=2; % switch instruction to 2
        end
    else
        alltrials(k).instr=0; % no instruction
    end
end 

% during which stimuli does the dot change to blue? (1:5)
dot_change={[1],[2],[3],[4],[5],[1 3],[1 4],[1 5],[2 3],[2 4],[2 5],[3 4],[3 5]};
for k=1:nr_tr
    alltrials(k).target=dot_change{randi(13,1)}; % zero for not
end

%%
[num1,txt1,raw] = xlsread('./stimuli_V2.xlsx',1);
[num2,txt2,raw] = xlsread('./stimuli_V2.xlsx',2);
[num3,txt3,raw] = xlsread('./stimuli_V2.xlsx',3);
[num4,txt4,raw] = xlsread('./stimuli_V2.xlsx',4);

% equation number
% equation correct or incorrect

% just to complete trials info:
for k=1:length(alltrials)

    if alltrials(k).cond==1 || alltrials(k).cond==5 
        for m=1:40
            test_same=0;
            for s=1:5
                if strcmp(alltrials(k).problem{s},txt1{m,s})
                    test_same=test_same+1;
                end
            end
            if test_same==5 && alltrials(k).cond==1
                alltrials(k).eq_nr=m;
                alltrials(k).eq_corr=num1(m,10);
            elseif test_same==5 && alltrials(k).cond==5
                alltrials(k).eq_nr=m;
                alltrials(k).eq_corr=num1(m,10);
            end
        end
    elseif alltrials(k).cond==2 || alltrials(k).cond==6
        for m=1:40
            test_same=0;
            for s=1:5
                if strcmp(alltrials(k).problem{s},txt2{m,s})
                    test_same=test_same+1;
                end
            end
            if test_same==5 && alltrials(k).cond==2
                alltrials(k).eq_nr=m;
                alltrials(k).eq_corr=num2(m,10);
            elseif test_same==5 && alltrials(k).cond==6
                alltrials(k).eq_nr=m;
                alltrials(k).eq_corr=num2(m,10);
            end
        end        
    elseif alltrials(k).cond==3 || alltrials(k).cond==7
        for m=1:40
            test_same=0;
            for s=1:5
                if strcmp(alltrials(k).problem{s},txt3{m,s})
                    test_same=test_same+1;
                end
            end
            if test_same==5 && alltrials(k).cond==3
                alltrials(k).eq_nr=m;
                alltrials(k).eq_corr=num3(m,10);
            elseif test_same==5 && alltrials(k).cond==7
                alltrials(k).eq_nr=m;
                alltrials(k).eq_corr=num3(m,10);
            end
        end
    elseif alltrials(k).cond==4 || alltrials(k).cond==8
        for m=1:40
            test_same=0;
            for s=1:5
                if strcmp(alltrials(k).problem{s},txt4{m,s})
                    test_same=test_same+1;
                end
            end
            if test_same==5 && alltrials(k).cond==4
                alltrials(k).eq_nr=m;
                alltrials(k).eq_corr=num4(m,10);
            elseif test_same==5 && alltrials(k).cond==8
                alltrials(k).eq_nr=m;
                alltrials(k).eq_corr=num4(m,10);
            end
        end    
    end
end

%% save

trials=alltrials(1:40);
save('./context_trials_set1','trials')
trials=alltrials(41:80);
save('./context_trials_set2','trials')
trials=alltrials(81:120);
save('./context_trials_set3','trials')
trials=alltrials(121:160);
save('./context_trials_set4','trials')
trials=alltrials(161:200);
save('./context_trials_set5','trials')
trials=alltrials(201:240);
save('./context_trials_set6','trials')
trials=alltrials(241:280);
save('./context_trials_set7','trials')
trials=alltrials(281:320);
save('./context_trials_set8','trials')




