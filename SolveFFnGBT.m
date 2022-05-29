classdef SolveFFnGBT < handle
    %SolveFFnIRC Summary of this class goes here
    %   Detailed explanation goes here
    properties
        Vlin;
        road;
        
        a1;
        a2;
        trenduoi;
    end
    properties
        FirstT;
        
        FirstV;
        
        FN_CAL_lin;
        FN_CAL_non;
    end
    
    methods
        function obj = SolveFFnGBT(init, road, airspring, t, Vlin, v, trenduoi)
            obj.Vlin = Vlin;
            obj.road = road;
            obj.FirstT = SolverT(init, road, airspring, t, v);
            obj.FirstT.SolvingTimeResponse(v);
            obj.trenduoi = trenduoi;
%             obj.FirstV = SolverV(obj.FirstT, Vlin);
%             obj.FirstV.SolvingFreqResponse();
        end
        
        
        
        function StepA_lin(obj, a1, a2, idx)
            
            close all;
            
            an = 0;
            if strcmp(obj.trenduoi, 'tren');
                an = 1;
            else
                an = -1;
            end
            
            gT = obj.FirstT.T;
            gA_lin = obj.FirstT.a_lin;
            t = obj.FirstT.T;
            [~, idxMaxA_lin] = findpeaks(an*gA_lin);
            
            ii(1) = idxMaxA_lin(a1);
            ii(2) = idxMaxA_lin(a2);
            
            
            pT_lin = gT(ii(2)) - gT(ii(1));
%             pT_non = gT(ii(2)) - gT(ii(1));



            obj.FN_CAL_lin(idx) = 1/pT_lin;
%             obj.FN_CAL_non(idx) = 1/pT_non;
            
            
            figure(1);
            plot(t, gA_lin);
            hold on;
            plot(t(idxMaxA_lin), gA_lin(idxMaxA_lin),'ro');
            hold off
            grid on
            grid minor
            leg1 = strcat('linear');
            leg3 = strcat('linear - peak');
            legend(leg1, leg3);
            tit = strcat('Car Body Acceleration at ', num2str(obj.road.v*3.6),' km/h - ', obj.road.roadtype);
            title(tit);
            xlabel('Time (s)');
            ylabel('Acceleration (m/s^2)');
        end
        
        
        
        
        
        
        
        
        function StepA_non(obj, a1, a2, idx)
            close all;
            
            an = 0;
            if strcmp(obj.trenduoi, 'tren');
                an = 1;
            else
                an = -1;
            end
            
            gT = obj.FirstT.T;
            gA_non = obj.FirstT.a_non;
            t = obj.FirstT.T;
            [~, idxMaxA_non] = findpeaks(an*gA_non);
            
            ii(1) = idxMaxA_non(a1);
            ii(2) = idxMaxA_non(a2);
            
            
%             pT_lin = gT(ii(2)) - gT(ii(1));
            pT_non = gT(ii(2)) - gT(ii(1));



%             obj.FN_CAL_lin(idx) = 1/pT_lin;
            obj.FN_CAL_non(idx) = 1/pT_non;
            
            
            figure(1);
            plot(t, gA_non);
            hold on;
            plot(t(idxMaxA_non), gA_non(idxMaxA_non),'ro');
            hold off
            grid on
            grid minor
            leg1 = strcat('linear');
            leg3 = strcat('linear - peak');
            legend(leg1, leg3);
            tit = strcat('Car Body Acceleration at ', num2str(obj.road.v*3.6),' km/h - ', obj.road.roadtype);
            title(tit);
            xlabel('Time (s)');
            ylabel('Acceleration (m/s^2)');
        end
        
        function NONCAL(obj)
            for v = 1:length(obj.Vlin)
                obj.FirstT.SolvingTimeResponse(obj.Vlin(v)/3.6);
                
                StepA_non(obj, 3, 4, v);
                if v >= 2
                    StepA_non(obj, 4, 5, v);
                end
%                 if v == 20
%                     StepA_non(obj, 4, 5, v);
%                 end
%                 input([num2str(v), ' == Press ''Enter'' to continue...'],'s');
            end
            obj.FirstT.road.v = v;
%             close all;
%             figure(1);
%             plot(obj.Vlin, obj.FN_CAL_non);
            
        end
        
        function LINCAL(obj)
            for v = 1:length(obj.Vlin)
                obj.FirstT.SolvingTimeResponse(obj.Vlin(v)/3.6);
                
                StepA_lin(obj, 4, 5, v);
                if v >= 3
                    StepA_lin(obj, 5, 6, v);
                end
%                 if v == 20
%                     StepA_lin(obj, 4, 5, v);
%                 end
%                 input([num2str(v), ' == Press ''Enter'' to continue...'],'s');
            end
            obj.FirstT.road.v = v;
%             close all;
%             figure(1);
%             plot(obj.Vlin, obj.FN_CAL_lin);
            
        end
        
        function Plotting(obj)
            NONCAL(obj);
            LINCAL(obj);
            
            close all;
            figure(1);
            plot(obj.Vlin, obj.FN_CAL_non, 'r');
            hold on
            plot(obj.Vlin, obj.FN_CAL_lin, 'b');
            plot([obj.Vlin(1), obj.Vlin(end)] , [obj.FirstT.init.fn_lin, obj.FirstT.init.fn_lin], 'bla');
            legend('nonlinear','linear', 'Linear Params');
            ylim([1.055, 1.085]);
            grid on;
            grid minor
            tit = strcat('Calculated Natural Frequency in different Car Speed - ',obj.FirstT.road.roadtype);
            title(tit);
            xlabel('Car speed [km/h]');
            ylabel('Natural Frequency [Hz]');
            
            
            figure(2)
            fn = ones(1, length(obj.Vlin)) * obj.FirstT.init.fn_lin;
            
            PerFN_non = (obj.FN_CAL_non - fn)./fn*100;
            PerFN_lin = (obj.FN_CAL_lin - fn)./fn*100;
            
            plot(obj.Vlin, PerFN_non, 'r');
            hold on
            plot(obj.Vlin, PerFN_lin, 'b');
            plot([obj.Vlin(1), obj.Vlin(end)],[0 0], 'bla');
            legend('nonlinear','linear', 'Linear Params');
            grid on;
            grid minor
            ylim([-2.5, 0.5]);
            tit = strcat('Calculated Natural Frequency in different Car Speed - ',obj.road.roadtype);
            title(tit);
            xlabel('Car speed [km/h]');
            ylabel('ERROR [%]');
        end
        
    end
    
end

