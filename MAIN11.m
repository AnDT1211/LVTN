clc; clear; close all;



% init_params = INIT_Params();
% 
% airspring = AirSpring(INIT_AirSpring());
% 
% roadirc = RoadIRC(INIT_RoadIRC(init_params));
% roadgbt = RoadGBT(INIT_RoadGBT(init_params));
% roadircSUG = RoadIRC(INIT_RoadIRC_SUG(init_params));
% roadgbtSUG = RoadGBT(INIT_RoadGBT_SUG(init_params));
% 
% 
% Yirc = roadirc.dis_t(init_params.t);
% Ygbt = roadgbt.dis_t(init_params.t);
% YircSUG = roadircSUG.dis_t(init_params.t);
% YgbtSUG = roadgbtSUG.dis_t(init_params.t);
% 
% S = init_params.t*init_params.v;
% 
% dk = Yirc > 0;
% S(~dk) = nan;
% 
% figure(1);
% plot(S, Yirc, 'b' ,'LineWidth',2)
% hold on
% plot(S, Ygbt ,'m' ,'LineWidth',2)
% plot(S, YircSUG ,'r' ,'LineWidth',2)
% plot(S, YgbtSUG ,'c' ,'LineWidth',2)
% legend(roadirc.roadtype, roadgbt.roadtype, roadircSUG.roadtype, roadgbtSUG.roadtype);
% grid on
% grid minor
% title('Road profile of 4 Roads');
% xlabel('Displacement (m)');
% ylabel('Displacement (m)');
% 
% 
% init = INIT(init_params, airspring);
% init.ShowThongSo();
% 
% 
% solveT_IRC = SolverT(init, roadirc, airspring);
% solveT_GBT = SolverT(init, roadgbt, airspring);
% solveT_IRCSUG = SolverT(init, roadircSUG, airspring);
% solveT_GBTSUG = SolverT(init, roadgbtSUG, airspring);
% 
% 
% solveV_IRC = SolverV(solveT_IRC, init_params);
% solveV_GBT = SolverV(solveT_GBT, init_params);
% solveV_IRCSUG = SolverV(solveT_IRCSUG, init_params);
% solveV_GBTSUG = SolverV(solveT_GBTSUG, init_params);
% 
% solveV_IRC.SolvingFreqResponse();
% solveV_GBT.SolvingFreqResponse();
% solveV_IRCSUG.SolvingFreqResponse();
% solveV_GBTSUG.SolvingFreqResponse();
% 
% save('M11.mat');

load('M11.mat');


% figure(1)
% plot(init_params.vLin, solveV_IRC.SDD_non, 'b','LineWidth',2);
% hold on
% plot(init_params.vLin, solveV_GBT.SDD_non, 'm','LineWidth',2);
% plot(init_params.vLin, solveV_IRCSUG.SDD_non, 'r','LineWidth',2);
% plot(init_params.vLin, solveV_GBTSUG.SDD_non, 'c','LineWidth',2);
% hold off
% legend(roadirc.roadtype, roadgbt.roadtype, roadircSUG.roadtype, roadgbtSUG.roadtype);
% grid on
% grid minor
% tit = strcat('Suspension Dynamic Deflection of Air Spring');
% title(tit);
% xlabel('Car speed (km/h)');
% ylabel('SDD (m)');
% 
% figure(2)
% plot(init_params.vLin, solveV_IRC.SDD_lin, 'b','LineWidth',2);
% hold on
% plot(init_params.vLin, solveV_GBT.SDD_lin, 'm','LineWidth',2);
% plot(init_params.vLin, solveV_IRCSUG.SDD_lin, 'r','LineWidth',2);
% plot(init_params.vLin, solveV_GBTSUG.SDD_lin, 'c','LineWidth',2);
% hold off
% legend(roadirc.roadtype, roadgbt.roadtype, roadircSUG.roadtype, roadgbtSUG.roadtype);
% grid on
% grid minor
% tit = strcat('Suspension Dynamic Deflection of Air Spring');
% title(tit);
% xlabel('Car speed (km/h)');
% ylabel('SDD (m)');



% [a, b_gbt_non] = max(solveV_GBT.BVA_non)
% plot(init_params.vLin(b_gbt_non), solveV_GBT.BVA_non(b_gbt_non), '-mo','LineWidth',2)
% [a, b_ircSUG_non] = max(solveV_IRCSUG.BVA_non)
% plot(init_params.vLin(b_ircSUG_non), solveV_IRCSUG.BVA_non(b_ircSUG_non), '-ro','LineWidth',2)
% [a, b_gbtSUG_non] = max(solveV_GBTSUG.BVA_non)
% plot(init_params.vLin(b_gbtSUG_non), solveV_GBTSUG.BVA_non(b_gbtSUG_non), '-co','LineWidth',2)

%% abc


figure(2)
plot(init_params.vLin, solveV_IRC.BVA_non, 'b','LineWidth',2);
hold on
plot(init_params.vLin, solveV_GBT.BVA_non, 'm','LineWidth',2);
plot(init_params.vLin, solveV_IRCSUG.BVA_non, 'r','LineWidth',2);
plot(init_params.vLin, solveV_GBTSUG.BVA_non, 'c','LineWidth',2);
legend(roadirc.roadtype, roadgbt.roadtype, roadircSUG.roadtype, roadgbtSUG.roadtype);
grid on
grid minor
tit = strcat('Body Vibration Acceleration of Air Spring');
title(tit);
xlabel('Car speed (km/h)');
ylabel('BVA (m/s^2)');
[a, b_gbt_non] = max(solveV_GBT.BVA_non)
plot(init_params.vLin(b_gbt_non), solveV_GBT.BVA_non(b_gbt_non), '-mo','LineWidth',2)
[a, b_ircSUG_non] = max(solveV_IRCSUG.BVA_non)
plot(init_params.vLin(b_ircSUG_non), solveV_IRCSUG.BVA_non(b_ircSUG_non), '-ro','LineWidth',2)
[a, b_gbtSUG_non] = max(solveV_GBTSUG.BVA_non)
plot(init_params.vLin(b_gbtSUG_non), solveV_GBTSUG.BVA_non(b_gbtSUG_non), '-co','LineWidth',2)
hold off


figure(3)
plot(init_params.vLin, solveV_IRC.BVA_lin, 'b','LineWidth',2);
hold on
plot(init_params.vLin, solveV_GBT.BVA_lin, 'm','LineWidth',2);
plot(init_params.vLin, solveV_IRCSUG.BVA_lin, 'r','LineWidth',2);
plot(init_params.vLin, solveV_GBTSUG.BVA_lin, 'c','LineWidth',2);
legend(roadirc.roadtype, roadgbt.roadtype, roadircSUG.roadtype, roadgbtSUG.roadtype);
grid on
grid minor
tit = strcat('Body Vibration Acceleration of Leaf Spring');
title(tit);
xlabel('Car speed (km/h)');
ylabel('BVA (m/s^2)');
[a, b_gbt_lin] = max(solveV_GBT.BVA_lin);
plot(init_params.vLin(b_gbt_lin), solveV_GBT.BVA_lin(b_gbt_lin), '-mo','LineWidth',2)
[a, b_ircSUG_lin] = max(solveV_IRCSUG.BVA_lin);
plot(init_params.vLin(b_ircSUG_lin), solveV_IRCSUG.BVA_lin(b_ircSUG_lin), '-ro','LineWidth',2)
[a, b_gbtSUG_lin] = max(solveV_GBTSUG.BVA_lin);
plot(init_params.vLin(b_gbtSUG_lin), solveV_GBTSUG.BVA_lin(b_gbtSUG_lin), '-co','LineWidth',2)
hold off



load('M6.mat')
IRC_FN_non = SOLVE.FN_CAL_non;
IRC_FN_lin = SOLVE.FN_CAL_lin;
IRC_ZT_non = SOLVE.ZT_CAL_non;
IRC_ZT_lin = SOLVE.ZT_CAL_lin;

IRC_FN_err_non = fn_err_non;
IRC_FN_err_lin = fn_err_lin;
IRC_ZT_err_non = zt_err_non;
IRC_ZT_err_lin = zt_err_lin;


load('M7.mat')
GBT_FN_non = SOLVE.FN_CAL_non;
GBT_FN_lin = SOLVE.FN_CAL_lin;
GBT_ZT_non = SOLVE.ZT_CAL_non;
GBT_ZT_lin = SOLVE.ZT_CAL_lin;

GBT_FN_err_non = fn_err_non;
GBT_FN_err_lin = fn_err_lin;
GBT_ZT_err_non = zt_err_non;
GBT_ZT_err_lin = zt_err_lin;


load('M9.mat')
GBTSUG_FN_non = SOLVE.FN_CAL_non;
GBTSUG_FN_lin = SOLVE.FN_CAL_lin;
GBTSUG_ZT_non = SOLVE.ZT_CAL_non;
GBTSUG_ZT_lin = SOLVE.ZT_CAL_lin;

GBTSUG_FN_err_non = fn_err_non;
GBTSUG_FN_err_lin = fn_err_lin;
GBTSUG_ZT_err_non = zt_err_non;
GBTSUG_ZT_err_lin = zt_err_lin;


load('M8.mat')
IRCSUG_FN_non = SOLVE.FN_CAL_non;
IRCSUG_FN_lin = SOLVE.FN_CAL_lin;
IRCSUG_ZT_non = SOLVE.ZT_CAL_non;
IRCSUG_ZT_lin = SOLVE.ZT_CAL_lin;

IRCSUG_FN_err_non = fn_err_non;
IRCSUG_FN_err_lin = fn_err_lin;
IRCSUG_ZT_err_non = zt_err_non;
IRCSUG_ZT_err_lin = zt_err_lin;
load('M11.mat');




figure(4)
% X = [init_params.vLin(b_gbt_non), init_params.vLin(b_ircSUG_non), init_params.vLin(b_gbtSUG_non)]
% x = [1980 1990 2000];
ygbt_non = [IRC_FN_err_non(b_gbt_non), GBT_FN_err_non(b_gbt_non), IRCSUG_FN_err_non(b_gbt_non), GBTSUG_FN_err_non(b_gbt_non)];
yircSUG_non = [IRC_FN_err_non(b_ircSUG_non), GBT_FN_err_non(b_ircSUG_non), IRCSUG_FN_err_non(b_ircSUG_non), GBTSUG_FN_err_non(b_ircSUG_non)];
ygbtSUG_non = [IRC_FN_err_non(b_gbtSUG_non), GBT_FN_err_non(b_gbtSUG_non), IRCSUG_FN_err_non(b_gbtSUG_non), GBTSUG_FN_err_non(b_gbtSUG_non)];
Y = abs([ygbt_non; yircSUG_non; ygbtSUG_non]);
bar(Y)
title('Natural Frequency Estimate Error at specific Car Velocity of Air Spring')
ylabel('Error %')

% xlabel(['1: At ', num2str(init_params.vLin(b_gbt_non), 4), ' km/h     |    2: At ', ...
%         num2str(init_params.vLin(b_ircSUG_non), 4), ' km/h     |     3: At ', ...
%         num2str(init_params.vLin(b_gbtSUG_non), 4), ' km/h']);

xlabel({['1: At ', num2str(init_params.vLin(b_gbt_non), 4), ' km/h (at max(BVA) GB/T type)'];
        ['2: At ', num2str(init_params.vLin(b_ircSUG_non), 4), ' km/h (at max(BVA) IRC suggestion type)'];
        ['3: At ', num2str(init_params.vLin(b_gbtSUG_non), 4), ' km/h (at max(BVA) GB/T suggestion type)']});
legend(roadirc.roadtype, roadgbt.roadtype, roadircSUG.roadtype, roadgbtSUG.roadtype);





figure(5)
% X = [init_params.vLin(b_gbt_non), init_params.vLin(b_ircSUG_non), init_params.vLin(b_gbtSUG_non)]
% x = [1980 1990 2000];
ygbt_lin = [IRC_FN_err_lin(b_gbt_lin), GBT_FN_err_lin(b_gbt_lin), IRCSUG_FN_err_lin(b_gbt_lin), GBTSUG_FN_err_lin(b_gbt_lin)];
yircSUG_lin = [IRC_FN_err_lin(b_ircSUG_lin), GBT_FN_err_lin(b_ircSUG_lin), IRCSUG_FN_err_lin(b_ircSUG_lin), GBTSUG_FN_err_lin(b_ircSUG_lin)];
ygbtSUG_lin = [IRC_FN_err_lin(b_gbtSUG_lin), GBT_FN_err_lin(b_gbtSUG_lin), IRCSUG_FN_err_lin(b_gbtSUG_lin), GBTSUG_FN_err_lin(b_gbtSUG_lin)];
Y = abs([ygbt_lin; yircSUG_lin; ygbtSUG_lin]);
bar(Y)
title('Natural Frequency Estimate Error at specific Car Velocity of Leaf Spring')
ylabel('Error %')

xlabel({['1: At ', num2str(init_params.vLin(b_gbt_lin), 4), ' km/h (at max(BVA) GB/T type)'];
        ['2: At ', num2str(init_params.vLin(b_ircSUG_lin), 4), ' km/h (at max(BVA) IRC suggestion type)'];
        ['3: At ', num2str(init_params.vLin(b_gbtSUG_lin), 4), ' km/h (at max(BVA) GB/T suggestion type)']});
legend(roadirc.roadtype, roadgbt.roadtype, roadircSUG.roadtype, roadgbtSUG.roadtype);





figure(6)
ygbt_non = [IRC_ZT_err_non(b_gbt_non), GBT_ZT_err_non(b_gbt_non), IRCSUG_ZT_err_non(b_gbt_non), GBTSUG_ZT_err_non(b_gbt_non)];
yircSUG_non = [IRC_ZT_err_non(b_ircSUG_non), GBT_ZT_err_non(b_ircSUG_non), IRCSUG_ZT_err_non(b_ircSUG_non), GBTSUG_ZT_err_non(b_ircSUG_non)];
ygbtSUG_non = [IRC_ZT_err_non(b_gbtSUG_non), GBT_ZT_err_non(b_gbtSUG_non), IRCSUG_ZT_err_non(b_gbtSUG_non), GBTSUG_ZT_err_non(b_gbtSUG_non)];
Y = abs([ygbt_non; yircSUG_non; ygbtSUG_non]);
bar(Y)
title('Damping Ratio Estimate Error at specific Car Velocity of Air Spring')
ylabel('Error %')

xlabel({['1: At ', num2str(init_params.vLin(b_gbt_non), 4), ' km/h (at max(BVA) GB/T type)'];
        ['2: At ', num2str(init_params.vLin(b_ircSUG_non), 4), ' km/h (at max(BVA) IRC suggestion type)'];
        ['3: At ', num2str(init_params.vLin(b_gbtSUG_non), 4), ' km/h (at max(BVA) GB/T suggestion type)']});
legend(roadirc.roadtype, roadgbt.roadtype, roadircSUG.roadtype, roadgbtSUG.roadtype);
ylim([0, 30])


figure(7)
ygbt_lin = [IRC_ZT_err_lin(b_gbt_lin), GBT_ZT_err_lin(b_gbt_lin), IRCSUG_ZT_err_lin(b_gbt_lin), GBTSUG_ZT_err_lin(b_gbt_lin)];
yircSUG_lin = [IRC_ZT_err_lin(b_ircSUG_lin), GBT_ZT_err_lin(b_ircSUG_lin), IRCSUG_ZT_err_lin(b_ircSUG_lin), GBTSUG_ZT_err_lin(b_ircSUG_lin)];
ygbtSUG_lin = [IRC_ZT_err_lin(b_gbtSUG_lin), GBT_ZT_err_lin(b_gbtSUG_lin), IRCSUG_ZT_err_lin(b_gbtSUG_lin), GBTSUG_ZT_err_lin(b_gbtSUG_lin)];
Y = abs([ygbt_lin; yircSUG_lin; ygbtSUG_lin]);
bar(Y)
title('Damping Ratio Estimate Error at specific Car Velocity of Leaf Spring')
ylabel('Error %')

xlabel({['1: At ', num2str(init_params.vLin(b_gbt_lin), 4), ' km/h (at max(BVA) GB/T type)'];
        ['2: At ', num2str(init_params.vLin(b_ircSUG_lin), 4), ' km/h (at max(BVA) IRC suggestion type)'];
        ['3: At ', num2str(init_params.vLin(b_gbtSUG_lin), 4), ' km/h (at max(BVA) GB/T suggestion type)']});
legend(roadirc.roadtype, roadgbt.roadtype, roadircSUG.roadtype, roadgbtSUG.roadtype);
ylim([0, 30])

















