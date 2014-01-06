%% display every font available

fontlist = listfonts;
for i = 1:length(fontlist)
close all; img = renderText('Rosemary',fontlist{i}); imshow(img)
fontlist{i} % print the fontname
pause
end 

%% display all characters if a single font

img = renderText('abcdefghijklmnopqrstuvwxyz123456789*/-+!@#$%^&*()','Courier'); imshow(img)

%% randomly display words

% Work | Word presentation
numWordsInChunk = stimTime / (wordTime + waitTime);         % how many words to present within [stimTime] seconds?
randString = randi(numLibrary,[1,numWordsInChunk]);         % generate random number string to randomly choose words for a trial

for i = 1:numWordsInChunk
    rnum = randString(i);
    texind = eval(sprintf('tex_%i',rnum));
    Screen('FillRect',window,gray,[])
    Screen('DrawTexture',window, texind)
    Screen('Flip',window)
    WaitSecs(wordTime)
    
    Screen('FillRect',window,gray)
    Screen('Flip',window)
    WaitSecs(waitTime)
end

% Rest | Blank Gray Screen
Screen('FillRect',window,gray,[])
Screen('Flip',window)
WaitSecs(stimTime)

%% Images --> Textures
load words

for i = 1:length(words)
    word    = words{i};
    img     = imread(num2str(['./stimuli/word4/' word '.bmp']));
    pretex  = Screen('MakeTexture',window,img); 
    eval(sprintf('tex_%i = pretex;',i));
end

for i = 1:length(words)
    word    = words{i};
    img     = imread(num2str(['./stimuli/scramble40/' word '.bmp']));
    pretex  = Screen('MakeTexture',window,img); 
    eval(sprintf('tex40_%i = pretex;',i));
end
