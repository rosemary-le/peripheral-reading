

scale_ft=.30; % image scale factor 
sz_img=[size(img,2) size(img,1)];
sz_img=scale_ft*sz_img;
center_word=center_sc+scale_ft*[-5 -15];
pos_img=[center_word-.5*sz_img center_word+.5*sz_img];

Screen('DrawTexture', Sc.window, trials(1).pointer(2),[],pos_img);
Screen('FillOval',Sc.window,[255 0 0], [center_sc-oval_s center_sc+oval_s]);
Screen('Flip',Sc.window); 

%% left and right at 3 degrees

scale_ft=.25; % image scale factor 
sz_img=[size(img,2) size(img,1)];
sz_img=scale_ft*sz_img;
center_word=center_sc+scale_ft*[-5 -15];
word_offset=[82 0];
center_word=center_word+word_offset;

pos_img=[center_word-.5*sz_img center_word+.5*sz_img];

Screen('DrawTexture', Sc.window, trials(3).pointer(6),[],pos_img);
Screen('FillOval',Sc.window,[255 0 0], [center_sc-oval_s center_sc+oval_s]);
Screen('Flip',Sc.window); 

%% left and right at 2 degrees

scale_ft=.20; % image scale factor 
sz_img=[size(img,2) size(img,1)];
sz_img=scale_ft*sz_img;
center_word=center_sc+scale_ft*[-5 -15];
word_offset=[54 0];
center_word=center_word+word_offset;

pos_img=[center_word-.5*sz_img center_word+.5*sz_img];

Screen('DrawTexture', Sc.window, trials(3).pointer(3),[],pos_img);
Screen('FillOval',Sc.window,[255 0 0], [center_sc-oval_s center_sc+oval_s]);
Screen('Flip',Sc.window); 

%% left and right at 1 degree

scale_ft=.18; % image scale factor 
sz_img=[size(img,2) size(img,1)];
sz_img=scale_ft*sz_img;
center_word=center_sc+scale_ft*[-5 -15];
word_offset=[-28 0];
center_word=center_word+word_offset;

pos_img=[center_word-.5*sz_img center_word+.5*sz_img];

Screen('DrawTexture', Sc.window, trials(1).pointer(4),[],pos_img);
Screen('FillOval',Sc.window,[255 0 0], [center_sc-oval_s center_sc+oval_s]);
Screen('Flip',Sc.window); 

%% center
scale_ft=.18; % image scale factor 
sz_img=[size(img,2) size(img,1)];
sz_img=scale_ft*sz_img;
center_word=center_sc+scale_ft*[-5 -15];
word_offset=[0 0];
center_word=center_word+word_offset;

pos_img=[center_word-.5*sz_img center_word+.5*sz_img];

Screen('DrawTexture', Sc.window, trials(1).pointer(1),[],pos_img);
Screen('FillOval',Sc.window,[255 0 0], [center_sc-oval_s center_sc+oval_s]);
Screen('Flip',Sc.window); 

%%
%% TEST perfect boxes masking half the letters

Screen('DrawTexture', Sc.window, trials(22).pointer(2));

%-- TEST BOUNDARIES

% boundaries in x position:
b_d=[...
    center_sc(1)-6*(size(img,2)/10),...
    center_sc(1)-4*(size(img,2)/10)+19,...
    center_sc(1)-2*(size(img,2)/10)+12,...
    center_sc(1)+3,...
    center_sc(1)+2*(size(img,2)/10)-6,...
    center_sc(1)+4*(size(img,2)/10)-13,...
    center_sc(1)+6*(size(img,2)/10)];

bpos_1=[b_d(1)-1 center_sc(2)-size(img,1) b_d(1)+1  center_sc(2)+size(img,1)];
bpos_2=[b_d(2)-1 center_sc(2)-size(img,1) b_d(2)+1  center_sc(2)+size(img,1)];
bpos_3=[b_d(3)-1 center_sc(2)-size(img,1) b_d(3)+1  center_sc(2)+size(img,1)];
bpos_4=[b_d(4)-1 center_sc(2)-size(img,1) b_d(4)+1  center_sc(2)+size(img,1)];
bpos_5=[b_d(5)-1 center_sc(2)-size(img,1) b_d(5)+1  center_sc(2)+size(img,1)];
bpos_6=[b_d(6)-1 center_sc(2)-size(img,1) b_d(6)+1  center_sc(2)+size(img,1)];
bpos_7=[b_d(7)-1 center_sc(2)-size(img,1) b_d(7)+1  center_sc(2)+size(img,1)];

Screen('FillRect',Sc.window,[1 1 1],[bpos_1]);
Screen('FillRect',Sc.window,[1 1 1],[bpos_2]);
Screen('FillRect',Sc.window,[1 1 1],[bpos_3]);
Screen('FillRect',Sc.window,[1 1 1],[bpos_4]);
Screen('FillRect',Sc.window,[1 1 1],[bpos_5]);
Screen('FillRect',Sc.window,[1 1 1],[bpos_6]);
Screen('FillRect',Sc.window,[1 1 1],[bpos_7]);

Screen('Flip',Sc.window); 

%%
%-- MAKE BOXES WITH THESE BOUNDARIES
img2=img;
img2=imresize(img2,scale_ft);

Screen('DrawTexture', Sc.window, trials(1).pointer(2),[],pos_img);

b_d=[...
    center_sc(1)-6*(size(img2,2)/10),...
    center_sc(1)-4*(size(img2,2)/10)+19,...
    center_sc(1)-2*(size(img2,2)/10)+12,...
    center_sc(1)+3,...
    center_sc(1)+2*(size(img2,2)/10)-6,...
    center_sc(1)+4*(size(img2,2)/10)-13,...
    center_sc(1)+6*(size(img2,2)/10)];

bpos_1=[b_d(1) center_sc(2)-size(img2,1) b_d(2)-1 center_sc(2)+size(img2,1)];
bpos_2=[b_d(2) center_sc(2)-size(img2,1) b_d(3)-1 center_sc(2)+size(img2,1)];
bpos_3=[b_d(3) center_sc(2)-size(img2,1) b_d(4)-1 center_sc(2)+size(img2,1)];
bpos_4=[b_d(4) center_sc(2)-size(img2,1) b_d(5)-1 center_sc(2)+size(img2,1)];
bpos_5=[b_d(5) center_sc(2)-size(img2,1) b_d(6)-1 center_sc(2)+size(img2,1)];
bpos_6=[b_d(6) center_sc(2)-size(img2,1) b_d(7)-1 center_sc(2)+size(img2,1)];

Screen('Flip',Sc.window); 

