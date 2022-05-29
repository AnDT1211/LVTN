clc; clear; close all;

init_params = INIT_Params();

airspring = AirSpring(INIT_AirSpring());

init = INIT(init_params, airspring);
init.ShowThongSo();


solveT_OLD = SolveOldMethod(init, airspring);
solveT_OLD.SolvingTimeResponse(0.1);

[~, idxMaxA_non] = findpeaks(-1*solveT_OLD.a_non);
[~, idxMaxA_lin] = findpeaks(-1*solveT_OLD.a_lin);
[~, idxMaxX_non] = findpeaks(solveT_OLD.X_non(:,3));
[~, idxMaxX_lin] = findpeaks(solveT_OLD.X_lin(:,3));




figure(1)
plot(solveT_OLD.T, solveT_OLD.X_non(:,3), 'r');
hold on
plot(solveT_OLD.T, solveT_OLD.X_lin(:,3), 'b');
plot(solveT_OLD.T(idxMaxX_non), solveT_OLD.X_non(idxMaxX_non,3), 'ro');
plot(solveT_OLD.T(idxMaxX_lin), solveT_OLD.X_lin(idxMaxX_lin,3), 'bo');

plot([0, solveT_OLD.T(idxMaxX_non(1))],...
    [solveT_OLD.X_non(idxMaxX_non(1),3), solveT_OLD.X_non(idxMaxX_non(1),3)], 'r--')
plot([0, solveT_OLD.T(idxMaxX_non(2))],...
    [solveT_OLD.X_non(idxMaxX_non(2),3), solveT_OLD.X_non(idxMaxX_non(2),3)], 'r--')

plot([0, solveT_OLD.T(idxMaxX_lin(1))],...
    [solveT_OLD.X_lin(idxMaxX_lin(1),3), solveT_OLD.X_lin(idxMaxX_lin(1),3)], 'b--')
plot([0, solveT_OLD.T(idxMaxX_lin(2))],...
    [solveT_OLD.X_lin(idxMaxX_lin(2),3), solveT_OLD.X_lin(idxMaxX_lin(2),3)], 'b--')
hold off
grid on
grid minor
xlabel('Time (s)');
ylabel('Displacement (m)')
title('Body Displacement - Old method')
legend('non-linear','linear')

pX_non = log(abs(solveT_OLD.X_non(idxMaxX_non(1),3)/solveT_OLD.X_non(idxMaxX_non(2),3)))/(3-2);
ZT_test_non = pX_non/sqrt(4*pi^2 + pX_non^2);

pX_lin = log(abs(solveT_OLD.X_lin(idxMaxX_lin(1),3)/solveT_OLD.X_lin(idxMaxX_lin(2),3)))/(3-2);
ZT_test_lin = pX_lin/sqrt(4*pi^2 + pX_lin^2);



zt_old_err_non = (ZT_test_non - init.zt_non)/init.zt_non*100
zt_old_err_lin = (ZT_test_lin - init.zt_lin)/init.zt_lin*100





figure(2)
plot(solveT_OLD.T, solveT_OLD.a_non, 'r')
hold on
plot(solveT_OLD.T, solveT_OLD.a_lin, 'b')
plot(solveT_OLD.T(idxMaxA_non), solveT_OLD.a_non(idxMaxA_non), 'ro')
plot(solveT_OLD.T(idxMaxA_lin), solveT_OLD.a_lin(idxMaxA_lin), 'bo')
plot([solveT_OLD.T(idxMaxA_non(2)), solveT_OLD.T(idxMaxA_non(2))], ...
    [solveT_OLD.a_non(idxMaxA_non(2)), -5], 'r--')
plot([solveT_OLD.T(idxMaxA_non(3)), solveT_OLD.T(idxMaxA_non(3))], ...
    [solveT_OLD.a_non(idxMaxA_non(3)), -5], 'r--')

plot([solveT_OLD.T(idxMaxA_lin(2)), solveT_OLD.T(idxMaxA_lin(2))], ...
    [solveT_OLD.a_lin(idxMaxA_lin(2)), -5], 'b--')
plot([solveT_OLD.T(idxMaxA_lin(3)), solveT_OLD.T(idxMaxA_lin(3))], ...
    [solveT_OLD.a_lin(idxMaxA_lin(3)), -5], 'b--')
hold off
grid on
grid minor
xlabel('Time (s)');
ylabel('Acceleration (m)')
title('Body Acceleration - Old method')
legend('non-linear','linear')
ylim([-5, 3])


pT_lin = solveT_OLD.T(idxMaxA_lin(3)) - solveT_OLD.T(idxMaxA_lin(2));
FN_CAL_lin = 1/pT_lin;

pT_non = solveT_OLD.T(idxMaxA_non(3)) - solveT_OLD.T(idxMaxA_non(2));
FN_CAL_non = 1/pT_non;

fn_old_err_non = (FN_CAL_non - init.fn_non)/init.fn_non*100
fn_old_err_lin = (FN_CAL_lin - init.fn_lin)/init.fn_lin*100

save M20.mat

% 
% 
% solveT_IRC = SolverT(init, roadirc, airspring);
% solveT_IRC.SolvingTimeResponse(init_params.v*3.6);
% 
% solveT_GBT = SolverT(init, roadgbt, airspring);
% solveT_GBT.SolvingTimeResponse(init_params.v*3.6);


% leg1 = strcat('IRC standard non-linear');
% leg2 = strcat('IRC standard linear');
% leg3 = strcat('GB/T standard non-linear');
% leg4 = strcat('GB/T standard linear');
% 
% 
% figure(1)
% plot(solveT_IRC.T, solveT_IRC.X_non(:, 3), 'b');
% hold on
% plot(solveT_IRC.T, solveT_IRC.X_lin(:, 3), '--b');
% 
% plot(solveT_GBT.T, solveT_GBT.X_non(:, 3), 'r');
% plot(solveT_GBT.T, solveT_GBT.X_lin(:, 3), '--r');
% hold off
% legend(leg1, leg2, leg3, leg4);
% grid on
% grid minor
% tit = strcat('Car Body Displacement at ', num2str(init_params.v*3.6),' km/h');
% title(tit);
% xlabel('Time (s)');
% ylabel('Displacement (m)');
% saveas(figure(1), 'img/Compare/IRCvsGBT/a1_dis.png');
% 
% 
% figure(2)
% plot(solveT_IRC.T, solveT_IRC.rev_X_non, 'b');
% hold on
% plot(solveT_IRC.T, solveT_IRC.rev_X_lin, '--b');
% 
% plot(solveT_GBT.T, solveT_GBT.rev_X_non, 'r');
% plot(solveT_GBT.T, solveT_GBT.rev_X_lin, '--r');
% hold off
% legend(leg1, leg2, leg3, leg4);
% grid on
% grid minor
% tit = strcat('Relative Displacement at ', num2str(init_params.v*3.6),' km/h');
% title(tit);
% xlabel('Time (s)');
% ylabel('Relative Displacement (m)');
% saveas(figure(2), 'img/Compare/IRCvsGBT/a2_revdis.png');
% 
% 
% figure(3)
% plot(solveT_IRC.T, solveT_IRC.a_non, 'b');
% hold on
% plot(solveT_IRC.T, solveT_IRC.a_lin, '--b');
% 
% plot(solveT_GBT.T, solveT_GBT.a_non, 'r');
% plot(solveT_GBT.T, solveT_GBT.a_lin, '--r');
% hold off
% legend(leg1, leg2, leg3, leg4);
% grid on
% grid minor
% tit = strcat('Body Acceleration at ', num2str(init_params.v*3.6),' km/h');
% title(tit);
% xlabel('Time (s)');
% ylabel('Acceleration (m/s^2)');
% saveas(figure(3), 'img/Compare/IRCvsGBT/a3_acc.png');
% 
% close all
% 
% 
% %% Plot Freq Respones
% solveV_IRC = SolverV(solveT_IRC, init_params);
% solveV_GBT = SolverV(solveT_GBT, init_params);
% 
% solveV_IRC.SolvingFreqResponse();
% solveV_GBT.SolvingFreqResponse();
% 
% 
% figure(1)
% plot(init_params.vLin, solveV_IRC.BVA_non, 'b');
% hold on
% plot(init_params.vLin, solveV_IRC.BVA_lin, '--b');
% 
% plot(init_params.vLin, solveV_GBT.BVA_non, 'r');
% plot(init_params.vLin, solveV_GBT.BVA_lin, '--r');
% hold off
% legend({leg1, leg2, leg3, leg4}, 'Position',[0.3, 0.8, 0, 0]);
% grid on
% grid minor
% tit = strcat('Body Vibration Acceleration');
% title(tit);
% xlabel('Car speed (km/h)');
% ylabel('BVA (m/s^2)');
% saveas(figure(1), 'img/Compare/IRCvsGBT/v1_BVA.png');
% 
% figure(2)
% plot(init_params.vLin, solveV_IRC.RMSA_non, 'b');
% hold on
% plot(init_params.vLin, solveV_IRC.RMSA_lin, '--b');
% 
% plot(init_params.vLin, solveV_GBT.RMSA_non, 'r');
% plot(init_params.vLin, solveV_GBT.RMSA_lin, '--r');
% hold off
% legend({leg1, leg2, leg3, leg4}, 'Position',[0.72, 0.7, 0, 0]);
% grid on
% grid minor
% tit = strcat('RMS Body Vibration Acceleration');
% title(tit);
% xlabel('Car speed (km/h)');
% ylabel('RMS(BVA) (m/s^2)');
% saveas(figure(2), 'img/Compare/IRCvsGBT/v2_RMSA.png');
% 
% figure(3)
% plot(init_params.vLin, solveV_IRC.SDD_non, 'b');
% hold on
% plot(init_params.vLin, solveV_IRC.SDD_lin, '--b');
% 
% plot(init_params.vLin, solveV_GBT.SDD_non, 'r');
% plot(init_params.vLin, solveV_GBT.SDD_lin, '--r');
% hold off
% legend({leg1, leg2, leg3, leg4}, 'Position',[0.72, 0.81, 0, 0]);
% grid on
% grid minor
% tit = strcat('Suspension Dynamic Deflection');
% title(tit);
% xlabel('Car speed (km/h)');
% ylabel('SDD (m)');
% saveas(figure(3), 'img/Compare/IRCvsGBT/v3_SDD.png');
% 
% 
% figure(4)
% plot(init_params.vLin, solveV_IRC.TDL_non, 'b');
% hold on
% plot(init_params.vLin, solveV_IRC.TDL_lin, '--b');
% 
% plot(init_params.vLin, solveV_GBT.TDL_non, 'r');
% plot(init_params.vLin, solveV_GBT.TDL_lin, '--r');
% hold off
% legend({leg1, leg2, leg3, leg4}, 'Position',[0.72, 0.81, 0, 0]);
% grid on
% grid minor
% tit = strcat('Tire relative Dynamic Load');
% title(tit);
% xlabel('Car speed (km/h)');
% ylabel('TDL (N)');
% saveas(figure(4), 'img/Compare/IRCvsGBT/v4_TDL.png');
% 
% 
