%% function to define rect coordinates [RectLeft,RectTop,RectRight,RectBottom] 
% INPUTS:
% 1. center coordinates (x,y)
% 2. original image size. [#rows, #cols] matlab convention
% 3. scaling factor
% OUTPUTS:
% 1. 1x4 matrix of rectangular coordinates [RectLeft,RectTop,RectRight,RectBottom]


function rectCoord = pr_makeRectCoord(center, imgSize, scaleFact)

newImgSize = scaleFact * imgSize; 

halfWidth = newImgSize(2)/2;
halfHeight = newImgSize(1)/2;

% [RectLeft,RectTop,RectRight,RectBottom]
a = center(1) - halfWidth;
b = center(2) - halfHeight;
c = center(1) + halfWidth;
d = center(2) + halfHeight;

rectCoord = [a b c d]; 

end

%% Old version. 
% 
% %% function to define rect coordinates [RectLeft,RectTop,RectRight,RectBottom] 
% % INPUTS:
% % 1. center coordinates (x,y)
% % 2. 1/2 width of rectangle formed around centerX
% % 3. 1/2 height of rectangle formed around centerY
% % OUTPUTS:
% % 1. 1x4 matrix of rectangular coordinates [RectLeft,RectTop,RectRight,RectBottom]
% 
% 
% function rectCoord = pr_makeRectCoord(center, halfWidth, halfHeight)
% 
% % [RectLeft,RectTop,RectRight,RectBottom]
% a = center(1) - halfWidth;
% b = center(2) - halfHeight;
% c = center(1) + halfWidth;
% d = center(2) + halfHeight;
% 
% rectCoord = [a b c d]; 
% 
% end
