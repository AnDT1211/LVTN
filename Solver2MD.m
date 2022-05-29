classdef Solver2MD < handle
    %SOLVER2MD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        MD1;
        MD2;
    end
    
    methods
        function obj = Solver2MD(solveMD1, solveMD2)
            obj.MD1 = solveMD1;
            obj.MD2 = solveMD2;
        end
        
        function PlottingFreqResponse(obj)
            V = obj.MD1.FirstV.vLin;
            close all;
            
            figure(1)
            plot(V, obj.MD1.FirstV.SDD_non, 'r');
            hold on
            plot(V, obj.MD1.FirstV.SDD_lin, 'b');
            plot(V, obj.MD2.FirstV.SDD_non, '--r');
            plot(V, obj.MD2.FirstV.SDD_lin, '--b');
            hold off
            grid on
            grid minor
            leg1 = strcat('linear -', obj.MD1.road.roadtype);
            leg2 = strcat('nonlinear -', obj.MD1.road.roadtype);
            leg3 = strcat('linear -', obj.MD2.road.roadtype);
            leg4 = strcat('nonlinear -', obj.MD2.road.roadtype);
            legend(leg1, leg2, leg3, leg4);
            tit = strcat('SDD - suspension dynamic deflection');
            title(tit);
            xlabel('Car speed (km/h)');
            ylabel('Relative Displacement (m)');
            
            
            
            figure(2)
            plot(V, obj.MD1.FirstV.BVA_non, 'r');
            hold on
            plot(V, obj.MD1.FirstV.BVA_lin, 'b');
            plot(V, obj.MD2.FirstV.BVA_non, '--r');
            plot(V, obj.MD2.FirstV.BVA_lin, '--b');
            hold off
            grid on
            grid minor
            leg1 = strcat('linear -', obj.MD1.road.roadtype);
            leg2 = strcat('nonlinear -', obj.MD1.road.roadtype);
            leg3 = strcat('linear -', obj.MD2.road.roadtype);
            leg4 = strcat('nonlinear -', obj.MD2.road.roadtype);
            legend(leg1, leg2, leg3, leg4);
            tit = strcat('BVA - Body Vibration Acceleration Maximum');
            title(tit);
            xlabel('Car speed (km/h)');
            ylabel('Acceleration (m/s^2)');
            
            
            
            figure(3)
            plot(V, obj.MD1.FirstV.RMSA_non, 'r');
            hold on
            plot(V, obj.MD1.FirstV.RMSA_lin, 'b');
            plot(V, obj.MD2.FirstV.RMSA_non, '--r');
            plot(V, obj.MD2.FirstV.RMSA_lin, '--b');
            hold off
            grid on
            grid minor
            leg1 = strcat('linear -', obj.MD1.road.roadtype);
            leg2 = strcat('nonlinear -', obj.MD1.road.roadtype);
            leg3 = strcat('linear -', obj.MD2.road.roadtype);
            leg4 = strcat('nonlinear -', obj.MD2.road.roadtype);
            legend(leg1, leg2, leg3, leg4);
            tit = strcat('RMSA - Body Vibration Root Mean Square');
            title(tit);
            xlabel('Car speed (km/h)');
            ylabel('Acceleration (m/s^2)');
            
            
            
            figure(4)
            plot(V, obj.MD1.FirstV.TDL_non, 'r');
            hold on
            plot(V, obj.MD1.FirstV.TDL_lin, 'b');
            plot(V, obj.MD2.FirstV.TDL_non, '--r');
            plot(V, obj.MD2.FirstV.TDL_lin, '--b');
            hold off
            grid on
            grid minor
            leg1 = strcat('linear -', obj.MD1.road.roadtype);
            leg2 = strcat('nonlinear -', obj.MD1.road.roadtype);
            leg3 = strcat('linear -', obj.MD2.road.roadtype);
            leg4 = strcat('nonlinear -', obj.MD2.road.roadtype);
            legend(leg1, leg2, leg3, leg4);
            tit = strcat('TDL - Tire Relative Dynamic Load');
            title(tit);
            xlabel('Car speed (km/h)');
            ylabel('TDL (N)');
            
            
            
            
            
            
            
        end
        
        function plottingTimeRes(obj)
            t = obj.MD1.FirstT.T;
            close all;
            
            figure(1)
            plot(t, obj.MD1.road.dis_t(t))
            hold on
            plot(t, obj.MD2.road.dis_t(t))
            grid on
            grid minor
            tit = strcat('Road Displacement at ', num2str(obj.MD1.road.v*3.6),' km/h');
            title(tit);
            xlabel('Time [s]');
            ylabel('Displacement [m]');
            
            figure(2)
            plot(t*obj.MD1.road.v, obj.MD1.road.dis_t(t))
            hold on
            plot(t*obj.MD2.road.v, obj.MD2.road.dis_t(t))
            grid on
            grid minor
            tit = strcat('Road Displacement');
            title(tit);
            xlabel('Displacement [m]');
            ylabel('Displacement [m]');
            
            
            figure(3)
            plot(t, obj.MD1.FirstT.X_lin(:,3), 'b')
            hold on
            plot(t, obj.MD1.FirstT.X_non(:,3), 'r')
            plot(t, obj.MD2.FirstT.X_lin(:,3), '--b')
            plot(t, obj.MD2.FirstT.X_non(:,3), '--r')
            hold off
            grid on
            grid minor
            leg1 = strcat('linear -', obj.MD1.road.roadtype);
            leg2 = strcat('nonlinear -', obj.MD1.road.roadtype);
            leg3 = strcat('linear -', obj.MD2.road.roadtype);
            leg4 = strcat('nonlinear -', obj.MD2.road.roadtype);
            legend(leg1, leg2, leg3, leg4);
            tit = strcat('Car Body Displacement at :', num2str(obj.MD1.FirstT.road.v*3.6),' km/h');
            title(tit);
            xlabel('Time (s)');
            ylabel('Displacement (m)');
            
            figure(4)
            plot(t, obj.MD1.FirstT.a_lin, 'b')
            hold on
            plot(t, obj.MD1.FirstT.a_non, 'r')
            plot(t, obj.MD2.FirstT.a_lin, '--b')
            plot(t, obj.MD2.FirstT.a_non, '--r')
            hold off
            grid on
            grid minor
            leg1 = strcat('linear -', obj.MD1.road.roadtype);
            leg2 = strcat('nonlinear -', obj.MD1.road.roadtype);
            leg3 = strcat('linear -', obj.MD2.road.roadtype);
            leg4 = strcat('nonlinear -', obj.MD2.road.roadtype);
            legend(leg1, leg2, leg3, leg4);
            tit = strcat('Car Body Acceleration at :', num2str(obj.MD1.road.v*3.6),' km/h');
            title(tit);
            xlabel('Time (s)');
            ylabel('Acceleration (m/s^2)');
            
            
            figure(5)
            plot(t, obj.MD1.FirstT.rev_X_lin, 'b')
            hold on
            plot(t, obj.MD1.FirstT.rev_X_non, 'r')
            plot(t, obj.MD2.FirstT.rev_X_lin, '--b')
            plot(t, obj.MD2.FirstT.rev_X_non, '--r')
            hold off
            grid on
            grid minor
            leg1 = strcat('linear -', obj.MD1.road.roadtype);
            leg2 = strcat('nonlinear -', obj.MD1.road.roadtype);
            leg3 = strcat('linear -', obj.MD2.road.roadtype);
            leg4 = strcat('nonlinear -', obj.MD2.road.roadtype);
            legend(leg1, leg2, leg3, leg4);
            tit = strcat('Relative Displacement at ', num2str(obj.MD1.road.v*3.6),' km/h');
            title(tit);
            xlabel('Time (s)');
            ylabel('Displacement (m)');
        end
    end
    
end

