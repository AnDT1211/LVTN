clc; clear; close all;

len = 1;

init_params = INIT_Params();

airspring = AirSpring(INIT_AirSpring());

height = 0.04:0.01:0.15;
% len = 0.4:0.1:1.5;

init_road = INIT_RoadIRC(init_params);
init_road.d1 = len;

for dd1 = 1 : length(height)
    disp(num2str(dd1));
    
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

    [a, b_IRC_non] = max(solveV_IRC.BVA_non);
    [a, b_IRC_lin] = max(solveV_IRC.BVA_lin);

    VmaxA_IRC_non(dd1) = init_params.vLin(b_IRC_non);
    VmaxA_IRC_lin(dd1) = init_params.vLin(b_IRC_lin);


    [a, b_GBT_non] = max(solveV_GBT.BVA_non);
    [a, b_GBT_lin] = max(solveV_GBT.BVA_lin);

    VmaxA_GBT_non(dd1) = init_params.vLin(b_GBT_non);
    VmaxA_GBT_lin(dd1) = init_params.vLin(b_GBT_lin);

end




save M24.mat
load M24.mat
plot(height, VmaxA_IRC_non)
hold on
plot(height, VmaxA_IRC_lin)


























