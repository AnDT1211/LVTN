clc; clear; close all;
load M24.mat
len = 1;

init_params = INIT_Params();

airspring = AirSpring(INIT_AirSpring());

height = 0.04:0.01:0.15;
% len = 0.4:0.1:1.5;

init_roadIRC = INIT_RoadIRC(init_params);
init_roadIRC.d1 = len;

for dd1 = 2 : length(height)
    disp(num2str(dd1));
    init_roadIRC.d2 = height(dd1);

    init = INIT(init_params, airspring);
%     init.ShowThongSo();
    roadirc = RoadIRC(init_roadIRC);
    roadgbt = RoadGBT(init_roadIRC);

    solveT_IRCnon = SolverT(init, roadirc, airspring);
    solveT_GBT = SolverT(init, roadgbt, airspring);

    
    solveT_IRCnon.SolvingTimeResponse(VmaxA_IRC_non(dd1)/3.6);
    
    
    [~, idxMaxA_non] = findpeaks(-1*solveT_IRCnon.a_non);

    pT_non = solveT_IRCnon.T(idxMaxA_non(5)) - solveT_IRCnon.T(idxMaxA_non(4));
    FN_CAL_non = 1/pT_non;
    fn_err_IRC_non(dd1) = (FN_CAL_non - init.fn_non)/init.fn_non*100;
    
    
    
    % linear IRC
    
    solveT_IRCnon.SolvingTimeResponse(VmaxA_IRC_lin(dd1)/3.6);
    
    
    [~, idxMaxA_lin] = findpeaks(-1*solveT_IRCnon.a_lin);

    pT_lin = solveT_IRCnon.T(idxMaxA_lin(5)) - solveT_IRCnon.T(idxMaxA_lin(4));
    if dd1 >= 3
        pT_lin = solveT_IRCnon.T(idxMaxA_lin(6)) - solveT_IRCnon.T(idxMaxA_lin(5));
    end
    if dd1 >= 5
        pT_lin = solveT_IRCnon.T(idxMaxA_lin(5)) - solveT_IRCnon.T(idxMaxA_lin(4));
    end
    if dd1 >= 7
        pT_lin = solveT_IRCnon.T(idxMaxA_lin(6)) - solveT_IRCnon.T(idxMaxA_lin(5));
    end
    FN_CAL_lin = 1/pT_lin;
    fn_err_IRC_lin(dd1) = (FN_CAL_lin - init.fn_lin)/init.fn_lin*100;
    
    
    
    % GBT non
    
    solveT_GBT.SolvingTimeResponse(VmaxA_GBT_non(dd1)/3.6);
    
    [~, idxMaxA_non] = findpeaks(-1*solveT_GBT.a_non);

    pT_non = solveT_GBT.T(idxMaxA_non(5)) - solveT_GBT.T(idxMaxA_non(4));
    FN_CAL_non = 1/pT_non;
    fn_err_GBT_non(dd1) = (FN_CAL_non - init.fn_non)/init.fn_non*100;
    
    
    
    % linear GB/T
    
    solveT_GBT.SolvingTimeResponse(VmaxA_GBT_lin(dd1)/3.6);
    [~, idxMaxA_lin] = findpeaks(-1*solveT_GBT.a_lin);

    pT_lin = solveT_GBT.T(idxMaxA_lin(6)) - solveT_GBT.T(idxMaxA_lin(5));
    FN_CAL_lin = 1/pT_lin;
    fn_err_GBT_lin(dd1) = (FN_CAL_lin - init.fn_lin)/init.fn_lin*100;
%     
%     close all;
%     
%     plot(solveT_GBT.T, solveT_GBT.a_lin)
%     hold on
%     plot(solveT_GBT.T(idxMaxA_lin), solveT_GBT.a_lin(idxMaxA_lin),'o')
%     
%     input(' == Press ''Enter'' to continue...','s');
end

height(1) = nan;
save M25.mat


load M25.mat
close all;
plot(height, fn_err_IRC_non,'r', 'LineWidth',2);
hold on
plot(height, fn_err_IRC_lin,'--r', 'LineWidth',2);
plot(height, fn_err_GBT_non,'b', 'LineWidth',2);
plot(height, fn_err_GBT_lin,'--b', 'LineWidth',2);
xlabel('Height of bump (m)')
ylabel('ERROR (%)')
title('Natural frequenct results using new method')
grid on
grid minor
legend('non-linear sine square type','linear sine square type',...
    'non-linear triangle type','linear triangle type');










