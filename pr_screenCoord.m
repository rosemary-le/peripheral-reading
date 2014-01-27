%% calculates 'center' coordinates for (x,y) degrees from fixation
% coordinates will be in ptb convention
% INPUTS:
% 1. a structure with the following fields:
%     - 'siz'   size of the display
%     - 'res'   resolution of the display
%     - 'vdist' viewing distance 
% 2. degh - degrees to move horizontally
% 3. degv - degrees to move vertically
% OUTPUTS:
% 1. pixel coordinates

function [coord] = pr_screenCoord(p , degh, degv) 


%% Calculate pixel size = size of screen in cm/ resolution
pix = p.siz ./ p.res;              % calculate pixel size

%% how many pixels in ONE degree of visual angle?
degperpix = (2*atan(pix./(2*p.vdist))).*180/pi; 
pixperdeg = 1./degperpix; 

%% calculate the center
center = [p.res(1)/2, p.res(2)/2];

%% pixel coordinates after moving degh degrees horizontally 
coord(1) = center(1) + degh*pixperdeg(1);

%% pixel coordinates after moving degv degrees vertically
coord(2) = center(2) + degv*pixperdeg(1);


end
