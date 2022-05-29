clc; clear; close all;


import mlreportgen.ppt.*

ppt = Presentation('ahihi.pptx');

ppt.add('Title Slide');
contents = find(ppt,'Title');

ppt.find(
replace(contents,'My First Presentation');
contents = find(ppt,'Subtitle');
replace(contents,'Do Thai An - 1652005');
contents = find(ppt,'Footer');

size(contents)
% replace(contents,'Midterm');
close(ppt);

















