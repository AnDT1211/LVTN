classdef AirSpring < handle
    %AIRSPRINGMAIN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        Height_CAT;
        Force_CAT;
        PSI_CAT;
        
        Height_LIN;
        Force_LIN;
        
        Force_des;
        Force_PolyTrans
        
    end
    
    properties (Access = public)
        Mass_DES;
        PSI_DES;
        Force_DES;
        
        KS_MIN;
        KS_MAX;
    end
    
    %GET DATA
    properties (Access = public)
        DIS_CAL;
        CTH_STIFF;
        Height_DES;
    end
    
    methods (Access = public)
%         function obj = AirSpring(Height, Force, PSI, Des_PSI, Des_MASS)
%             obj.Height_CAT = Height;
%             obj.Force_CAT = Force;
%             obj.PSI_CAT = PSI;
%             obj.Mass_DES = Des_MASS;
%             obj.PSI_DES = Des_PSI;
%             
%             
%             getVar(obj);
%         end
        
        function obj = AirSpring(init_airspring)
            obj.Height_CAT = init_airspring.Height;
            obj.Force_CAT = init_airspring.Force;
            obj.PSI_CAT = init_airspring.PSI;
            obj.Mass_DES = init_airspring.Des_MASS;
            obj.PSI_DES = init_airspring.Des_PSI;
            
            
            getVar(obj);
        end
        
        
        
        
    end
    
    methods (Access = private)
        
        function getVar(obj)
            dis = linspace(obj.Height_CAT(1), obj.Height_CAT(end), 1e3);
            dis2 = dis - Get_DesignHeight(obj);
            obj.KS_MAX = polyval(Get_CongthucStiff(obj), dis2(1));
            obj.KS_MIN = polyval(Get_CongthucStiff(obj), dis2(end));
        end
        
        % Polifit force và height theo catalog
        function MultiPoly(obj)
            obj.Height_LIN = linspace(obj.Height_CAT(1), obj.Height_CAT(end), 1e3);
            sz = size(obj.Force_CAT(:,1));
            sz = sz(1);
            obj.Force_LIN = zeros(sz, 1e3);
            for i = 1:sz
                pol = polyfit(obj.Height_CAT, obj.Force_CAT(i,:), 3);
                obj.Force_LIN(i,:) = polyval(pol, obj.Height_LIN);
            end
        end
        
        
        function Poly2(obj)
            MultiPoly(obj);
            for i = 1:length(obj.Force_LIN)
                pol = polyfit(obj.PSI_CAT, obj.Force_LIN(:,i),2);
                obj.Force_des(i) = polyval(pol, obj.PSI_DES);
            end
            pol_new = polyfit(obj.Height_LIN, obj.Force_des, 3);
            obj.Force_PolyTrans = polyval(pol_new, obj.Height_LIN);
        end
        
        
        
        function eq = GetEquation(obj)
            MultiPoly(obj);
            for i = 1:length(obj.Force_LIN)
                pol = polyfit(obj.PSI_CAT, obj.Force_LIN(:,i),2);
                obj.Force_des(i) = polyval(pol, obj.PSI_DES);
            end
            eq = polyfit(obj.Height_LIN, obj.Force_des, 3);
        end
        
        
        function Calculate_CTSTIFF_DIS(obj)
            obj.Height_DES = HeightFromForce_PSI(obj);
            obj.DIS_CAL = linspace(obj.Height_CAT(1), obj.Height_CAT(end), 1e3) - obj.Height_DES;
            
            Des_lin = linspace(obj.Height_CAT(1), obj.Height_CAT(end), 1e3);
            eq = GetEquation(obj);
            Stiff = polyval(eq, Des_lin)./Des_lin;
            obj.CTH_STIFF = polyfit(obj.DIS_CAL, Stiff, 5);
        end
        
    end
    
    
    % plot for AirSpring
    methods(Access = public)
        
        function PlotHeightForceRAWCAT(obj)
            figure(1);
            plot(obj.Height_CAT, obj.Force_CAT, 'o-');
            grid on
            grid minor
            legend('20 PSI','40 PSI','60 PSI','80 PSI','100 PSI');
            title('Force vs Height at different Pressure');
            xlabel('Height [m]');
            ylabel('Force [N]');
        end
        
        function PlotHeightForcePol(obj)
            MultiPoly(obj);
            figure(2)
            plot(obj.Height_LIN,obj.Force_LIN);
            grid on
            grid minor
            legend('20 PSI','40 PSI','60 PSI','80 PSI','100 PSI');
            title('Force vs Height at different Pressure after polyfit');
            xlabel('Height [m]');
            ylabel('Force [N]');
        end
        
        function Plot2(obj)
            PlotHeightForcePol(obj);
            Poly2(obj);
            figure(2)
            hold on;
            plot(obj.Height_LIN, obj.Force_PolyTrans, 'LineWidth' , 2)
            legend('20 PSI','40 PSI','60 PSI','80 PSI','100 PSI',strcat(num2str(obj.PSI_DES),' PSI'));
            hold off;
        end
        
        function chieucao = HeightFromForce_PSI(obj)
            equt = GetEquation(obj);
            y = 0;
            syms x;
            for i = 1:length(equt)
                y = y + equt(i)*x^(4-i);
            end
            eqn = y == obj.Mass_DES*10;
            h = vpasolve(eqn, x);
            chieucao = double(h(1));
        end
        
        function PlotDesHeight(obj)
            Plot2(obj);
            chieucao = HeightFromForce_PSI(obj);
            figure(2)
            hold on;
            x = [chieucao, chieucao];
            y = [0, obj.Mass_DES*10];
            plot(x, y, 'b--');
            
            x = [0.05, chieucao];
            y = [obj.Mass_DES*10, obj.Mass_DES*10];
            plot(x, y, 'b--');
            hold off;
        end
        
        function PlotDesHeight2(obj)
            Poly2(obj);
            
            figure(3)
            plot(obj.Height_LIN, obj.Force_PolyTrans, 'LineWidth' , 2)
            hold on;
            
            chieucao = HeightFromForce_PSI(obj);
            hold on;
            x = [chieucao, chieucao];
            y = [obj.Force_PolyTrans(end), obj.Mass_DES*10];
            plot(x, y, 'b--');
            
            x = [obj.Height_CAT(1), chieucao];
            y = [obj.Mass_DES*10, obj.Mass_DES*10];
            plot(x, y, 'b--');
            hold off;
            grid on
            grid minor
            an = strcat('Spring Height vs Force at ',num2str(obj.PSI_DES),' PSI');
            title(an);
            xlabel('Height [m]');
            ylabel('Force [N]');
            
        end
        
        function cth = Get_CongthucStiff(obj)
            Calculate_CTSTIFF_DIS(obj);
            cth = obj.CTH_STIFF;
        end
        
        function des = Get_DesignHeight(obj)
            des = HeightFromForce_PSI(obj);
        end
        
        function stiff_lin = Get_LinearStiff(obj)
            stiff_lin = polyval(Get_CongthucStiff(obj), 0);
        end
        
        function plotStiff2(obj)
            dis = linspace(obj.Height_CAT(1), obj.Height_CAT(end), 1e3);
            dis2 = dis - Get_DesignHeight(obj);
            obj.Height_CAT(end)
            obj.Height_CAT(1)
            obj.Height_CAT(end) - Get_DesignHeight(obj)
            Get_DesignHeight(obj) - obj.Height_CAT(1)
            
            dis2(end) - dis2(1)
            
            figure(4)
            plot(dis2, polyval(Get_CongthucStiff(obj), dis2),'r');
            hold on
            plot([dis2(1) dis2(end)], [polyval(Get_CongthucStiff(obj), 0) polyval(Get_CongthucStiff(obj), 0)], 'b')
            plot([0 0],[0 3e5],'--g');
            
%             plot([-0.15 0],[polyval(Get_CongthucStiff(obj), 0) polyval(Get_CongthucStiff(obj), 0)],'--r');
            grid on
            grid minor
            legend('nonlinear','linear');
            an = strcat('Relative Displacement vs Stiffness');
            title(an);
            xlabel('Displacement [m]');
            ylabel('Stiffness [N/m]');
            
        end
        
        function plotStiff(obj)
            dis = linspace(obj.Height_CAT(1), obj.Height_CAT(end), 1e3);
            dis2 = dis - Get_DesignHeight(obj);
%             obj.Height_CAT(end)
%             obj.Height_CAT(1)
%             obj.Height_CAT(end) - Get_DesignHeight(obj);
%             Get_DesignHeight(obj) - obj.Height_CAT(1);
%             
%             dis2(end) - dis2(1);
            
            figure(4)
            plot(dis2, polyval(Get_CongthucStiff(obj), dis2));
            hold on
            plot([0 0],[0 polyval(Get_CongthucStiff(obj), 0)],'--r');
            plot([-0.15 0],[polyval(Get_CongthucStiff(obj), 0) polyval(Get_CongthucStiff(obj), 0)],'--r');
            grid on
            grid minor
            an = strcat('Airspring Displacement vs Stiffness at ',num2str(obj.PSI_DES),' PSI');
            title(an);
            xlabel('Displacement [m]');
            ylabel('Stiffness [N/m]');
            
        end
    end
end

