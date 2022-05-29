figure(2)
plot(init_params.vLin, solveV_IRC.SDD_lin, 'b','LineWidth',2);
hold on
plot(init_params.vLin, solveV_GBT.SDD_lin, 'm','LineWidth',2);
plot(init_params.vLin, solveV_IRCSUG.SDD_lin, 'r','LineWidth',2);
plot(init_params.vLin, solveV_GBTSUG.SDD_lin, 'c','LineWidth',2);
hold off
legend(roadirc.roadtype, roadgbt.roadtype, roadircSUG.roadtype, roadgbtSUG.roadtype);
grid on
grid minor
tit = strcat('Suspension Dynamic Deflection of Air Spring');
title(tit);
xlabel('Car speed (km/h)');
ylabel('SDD (m)');