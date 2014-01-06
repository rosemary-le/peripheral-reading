% Script to call the function VisualAngle.m
% Calculate visual angle

% function [pixperdeg , degperpix] = VisualAngle(params)

% params is a structure such that:
% params.res    is the resolution of the monitor
% params.sz     is the size of the monitor in cm
% params.vdist  is the viewing distance in cm
% (these values can be along a single dimension)

% Calculates the visual angle subtended by a single pixel
% returns the pixels per degree and its reciprocal: pixels per degree

%%
clc;

pix = 15;

%'laptop'
% Resolution: 1280 x 800
% Monitor Size: 28.7 x 17.9
% images take up 600 x 600

% 'serrelab'     
% Resolution: 1280 x 960
% Monitor: 36.8 x 27.6
% images take up 600 x 600

r = [1280 800];         % resolution of monitor
s = [28.7 17.9];        % size of monitor (cm)
v = 50;                 % viewing distance (cm)

params = struct('res',r,'sz',s,'vdist',v);

[pixpd,degpp] = VisualAngle(params);

p = pix/pixpd;

fprintf('%3.2f pixels at a distance of %3.1f cm subtends %3.4f visual angle degrees\n',pix,v,p)