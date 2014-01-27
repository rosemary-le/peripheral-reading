%% Generate the stimuli for the reading in the periphery experiment
%
% copyright vistalab, November 2013, Jason D. Yeatman and Rosemary Le


%% Read the list of letters into Matlab
clc; clear all; close all; 

% get the path to the periphery repository
prPath = pr_rootPath; 
% path to the text file containing the letters
textFileName = fullfile(prPath,'stimuli','letters','alphabet.txt');
% read in the text file
fid = fopen(textFileName);
letters = textscan(fid, '%s');
fclose(fid);
% convert to cell array
letters = letters{1};

%% Create images for each word

% Roman - Courier

for ii = 1:length(letters)
    % Render the word. Note the data format (uint8)
    im = uint8(renderText(letters{ii},'Courier',[],4));
    
    % Change the background to gray (128) and the word to white (255)
    im(im==0) = 128;
    im(im==1) = 255;
    
    % Save the image as a png
    imwrite(im,fullfile('stimuli','letters','Roman', sprintf('%s.png',letters{ii})))
end

% Greek - Euclid Symbol

for ii = 1:length(letters)
    % Render the word. Note the data format (uint8)
    im = uint8(renderText(letters{ii},'Euclid Symbol',[],4));
    
    % Change the background to gray (128) and the word to white (255)
    im(im==0) = 128;
    im(im==1) = 255;
    
    % Save the image as a png
    imwrite(im,fullfile('stimuli','letters','Greek', sprintf('%s.png',letters{ii})))
end

%% Prototype
% %% Read the list of words into matlab
% 
% % Get the path to the periphery repository
% wpPath = wp_rootPath;
% % Change into the stimuli directory
% cd(fullfile(wpPath,'stimuli'));
% % Path to the text file containing the words
% textFile = fullfile(wpPath,'stimuli','4Letter_Min150.txt');
% % Read in the text file
% fid = fopen(textFile);
% cols = textscan(fid,'%s');
% fclose(fid);
% % Convert the words to a cell array of lower case strings
% words = lower(cols{1});
% 
% %% Create images for each word
% 
% for ii = 1:length(words)
%     % Render the word. Note the data format (uint8)
%     im = uint8(renderText(words{ii}, [], [], 4));
%     % Change the background to gray (128) and the word to white (255)
%     im(im==0) = 128;
%     im(im==1) = 255;
%     % Save the image as a bitmap
%     imwrite(im,fullfile('word4',sprintf('%s.bmp',words{ii})));
%     % Add noise to the image (20%, 40%, 60%, 80%)
%     for n =[20 40 60 80]
%         % Shuffle the phase of the fourier transform of the image
%         ims = phaseScramble(im,n./100);
%         imwrite(ims,fullfile(sprintf('scramble%s/%s.bmp',num2str(n),words{ii})));
%     end
% end