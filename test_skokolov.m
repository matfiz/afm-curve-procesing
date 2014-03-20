close all;
clear all;
clc;
load('D:\Brzezinka\Dokumenty\doktoranckie\JPK\curve_processing\tmp\dataheight.mat')
curve = cps_handles.current_curve;
data = curve.force_distance_approach;
plot(data(1,:),data(2,:))