clc; clear; close all;

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



leg1 = 'IRC type';
leg2 = 'GB/T type';
leg3 = 'IRC suggestion type';
leg4 = 'GB/T suggestion type';


figure(1)
plot(VLin, IRC_FN_err_non, 'b' ,'LineWidth',2)
hold on
plot(VLin, GBT_FN_err_non, 'm' ,'LineWidth',2)
plot(VLin, IRCSUG_FN_err_non, 'r' ,'LineWidth',2)
plot(VLin, GBTSUG_FN_err_non, 'c' ,'LineWidth',2)
grid on
grid minor
legend(leg1, leg2, leg3, leg4);
xlabel('Car speed (km/h)')
ylabel('ERROR (%)')
tit = strcat('Natural Frequency Calculation of Air Spring');
title(tit)
plot([VLin(1), VLin(end)], [0 0], 'k');
hold off;






figure(2)
plot(VLin, IRC_FN_err_lin, 'b' ,'LineWidth',2)
hold on
plot(VLin, GBT_FN_err_lin, 'm' ,'LineWidth',2)
plot(VLin, IRCSUG_FN_err_lin, 'r' ,'LineWidth',2)
plot(VLin, GBTSUG_FN_err_lin, 'c' ,'LineWidth',2)
grid on
grid minor
legend(leg1, leg2, leg3, leg4);
xlabel('Car speed (km/h)')
ylabel('ERROR (%)')
tit = strcat('Natural Frequency Calculation of Leaf Spring');
title(tit)
plot([VLin(1), VLin(end)], [0 0], 'k');
hold off;




figure(3)
plot(VLin, IRC_ZT_err_non, 'b' ,'LineWidth',2)
hold on
plot(VLin, GBT_ZT_err_non, 'm' ,'LineWidth',2)
plot(VLin, IRCSUG_ZT_err_non, 'r' ,'LineWidth',2)
plot(VLin, GBTSUG_ZT_err_non, 'c' ,'LineWidth',2)
hold off;
grid on
grid minor
legend(leg1, leg2, leg3, leg4);
xlabel('Car speed (km/h)')
ylabel('ERROR (%)')
tit = strcat('Damping Ratio Calculation of Air Spring');
title(tit)
ylim([-19.4, -17.6])

figure(4)
plot(VLin, IRC_ZT_err_lin, 'b' ,'LineWidth',2)
hold on
plot(VLin, GBT_ZT_err_lin, 'm' ,'LineWidth',2)
plot(VLin, IRCSUG_ZT_err_lin, 'r' ,'LineWidth',2)
plot(VLin, GBTSUG_ZT_err_lin, 'c' ,'LineWidth',2)
% plot([VLin(1), VLin(end)], [0 0]);
hold off;
grid on
grid minor
legend(leg1, leg2, leg3, leg4);
xlabel('Car speed (km/h)')
ylabel('ERROR (%)')
tit = strcat('Damping Ratio Calculation of Leaf Spring');
title(tit)
ylim([-19.4, -17.6])































