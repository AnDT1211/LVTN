clc; clear; close all;

init_params = INIT_Params();

airspring = AirSpring(INIT_AirSpring());


height = 0.04 : 0.01 : 0.1;
len = 0.5:0.5:5;
for dd1 = 1 : length(len)
    disp(num2str(dd1));
    for dd2 = 1 : length(height)

        init_roadIRC = INIT_RoadIRC(init_params);
        init_roadIRC.d2 = height(dd2);
        init_roadIRC.d1 = len(dd1);

        roadirc = RoadIRC(init_roadIRC);

        init = INIT(init_params, airspring);
    %     init.ShowThongSo();

    
        solveT_IRC = SolverT(init, roadirc, airspring);
    %     solveT_IRC.SolvingTimeResponse(init_params.v*3.6);

        solveV_IRC = SolverV(solveT_IRC, init_params); 
        solveV_IRC.SolvingFreqResponse(); 

        [a, b_non] = max(solveV_IRC.BVA_non);
        [a, b_lin] = max(solveV_IRC.BVA_lin);


        maxA_non(dd1, dd2) = init_params.vLin(b_non);
        maxA_lin(dd1, dd2) = init_params.vLin(b_lin);


    end
end

figure(1)
surf(len, height, maxA_non)
% figure(1)
% plot(height, maxA_non, 'r')
% hold on
% plot(height, maxA_lin, 'r')




% figure(1)
% plot(init_params.vLin, solveV_IRC.BVA_non, 'b');
% hold on
% plot(init_params.vLin, solveV_IRC.BVA_lin, '--b');
% 
% plot(init_params.vLin, solveV_GBT.BVA_non, 'r');
% plot(init_params.vLin, solveV_GBT.BVA_lin, '--r');
% hold off
% legend({leg1, leg2, leg3, leg4}, 'Position',[0.72, 0.25, 0, 0]);
% grid on
% grid minor
% tit = strcat('Body Vibration Acceleration');
% title(tit);
% xlabel('Car speed (km/h)');
% ylabel('BVA (m/s^2)');
% saveas(figure(1), 'img/Compare/IRCvsIRC_SUG/v1_BVA.png');
% 
% figure(2)
% plot(init_params.vLin, solveV_IRC.RMSA_non, 'b');
% hold on
% plot(init_params.vLin, solveV_IRC.RMSA_lin, '--b');
% 
% plot(init_params.vLin, solveV_GBT.RMSA_non, 'r');
% plot(init_params.vLin, solveV_GBT.RMSA_lin, '--r');
% hold off
% legend({leg1, leg2, leg3, leg4}, 'Position',[0.72, 0.25, 0, 0]);
% grid on
% grid minor
% tit = strcat('RMS Body Vibration Acceleration');
% title(tit);
% xlabel('Car speed (km/h)');
% ylabel('RMS(BVA) (m/s^2)');
% saveas(figure(2), 'img/Compare/IRCvsIRC_SUG/v2_RMSA.png');
% 
% figure(3)
% plot(init_params.vLin, solveV_IRC.SDD_non, 'b');
% hold on
% plot(init_params.vLin, solveV_IRC.SDD_lin, '--b');
% 
% plot(init_params.vLin, solveV_GBT.SDD_non, 'r');
% plot(init_params.vLin, solveV_GBT.SDD_lin, '--r');
% hold off
% legend({leg1, leg2, leg3, leg4}, 'Position',[0.72, 0.25, 0, 0]);
% grid on
% grid minor
% tit = strcat('Suspension Dynamic Deflection');
% title(tit);
% xlabel('Car speed (km/h)');
% ylabel('SDD (m)');
% saveas(figure(3), 'img/Compare/IRCvsIRC_SUG/v3_SDD.png');
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
% legend({leg1, leg2, leg3, leg4}, 'Position',[0.72, 0.25, 0, 0]);
% grid on
% grid minor
% tit = strcat('Tire relative Dynamic Load');
% title(tit);
% xlabel('Car speed (km/h)');
% ylabel('TDL (N)');
% saveas(figure(4), 'img/Compare/IRCvsIRC_SUG/v4_TDL.png');
% 
% 
