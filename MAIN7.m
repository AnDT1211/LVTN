clc; clear; close all;


init_params = INIT_Params();

airspring = AirSpring(INIT_AirSpring());

road = RoadGBT(INIT_RoadGBT(init_params));


init = INIT(init_params, airspring);
init.ShowThongSo();


solveT = SolverT(init, road, airspring);


VLin = linspace(10, 100, 5e2);



solveT.SolvingTimeResponse(VLin(300));


[~, idxMaxA_non] = findpeaks(1*solveT.X_non(:,3));
[~, idxMaxA_lin] = findpeaks(1*solveT.X_lin(:,3));
figure(1)
plot(solveT.T, solveT.X_non(:,3),'r')
hold on
plot(solveT.T(idxMaxA_non), solveT.X_non(idxMaxA_non, 3),'ro')
plot(solveT.T, solveT.X_lin(:,3),'b')
plot(solveT.T(idxMaxA_lin), solveT.X_lin(idxMaxA_lin, 3),'bo')

%% abc

close all;


[~, idxMaxA_non] = findpeaks(-1*solveT.a_non);
[~, idxMaxA_lin] = findpeaks(-1*solveT.a_lin);
[~, idxMaxX_non] = findpeaks(solveT.X_non(:,3));
[~, idxMaxX_lin] = findpeaks(solveT.X_lin(:,3));


SOLVE = SolverFnZt(VLin, INIT_FnZtGBT(), solveT);

SOLVE.CalculateFnZT(idxMaxA_non, idxMaxA_lin, idxMaxX_non, idxMaxX_lin);



leg1 = 'non-linear';
leg2 = 'linear';
leg3 = 'init param';

figure(1)
plot(VLin, SOLVE.FN_CAL_non,'r');
hold on
plot(VLin, SOLVE.FN_CAL_lin,'b');
plot([VLin(1), VLin(end)], [init.fn_non, init.fn_non],'g')
grid on
grid minor
legend(leg1, leg2, leg3);
% ylim([0, init.fn_non + 0.2])
xlabel('Car speed (km/h)')
ylabel('Natural frequency (Hz)')
tit = strcat('Natural Frequency Calculation-',road.roadtype);
title(tit)



FN_INIT = init.fn_non*ones(1,length(SOLVE.FN_CAL_non));
fn_err_non = (SOLVE.FN_CAL_non - FN_INIT)/init.fn_non*100;
fn_err_lin = (SOLVE.FN_CAL_lin - FN_INIT)/init.fn_non*100;

figure(2)
plot(VLin, fn_err_non,'r');
hold on
plot(VLin, fn_err_lin,'b');
plot([VLin(1), VLin(end)], [0, 0], 'g')
grid on
grid minor
legend(leg1, leg2, leg3);
% ylim([min(err_non) - 1, 1])
xlabel('Car speed (km/h)')
ylabel('ERROR (%)')
tit = strcat('Natural Frequency Calculation-',road.roadtype);
title(tit)



figure(3)
plot(VLin, SOLVE.ZT_CAL_non,'r');
hold on
plot(VLin, SOLVE.ZT_CAL_lin,'b');
plot([VLin(1), VLin(end)], [init.zt_non, init.zt_non],'g')
grid on
grid minor
legend(leg1, leg2, leg3);
% ylim([0, 0.45])
xlabel('Car speed (km/h)')
ylabel('Damping ratio (1)')
tit = strcat('Damping ratio Calculation-',road.roadtype);
title(tit)



ZT_INIT = init.zt_non*ones(1,length(SOLVE.ZT_CAL_non));
zt_err_non = (SOLVE.ZT_CAL_non - ZT_INIT)/init.zt_non*100;
zt_err_lin = (SOLVE.ZT_CAL_lin - ZT_INIT)/init.zt_non*100;

figure(4)
plot(VLin, zt_err_non,'r');
hold on
plot(VLin, zt_err_lin,'b');
plot([VLin(1), VLin(end)], [0, 0], 'g')
grid on
grid minor
legend(leg1, leg2, leg3);
% ylim([min(err_non) - 1, 1])
xlabel('Car speed (km/h)')
ylabel('ERROR (%)')
tit = strcat('Damping Ratio Calculation-',road.roadtype);
title(tit)

save('M7.mat');







