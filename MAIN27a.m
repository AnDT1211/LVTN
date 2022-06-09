clc; clear; close all;

len = 1;

init_params = INIT_Params();

airspring = AirSpring(INIT_AirSpring());

height = 0.01:0.01:0.15;
% len = 0.4:0.1:1.5;

init_road = INIT_RoadIRC(init_params);
init_road.d1 = len;

for dd1 = 1 : length(height)
    disp([num2str(dd1),'/',num2str(length(height))]);
    
    init_road.d2 = height(dd1);

    init = INIT(init_params, airspring);
%     init.ShowThongSo();
    roadirc = RoadIRC(init_road);
    roadgbt = RoadGBT(init_road);

    solveT_IRC = SolverT(init, roadirc, airspring);
    solveT_GBT = SolverT(init, roadgbt, airspring);

    solveV_IRC = SolverV(solveT_IRC, init_params); 
    solveV_IRC.SolvingFreqResponse(); 
    solveV_GBT = SolverV(solveT_GBT, init_params); 
    solveV_GBT.SolvingFreqResponse(); 

    [a_IRC_non, b_IRC_non] = max(solveV_IRC.BVA_non);
    [a_IRC_lin, b_IRC_lin] = max(solveV_IRC.BVA_lin);

    VmaxA_IRC_non(dd1) = init_params.vLin(b_IRC_non);
    VmaxA_IRC_lin(dd1) = init_params.vLin(b_IRC_lin);

    A_Max_IRC_non(dd1) = a_IRC_non;
    A_Max_IRC_lin(dd1) = a_IRC_lin;

    [a_GBT_non, b_GBT_non] = max(solveV_GBT.BVA_non);
    [a_GBT_lin, b_GBT_lin] = max(solveV_GBT.BVA_lin);

    VmaxA_GBT_non(dd1) = init_params.vLin(b_GBT_non);
    VmaxA_GBT_lin(dd1) = init_params.vLin(b_GBT_lin);

    A_Max_GBT_non(dd1) = a_GBT_non;
    A_Max_GBT_lin(dd1) = a_GBT_lin;
end




save M27.mat
load M27.mat
plot(height, VmaxA_IRC_non)
hold on
plot(height, VmaxA_IRC_lin)


figure(2)
plot(height, A_Max_IRC_non)
hold on
plot(height, A_Max_IRC_lin)
























