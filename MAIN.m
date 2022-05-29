clc; clear; close all;

t = linspace(0,5,1e4);

%% Airspring params
Height = [3.5, 4, 5, 6, 7, 8, 9, 10, 11, 13]*0.0254;
Force = [2100, 1800, 1700, 1400, 1200, 1200, 1150, 1100, 850, 60;      %20 PSI
        3600, 3400, 3100,  2700,  2500, 2600, 2400,2200, 1700, 460;     %40 PSI
        5100, 5000, 4600, 4000, 3800, 3900, 3600, 3200, 2700, 1100;    %60 PSI
        6700, 6600, 6100, 5400, 5200, 5300, 4900, 4300, 3600, 1800;    %80 PSI
        8300, 8200, 7600, 6700, 6500, 6600, 5800, 5500, 4600, 2300] * 4.44822162;
PSI = [20; 40; 60; 80; 100];

% INPUT
Des_PSI = 70;
Des_MASS = 2e3;

% DEFINE
airspring = AirSpring(Height, Force, PSI, Des_PSI, Des_MASS);
% airspring.PlotDesHeight()
% airspring.plotStiff2();


v = 20/3.6;
%% Road IRC
roadirc = RoadIRC(0.1, 5, v ,'IRC type');
% roadirc.Plotitng_s(t, 'b');
% disp('plot road IRC');
% input('Press ''Enter'' to continue...','s');
%% Road GBT
roadgbt = RoadGBT(0.04, 0.4, v, 'GB/T type');
% roadgbt.Plotitng_s(t, 'b');
% disp('plot road GBT');
% input('Press ''Enter'' to continue...','s');


%% Road GBT suggest
roadgbtSUG = RoadGBT(0.1, 1, v, 'GBT suggestion type');
% roadgbtSUG.Plotitng_s(t, 'b');
% disp('plot road GBT suggestion');
% input('Press ''Enter'' to continue...','s');
% 
%% Road IRC suggest
roadircSUG = RoadIRC(0.1, 1, v,'IRC Suggestion type');
% roadircSUG.Plotitng_s(t, 'b');
% disp('plot road IRC suggestion');
% input('Press ''Enter'' to continue...','s');

%%
ms = Des_MASS;

cs = 9e3;
ku = 870000;
mu_non = 200;
mu_lin = 250;

init = INIT(cs, mu_non, mu_lin, ku, airspring);
init.ShowThongSo();


% input('Press ''Enter'' to continue...','s');



%% Calculating
Vlin = linspace(0, 100, 20);
ircsolve = Solver2(init, roadirc, airspring, t, Vlin, v);
gbtsolve = Solver2(init, roadgbt, airspring, t, Vlin, v);
ircsolveSUG = Solver2(init, roadircSUG, airspring, t, Vlin, v);
gbtsolveSUG = Solver2(init, roadgbtSUG, airspring, t, Vlin, v);

% 
% 
% SSS = Solver2MD(ircsolve, gbtsolve);
% SSS.plottingTimeRes();
% input('Press ''Enter'' to continue...','s');
% SSS.PlottingFreqResponse();
% input('Press ''Enter'' to continue...','s');
% 
% 
% 
% SSS = Solver2MD(ircsolve, ircsolveSUG);
% SSS.plottingTimeRes();
% input('Press ''Enter'' to continue...','s');
% SSS.PlottingFreqResponse();
% input('Press ''Enter'' to continue...','s');
% 
% 
% SSS = Solver2MD(gbtsolve, gbtsolveSUG);
% SSS.plottingTimeRes();
% input('Press ''Enter'' to continue...','s');
% SSS.PlottingFreqResponse();
% input('Press ''Enter'' to continue...','s');
% 
% 
% SSS = Solver2MD(ircsolveSUG, gbtsolveSUG);
% SSS.plottingTimeRes();
% input('Press ''Enter'' to continue...','s');
% SSS.PlottingFreqResponse();
% input('Press ''Enter'' to continue...','s');
% 










Vlin = linspace(10, 100, 20);
%% tim fn zeta IRC


% FindFnIRC = SolveFFnIRC(init, roadirc, airspring, t, Vlin, v, 'duoi');
% FindFnIRC.Plotting();
% save('FN_IRC.mat');
% input('Press ''Enter'' to continue...','s');
% 
% FindZtIRC = SolveFZtIRC(init, roadirc, airspring, t, Vlin, v, 'tren');
% FindZtIRC.Plotting();
% save('ZT_IRC.mat');
% input('Press ''Enter'' to continue...','s');

% 
% 
%% tim fn zeta GBT
% 
% 
% FindFnGBT = SolveFFnGBT(init, roadgbt, airspring, t, Vlin, v, 'duoi');
% FindFnGBT.Plotting();
% save('FN_GBT.mat');
% input('Press ''Enter'' to continue...','s');
% 
% 
% FindZtGBT = SolveFZtGBT(init, roadgbt, airspring, t, Vlin, v, 'tren');
% FindZtGBT.Plotting();
% save('ZT_GBT.mat');
% input('Press ''Enter'' to continue...','s');
% 
% 
% 
%% tim fn zeta IRC SUGGESTION
% 
% 
% FindFnIRC_SUG = SolveFFnIRC_SUG(init, roadircSUG, airspring, t, Vlin, v, 'duoi');
% FindFnIRC_SUG.Plotting();
% save('FN_IRCSUG.mat');
% input('Press ''Enter'' to continue...','s');
% 
% FindZtIRC_SUG = SolveFZtIRC_SUG(init, roadircSUG, airspring, t, Vlin, v, 'tren');
% FindZtIRC_SUG.Plotting();
% save('ZT_IRCSUG.mat');
% input('Press ''Enter'' to continue...','s');
% 
% 
% 
%% tim fn zeta GBT SUGGESTION
% 
% 
% FindFnGBT_SUG = SolveFFnGBT_SUG(init, roadgbtSUG, airspring, t, Vlin, v, 'duoi');
% FindFnGBT_SUG.Plotting();
% save('FN_GBTSUG.mat');
% input('Press ''Enter'' to continue...','s');
% 
% 
FindZtGBT_SUG = SolveFZtGBT_SUG(init, roadgbt, airspring, t, Vlin, v, 'duoi');
FindZtGBT_SUG.Plotting();
save('ZT_GBTSUG.mat');
input('Press ''Enter'' to continue...','s');




















% 
% 
% ircsolveSUG = Solver(init, roadircSUG, airspring, t);


% ircsolve.FINDING1();
% ircsolve.FINDING3();

% ircsolveSUG.FINDING2();
% ircsolveSUG.FINDING3();


% gbtsolve.FINDING1();



% gbtSUGsolve = Solver(init, roadgbtSUG, airspring, t);

% ircsolve.PlottingFreqResponse();
% ircsolve.PlottingTimeResponse();

% ircsolve.Solving_FN_ZT(50);
% ircsolve.Solving_FN_ZT_MultiV();



% gbtsolve.Solving_FN_ZT_MultiV_GBT2();
% gbtsolve.Solving_FN_ZT_MultiV_GBT();


% gbtSUGsolve.Solving_FN_ZT_MultiV_GBT2();






% solverss = SolverSS(ircsolve, gbtsolve);
% solverss.plotSS_TimeResponse();
% solverss.plotSS_FreqResponse();


% solverss.plotRoad();


%%
% figure(5)
% plot(gbtsolve.V_Linspace, gbtsolve.RMSA_lin, 'b')
% hold on
% plot(gbtsolve.V_Linspace, gbtsolve.RMSA_non, 'r')
% hold off
% grid on
% grid minor
% legend('linear', 'nonlinear');
% tit = strcat('RMSA - Body Vibration Root Mean Square');
% title(tit);
% xlabel('Car speed (km/h)');
% ylabel('Acceleration (m/s^2)');







