clc; clear; close all;
load M22.mat


init_params = INIT_Params();

airspring = AirSpring(INIT_AirSpring());

height = 0.08;
len = 0.5:0.1:1.5;

init_roadIRC = INIT_RoadIRC(init_params);
init_roadIRC.d2 = height;

for dd1 = 2 : length(len)
    disp(num2str(dd1));
    
    init_roadIRC.d1 = len(dd1);

    init = INIT(init_params, airspring);
    init.ShowThongSo();
    roadirc = RoadIRC(init_roadIRC);
    roadgbt = RoadGBT(init_roadIRC);

    solveT_IRCnon = SolverT(init, roadirc, airspring);
    solveT_GBT = SolverT(init, roadgbt, airspring);

%     VmaxA_IRC_non(dd1)
    solveT_IRCnon.SolvingTimeResponse(VmaxA_IRC_non(dd1)/3.6);
    
    
    [~, idxMaxA_non] = findpeaks(-1*solveT_IRCnon.a_non);

    pT_non = solveT_IRCnon.T(idxMaxA_non(5)) - solveT_IRCnon.T(idxMaxA_non(4));
    FN_CAL_non = 1/pT_non
    fn_err_IRC_non(dd1) = (FN_CAL_non - init.fn_non)/init.fn_non*100;
    
    
    
    % linear IRC
    
    solveT_IRCnon.SolvingTimeResponse(VmaxA_IRC_lin(dd1)/3.6);
    
    
    [~, idxMaxA_lin] = findpeaks(-1*solveT_IRCnon.a_lin);

    pT_lin = solveT_IRCnon.T(idxMaxA_lin(5)) - solveT_IRCnon.T(idxMaxA_lin(4));
%     if dd1 >= 5
%         pT_lin = solveT_IRCnon.T(idxMaxA_lin(5)) - solveT_IRCnon.T(idxMaxA_lin(2));
%     end
%     if dd1 >= 8
%         pT_lin = solveT_IRCnon.T(idxMaxA_lin(4)) - solveT_IRCnon.T(idxMaxA_lin(2));
%     end
%     if dd1 >= 12
%         pT_lin = solveT_IRCnon.T(idxMaxA_lin(5)) - solveT_IRCnon.T(idxMaxA_lin(2));
%     end
    FN_CAL_lin = 1/pT_lin
    fn_err_IRC_lin(dd1) = (FN_CAL_lin - init.fn_lin)/init.fn_lin*100;
    
    
    
%     fn_old_err_lin = (FN_CAL_lin - init.fn_lin)/init.fn_lin*100
    
%     (FN_CAL_non - init.fn_non)/init.fn_non*100







%     close all;
%     
%     plot(solveT_IRCnon.T, solveT_IRCnon.a_lin)
%     hold on
%     plot(solveT_IRCnon.T(idxMaxA_lin), solveT_IRCnon.a_lin(idxMaxA_lin),'o')
%     
%     input([' == Press ''Enter'' to continue...'],'s');
end

len(1) = nan;
save M23.mat
% 

load M23.mat
close all
plot(len, fn_err_IRC_non, 'r')
hold on
plot(len, fn_err_IRC_lin, 'b')
hold off
grid on
grid minor
xlabel('Length of bump (m)');
ylabel('ERROR (%)');
title('Natural frequency calculation at h = 0.08m - sine square bump');
legend('non-linear','linear');














