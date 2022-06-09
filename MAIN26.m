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

    
    
    % non-linear IRC
    solveT_IRCnon.SolvingTimeResponse(VmaxA_IRC_non(dd1)/3.6);
    
    
    [~, idxMaxX_non] = findpeaks(solveT_IRCnon.X_non(:,3));
    
    if dd1 < 6
        pX_non = log(abs(solveT_IRCnon.X_non(idxMaxX_non(3),3)/...
            solveT_IRCnon.X_non(idxMaxX_non(4),3)))/(3-2);
    end
    if dd1 >= 6
        pX_non = log(abs(solveT_IRCnon.X_non(idxMaxX_non(2),3)/...
            solveT_IRCnon.X_non(idxMaxX_non(3),3)))/(3-2);
    end
    
    
    ZT_test_non = pX_non/sqrt(4*pi^2 + pX_non^2)
    zt_err_IRC_non(dd1) = (ZT_test_non - init.zt_non)/init.zt_non*100;
    
    
    % IRC lin
    solveT_IRCnon.SolvingTimeResponse(VmaxA_IRC_lin(dd1)/3.6);
    [~, idxMaxX_lin] = findpeaks(solveT_IRCnon.X_lin(:,3));
    pX_lin = log(abs(solveT_IRCnon.X_lin(idxMaxX_lin(3),3)/...
            solveT_IRCnon.X_lin(idxMaxX_lin(4),3)))/(3-2);
        
    ZT_test_lin = pX_lin/sqrt(4*pi^2 + pX_lin^2)
    zt_err_IRC_lin(dd1) = (ZT_test_lin - init.zt_lin)/init.zt_lin*100;
    
    
    
    
    
    % non-linear GBT
    solveT_GBT.SolvingTimeResponse(VmaxA_GBT_non(dd1)/3.6);
    
    
    [~, idxMaxX_non] = findpeaks(solveT_GBT.X_non(:,3));
%     pX_non = log(abs(solveT_GBT.X_non(idxMaxX_non(3),3)/...
%             solveT_GBT.X_non(idxMaxX_non(4),3)))/(3-2);
    if dd1 < 8
        pX_non = log(abs(solveT_GBT.X_non(idxMaxX_non(3),3)/...
            solveT_GBT.X_non(idxMaxX_non(4),3)))/(3-2);
    end
    if dd1 >= 8
        pX_non = log(abs(solveT_GBT.X_non(idxMaxX_non(2),3)/...
            solveT_GBT.X_non(idxMaxX_non(3),3)))/(3-2);
    end
    
    
    ZT_test_non = pX_non/sqrt(4*pi^2 + pX_non^2)
    zt_err_GBT_non(dd1) = (ZT_test_non - init.zt_non)/init.zt_non*100;
    
    
    % GBT lin
    solveT_GBT.SolvingTimeResponse(VmaxA_GBT_lin(dd1)/3.6);
    
    [~, idxMaxX_lin] = findpeaks(solveT_GBT.X_lin(:,3));
    
    pX_lin = log(abs(solveT_GBT.X_lin(idxMaxX_lin(3),3)/...
            solveT_GBT.X_lin(idxMaxX_lin(4),3)))/(3-2);
        
    ZT_test_lin = pX_lin/sqrt(4*pi^2 + pX_lin^2)
    zt_err_GBT_lin(dd1) = (ZT_test_lin - init.zt_lin)/init.zt_lin*100;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
%     close all;
%     plot(solveT_IRCnon.T, solveT_IRCnon.X_lin(:,3));
%     hold on
%     plot(solveT_IRCnon.T(idxMaxX_lin), solveT_IRCnon.X_lin(idxMaxX_lin,3),'o');
%     
%     input(' == Press ''Enter'' to continue...','s');
    
    
    
    
    
    
    
    
    
    
    
%     [~, idxMaxX_lin] = findpeaks(solveT_IRCnon.X_lin(:,3));
%     [~, idxMaxA_non] = findpeaks(-1*solveT_IRCnon.a_non);

%     pT_non = solveT_IRCnon.T(idxMaxA_non(5)) - solveT_IRCnon.T(idxMaxA_non(4));
%     FN_CAL_non = 1/pT_non;
%     fn_err_IRC_non(dd1) = (FN_CAL_non - init.fn_non)/init.fn_non*100;
    
    
%     
%     % linear IRC
%     
%     solveT_IRCnon.SolvingTimeResponse(VmaxA_IRC_lin(dd1)/3.6);
%     
%     
%     [~, idxMaxA_lin] = findpeaks(-1*solveT_IRCnon.a_lin);
% 
%     pT_lin = solveT_IRCnon.T(idxMaxA_lin(5)) - solveT_IRCnon.T(idxMaxA_lin(4));
%     if dd1 >= 3
%         pT_lin = solveT_IRCnon.T(idxMaxA_lin(6)) - solveT_IRCnon.T(idxMaxA_lin(5));
%     end
%     if dd1 >= 5
%         pT_lin = solveT_IRCnon.T(idxMaxA_lin(5)) - solveT_IRCnon.T(idxMaxA_lin(4));
%     end
%     if dd1 >= 7
%         pT_lin = solveT_IRCnon.T(idxMaxA_lin(6)) - solveT_IRCnon.T(idxMaxA_lin(5));
%     end
%     FN_CAL_lin = 1/pT_lin;
%     fn_err_IRC_lin(dd1) = (FN_CAL_lin - init.fn_lin)/init.fn_lin*100;
%     
%     
%     
%     % GBT non
%     
%     solveT_GBT.SolvingTimeResponse(VmaxA_GBT_non(dd1)/3.6);
%     
%     [~, idxMaxA_non] = findpeaks(-1*solveT_GBT.a_non);
% 
%     pT_non = solveT_GBT.T(idxMaxA_non(5)) - solveT_GBT.T(idxMaxA_non(4));
%     FN_CAL_non = 1/pT_non;
%     fn_err_GBT_non(dd1) = (FN_CAL_non - init.fn_non)/init.fn_non*100;
%     
%     
%     
%     % linear GB/T
%     
%     solveT_GBT.SolvingTimeResponse(VmaxA_GBT_lin(dd1)/3.6);
%     [~, idxMaxA_lin] = findpeaks(-1*solveT_GBT.a_lin);
% 
%     pT_lin = solveT_GBT.T(idxMaxA_lin(6)) - solveT_GBT.T(idxMaxA_lin(5));
%     FN_CAL_lin = 1/pT_lin;
%     fn_err_GBT_lin(dd1) = (FN_CAL_lin - init.fn_lin)/init.fn_lin*100;
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
save M26.mat
% 
% 
load M26.mat
close all;
plot(height, zt_err_IRC_non,'r', 'LineWidth',2);
hold on
plot(height, zt_err_IRC_lin,'r--', 'LineWidth',2);
plot(height, zt_err_GBT_non,'b', 'LineWidth',2);
plot(height, zt_err_GBT_lin,'b--', 'LineWidth',2);
xlabel('Height of bump (m)')
ylabel('ERROR (%)')
title('Damping ratio results using new method')
grid on
grid minor
legend('non-linear sine square type','linear sine square type',...
    'non-linear triangle type','linear triangle type');













% plot(height, fn_err_IRC_non,'r');
% hold on
% plot(height, fn_err_IRC_lin,'--r');
% plot(height, fn_err_GBT_non,'b');
% plot(height, fn_err_GBT_lin,'--b');
% xlabel('Height of bump (m)')
% ylabel('ERROR (%)')
% title('Natural frequenct results using new method')
% grid on
% grid minor
% legend('non-linear sine square type','linear sine square type',...
%     'non-linear triangle type','linear triangle type');










