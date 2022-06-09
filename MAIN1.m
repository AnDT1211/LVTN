clc; clear; close all;

init_as = INIT_AirSpring();
init_as.Des_PSI = 75;
airspring = AirSpring(init_as);

airspring.PlotDesHeight2();
airspring.plotStiff();

init_params = INIT_Params();

init = INIT(init_params, airspring);
init.ShowThongSo();
