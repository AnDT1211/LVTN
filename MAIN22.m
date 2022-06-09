clc; clear; close all;

% init_params = INIT_Params();
% 
% airspring = AirSpring(INIT_AirSpring());
% 
% height = 0.04 : 0.01 : 0.1;
% len = 0.5:0.5:5;
% for dd1 = 1 : length(len)
%     disp(num2str(dd1));
%     for dd2 = 1 : length(height)
% 
%         init_roadIRC = INIT_RoadIRC(init_params);
%         init_roadIRC.d2 = height(dd2);
%         init_roadIRC.d1 = len(dd1);
%         
%         init = INIT(init_params, airspring);
%     %     init.ShowThongSo();
%         roadirc = RoadIRC(init_roadIRC);
%         roadgbt = RoadGBT(init_roadIRC);
% 
%         solveT_IRC = SolverT(init, roadirc, airspring);
%         solveT_GBT = SolverT(init, roadgbt, airspring);
% 
%         solveV_IRC = SolverV(solveT_IRC, init_params); 
%         solveV_IRC.SolvingFreqResponse(); 
%         solveV_GBT = SolverV(solveT_GBT, init_params); 
%         solveV_GBT.SolvingFreqResponse(); 
% 
%         [a, b_IRC_non] = max(solveV_IRC.BVA_non);
%         [a, b_IRC_lin] = max(solveV_IRC.BVA_lin);
%         
%         maxA_IRC_non(dd1, dd2) = init_params.vLin(b_IRC_non);
%         maxA_IRC_lin(dd1, dd2) = init_params.vLin(b_IRC_lin);
%         
%         
%         [a, b_GBT_non] = max(solveV_GBT.BVA_non);
%         [a, b_GBT_lin] = max(solveV_GBT.BVA_lin);
%         
%         maxA_GBT_non(dd1, dd2) = init_params.vLin(b_GBT_non);
%         maxA_GBT_lin(dd1, dd2) = init_params.vLin(b_GBT_lin);
%         
%         
%     end
% end
% 
% 
% save M21.mat


% load M21.mat
% 
% 
% figure(1)
% hold on
% colormap winter
% % s1 = surf(height, len, maxA_GBT_non);
% % s2 = surf(height, len, maxA_IRC_lin);
% ylabel('length (m)');
% xlabel('height (m)');
% zlabel('Car speed (km/h)')
% title('Relationship between car velocity and bump parameters - sine square type');
% % legend([s1, s2], {'non-linear', 'linear'});
% hold off;


%% 
clc; clear; close all;
% load M21.mat

init_params = INIT_Params();

airspring = AirSpring(INIT_AirSpring());

height = 0.1;
len = 0.4:0.1:1.5;

init_roadIRC = INIT_RoadIRC(init_params);
init_roadIRC.d2 = height;

for dd1 = 1 : length(len)
    disp(num2str(dd1));
    
    init_roadIRC.d1 = len(dd1);

    init = INIT(init_params, airspring);
%     init.ShowThongSo();
    roadirc = RoadIRC(init_roadIRC);
    roadgbt = RoadGBT(init_roadIRC);

    solveT_IRC = SolverT(init, roadirc, airspring);
    solveT_GBT = SolverT(init, roadgbt, airspring);

    solveV_IRC = SolverV(solveT_IRC, init_params); 
    solveV_IRC.SolvingFreqResponse(); 
    solveV_GBT = SolverV(solveT_GBT, init_params); 
    solveV_GBT.SolvingFreqResponse(); 

    [a, b_IRC_non] = max(solveV_IRC.BVA_non);
    [a, b_IRC_lin] = max(solveV_IRC.BVA_lin);

    VmaxA_IRC_non(dd1) = init_params.vLin(b_IRC_non);
    VmaxA_IRC_lin(dd1) = init_params.vLin(b_IRC_lin);


    [a, b_GBT_non] = max(solveV_GBT.BVA_non);
    [a, b_GBT_lin] = max(solveV_GBT.BVA_lin);

    VmaxA_GBT_non(dd1) = init_params.vLin(b_GBT_non);
    VmaxA_GBT_lin(dd1) = init_params.vLin(b_GBT_lin);

end

save M22.mat

load M22.mat

figure(1)
yyaxis left
plot(len, VmaxA_IRC_non)
hold on
plot(len, VmaxA_IRC_lin, '--')
hold off
ylabel('car speed - sine square type (km/h)')

yyaxis right
% figure(2)
plot(len, VmaxA_GBT_non)
hold on
plot(len, VmaxA_GBT_lin, '--')
hold off
ylabel('car speed - triangle type (km/h)')
xlabel('bump length (m)')
% xlim([0.4 1.5])
grid on
grid minor
legend('non-linear','linear','non-linear','linear')
title('Relationship between car velocitty at maximum acceleration vs bump lenght')
















% 
% 
% 
% 
% 
% 
% %% 
% clc; clear; close all;
% load M21.mat
% 
% 
% 
% init_params = INIT_Params();
% 
% airspring = AirSpring(INIT_AirSpring());
% 
% height = 0.04 : 0.01 : 0.1;
% len_IRC = 0.5:0.5:2;
% for dd1 = 1 : length(len_IRC) % y
%     disp(num2str(dd1));
%     for dd2 = 1 : length(height) % x
%         
%         close all;
%         v = maxA_IRC_lin(dd1, dd2);
%         init_roadIRC = INIT_RoadIRC(init_params);
%         init_roadIRC.d2 = height(dd2);
%         init_roadIRC.d1 = len(dd1);
%         
%         init = INIT(init_params, airspring);
%         
%         roadirc = RoadIRC(init_roadIRC);
% 
%         solveT_IRC_non = SolverT(init, roadirc, airspring);
%         solveT_IRC_non.SolvingTimeResponse(v);
%         plot(solveT_IRC_non.T, solveT_IRC_non.a_non)
% %         
%         input([' == Press ''Enter'' to continue...'],'s');
%     end
% end
% 
% 
% 
% 
% % len_GBT = 0.5:0.5:1.5;
% % for dd1 = 1 : length(len_IRC)
% %     disp(num2str(dd1));
% %     for dd2 = 1 : length(height)
% % 
% %         init_roadIRC = INIT_RoadIRC(init_params);
% %         init_roadIRC.d2 = height(dd2);
% %         init_roadIRC.d1 = len(dd1);
% %         
% %         init = INIT(init_params, airspring);
% %     %     init.ShowThongSo();
% % %         roadirc = RoadIRC(init_roadIRC);
% %         roadgbt = RoadGBT(init_roadIRC);
% % 
% % %         solveT_IRC = SolverT(init, roadirc, airspring);
% %         solveT_GBT = SolverT(init, roadgbt, airspring);
% %         
% %         
% % 
% % 
% %     end
% % end
% 
% 
% 
% 
% 
% 
% 
% 
% 
% % figure;
% % %surf 1
% % h1 = surf(height, len, maxA_IRC_non,'FaceLighting','gouraud',...
% %     'MeshStyle','column',...
% %     'SpecularColorReflectance',0,...
% %     'SpecularExponent',5,...
% %     'SpecularStrength',0.2,...
% %     'DiffuseStrength',1,...
% %     'AmbientStrength',0.4,...
% %     'AlignVertexCenters','on',...
% %     'LineWidth',0.2,...
% %     'FaceAlpha',0.2,...
% %     'FaceColor',[0.07 0.6 1],...
% %     'EdgeAlpha',0.2);
% % hold on
% % %surf 2
% % h2 = surf(height, len, maxA_IRC_lin,'SpecularExponent',1,...
% %     'SpecularStrength',1,...
% %     'DiffuseStrength',1,...
% %     'AmbientStrength',0.4,...
% %     'FaceColor',[0.5 0.5 .5],...
% %     'AlignVertexCenters','on',...
% %     'LineWidth',0.2,...
% %     'EdgeAlpha',1);
% % 
% % hold off
% % ylabel('length (m)');
% % xlabel('height (m)');
% % zlabel('Car speed (km/h)')
% % title('Relationship between car velocity and bump parameters - sine square type');
% % legend([h1, h2], {'non-linear', 'linear'});
% % 
% % 
% % 
% % 
% % figure(2);
% % %surf 1
% % h1 = surf(height, len, maxA_GBT_non,'FaceLighting','gouraud',...
% %     'MeshStyle','column',...
% %     'SpecularColorReflectance',0,...
% %     'SpecularExponent',5,...
% %     'SpecularStrength',0.2,...
% %     'DiffuseStrength',1,...
% %     'AmbientStrength',0.4,...
% %     'AlignVertexCenters','on',...
% %     'LineWidth',0.2,...
% %     'FaceAlpha',0.2,...
% %     'FaceColor',[0.07 0.6 1],...
% %     'EdgeAlpha',0.2);
% % hold on
% % %surf 2
% % h2 = surf(height, len, maxA_GBT_lin,'SpecularExponent',1,...
% %     'SpecularStrength',1,...
% %     'DiffuseStrength',1,...
% %     'AmbientStrength',0.4,...
% %     'FaceColor',[0.5 0.5 .5],...
% %     'AlignVertexCenters','on',...
% %     'LineWidth',0.2,...
% %     'EdgeAlpha',1);
% % 
% % hold off
% % ylabel('length (m)');
% % xlabel('height (m)');
% % zlabel('Car speed (km/h)')
% % title('Relationship between car velocity and bump parameters - triangle type');
% % legend([h1, h2], {'non-linear', 'linear'});
% 
% 
% 
% 
% % figure(1)
% % hold on
% % colormap winter
% % % s1 = surf(height, len, maxA_IRC_non);
% % s2 = surf(height, len, maxA_IRC_lin);
% % ylabel('length (m)');
% % xlabel('height (m)');
% % zlabel('Car speed (km/h)')
% % title('Relationship between car velocity and bump parameters - sine square type');
% % % legend([s1, s2], {'non-linear', 'linear'});
% % hold off;
% % 
% % 
% % 
% % figure(2)
% % hold on
% % % h1 = surf(height, len, maxA_GBT_non);
% % h2 = surf(height, len, maxA_GBT_lin);
% % hold off
% % ylabel('length (m)');
% % xlabel('height (m)');
% % zlabel('Car speed (km/h)')
% % title('Relationship between car velocity and bump parameters - triangle type');
% % % legend([s1, s2], {'non-linear', 'linear'});
% % hold off;
% 
% 
% 
% 
% 
% 
% 









