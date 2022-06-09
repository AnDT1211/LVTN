clc; clear; close all;

init_params = INIT_Params();

airspring = AirSpring(INIT_AirSpring());

init = INIT(init_params, airspring);
init.ShowThongSo();


solveT_OLD = SolveOldMethod(init, airspring);
solveT_OLD.SolvingTimeResponse(0.1);

[~, idxMaxA_non] = findpeaks(-1*solveT_OLD.a_non);
[~, idxMaxA_lin] = findpeaks(-1*solveT_OLD.a_lin);
[~, idxMinA_non] = findpeaks(1*solveT_OLD.a_non);
[~, idxMinA_lin] = findpeaks(1*solveT_OLD.a_lin);


[~, idxMaxX_non] = findpeaks(solveT_OLD.X_non(:,3));
[~, idxMaxX_lin] = findpeaks(solveT_OLD.X_lin(:,3));
[~, idxMinX_non] = findpeaks(-1*solveT_OLD.X_non(:,3));
[~, idxMinX_lin] = findpeaks(-1*solveT_OLD.X_lin(:,3));



figure(1)
plot(solveT_OLD.T, solveT_OLD.X_non(:,3), 'r');
hold on
plot(solveT_OLD.T, solveT_OLD.X_lin(:,3), 'b');
plot(solveT_OLD.T(idxMaxX_non), solveT_OLD.X_non(idxMaxX_non,3), 'ro');
plot(solveT_OLD.T(idxMaxX_lin), solveT_OLD.X_lin(idxMaxX_lin,3), 'bo');

plot(solveT_OLD.T(idxMinX_non), solveT_OLD.X_non(idxMinX_non,3), 'r*');
plot(solveT_OLD.T(idxMinX_lin), solveT_OLD.X_lin(idxMinX_lin,3), 'b*');

% plot([0, solveT_OLD.T(idxMaxX_non(1))],...
%     [solveT_OLD.X_non(idxMaxX_non(1),3), solveT_OLD.X_non(idxMaxX_non(1),3)], 'r--')
% plot([0, solveT_OLD.T(idxMaxX_non(2))],...
%     [solveT_OLD.X_non(idxMaxX_non(2),3), solveT_OLD.X_non(idxMaxX_non(2),3)], 'r--')
% 
% plot([0, solveT_OLD.T(idxMaxX_lin(1))],...
%     [solveT_OLD.X_lin(idxMaxX_lin(1),3), solveT_OLD.X_lin(idxMaxX_lin(1),3)], 'b--')
% plot([0, solveT_OLD.T(idxMaxX_lin(2))],...
%     [solveT_OLD.X_lin(idxMaxX_lin(2),3), solveT_OLD.X_lin(idxMaxX_lin(2),3)], 'b--')
hold off
grid on
grid minor
xlabel('Time (s)');
ylabel('Displacement (m)')
title('Body Displacement - Old method')
legend('non-linear','linear')

pX_non = log(abs(solveT_OLD.X_non(idxMaxX_non(1),3)/solveT_OLD.X_non(idxMaxX_non(2),3)))/(3-2);
ZT_test_non = pX_non/sqrt(4*pi^2 + pX_non^2)

pX_lin = log(abs(solveT_OLD.X_lin(idxMaxX_lin(1),3)/solveT_OLD.X_lin(idxMaxX_lin(2),3)))/(3-2);
ZT_test_lin = pX_lin/sqrt(4*pi^2 + pX_lin^2)



zt_old_err_non = (ZT_test_non - init.zt_non)/init.zt_non*100
zt_old_err_lin = (ZT_test_lin - init.zt_lin)/init.zt_lin*100



% 





AA = solveT_OLD.a_non(idxMinA_non(3)) - solveT_OLD.a_non(idxMaxA_non(2));
BB = solveT_OLD.a_non(idxMinA_non(3)) - solveT_OLD.a_non(idxMaxA_non(3));

% AA
% BB

eq = AA/BB

zet = 1/sqrt(1 + pi^2/log(eq)^2)


figure(2)
plot(solveT_OLD.T, solveT_OLD.a_non, 'r')
hold on
plot(solveT_OLD.T, solveT_OLD.a_lin, 'b')
plot(solveT_OLD.T(idxMaxA_non), solveT_OLD.a_non(idxMaxA_non), 'ro')
plot(solveT_OLD.T(idxMaxA_lin), solveT_OLD.a_lin(idxMaxA_lin), 'bo')
plot(solveT_OLD.T(idxMinA_non), solveT_OLD.a_non(idxMinA_non), 'ro')
plot(solveT_OLD.T(idxMinA_lin), solveT_OLD.a_lin(idxMinA_lin), 'bo')





% plot([solveT_OLD.T(idxMaxA_non(2)), solveT_OLD.T(idxMaxA_non(2))], ...
%     [solveT_OLD.a_non(idxMaxA_non(2)), -5], 'r--')
% plot([solveT_OLD.T(idxMaxA_non(3)), solveT_OLD.T(idxMaxA_non(3))], ...
%     [solveT_OLD.a_non(idxMaxA_non(3)), -5], 'r--')
% 
% plot([solveT_OLD.T(idxMaxA_lin(2)), solveT_OLD.T(idxMaxA_lin(2))], ...
%     [solveT_OLD.a_lin(idxMaxA_lin(2)), -5], 'b--')
% plot([solveT_OLD.T(idxMaxA_lin(3)), solveT_OLD.T(idxMaxA_lin(3))], ...
%     [solveT_OLD.a_lin(idxMaxA_lin(3)), -5], 'b--')
hold off
grid on
grid minor
xlabel('Time (s)');
ylabel('Acceleration (m)')
title('Body Acceleration - Old method')
legend('non-linear','linear')
ylim([-5, 3])
% 
% 
% pT_lin = solveT_OLD.T(idxMaxA_lin(3)) - solveT_OLD.T(idxMaxA_lin(2));
% FN_CAL_lin = 1/pT_lin;
% 
% pT_non = solveT_OLD.T(idxMaxA_non(3)) - solveT_OLD.T(idxMaxA_non(2));
% FN_CAL_non = 1/pT_non;
% 
% fn_old_err_non = (FN_CAL_non - init.fn_non)/init.fn_non*100
% fn_old_err_lin = (FN_CAL_lin - init.fn_lin)/init.fn_lin*100
% 
% save M20.mat

