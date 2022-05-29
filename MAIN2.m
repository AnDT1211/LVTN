clc; clear; close all;

init_params = INIT_Params();

airspring = AirSpring(INIT_AirSpring());

roadirc = RoadIRC(INIT_RoadIRC(init_params));
roadgbt = RoadGBT(INIT_RoadGBT(init_params));

%% Plot road Profile
Yirc = roadirc.dis_t(init_params.t);
Ygbt = roadgbt.dis_t(init_params.t);

S = init_params.t*init_params.v;


figure(1);
plot(S, Yirc, 'b')
hold on
plot(S, Ygbt ,'r')
hold off;
legend(roadirc.roadtype, roadgbt.roadtype);
xlim([0 roadirc.d1])
grid on
grid minor
tit = strcat('Compare two Standard Road Profile');
title(tit);
xlabel('Displacement [m]');
ylabel('Displacement [m]');
saveas(figure(1), 'img/Compare/IRCvsGBT/r_road.png');

close all;

% Plot Time Respones
init = INIT(init_params, airspring);
init.ShowThongSo();


solveT_IRC = SolverT(init, roadirc, airspring);
solveT_IRC.SolvingTimeResponse(init_params.v*3.6);

solveT_GBT = SolverT(init, roadgbt, airspring);
solveT_GBT.SolvingTimeResponse(init_params.v*3.6);


leg1 = strcat('IRC standard non-linear');
leg2 = strcat('IRC standard linear');
leg3 = strcat('GB/T standard non-linear');
leg4 = strcat('GB/T standard linear');


figure(1)
plot(solveT_IRC.T, solveT_IRC.X_non(:, 3), 'b');
hold on
plot(solveT_IRC.T, solveT_IRC.X_lin(:, 3), '--b');

plot(solveT_GBT.T, solveT_GBT.X_non(:, 3), 'r');
plot(solveT_GBT.T, solveT_GBT.X_lin(:, 3), '--r');
hold off
legend(leg1, leg2, leg3, leg4);
grid on
grid minor
tit = strcat('Car Body Displacement at ', num2str(init_params.v*3.6),' km/h');
title(tit);
xlabel('Time (s)');
ylabel('Displacement (m)');
saveas(figure(1), 'img/Compare/IRCvsGBT/a1_dis.png');


figure(2)
plot(solveT_IRC.T, solveT_IRC.rev_X_non, 'b');
hold on
plot(solveT_IRC.T, solveT_IRC.rev_X_lin, '--b');

plot(solveT_GBT.T, solveT_GBT.rev_X_non, 'r');
plot(solveT_GBT.T, solveT_GBT.rev_X_lin, '--r');
hold off
legend(leg1, leg2, leg3, leg4);
grid on
grid minor
tit = strcat('Relative Displacement at ', num2str(init_params.v*3.6),' km/h');
title(tit);
xlabel('Time (s)');
ylabel('Relative Displacement (m)');
saveas(figure(2), 'img/Compare/IRCvsGBT/a2_revdis.png');


figure(3)
plot(solveT_IRC.T, solveT_IRC.a_non, 'b');
hold on
plot(solveT_IRC.T, solveT_IRC.a_lin, '--b');

plot(solveT_GBT.T, solveT_GBT.a_non, 'r');
plot(solveT_GBT.T, solveT_GBT.a_lin, '--r');
hold off
legend(leg1, leg2, leg3, leg4);
grid on
grid minor
tit = strcat('Body Acceleration at ', num2str(init_params.v*3.6),' km/h');
title(tit);
xlabel('Time (s)');
ylabel('Acceleration (m/s^2)');
saveas(figure(3), 'img/Compare/IRCvsGBT/a3_acc.png');

close all


%% Plot Freq Respones
solveV_IRC = SolverV(solveT_IRC, init_params);
solveV_GBT = SolverV(solveT_GBT, init_params);

solveV_IRC.SolvingFreqResponse();
solveV_GBT.SolvingFreqResponse();


figure(1)
plot(init_params.vLin, solveV_IRC.BVA_non, 'b');
hold on
plot(init_params.vLin, solveV_IRC.BVA_lin, '--b');

plot(init_params.vLin, solveV_GBT.BVA_non, 'r');
plot(init_params.vLin, solveV_GBT.BVA_lin, '--r');
hold off
legend({leg1, leg2, leg3, leg4}, 'Position',[0.3, 0.8, 0, 0]);
grid on
grid minor
tit = strcat('Body Vibration Acceleration');
title(tit);
xlabel('Car speed (km/h)');
ylabel('BVA (m/s^2)');
saveas(figure(1), 'img/Compare/IRCvsGBT/v1_BVA.png');

figure(2)
plot(init_params.vLin, solveV_IRC.RMSA_non, 'b');
hold on
plot(init_params.vLin, solveV_IRC.RMSA_lin, '--b');

plot(init_params.vLin, solveV_GBT.RMSA_non, 'r');
plot(init_params.vLin, solveV_GBT.RMSA_lin, '--r');
hold off
legend({leg1, leg2, leg3, leg4}, 'Position',[0.72, 0.7, 0, 0]);
grid on
grid minor
tit = strcat('RMS Body Vibration Acceleration');
title(tit);
xlabel('Car speed (km/h)');
ylabel('RMS(BVA) (m/s^2)');
saveas(figure(2), 'img/Compare/IRCvsGBT/v2_RMSA.png');

figure(3)
plot(init_params.vLin, solveV_IRC.SDD_non, 'b');
hold on
plot(init_params.vLin, solveV_IRC.SDD_lin, '--b');

plot(init_params.vLin, solveV_GBT.SDD_non, 'r');
plot(init_params.vLin, solveV_GBT.SDD_lin, '--r');
hold off
legend({leg1, leg2, leg3, leg4}, 'Position',[0.72, 0.81, 0, 0]);
grid on
grid minor
tit = strcat('Suspension Dynamic Deflection');
title(tit);
xlabel('Car speed (km/h)');
ylabel('SDD (m)');
saveas(figure(3), 'img/Compare/IRCvsGBT/v3_SDD.png');


figure(4)
plot(init_params.vLin, solveV_IRC.TDL_non, 'b');
hold on
plot(init_params.vLin, solveV_IRC.TDL_lin, '--b');

plot(init_params.vLin, solveV_GBT.TDL_non, 'r');
plot(init_params.vLin, solveV_GBT.TDL_lin, '--r');
hold off
legend({leg1, leg2, leg3, leg4}, 'Position',[0.72, 0.81, 0, 0]);
grid on
grid minor
tit = strcat('Tire relative Dynamic Load');
title(tit);
xlabel('Car speed (km/h)');
ylabel('TDL (N)');
saveas(figure(4), 'img/Compare/IRCvsGBT/v4_TDL.png');


