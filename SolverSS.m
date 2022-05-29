classdef SolverSS < handle
    %SOLVERSS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        solver1;
        solver2;
    end
    
    methods (Access = public)
        function obj = SolverSS(solver1, solver2)
            obj.solver1 = solver1;
            obj.solver2 = solver2;
        end
        
        
        
        
    end
   
    methods (Access = public )
        function CalculateTimeResponse(obj)
            obj.solver1.SolvingTimeResponse();
            obj.solver2.SolvingTimeResponse();
        end
        
        function CalculateFreqResponse(obj)
            obj.solver1.SolvingFreqResponse();
            obj.solver2.SolvingFreqResponse();
        end
            
        
        function plotSS_FreqResponse(obj)
            CalculateFreqResponse(obj);
            
            figure(1)
            plot(obj.solver1.V_Linspace/(2*pi), obj.solver1.SDD_lin, 'b')
            hold on
            plot(obj.solver1.V_Linspace/(2*pi), obj.solver1.SDD_non, 'r')
            plot(obj.solver2.V_Linspace/(2*pi), obj.solver2.SDD_lin, '--b')
            plot(obj.solver2.V_Linspace/(2*pi), obj.solver2.SDD_non, '--r')
            hold off
            grid on
            grid minor
            leg1 = strcat('linear - ', obj.solver1.road.roadtype);
            leg2 = strcat('nonlinear - ', obj.solver1.road.roadtype);
            leg3 = strcat('linear - ', obj.solver2.road.roadtype);
            leg4 = strcat('nonlinear - ', obj.solver2.road.roadtype);
            legend(leg1, leg2, leg3, leg4);
            tit = strcat('SDD - suspension dynamic deflection');
            title(tit);
            xlabel('Input frequency [Hz]');
            ylabel('Relative Displacement (m)');
            
            
            figure(2)
            plot(obj.solver1.V_Linspace/(2*pi), obj.solver1.RMSA_lin, 'b')
            hold on
            plot(obj.solver1.V_Linspace/(2*pi), obj.solver1.RMSA_non, 'r')
            plot(obj.solver2.V_Linspace/(2*pi), obj.solver2.RMSA_lin, '--b')
            plot(obj.solver2.V_Linspace/(2*pi), obj.solver2.RMSA_non, '--r')
            hold off
            grid on
            grid minor
            legend(leg1, leg2, leg3, leg4);
            tit = strcat('RMSA - Body Vibration Root Mean Square');
            title(tit);
            xlabel('Input frequency [Hz]');
            ylabel('Acceleration (m/s^2)');
            
            figure(3)
            plot(obj.solver1.V_Linspace/(2*pi), obj.solver1.BVA_lin, 'b')
            hold on
            plot(obj.solver1.V_Linspace/(2*pi), obj.solver1.BVA_non, 'r')
            plot(obj.solver2.V_Linspace/(2*pi), obj.solver2.BVA_lin, '--b')
            plot(obj.solver2.V_Linspace/(2*pi), obj.solver2.BVA_non, '--r')
            hold off
            grid on
            grid minor
            legend(leg1, leg2, leg3, leg4);
            tit = strcat('BVA - Body Vibration Acceleration Maximum');
            title(tit);
            xlabel('Input frequency [Hz]');
            ylabel('Acceleration (m/s^2)');
            
            
            figure(4)
            plot(obj.solver1.V_Linspace/(2*pi), obj.solver1.TDL_lin, 'b')
            hold on
            plot(obj.solver1.V_Linspace/(2*pi), obj.solver1.TDL_non, 'r')
            plot(obj.solver2.V_Linspace/(2*pi), obj.solver2.TDL_lin, '--b')
            plot(obj.solver2.V_Linspace/(2*pi), obj.solver2.TDL_non, '--r')
            hold off
            grid on
            grid minor
            legend(leg1, leg2, leg3, leg4);
            tit = strcat('TDL - Tire Relative Dynamic Load');
            title(tit);
            xlabel('Input frequency [Hz]');
            ylabel('TDL (N)');
        end
        
        function plotSS_TimeResponse(obj)
            CalculateTimeResponse(obj);
            
            figure(1)
            plot(obj.solver1.T, obj.solver1.X_lin(:,3), 'b')
            hold on
            plot(obj.solver1.T, obj.solver1.X_non(:,3), 'r')
            plot(obj.solver2.T, obj.solver2.X_lin(:,3), '--b')
            plot(obj.solver2.T, obj.solver2.X_non(:,3), '--r')
            hold off
            grid on
            grid minor
            
            leg1 = strcat('linear - ', obj.solver1.road.roadtype);
            leg2 = strcat('nonlinear - ', obj.solver1.road.roadtype);
            leg3 = strcat('linear - ', obj.solver2.road.roadtype);
            leg4 = strcat('nonlinear - ', obj.solver2.road.roadtype);
            legend(leg1, leg2, leg3, leg4);
            tit = strcat('Car Body Displacement at ', num2str(obj.solver1.road.v*3.6),' km/h');
            title(tit);
            xlabel('Time (s)');
            ylabel('Displacement (m)');
            
            
            
            
            figure(2)
            plot(obj.solver1.T, obj.solver1.a_lin, 'b')
            hold on
            plot(obj.solver1.T, obj.solver1.a_non, 'r')
            plot(obj.solver2.T, obj.solver2.a_lin, '--b')
            plot(obj.solver2.T, obj.solver2.a_non, '--r')
            hold off
            grid on
            grid minor
            legend(leg1, leg2, leg3, leg4);
            tit = strcat('Car Body Acceleration at ', num2str(obj.solver1.road.v*3.6),' km/h');
            title(tit);
            xlabel('Time (s)');
            ylabel('Acceleration (m/s^2)');
            
            
            figure(3)
            plot(obj.solver1.T, obj.solver1.rev_X_lin, 'b')
            hold on
            plot(obj.solver1.T, obj.solver1.rev_X_non, 'r')
            plot(obj.solver2.T, obj.solver2.rev_X_lin, '--b')
            plot(obj.solver2.T, obj.solver2.rev_X_non, '--r')
            hold off
            grid on
            grid minor
            legend(leg1, leg2, leg3, leg4);
            tit = strcat('Relative Displacement at ', num2str(obj.solver1.road.v*3.6),' km/h');
            title(tit);
            xlabel('Time (s)');
            ylabel('Displacement (m)');
        end
        
        
        function plotRoad(obj)
            figure(1)
            plot(obj.solver1.t.*obj.solver1.road.v, obj.solver1.road.dis_t(obj.solver1.t), 'b')
            hold on
            plot(obj.solver2.t.*obj.solver2.road.v, obj.solver2.road.dis_t(obj.solver2.t), 'r')
            xlim([0, obj.solver1.road.d1])
            legend(obj.solver1.road.roadtype, obj.solver2.road.roadtype)
            grid on
            grid minor
            xlabel('Displacement [m]')
            ylabel('Displacement [m]')
            title('Road Compare')
            
        end
        
    end
end

