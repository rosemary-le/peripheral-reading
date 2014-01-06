
% example for trial nr 2
tr_nr=1;% trial number
a=NaN(length(trials(tr_nr).resp_t),1);

for k=1:length(trials(tr_nr).resp_t)
    if ~isempty(trials(tr_nr).resp_t{k})
        a(k)=trials(tr_nr).resp_t{k};
    end
end

% figure shows start and stop of button press fro this trial
figure,plot(a)