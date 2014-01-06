% 4 JW word in consonant strings: at 1 degree, 1.6 deg word left to right
a=load('../../dhermes/words_speed_LR/data/behavior/73545138877_JW20130805_set1_run01_1_all.mat');
b=load('../../dhermes/words_speed_LR/data/behavior/73545138200_JW20130805_set2_run01_2_all.mat');
a2=load('../../dhermes/words_speed_LR/data/behavior/73545136766_JW20130805_set3_run01_3_all.mat');
b2=load('../../dhermes/words_speed_LR/data/behavior/73545137517_JW20130805_set4_run01_4_all.mat');
tr_isi=[1/2 1/3 1/4 1/5 1/6 1/10 1/20]; % inter stimulus intervals


a.trials(end).time(end)-a.trials(1).time(2)
b.trials(end).time(end)-b.trials(1).time(2)

% clear oval_s n ITI T_instr r* b* c* d* k* f* Sc i* p* s* pointers unused t t_resp total_nr_stims trig_rect wait m*
%%
%% recode trials code  

for k=1:length(a.trials)
    a.trials(k).resp_b=find(a.trials(k).resp_b,1);
end
for k=1:length(b.trials)
    b.trials(k).resp_b=find(b.trials(k).resp_b,1);
end
for k=1:length(a2.trials)
    a2.trials(k).resp_b=find(a2.trials(k).resp_b,1);
end
for k=1:length(b2.trials)
    b2.trials(k).resp_b=find(b2.trials(k).resp_b,1);
end
%%

clear out

for c=1:4 % masking letetrs or segments

    if c==1
        trials=a.trials;
    elseif c==2
        trials=b.trials;
    elseif c==3
        trials=a2.trials;
    elseif c==4
        trials=b2.trials;
    end
    
    trial_code=zeros(length(trials),6);

    for k=1:length(trials)
        trial_code(k,1)=trials(k).nr;
        trial_code(k,2)=trials(k).cond;
        if trials(k).cond<10 % no target
            trial_code(k,3)=trials(k).cond;
        else % there was a target
            trial_code(k,3)=trials(k).cond-10;
        end
%         trial_code(k,4)=str2double(trials(k).resp_b(1)); % laptop: when pressing 1 or 9
        trial_code(k,4)=trials(k).resp_b;
    end
    
    %%%% laptop:
    % 1 is 0 (no word) and 9 is 1 (word) for easy calculation
    % trial_code(trial_code(:,4)==1,4)=0;
    % trial_code(trial_code(:,4)==9,4)=1;

    %%%% vista lab
    % 30 is 0 (no word) and 38 is 1 (word) for easy calculation
    trial_code(trial_code(:,4)==30,4)=0;
    trial_code(trial_code(:,4)==38,4)=1;

    nr_cond=max(trial_code(:,3));
    nr_repeats=length(find(trial_code(:,3)==1));
    %1-HIT, 2-FA, 3-CR, 4-MISS, 5-HITrate, 6-FArate, 7-d-prime:
    out(c).output_vals=zeros(nr_cond,7);
    for k=1:nr_cond
        nr_trials_cond=length(find(trial_code(:,3)==k));
        out(c).output_vals(k,1)=sum(trial_code(trial_code(:,2)==10+k,4));
        out(c).output_vals(k,2)=sum(trial_code(trial_code(:,2)==k,4));
        out(c).output_vals(k,3)=(nr_repeats/2)-sum(trial_code(trial_code(:,2)==k,4));
        out(c).output_vals(k,4)=(nr_repeats/2)-sum(trial_code(trial_code(:,2)==10+k,4));
        % add 1 to all responses for avoid NaN and Inf
        out(c).output_vals(k,5)=(out(c).output_vals(k,1))/(out(c).output_vals(k,1)+out(c).output_vals(k,4));
        out(c).output_vals(k,6)=(out(c).output_vals(k,2))/(out(c).output_vals(k,2)+out(c).output_vals(k,3));
        HR_4dprime=(1+out(c).output_vals(k,1))/(2+out(c).output_vals(k,1)+out(c).output_vals(k,4));
        FAR_4dprime=(1+out(c).output_vals(k,2))/(2+out(c).output_vals(k,2)+out(c).output_vals(k,3));
        out(c).output_vals(k,7)=norminv(HR_4dprime) - ...
            norminv(FAR_4dprime);
    end
end

cond_color={'b','b','r','r'};
cond_line={'-','--','-','--'};
figure('Position',[0 200 400 600])
%%% 1,2 = left, 3,4 = right

for c=1:4

subplot(3,1,1),hold on
plot(tr_isi,out(c).output_vals(:,7),cond_line{c},'Color',cond_color{c})
ylabel('dprime')
% ylim([-0.01 2])
plot(tr_isi,out(c).output_vals(:,7),'k.','MarkerSize',10)
title('blue=left, red=right, solid=wordinCS')

subplot(3,1,2),hold on
plot(tr_isi,out(c).output_vals(:,5),cond_line{c},'Color',cond_color{c})
plot(tr_isi,out(c).output_vals(:,5),'k.','MarkerSize',10)
ylabel('HIT rate')
ylim([-0.01 1.1])

subplot(3,1,3),hold on
plot(tr_isi,out(c).output_vals(:,6),'Color',cond_color{c})
plot(tr_isi,out(c).output_vals(:,6),'k.','MarkerSize',10)
ylabel('FA rate')
ylim([-0.01 1.1])
end

set(gcf,'PaperPositionMode','auto')



%%
% print('-dpng','-r300',['./figures/prelim_plot/JW20130805_dprime1'])

