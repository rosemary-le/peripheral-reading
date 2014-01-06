function [pixperdeg , degperpix] = VisualAngle(params)

% params is a structure such that:
% params.res    is the resolution of the monitor
% params.sz     is the size of the monitor in cm
% params.vdist  is the viewing distance in cm
% (these values can be along a single dimension)

% Calculates the visual angle subtended by a single pixel
% returns the pixels per degree and its reciprocal: pixels per degree

pix = params.sz / params.res;       % calculates the size of a pixel in cm
degperpix = (2*atan(pix./(2*params.vdist))).*(180/pi);
pixperdeg = 1./degperpix;

end