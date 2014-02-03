%% Demo for using GINPUT_GUI

%% Instructions on how to use this demo:
%
% 1. Let the GUI load.
% 2. Select points on the two plots, just like one would use GINPUT.
% 3. To close the GUI, user needs to double click on the left hand side 
%    plot. This closing procedure could be edited inside ginput_gui.m.

img1 = imread('peppers.png');
img2 = imread('gantrycrane.png');
[pt1cell,pt2cell] = ginput_gui(img1,[],img2,[]);
pt1 = cell2mat(pt1cell)
pt2 = cell2mat(pt2cell)
