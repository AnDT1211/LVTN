classdef SolveFZtGBT_SUG < handle
    %SOLVEFZTIRC Summary of this class goes here
    %   Detailed explanation goes here
    properties
        Vlin;
        road;
        
        trenduoi;
    end
    properties
        FirstT;
        
        FirstV;
        
        ZT_CAL_lin;
        ZT_CAL_non;
    end
    
    methods
        function obj = SolveFZtGBT_SUG(init, road, airspring, t, Vlin, v, trenduoi)
            obj.Vlin = Vlin;
            obj.road = road;
            obj.FirstT = SolverT(init, road, airspring, t, v);
            obj.FirstT.SolvingTimeResponse(v);
            obj.trenduoi = trenduoi;
        end
        
        function StepX_non(obj, a1, a2, idx)
            
            close all;
            
            an = 0;
            if strcmp(obj.trenduoi, 'tren');
                an = 1;
            else
                an = -1;
            end
            
            
            
            t = obj.FirstT.T;
            gX_non = obj.FirstT.X_non;
            
            [~, idxMaxX_non] = findpeaks(an*gX_non(:,3));
            
            ii(1) = idxMaxX_non(a1);
            ii(2) = idxMaxX_non(a2);
            
            
            xx = gX_non(ii(1),3)/gX_non(ii(2),3);
            obj.ZT_CAL_non(idx) = 1/(2*pi)*log(xx)/log(exp(1));
%             1/(2*pi)*log(xx)/log(exp(1))

            
            figure(1);
            plot(t, gX_non(:,3));
            hold on;
            plot(t(idxMaxX_non), gX_non(idxMaxX_non,3),'ro');
            plot(t, obj.FirstT.road.dis_t(t),'g');
            hold off
            grid on
            grid minor
            leg1 = strcat('linear');
            leg3 = strcat('linear - peak');
            leg5 = strcat('road profile');
            legend(leg1, leg3, leg5);
            tit = strcat('Car Body Displacement at ', num2str(obj.road.v*3.6),' km/h - ', obj.road.roadtype);
            title(tit);
            xlabel('Time (s)');
            ylabel('Displacement (m)');
        end
        
        function NONCAL(obj)
            for v = 1:length(obj.Vlin)
                obj.FirstT.SolvingTimeResponse(obj.Vlin(v)/3.6);
                
                StepX_non(obj, 1, 2, v);
                if v >= 2
                    StepX_lin(obj, 2, 3, v);
                end
%                 if v == 20
%                     StepA_lin(obj, 4, 5, v);
%                 end
%                 input([num2str(v), ' == Press ''Enter'' to continue...'],'s');
            end
            obj.FirstT.road.v = v;
            
        end
        
        
        
        
        
        function StepX_lin(obj, a1, a2, idx)
            
            close all;
            
            an = 0;
            if strcmp(obj.trenduoi, 'tren');
                an = 1;
            else
                an = -1;
            end
            
            
            
            t = obj.FirstT.T;
            gX_lin = obj.FirstT.X_lin;
            
            [~, idxMaxX_lin] = findpeaks(an*gX_lin(:,3));
            
            ii(1) = idxMaxX_lin(a1);
            ii(2) = idxMaxX_lin(a2);
            
            
            xx = gX_lin(ii(1),3)/gX_lin(ii(2),3);
            obj.ZT_CAL_lin(idx) = 1/(2*pi)*log(xx)/log(exp(1));

            
            figure(1);
            plot(t, gX_lin(:,3));
            hold on;
            plot(t(idxMaxX_lin), gX_lin(idxMaxX_lin,3),'ro');
            plot(t, obj.FirstT.road.dis_t(t),'g');
            hold off
            grid on
            grid minor
            leg1 = strcat('linear');
            leg3 = strcat('linear - peak');
            leg5 = strcat('road profile');
            legend(leg1, leg3, leg5);
            tit = strcat('Car Body Displacement at ', num2str(obj.road.v*3.6),' km/h - ', obj.road.roadtype);
            title(tit);
            xlabel('Time (s)');
            ylabel('Displacement (m)');
        end
        
        function LINCAL(obj)
            for v = 1:length(obj.Vlin)
                obj.FirstT.SolvingTimeResponse(obj.Vlin(v)/3.6);
                
                StepX_lin(obj, 2, 3, v);
                if v >= 2
                    StepX_lin(obj, 3, 4, v);
                end
%                 if v == 20
%                     StepA_lin(obj, 4, 5, v);
%                 end
%                 input([num2str(v), ' == Press ''Enter'' to continue...'],'s');
            end
            obj.FirstT.road.v = v;
        end
        
        function Plotting(obj)
            NONCAL(obj);
            LINCAL(obj);
            
            close all;
            figure(1);
            plot(obj.Vlin, obj.ZT_CAL_non, 'r');
            hold on
            plot(obj.Vlin, obj.ZT_CAL_lin, 'b');
            plot([obj.Vlin(1), obj.Vlin(end)] , [obj.FirstT.init.zt_lin, obj.FirstT.init.zt_lin], 'bla');
            legend('nonlinear','linear', 'Linear Params');
%             ylim([1.03, 1.1]);
            grid on;
            grid minor
            tit = strcat('Calculated Damping Ratio in different Car Speed - ',obj.FirstT.road.roadtype);
            title(tit);
            xlabel('Car speed [km/h]');
            ylabel('Damping Ratio [1]');
            
            
            figure(2)
            zt = ones(1, length(obj.Vlin)) * obj.FirstT.init.zt_non;
            
            PerFN_non = (obj.ZT_CAL_non - zt)./zt*100;
            PerFN_lin = (obj.ZT_CAL_lin - zt)./zt*100;
            
            plot(obj.Vlin, PerFN_non, 'r');
            hold on
            plot(obj.Vlin, PerFN_lin, 'b');
            plot([obj.Vlin(1), obj.Vlin(end)],[0 0], 'bla');
            legend('nonlinear','linear', 'Zeta Params');
            grid on;
            grid minor
            
            tit = strcat('Calculated Damping ratio in different Car Speed - ',obj.FirstT.road.roadtype);
            title(tit);
            xlabel('Car speed [km/h]');
            ylabel('ERROR [%]');
            ylim([-18, 1]);
             
        end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    end
    
end

