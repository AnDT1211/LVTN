classdef Solver < handle
    %SOLVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        road;
        airspring;
        init;
        
        congthucStiff;
        V_Linspace = linspace(0, 100, 1e3);
        fntatdanNon;
        zetTestNon;
    end
    properties
        t;
        T;
        
        X_non;
        X_lin;
        
        rev_X_non;
        rev_X_lin;
        
        a_non;
        a_lin;
        
        SDD_non;
        SDD_lin;
        
        BVA_non;
        BVA_lin;
        
        RMSA_non;
        RMSA_lin;
        
        TDL_non;
        TDL_lin;
        
        FN_non;
        FN_lin;
        
        ZT_1_non;
        ZT_1_lin;
        
    end
    
    
    methods
        function obj = Solver(init, road, airspring, t)
            obj.t = t;
            obj.init = init;
            obj.road = road;
            obj.airspring = airspring;
            obj.congthucStiff = airspring.Get_CongthucStiff();
        end
        
        function PlottingTimeResponse(obj)
            SolvingTimeResponse(obj);
            
            figure(1)
            plot(obj.T, obj.X_lin(:,3), 'b')
            hold on
            plot(obj.T, obj.X_non(:,3), 'r')
            hold off
            grid on
            grid minor
            legend('linear', 'nonlinear');
            tit = strcat('Car Body Displacement at ', num2str(obj.road.v*3.6),' km/h');
            title(tit);
            xlabel('Time (s)');
            ylabel('Displacement (m)');
            
            figure(2)
            plot(obj.T, obj.a_lin, 'b')
            hold on
            plot(obj.T, obj.a_non, 'r')
            hold off
            grid on
            grid minor
            legend('linear', 'nonlinear');
            tit = strcat('Car Body Acceleration at ', num2str(obj.road.v*3.6),' km/h');
            title(tit);
            xlabel('Time (s)');
            ylabel('Acceleration (m/s^2)');
            
            
            figure(3)
            plot(obj.T, obj.rev_X_lin, 'b')
            hold on
            plot(obj.T, obj.rev_X_non, 'r')
            hold off
            grid on
            grid minor
            legend('linear', 'nonlinear');
            tit = strcat('Relative Displacement at ', num2str(obj.road.v*3.6),' km/h');
            title(tit);
            xlabel('Time (s)');
            ylabel('Displacement (m)');
        end
        
        function PlottingFreqResponse(obj)
            SolvingFreqResponse(obj)
            figure(1)
            plot(obj.V_Linspace, obj.SDD_lin, 'b')
            hold on
            plot(obj.V_Linspace, obj.SDD_non, 'r')
            hold off
            grid on
            grid minor
            legend('linear', 'nonlinear');
            tit = strcat('SDD - suspension dynamic deflection');
            title(tit);
            xlabel('Car speed (km/h)');
            ylabel('Relative Displacement (m)');
            
            
            figure(2)
            plot(obj.V_Linspace, obj.RMSA_lin, 'b')
            hold on
            plot(obj.V_Linspace, obj.RMSA_non, 'r')
            hold off
            grid on
            grid minor
            legend('linear', 'nonlinear');
            tit = strcat('RMSA - Body Vibration Root Mean Square');
            title(tit);
            xlabel('Car speed (km/h)');
            ylabel('Acceleration (m/s^2)');
            
            figure(3)
            plot(obj.V_Linspace, obj.BVA_lin, 'b')
            hold on
            plot(obj.V_Linspace, obj.BVA_non, 'r')
            hold off
            grid on
            grid minor
            legend('linear', 'nonlinear');
            tit = strcat('BVA - Body Vibration Acceleration Maximum');
            title(tit);
            xlabel('Car speed (km/h)');
            ylabel('Acceleration (m/s^2)');
            
            
            figure(4)
            plot(obj.V_Linspace, obj.TDL_lin, 'b')
            hold on
            plot(obj.V_Linspace, obj.TDL_non, 'r')
            hold off
            grid on
            grid minor
            legend('linear', 'nonlinear');
            tit = strcat('TDL - Tire Relative Dynamic Load');
            title(tit);
            xlabel('Car speed (km/h)');
            ylabel('TDL (N)');
        end
        
        
        
        
        
        
        
    end
    
    
    methods (Access = public)
        
        
        
        
        function Solving_FN_ZT_LINEAR_GBT(obj, vv)
            obj.road.v = vv/3.6;
            [gT, gX_lin]  = ode45(@obj.PTVP_lin, obj.t, [0; 0; 0; 0]); 
            
            gA_lin = -(obj.init.ks/obj.init.ms).*(gX_lin(:,3)-gX_lin(:,1)) ... 
                -(obj.init.cs/obj.init.ms).*(gX_lin(:,4)-gX_lin(:,2));
            
            [valMaxA_lin, idxMaxA_lin] = findpeaks(-gA_lin); %,'SortStr','descend'
            
            idxlin = idxMaxA_lin(1:3);
            valA_lin = valMaxA_lin(1:3);
            
            pT_lin = gT(idxlin(2)) - gT(idxlin(1));

            
            
            disp(['Calculated natural frequency - linear = ', num2str(1/pT_lin), ' Hz']);
            
            
            
            figure(1)
            plot(gT, gA_lin ,'b');
            hold on
            plot(gT(idxlin), -valA_lin, 'bo');
            grid on
            grid minor
            leg1 = strcat('linear');
            leg3 = strcat('linear - peak');
            legend(leg1, leg3);
            tit = strcat('Car Body Acceleration at ', num2str(obj.road.v*3.6),' km/h - ', obj.road.roadtype);
            title(tit);
            xlabel('Time (s)');
            ylabel('Acceleration (m/s^2)');
            
            
%             pT_lin = gT(idxMaxA_lin(3)) - gT(idxMaxA_lin(2));
%             pT_non = gT(idxMaxA_non(3)) - gT(idxMaxA_non(2));
            
%             obj.FN_1_lin = 1/pT_lin;
%             obj.FN_1_non = 1/pT_non;
%             disp(num2str(obj.FN_1_lin));
%             disp(num2str(obj.FN_1_non));
            
            
            
            
            [valMaxX_lin, idxMaxX_lin] = findpeaks(gX_lin(:,3));
            
            idxRevlin = idxMaxX_lin(1:3);
            
            valX_lin = valMaxX_lin(1:3);
            
            xx = gX_lin(idxMaxX_lin(2),3)/gX_lin(idxMaxX_lin(3),3);
            zt_lin = 1/(2*pi)*log(xx)/log(exp(1));
            

            disp(['Calculated damping ratio - linear = ', num2str(zt_lin), ' ']);
            
            
            
%             disp(num2str(zt));
            
%             if gT(idxRevlin(2)) - gT(idxRevlin(1)) < 0.4
%                 idxRevlin(2) = idxMaxX_lin(3);
%                 valX_lin(2) = valMaxX_lin(3);
%             end
%             if gT(idxRevnon(2)) - gT(idxRevnon(1)) < 0.6
%                 idxRevnon(2) = idxMaxX_non(3);
%                 valX_non(2) = valMaxX_non(3);
%             end
            
            
            figure(2)
            plot(gT, gX_lin(:,3) ,'b');
            hold on
            plot(gT(idxRevlin), valX_lin, 'bo');
            plot(gT, obj.road.dis_t(gT),'g');
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
        
        function Solving_FN_ZT_MultiV_GBT2(obj)
            SolvingFreqResponse(obj);
            
%             [~, idx] = findpeaks(obj.RMSA_lin); %,'SortStr','descend'
            [~, idx] = max(abs(obj.RMSA_lin));
            velMaxRMSA_lin = obj.V_Linspace(idx)
            Solving_FN_ZT_LINEAR_GBT(obj, velMaxRMSA_lin);
            
            for v = 1:length(obj.V_Linspace)
                obj.road.v = obj.V_Linspace(v)/3.6;
                [~, gX_lin]  = ode45(@obj.PTVP_lin, obj.t, [0; 0; 0; 0]); 
                [gT, gX_non]  = ode45(@obj.PTVP_non, obj.t, [0; 0; 0; 0]); 


                gA_non = -(polyval(obj.congthucStiff, gX_non(:,3)-gX_non(:,1))/obj.init.ms).*(gX_non(:,3)-gX_non(:,1)) ... 
                    -(obj.init.cs/obj.init.ms).*(gX_non(:,4)-gX_non(:,2));
                gA_lin = -(obj.init.ks/obj.init.ms).*(gX_lin(:,3)-gX_lin(:,1)) ... 
                    -(obj.init.cs/obj.init.ms).*(gX_lin(:,4)-gX_lin(:,2));

                [valMaxA_non, idxMaxA_non] = findpeaks(-gA_non);
                [valMaxA_lin, idxMaxA_lin] = findpeaks(-gA_lin);

                idxlin = idxMaxA_lin(1:3);
                idxnon = idxMaxA_non(1:3);
                valA_lin = valMaxA_lin(1:3);
                valA_non = valMaxA_non(1:3);

                
                pT_lin = gT(idxlin(2)) - gT(idxlin(1));
                pT_non = gT(idxnon(2)) - gT(idxnon(1));
                
               
                
                obj.FN_1_lin(v) = 1/pT_lin;
                obj.FN_1_non(v) = 1/pT_non;
                
                FNN_lin(v) =  1/pT_lin;
                FNN_non(v) =  1/pT_non;
                
                
                
            
                [valMaxX_non, idxMaxX_non] = findpeaks(gX_non(:,3));
                [valMaxX_lin, idxMaxX_lin] = findpeaks(gX_lin(:,3));

                idxRevlin = idxMaxX_lin(1:3);
                idxRevnon = idxMaxX_non(1:3);

                valX_lin = valMaxX_lin(1:3);
                valX_non = valMaxX_non(1:3);

                xx = gX_lin(idxRevlin(2),3)/gX_lin(idxRevlin(3),3);
                zt_lin(v) = 1/(2*pi)*log(xx)/log(exp(1));
                
                
                xx = gX_lin(idxRevnon(2),3)/gX_lin(idxRevnon(3),3);
                zt_non(v) = 1/(2*pi)*log(xx)/log(exp(1));
                
                
            end
            figure(3)
            plot(obj.V_Linspace, obj.FN_1_non, 'r');
            hold on
            plot(obj.V_Linspace, obj.FN_1_lin, 'b');
            plot([obj.V_Linspace(1), obj.V_Linspace(end)], ...
                [obj.init.fn_lin, obj.init.fn_lin], '--r');
            plot([obj.V_Linspace(1), obj.V_Linspace(end)], ...
                [obj.init.fn_lin, obj.init.fn_lin], '--b');
            legend('nonlinear','linear','initial nonlinear','initial linear');
            grid on;
            grid minor
            tit = strcat('Calculated Natural Frequency in different Car Speed - ',obj.road.roadtype);
            title(tit);
            xlabel('Car speed [km/h]');
            ylabel('Natural Frequency [Hz]');
            
            
            figure(4)
            plot(obj.V_Linspace, zt_non, 'r');
            hold on
            plot(obj.V_Linspace, zt_lin, 'b');
            plot([obj.V_Linspace(1), obj.V_Linspace(end)], ...
                [obj.init.zt_non, obj.init.zt_non], '--r');
            plot([obj.V_Linspace(1), obj.V_Linspace(end)], ...
                [obj.init.zt_lin, obj.init.zt_lin], '--b');
            legend('nonlinear','linear','initial nonlinear','initial linear');
            grid on;
            grid minor
%             ylim([1.02, 1.09]);
            tit = strcat('Calculated Damping ratio in different Car Speed - ',obj.road.roadtype);
            title(tit);
            xlabel('Car speed [km/h]');
            ylabel('Damping ratio [1]');
            
        end
        
        
        
        
        
        
        
        function Solving_FN_ZT_LINEAR(obj, vv)
            obj.road.v = vv/3.6;
            [gT, gX_lin]  = ode45(@obj.PTVP_lin, obj.t, [0; 0; 0; 0]); 
            
            gA_lin = -(obj.init.ks/obj.init.ms).*(gX_lin(:,3)-gX_lin(:,1)) ... 
                -(obj.init.cs/obj.init.ms).*(gX_lin(:,4)-gX_lin(:,2));
            
            [valMaxA_lin, idxMaxA_lin] = findpeaks(-gA_lin); %,'SortStr','descend'
            
            idxlin = idxMaxA_lin(1:3);
            valA_lin = valMaxA_lin(1:3);
            
            if gT(idxlin(2)) - gT(idxlin(1)) < 0.8
                idxlin(3) = idxMaxA_lin(4);
                valA_lin(3) = valMaxA_lin(4);
                idxlin(2) = idxMaxA_lin(3);
                valA_lin(2) = valMaxA_lin(3);
            end

            if gT(idxlin(2)) - gT(idxlin(1)) < 0.8
                idxlin(3) = idxMaxA_lin(5);
                valA_lin(3) = valMaxA_lin(5);
                idxlin(2) = idxMaxA_lin(4);
                valA_lin(2) = valMaxA_lin(4);
            end
            
            
            
            pT_lin = gT(idxlin(3)) - gT(idxlin(2));

            
            
            disp(['Calculated natural frequency - linear = ', num2str(1/pT_lin), ' Hz']);
            
            
            
            figure(1)
            plot(gT, gA_lin ,'b');
            hold on
            plot(gT(idxlin), -valA_lin, 'bo');
            grid on
            grid minor
            leg1 = strcat('linear');
            leg3 = strcat('linear - peak');
            legend(leg1, leg3);
            tit = strcat('Car Body Acceleration at ', num2str(obj.road.v*3.6),' km/h - ', obj.road.roadtype);
            title(tit);
            xlabel('Time (s)');
            ylabel('Acceleration (m/s^2)');
            
            
%             pT_lin = gT(idxMaxA_lin(3)) - gT(idxMaxA_lin(2));
%             pT_non = gT(idxMaxA_non(3)) - gT(idxMaxA_non(2));
            
%             obj.FN_1_lin = 1/pT_lin;
%             obj.FN_1_non = 1/pT_non;
%             disp(num2str(obj.FN_1_lin));
%             disp(num2str(obj.FN_1_non));
            
            
            
            
            [valMaxX_lin, idxMaxX_lin] = findpeaks(gX_lin(:,3));
            
            idxRevlin = idxMaxX_lin(1:3);
            
            valX_lin = valMaxX_lin(1:3);
            
            xx = gX_lin(idxMaxX_lin(2),3)/gX_lin(idxMaxX_lin(3),3);
            zt_lin = 1/(2*pi)*log(xx)/log(exp(1));
            

            disp(['Calculated damping ratio - linear = ', num2str(zt_lin), ' ']);
            
            
            
%             disp(num2str(zt));
            
%             if gT(idxRevlin(2)) - gT(idxRevlin(1)) < 0.4
%                 idxRevlin(2) = idxMaxX_lin(3);
%                 valX_lin(2) = valMaxX_lin(3);
%             end
%             if gT(idxRevnon(2)) - gT(idxRevnon(1)) < 0.6
%                 idxRevnon(2) = idxMaxX_non(3);
%                 valX_non(2) = valMaxX_non(3);
%             end
            
            
            figure(2)
            plot(gT, gX_lin(:,3) ,'b');
            hold on
            plot(gT(idxRevlin), valX_lin, 'bo');
            plot(gT, obj.road.dis_t(gT),'g');
            grid on
            grid minor
            leg1 = strcat('linear');
            leg3 = strcat('linear - peak');
            leg5 = strcat('road profile');
            legend(leg1, leg3, leg5);
            tit = strcat('Car Body Displacement at ', num2str(obj.road.v*3.6),' km/h - ', obj.road.roadtype);
            title(tit);
            xlabel('Time (s)');
            ylabel('Relative Displacement (m)');
            
            
        end
        
        
        
        function Solving_FN_ZT_GBT(obj, vv)
            obj.road.v = vv/3.6;
            [~, gX_lin]  = ode45(@obj.PTVP_lin, obj.t, [0; 0; 0; 0]); 
            [gT, gX_non]  = ode45(@obj.PTVP_non, obj.t, [0; 0; 0; 0]); 
            
            
            gA_non = -(polyval(obj.congthucStiff, gX_non(:,3)-gX_non(:,1))/obj.init.ms).*(gX_non(:,3)-gX_non(:,1)) ... 
                -(obj.init.cs/obj.init.ms).*(gX_non(:,4)-gX_non(:,2));
            gA_lin = -(obj.init.ks/obj.init.ms).*(gX_lin(:,3)-gX_lin(:,1)) ... 
                -(obj.init.cs/obj.init.ms).*(gX_lin(:,4)-gX_lin(:,2));
            
            [valMaxA_non, idxMaxA_non] = findpeaks(-gA_non);
            [valMaxA_lin, idxMaxA_lin] = findpeaks(-gA_lin); %,'SortStr','descend'
            
            idxlin = idxMaxA_lin(1:5);
            idxnon = idxMaxA_non(1:5);
            valA_lin = valMaxA_lin(1:5);
            valA_non = valMaxA_non(1:5);
            
            
            pT_lin = gT(idxlin(2)) - gT(idxlin(1));
            pT_non = gT(idxnon(2)) - gT(idxnon(1));

            1/pT_lin
            1/pT_non
            
            
            figure(1)
            plot(gT, gA_lin ,'b');
            hold on
            plot(gT, gA_non ,'r');
            plot(gT(idxlin), -valA_lin, 'bo');
            plot(gT(idxnon), -valA_non, 'ro');
            plot(gT, obj.road.dis_t(gT), 'g');
            grid on
            grid minor
            leg1 = strcat('linear');
            leg2 = strcat('nonlinear');
            leg3 = strcat('linear - peak');
            leg4 = strcat('nonlinear - peak');
            legend(leg1, leg2, leg3, leg4);
            tit = strcat('Car Body Acceleration at ', num2str(obj.road.v*3.6),' km/h');
            title(tit);
            xlabel('Time (s)');
            ylabel('Acceleration (m/s^2)');
            
            
%             pT_lin = gT(idxMaxA_lin(3)) - gT(idxMaxA_lin(2));
%             pT_non = gT(idxMaxA_non(3)) - gT(idxMaxA_non(2));
            
%             obj.FN_1_lin = 1/pT_lin;
%             obj.FN_1_non = 1/pT_non;
%             disp(num2str(obj.FN_1_lin));
%             disp(num2str(obj.FN_1_non));
            
            
%             
%             rev_non = gX_non(:,3)-gX_non(:,1);
%             rev_lin = gX_lin(:,3)-gX_lin(:,1);
%             
%             [valMaxX_non, idxMaxX_non] = findpeaks(rev_non,'SortStr','descend');
%             [valMaxX_lin, idxMaxX_lin] = findpeaks(rev_lin,'SortStr','descend');
%             
%             idxRevlin = idxMaxX_lin(1:3);
%             idxRevnon = idxMaxX_non(1:3);
%             
%             valX_lin = valMaxX_lin(1:3);
%             valX_non = valMaxX_non(1:3);
%             
%             if gT(idxRevlin(2)) - gT(idxRevlin(1)) < 0.4
%                 idxRevlin(2) = idxMaxX_lin(3);
%                 valX_lin(2) = valMaxX_lin(3);
%             end
%             if gT(idxRevnon(2)) - gT(idxRevnon(1)) < 0.6
%                 idxRevnon(2) = idxMaxX_non(3);
%                 valX_non(2) = valMaxX_non(3);
%             end
%             
%             
%             figure(2)
%             plot(gT, rev_lin ,'b');
%             hold on
%             plot(gT, rev_non ,'r');
%             plot(gT(idxRevlin), valX_lin, 'bo');
%             plot(gT(idxRevnon), valX_non, 'ro');
%             plot(gT, obj.road.dis_t(gT),'g');
%             grid on
%             grid minor
%             leg1 = strcat('linear');
%             leg2 = strcat('nonlinear');
%             leg3 = strcat('linear - peak');
%             leg4 = strcat('nonlinear - peak');
%             leg5 = strcat('road profile');
%             legend(leg1, leg2, leg3, leg4, leg5);
%             tit = strcat('Car Body Relative Displacement at ', num2str(obj.road.v*3.6),' km/h');
%             title(tit);
%             xlabel('Time (s)');
%             ylabel('Relative Displacement (m)');
            
            
           
            
            
        end
        
        
        function Solving_FN_ZT(obj, vv)
            obj.road.v = vv/3.6;
            [~, gX_lin]  = ode45(@obj.PTVP_lin, obj.t, [0; 0; 0; 0]); 
            [gT, gX_non]  = ode45(@obj.PTVP_non, obj.t, [0; 0; 0; 0]); 
            
            
            gA_non = -(polyval(obj.congthucStiff, gX_non(:,3)-gX_non(:,1))/obj.init.ms).*(gX_non(:,3)-gX_non(:,1)) ... 
                -(obj.init.cs/obj.init.ms).*(gX_non(:,4)-gX_non(:,2));
            gA_lin = -(obj.init.ks/obj.init.ms).*(gX_lin(:,3)-gX_lin(:,1)) ... 
                -(obj.init.cs/obj.init.ms).*(gX_lin(:,4)-gX_lin(:,2));
            
            [valMaxA_non, idxMaxA_non] = findpeaks(-gA_non);
            [valMaxA_lin, idxMaxA_lin] = findpeaks(-gA_lin); %,'SortStr','descend'
            
            idxlin = idxMaxA_lin(1:3);
            idxnon = idxMaxA_non(1:3);
            valA_lin = valMaxA_lin(1:3);
            valA_non = valMaxA_non(1:3);
            
            if gT(idxlin(2)) - gT(idxlin(1)) < 0.8
                idxlin(3) = idxMaxA_lin(4);
                valA_lin(3) = valMaxA_lin(4);
                idxlin(2) = idxMaxA_lin(3);
                valA_lin(2) = valMaxA_lin(3);
            end
            if gT(idxnon(2)) - gT(idxnon(1)) < 0.8
                idxnon(3) = idxMaxA_non(4);
                valA_non(3) = valMaxA_non(4);
                idxnon(2) = idxMaxA_non(3);
                valA_non(2) = valMaxA_non(3);
            end

            if gT(idxlin(2)) - gT(idxlin(1)) < 0.8
                idxlin(3) = idxMaxA_lin(5);
                valA_lin(3) = valMaxA_lin(5);
                idxlin(2) = idxMaxA_lin(4);
                valA_lin(2) = valMaxA_lin(4);
            end
            if gT(idxnon(2)) - gT(idxnon(1)) < 0.8
                idxnon(3) = idxMaxA_non(5);
                valA_non(3) = valMaxA_non(5);
                idxnon(2) = idxMaxA_non(4);
                valA_non(2) = valMaxA_non(4);
            end
                
            
            
            pT_lin = gT(idxlin(3)) - gT(idxlin(2));
            pT_non = gT(idxnon(3)) - gT(idxnon(2));

            
            
            disp(['Calculated natural frequency - nonlinear = ', num2str(1/pT_non), ' Hz']);
            disp(['Calculated natural frequency - linear = ', num2str(1/pT_lin), ' Hz']);
            
            
            
            figure(1)
            plot(gT, gA_lin ,'b');
            hold on
            plot(gT, gA_non ,'r');
            plot(gT(idxlin), -valA_lin, 'bo');
            plot(gT(idxnon), -valA_non, 'ro');
%             plot(gT, obj.road.dis_t(gT), 'g');
            grid on
            grid minor
            leg1 = strcat('linear');
            leg2 = strcat('nonlinear');
            leg3 = strcat('linear - peak');
            leg4 = strcat('nonlinear - peak');
            legend(leg1, leg2, leg3, leg4);
            tit = strcat('Car Body Acceleration at ', num2str(obj.road.v*3.6),' km/h - ', obj.road.roadtype);
            title(tit);
            xlabel('Time (s)');
            ylabel('Acceleration (m/s^2)');
            
            
%             pT_lin = gT(idxMaxA_lin(3)) - gT(idxMaxA_lin(2));
%             pT_non = gT(idxMaxA_non(3)) - gT(idxMaxA_non(2));
            
%             obj.FN_1_lin = 1/pT_lin;
%             obj.FN_1_non = 1/pT_non;
%             disp(num2str(obj.FN_1_lin));
%             disp(num2str(obj.FN_1_non));
            
            
            
            
            [valMaxX_non, idxMaxX_non] = findpeaks(gX_non(:,3));
            [valMaxX_lin, idxMaxX_lin] = findpeaks(gX_lin(:,3));
            
            idxRevlin = idxMaxX_lin(1:3);
            idxRevnon = idxMaxX_non(1:3);
            
            valX_lin = valMaxX_lin(1:3);
            valX_non = valMaxX_non(1:3);
            
            xx = gX_lin(idxMaxX_lin(2),3)/gX_lin(idxMaxX_lin(3),3);
            zt_lin = 1/(2*pi)*log(xx)/log(exp(1));
            
            xx = gX_lin(idxMaxX_non(2),3)/gX_lin(idxMaxX_non(3),3);
            zt_non = 1/(2*pi)*log(xx)/log(exp(1));

            disp(['Calculated damping ratio - nonlinear = ', num2str(zt_non), ' ']);
            disp(['Calculated damping ratio - linear = ', num2str(zt_lin), ' ']);
            
            
            
%             disp(num2str(zt));
            
%             if gT(idxRevlin(2)) - gT(idxRevlin(1)) < 0.4
%                 idxRevlin(2) = idxMaxX_lin(3);
%                 valX_lin(2) = valMaxX_lin(3);
%             end
%             if gT(idxRevnon(2)) - gT(idxRevnon(1)) < 0.6
%                 idxRevnon(2) = idxMaxX_non(3);
%                 valX_non(2) = valMaxX_non(3);
%             end
            
            
            figure(2)
            plot(gT, gX_lin(:,3) ,'b');
            hold on
            plot(gT, gX_non(:,3) ,'r');
            plot(gT(idxRevlin), valX_lin, 'bo');
            plot(gT(idxRevnon), valX_non, 'ro');
            plot(gT, obj.road.dis_t(gT),'g');
            grid on
            grid minor
            leg1 = strcat('linear');
            leg2 = strcat('nonlinear');
            leg3 = strcat('linear - peak');
            leg4 = strcat('nonlinear - peak');
            leg5 = strcat('road profile');
            legend(leg1, leg2, leg3, leg4, leg5);
            tit = strcat('Car Body Displacement at ', num2str(obj.road.v*3.6),' km/h - ', obj.road.roadtype);
            title(tit);
            xlabel('Time (s)');
            ylabel('Relative Displacement (m)');
            
            
        end
        
        
        function Solving_FN_ZT_MultiV_GBT(obj)
            
            
            
            
            for v = 1:length(obj.V_Linspace)
                obj.road.v = obj.V_Linspace(v)/3.6;
                [~, gX_lin]  = ode45(@obj.PTVP_lin, obj.t, [0; 0; 0; 0]); 
                [gT, gX_non]  = ode45(@obj.PTVP_non, obj.t, [0; 0; 0; 0]); 


                gA_non = -(polyval(obj.congthucStiff, gX_non(:,3)-gX_non(:,1))/obj.init.ms).*(gX_non(:,3)-gX_non(:,1)) ... 
                    -(obj.init.cs/obj.init.ms).*(gX_non(:,4)-gX_non(:,2));
                gA_lin = -(obj.init.ks/obj.init.ms).*(gX_lin(:,3)-gX_lin(:,1)) ... 
                    -(obj.init.cs/obj.init.ms).*(gX_lin(:,4)-gX_lin(:,2));

                [valMaxA_non, idxMaxA_non] = findpeaks(-gA_non);
                [valMaxA_lin, idxMaxA_lin] = findpeaks(-gA_lin);

                idxlin = idxMaxA_lin(1:2);
                idxnon = idxMaxA_non(1:2);
                valA_lin = valMaxA_lin(1:2);
                valA_non = valMaxA_non(1:2);

%                 if gT(idxlin(2)) - gT(idxlin(1)) < 0.8
%                     idxlin(3) = idxMaxA_lin(4);
%                     valA_lin(3) = valMaxA_lin(4);
%                     idxlin(2) = idxMaxA_lin(3);
%                     valA_lin(2) = valMaxA_lin(3);
%                 end
%                 if gT(idxnon(2)) - gT(idxnon(1)) < 0.8
%                     idxnon(3) = idxMaxA_non(4);
%                     valA_non(3) = valMaxA_non(4);
%                     idxnon(2) = idxMaxA_non(3);
%                     valA_non(2) = valMaxA_non(3);
%                 end
%                 
%                 if gT(idxlin(2)) - gT(idxlin(1)) < 0.8
%                     idxlin(3) = idxMaxA_lin(5);
%                     valA_lin(3) = valMaxA_lin(5);
%                     idxlin(2) = idxMaxA_lin(4);
%                     valA_lin(2) = valMaxA_lin(4);
%                 end
%                 if gT(idxnon(2)) - gT(idxnon(1)) < 0.8
%                     idxnon(3) = idxMaxA_non(5);
%                     valA_non(3) = valMaxA_non(5);
%                     idxnon(2) = idxMaxA_non(4);
%                     valA_non(2) = valMaxA_non(4);
%                 end
                
                
                
                
                pT_lin = gT(idxlin(2)) - gT(idxlin(1));
                pT_non = gT(idxnon(2)) - gT(idxnon(1));
                
                obj.FN_1_lin(v) = 1/pT_lin;
                obj.FN_1_non(v) = 1/pT_non;
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
%                 obj.road.v = obj.V_Linspace(v)/3.6;
%                 [~, gX_lin]  = ode45(@obj.PTVP_lin, obj.t, [0; 0; 0; 0]); 
%                 [gT, gX_non]  = ode45(@obj.PTVP_non, obj.t, [0; 0; 0; 0]); 
% 
%                 rev_non = gX_non(:,3)-gX_non(:,1);
%                 rev_lin = gX_lin(:,3)-gX_lin(:,1);
% 
%                 [valMaxX_non, idxMaxX_non] = findpeaks(rev_non);
%                 [valMaxX_lin, idxMaxX_lin] = findpeaks(rev_lin);
% 
%                 gA_non = -(polyval(obj.congthucStiff, gX_non(:,3)-gX_non(:,1))/obj.init.ms).*(gX_non(:,3)-gX_non(:,1)) ... 
%                     -(obj.init.cs/obj.init.ms).*(gX_non(:,4)-gX_non(:,2));
%                 gA_lin = -(obj.init.ks/obj.init.ms).*(gX_non(:,3)-gX_non(:,1)) ... 
%                     -(obj.init.cs/obj.init.ms).*(gX_non(:,4)-gX_non(:,2));
% 
%                 [valMaxA_non, idxMaxA_non] = findpeaks(-gA_non);
%                 [valMaxA_lin, idxMaxA_lin] = findpeaks(-gA_lin);
% 
%                 pT_lin = gT(idxMaxA_lin(3)) - gT(idxMaxA_lin(2));
%                 pT_non = gT(idxMaxA_non(3)) - gT(idxMaxA_non(2));
% 
%                 if 1/pT_lin > 2
% %                     obj.FN_1_lin = 1/pT_lin;
% %                     obj.FN_1_non = 1/pT_non;
% %                     disp(num2str(obj.FN_1_lin));
% %                     disp(num2str(obj.FN_1_non));
%                     disp(['linear ', num2str(v),' at vel = ',num2str(obj.road.v)]);
% %                     FN_lin(v) = 1/pT_lin;
% %                     FN_non(v) = 1/pT_non;
%                 end
%                 
%                 if 1/pT_non > 2
%                     disp(['nonlinear ', num2str(v),' at vel = ',num2str(obj.road.v)]);
%                 end
%                 
                
                
                
                
%                 obj.road.v = obj.V_Linspace(id)/3.6;
%                 [obj.T, obj.X_lin]  = ode45(@obj.PTVP_lin, obj.t, [0; 0; 0; 0]); 
%                 [obj.T, obj.X_non]  = ode45(@obj.PTVP_non, obj.t, [0; 0; 0; 0]); 
%                 [~, idxMaxA_non] = findpeaks(-obj.X_non(:,3));
%                 [~, idxMaxA_lin] = findpeaks(-obj.X_lin(:,3));
%                 
%                 try
%                     xx = obj.X_non(idxMaxA_non(2),3)/obj.X_non(idxMaxA_non(3),3);
%                     obj.zetTestNon(id) = 1/(2*pi)*log(xx)/log(exp(1));
%                     Ttatdan = obj.T(idxMaxA_non(3)) - obj.T(idxMaxA_non(2));
%                     obj.fntatdanNon(id) = 1/Ttatdan;
%             
%                     xx = obj.X_lin(idxMaxA_lin(2),3)/obj.X_lin(idxMaxA_lin(3),3);
%                     obj.zetTestLin(id) = 1/(2*pi)*log(xx)/log(exp(1));
%                     Ttatdan = obj.T(idxMaxA_lin(3)) - obj.T(idxMaxA_lin(2));
%                     obj.fntatdanLin(id) = 1/Ttatdan;
%                 catch
%                     obj.fntatdanNon(id) = nan;
%                     obj.zetTestNon(id) = nan;
%                 end
            end
            
            plot(obj.V_Linspace, obj.FN_1_lin);
        end
        
        
        function Solving_FN_ZT_MultiV(obj)
            SolvingFreqResponse(obj);
            [~, idx] = findpeaks(obj.RMSA_lin); %,'SortStr','descend'
%             [~, idx] = max(abs(obj.RMSA_lin));
            velMaxRMSA_lin = obj.V_Linspace(idx)
            Solving_FN_ZT_LINEAR(obj, velMaxRMSA_lin);
%             Solving_FN_ZT(obj, 20);
            
            for v = 1:length(obj.V_Linspace)
                obj.road.v = obj.V_Linspace(v)/3.6;
                [~, gX_lin]  = ode45(@obj.PTVP_lin, obj.t, [0; 0; 0; 0]); 
                [gT, gX_non]  = ode45(@obj.PTVP_non, obj.t, [0; 0; 0; 0]); 


                gA_non = -(polyval(obj.congthucStiff, gX_non(:,3)-gX_non(:,1))/obj.init.ms).*(gX_non(:,3)-gX_non(:,1)) ... 
                    -(obj.init.cs/obj.init.ms).*(gX_non(:,4)-gX_non(:,2));
                gA_lin = -(obj.init.ks/obj.init.ms).*(gX_lin(:,3)-gX_lin(:,1)) ... 
                    -(obj.init.cs/obj.init.ms).*(gX_lin(:,4)-gX_lin(:,2));

                [valMaxA_non, idxMaxA_non] = findpeaks(-gA_non);
                [valMaxA_lin, idxMaxA_lin] = findpeaks(-gA_lin);

                idxlin = idxMaxA_lin(1:3);
                idxnon = idxMaxA_non(1:3);
                valA_lin = valMaxA_lin(1:3);
                valA_non = valMaxA_non(1:3);

%                 if gT(idxlin(3)) - gT(idxlin(2)) < 0.4
%                     idxlin(3) = idxMaxA_lin(4);
%                     valA_lin(3) = valMaxA_lin(4);
%                 end
%                 if gT(idxnon(3)) - gT(idxnon(2)) < 0.6
%                     idxnon(3) = idxMaxA_non(4);
%                     valA_non(3) = valMaxA_non(4);
%                 end
                
                if gT(idxlin(2)) - gT(idxlin(1)) < 0.8
                    idxlin(3) = idxMaxA_lin(4);
                    valA_lin(3) = valMaxA_lin(4);
                    idxlin(2) = idxMaxA_lin(3);
                    valA_lin(2) = valMaxA_lin(3);
                end
                if gT(idxnon(2)) - gT(idxnon(1)) < 0.8
                    idxnon(3) = idxMaxA_non(4);
                    valA_non(3) = valMaxA_non(4);
                    idxnon(2) = idxMaxA_non(3);
                    valA_non(2) = valMaxA_non(3);
                end
                
                if gT(idxlin(2)) - gT(idxlin(1)) < 0.8
                    idxlin(3) = idxMaxA_lin(5);
                    valA_lin(3) = valMaxA_lin(5);
                    idxlin(2) = idxMaxA_lin(4);
                    valA_lin(2) = valMaxA_lin(4);
                end
                if gT(idxnon(2)) - gT(idxnon(1)) < 0.8
                    idxnon(3) = idxMaxA_non(5);
                    valA_non(3) = valMaxA_non(5);
                    idxnon(2) = idxMaxA_non(4);
                    valA_non(2) = valMaxA_non(4);
                end
                
                
                
                
                pT_lin = gT(idxlin(3)) - gT(idxlin(2));
                pT_non = gT(idxnon(3)) - gT(idxnon(2));
                
                obj.FN_1_lin(v) = 1/pT_lin;
                obj.FN_1_non(v) = 1/pT_non;
                
                
                
                
                
                
            
                [valMaxX_non, idxMaxX_non] = findpeaks(gX_non(:,3));
                [valMaxX_lin, idxMaxX_lin] = findpeaks(gX_lin(:,3));

                idxRevlin = idxMaxX_lin(1:3);
                idxRevnon = idxMaxX_non(1:3);

                valX_lin = valMaxX_lin(1:3);
                valX_non = valMaxX_non(1:3);

                xx = gX_lin(idxRevlin(2),3)/gX_lin(idxRevlin(3),3);
                zt_lin(v) = 1/(2*pi)*log(xx)/log(exp(1));
                
                
                xx = gX_lin(idxRevnon(2),3)/gX_lin(idxRevnon(3),3);
                zt_non(v) = 1/(2*pi)*log(xx)/log(exp(1));
                
                
            end
            figure(3)
            plot(obj.V_Linspace, obj.FN_1_non, 'r');
            hold on
            plot(obj.V_Linspace, obj.FN_1_lin, 'b');
            plot([obj.V_Linspace(1), obj.V_Linspace(end)], ...
                [obj.init.fn_lin, obj.init.fn_lin], '--r');
            plot([obj.V_Linspace(1), obj.V_Linspace(end)], ...
                [obj.init.fn_lin, obj.init.fn_lin], '--b');
            legend('nonlinear','linear','initial nonlinear','initial linear');
            grid on;
            grid minor
            ylim([1.02, 1.09]);
            tit = strcat('Calculated Natural Frequency in different Car Speed - ',obj.road.roadtype);
            title(tit);
            xlabel('Car speed [km/h]');
            ylabel('Natural Frequency [Hz]');
            
            
            figure(4)
            plot(obj.V_Linspace, zt_non, 'r');
            hold on
            plot(obj.V_Linspace, zt_lin, 'b');
            plot([obj.V_Linspace(1), obj.V_Linspace(end)], ...
                [obj.init.zt_non, obj.init.zt_non], '--r');
            plot([obj.V_Linspace(1), obj.V_Linspace(end)], ...
                [obj.init.zt_lin, obj.init.zt_lin], '--b');
            legend('nonlinear','linear','initial nonlinear','initial linear');
            grid on;
            grid minor
%             ylim([1.02, 1.09]);
            tit = strcat('Calculated Damping ratio in different Car Speed - ',obj.road.roadtype);
            title(tit);
            xlabel('Car speed [km/h]');
            ylabel('Damping ratio [1]');
            
        end
        
        
        function FINDING3(obj)
            for v = 1:length(obj.V_Linspace)
                obj.road.v = obj.V_Linspace(v)/3.6;
                SolvingTimeResponse(obj);
                
            
                [valMaxX_non, idxMaxX_non] = findpeaks(obj.X_non(:,3));
                [valMaxX_lin, idxMaxX_lin] = findpeaks(obj.X_lin(:,3));

                
                close(figure(1))
                figure(1)
                plot(obj.T, obj.X_non(:,3), 'r');
                hold on
                plot(obj.T, obj.X_lin(:,3), 'b');
                plot(obj.T(idxMaxX_non), obj.X_non(idxMaxX_non, 3), 'ro');
                plot(obj.T(idxMaxX_lin), obj.X_lin(idxMaxX_lin, 3), 'bo');
                
                
                hold off;
                title(num2str(obj.V_Linspace(v)));
                
                xx1 = obj.X_lin(idxMaxX_lin(2),3)/obj.X_lin(idxMaxX_lin(3),3);
                xx2 = obj.X_non(idxMaxX_non(2),3)/obj.X_non(idxMaxX_non(3),3);
                
%                 if obj.V_Linspace(v) >= 20
%                     xx1 = obj.X_lin(idxMaxX_lin(2),3)/obj.X_lin(idxMaxX_lin(3),3);
%                     xx2 = obj.X_non(idxMaxX_non(2),3)/obj.X_non(idxMaxX_non(3),3);
%                 end
%                 if obj.V_Linspace(v) >= 30
%                     xx1 = obj.X_lin(idxMaxX_lin(2),3)/obj.X_lin(idxMaxX_lin(3),3);
%                     xx2 = obj.X_non(idxMaxX_non(2),3)/obj.X_non(idxMaxX_non(3),3);
%                 end
%                 if obj.V_Linspace(v) >= 40
%                     xx1 = obj.X_lin(idxMaxX_lin(3),3)/obj.X_lin(idxMaxX_lin(4),3);
%                     xx2 = obj.X_non(idxMaxX_non(2),3)/obj.X_non(idxMaxX_non(3),3);
%                 end
%                 if obj.V_Linspace(v) >= 50
%                     xx1 = obj.X_lin(idxMaxX_lin(3),3)/obj.X_lin(idxMaxX_lin(4),3);
%                     xx2 = obj.X_non(idxMaxX_non(3),3)/obj.X_non(idxMaxX_non(4),3);
%                 end
%                 if obj.V_Linspace(v) >= 60
%                     xx1 = obj.X_lin(idxMaxX_lin(3),3)/obj.X_lin(idxMaxX_lin(4),3);
%                     xx2 = obj.X_non(idxMaxX_non(3),3)/obj.X_non(idxMaxX_non(4),3);
%                 end
%                 if obj.V_Linspace(v) >= 70
%                     xx1 = obj.X_lin(idxMaxX_lin(3),3)/obj.X_lin(idxMaxX_lin(4),3);
%                     xx2 = obj.X_non(idxMaxX_non(3),3)/obj.X_non(idxMaxX_non(4),3);
%                 end
% %                 
%                 if obj.V_Linspace(v) >= 80
%                     xx1 = obj.X_lin(idxMaxX_lin(3),3)/obj.X_lin(idxMaxX_lin(4),3);
%                     xx2 = obj.X_non(idxMaxX_non(3),3)/obj.X_non(idxMaxX_non(4),3);
%                 end
                
                
                
                zt_non(v) = 1/(2*pi)*log(xx2)/log(exp(1));
                zt_lin(v) = 1/(2*pi)*log(xx1)/log(exp(1));
%                 pT_lin = obj.T(idxMaxA_lin(3)) - obj.T(idxMaxA_lin(2));
%                 pT_non = obj.T(idxMaxA_non(3)) - obj.T(idxMaxA_non(2));
% 
%                 if obj.V_Linspace(v) >= 20
%                     pT_non = obj.T(idxMaxA_non(3)) - obj.T(idxMaxA_non(2));
%                     pT_lin = obj.T(idxMaxA_lin(3)) - obj.T(idxMaxA_lin(2));
%                 end
%                 if obj.V_Linspace(v) >= 30
%                     pT_non = obj.T(idxMaxA_non(4)) - obj.T(idxMaxA_non(3));
%                     pT_lin = obj.T(idxMaxA_lin(3)) - obj.T(idxMaxA_lin(2));
%                 end
%                 if obj.V_Linspace(v) >= 40
%                     pT_non = obj.T(idxMaxA_non(4)) - obj.T(idxMaxA_non(3));
%                     pT_lin = obj.T(idxMaxA_lin(3)) - obj.T(idxMaxA_lin(2));
%                 end
%                 if obj.V_Linspace(v) >= 50
%                     pT_non = obj.T(idxMaxA_non(4)) - obj.T(idxMaxA_non(3));
%                     pT_lin = obj.T(idxMaxA_lin(3)) - obj.T(idxMaxA_lin(2));
%                 end
%                 if obj.V_Linspace(v) >= 60
%                     pT_non = obj.T(idxMaxA_non(4)) - obj.T(idxMaxA_non(3));
%                     pT_lin = obj.T(idxMaxA_lin(3)) - obj.T(idxMaxA_lin(2));
%                 end
%                 if obj.V_Linspace(v) >= 70
%                     pT_non = obj.T(idxMaxA_non(4)) - obj.T(idxMaxA_non(3));
%                     pT_lin = obj.T(idxMaxA_lin(3)) - obj.T(idxMaxA_lin(2));
%                 end
%                 
%                 if obj.V_Linspace(v) >= 80
%                     pT_non = obj.T(idxMaxA_non(5)) - obj.T(idxMaxA_non(4));
%                     pT_lin = obj.T(idxMaxA_lin(4)) - obj.T(idxMaxA_lin(3));
%                 end
                
                input('');
                
%                 pT_lin = gT(idxlin(3)) - gT(idxlin(2));
%                 pT_non = gT(idxnon(3)) - gT(idxnon(2));
%                 
%                 obj.FN_lin(v) = 1/pT_lin;
%                 obj.FN_non(v) = 1/pT_non;
                
            end
            
            figure(2)
            plot(obj.V_Linspace, zt_non, 'r');
            hold on
            plot(obj.V_Linspace, zt_lin, 'b');
            plot([obj.V_Linspace(1), obj.V_Linspace(end)], ...
                [obj.init.zt_non, obj.init.zt_non], 'bla');
            legend('nonlinear','linear','Zeta params');
            grid on;
            grid minor
            tit = strcat('Calculated Damping ratio in different Car Speed - ',obj.road.roadtype);
            title(tit);
            xlabel('Car speed [km/h]');
            ylabel('Damping ratio [1]');
            
            
            
            figure(3)
            zt = ones(1, length(obj.V_Linspace)) * obj.init.zt_non;
            
            PerFN_non = (zt_non - zt)./zt*100;
            PerFN_lin = (zt_lin - zt)./zt*100;
            
            plot(obj.V_Linspace, PerFN_non, 'r');
            hold on
            plot(obj.V_Linspace, PerFN_lin, 'b');
            plot([obj.V_Linspace(1), obj.V_Linspace(end)],[0 0], 'bla');
            legend('nonlinear','linear', 'Zeta Params');
            grid on;
            grid minor
            
            tit = strcat('Calculated Damping ratio in different Car Speed - ',obj.road.roadtype);
            title(tit);
            xlabel('Car speed [km/h]');
            ylabel('ERROR [%]');
            
            
        end
        
        
        
        function FINDING2(obj)
            for v = 1:length(obj.V_Linspace)
                obj.road.v = obj.V_Linspace(v)/3.6;
                SolvingTimeResponse(obj);
                
                [valMaxA_non, idxMaxA_non] = findpeaks(-obj.a_non);
                [valMaxA_lin, idxMaxA_lin] = findpeaks(-obj.a_lin);
                
                close(figure(1))
                figure(1)
                plot(obj.T, obj.a_non, 'r');
                hold on
                plot(obj.T, obj.a_lin, 'b');
                plot(obj.T(idxMaxA_non), obj.a_non(idxMaxA_non), 'ro');
                plot(obj.T(idxMaxA_lin), obj.a_lin(idxMaxA_lin), 'bo');
                
                
                hold off;
                title(num2str(obj.V_Linspace(v)));
                
                
                pT_lin = obj.T(idxMaxA_lin(3)) - obj.T(idxMaxA_lin(2));
                pT_non = obj.T(idxMaxA_non(3)) - obj.T(idxMaxA_non(2));

                if obj.V_Linspace(v) >= 20
                    pT_non = obj.T(idxMaxA_non(4)) - obj.T(idxMaxA_non(3));
                    pT_lin = obj.T(idxMaxA_lin(3)) - obj.T(idxMaxA_lin(2));
                end
                if obj.V_Linspace(v) >= 30
                    pT_non = obj.T(idxMaxA_non(5)) - obj.T(idxMaxA_non(4));
                    pT_lin = obj.T(idxMaxA_lin(3)) - obj.T(idxMaxA_lin(2));
                end
                if obj.V_Linspace(v) >= 40
                    pT_non = obj.T(idxMaxA_non(5)) - obj.T(idxMaxA_non(4));
                    pT_lin = obj.T(idxMaxA_lin(4)) - obj.T(idxMaxA_lin(3));
                end
                if obj.V_Linspace(v) >= 50
                    pT_non = obj.T(idxMaxA_non(7)) - obj.T(idxMaxA_non(6));
                    pT_lin = obj.T(idxMaxA_lin(4)) - obj.T(idxMaxA_lin(3));
                end
                if obj.V_Linspace(v) >= 60
                    pT_non = obj.T(idxMaxA_non(6)) - obj.T(idxMaxA_non(5));
                    pT_lin = obj.T(idxMaxA_lin(5)) - obj.T(idxMaxA_lin(4));
                end
                if obj.V_Linspace(v) >= 70
                    pT_non = obj.T(idxMaxA_non(5)) - obj.T(idxMaxA_non(4));
                    pT_lin = obj.T(idxMaxA_lin(5)) - obj.T(idxMaxA_lin(4));
                end
                
                if obj.V_Linspace(v) >= 80
                    pT_non = obj.T(idxMaxA_non(5)) - obj.T(idxMaxA_non(4));
                    pT_lin = obj.T(idxMaxA_lin(5)) - obj.T(idxMaxA_lin(4));
                end
                
                input('');
                
%                 pT_lin = gT(idxlin(3)) - gT(idxlin(2));
%                 pT_non = gT(idxnon(3)) - gT(idxnon(2));
%                 
                obj.FN_lin(v) = 1/pT_lin;
                obj.FN_non(v) = 1/pT_non;
                
            end
            
            figure(2)
            plot(obj.V_Linspace, obj.FN_non, 'r');
            hold on
            plot(obj.V_Linspace, obj.FN_lin, 'b');
            plot([obj.V_Linspace(1), obj.V_Linspace(end)],[obj.init.fn_lin, obj.init.fn_lin], 'bla');
            legend('nonlinear','linear', 'Linear Params');
            grid on;
            grid minor
            ylim([1.02, 1.09]);
            tit = strcat('Calculated Natural Frequency in different Car Speed - ',obj.road.roadtype);
            title(tit);
            xlabel('Car speed [km/h]');
            ylabel('Natural Frequency [Hz]');
            
            
            figure(3)
            fn = ones(1, length(obj.V_Linspace)) * obj.init.fn_lin;
            
            PerFN_non = (obj.FN_non - fn)./fn*100;
            PerFN_lin = (obj.FN_lin - fn)./fn*100;
            
            plot(obj.V_Linspace, PerFN_non, 'r');
            hold on
            plot(obj.V_Linspace, PerFN_lin, 'b');
            plot([obj.V_Linspace(1), obj.V_Linspace(end)],[0 0], 'bla');
            legend('nonlinear','linear', 'Linear Params');
            grid on;
            grid minor
            
            tit = strcat('Calculated Natural Frequency in different Car Speed - ',obj.road.roadtype);
            title(tit);
            xlabel('Car speed [km/h]');
            ylabel('ERROR [%]');
            
            
        end
        
        
        function FINDING1(obj)
            for v = 1:length(obj.V_Linspace)
                obj.road.v = obj.V_Linspace(v)/3.6;
                SolvingTimeResponse(obj);
                
                [valMaxA_non, idxMaxA_non] = findpeaks(-obj.a_non);
                [valMaxA_lin, idxMaxA_lin] = findpeaks(-obj.a_lin);
                
                
                close(figure(1))
                figure(1)
                plot(obj.T, obj.a_non, 'r');
                hold on
                plot(obj.T, obj.a_lin, 'b');
                plot(obj.T(idxMaxA_non), obj.a_non(idxMaxA_non), 'ro');
                plot(obj.T(idxMaxA_lin), obj.a_lin(idxMaxA_lin), 'bo');
                
                
                hold off;
                title(num2str(obj.V_Linspace(v)));
                
                
                pT_lin = obj.T(idxMaxA_lin(3)) - obj.T(idxMaxA_lin(2));
                pT_non = obj.T(idxMaxA_non(3)) - obj.T(idxMaxA_non(2));

                if obj.V_Linspace(v) >= 30
                    pT_non = obj.T(idxMaxA_non(4)) - obj.T(idxMaxA_non(3));
                end
                
                if obj.V_Linspace(v) >= 50
                    pT_lin = obj.T(idxMaxA_lin(4)) - obj.T(idxMaxA_lin(3));
                end
                
                input('');
                
                obj.FN_lin(v) = 1/pT_lin;
                obj.FN_non(v) = 1/pT_non;
                
                
            end
            
            figure(2)
            plot(obj.V_Linspace, obj.FN_non, 'r');
            hold on
            plot(obj.V_Linspace, obj.FN_lin, 'b');
            plot([obj.V_Linspace(1), obj.V_Linspace(end)],[obj.init.fn_lin, obj.init.fn_lin], 'bla');
            legend('nonlinear','linear', 'Linear Params');
            grid on;
            grid minor
            ylim([1.02, 1.09]);
            tit = strcat('Calculated Natural Frequency in different Car Speed - ',obj.road.roadtype);
            title(tit);
            xlabel('Car speed [km/h]');
            ylabel('Natural Frequency [Hz]');
            
            
            figure(3)
            fn = ones(1, length(obj.V_Linspace)) * obj.init.fn_lin;
            
            PerFN_non = (obj.FN_non - fn)./fn*100;
            PerFN_lin = (obj.FN_lin - fn)./fn*100;
            
            plot(obj.V_Linspace, PerFN_non, 'r');
            hold on
            plot(obj.V_Linspace, PerFN_lin, 'b');
            plot([obj.V_Linspace(1), obj.V_Linspace(end)],[0 0], 'bla');
            legend('nonlinear','linear', 'Linear Params');
            grid on;
            grid minor
            
            tit = strcat('Calculated Natural Frequency in different Car Speed - ',obj.road.roadtype);
            title(tit);
            xlabel('Car speed [km/h]');
            ylabel('ERROR [%]');
            
            
        end
        
        
        
        
        
        
        
        
        function SolvingFreqResponse(obj)
             for v = 1:length(obj.V_Linspace)
                obj.road.v = obj.V_Linspace(v)/3.6;
                
                [~, gX_lin]  = ode45(@obj.PTVP_lin, obj.t, [0; 0; 0; 0]); 
                [gT, gX_non]  = ode45(@obj.PTVP_non, obj.t, [0; 0; 0; 0]); 
                
                
                KS = polyval(obj.congthucStiff, gX_non(:,3)-gX_non(:,1));
                gA_non = -(KS/obj.init.ms).*(gX_non(:,3)-gX_non(:,1)) ... 
                    -(obj.init.cs/obj.init.ms).*(gX_non(:,4)-gX_non(:,2));
                gA_lin = -(obj.init.ks/obj.init.ms).*(gX_lin(:,3)-gX_lin(:,1)) ... 
                    -(obj.init.cs/obj.init.ms).*(gX_lin(:,4)-gX_lin(:,2));
                
                obj.SDD_lin(v) = max(abs(gX_lin(:,3) - gX_lin(:,1)));
                obj.SDD_non(v) = max(abs(gX_non(:,3) - gX_non(:,1)));
                
                obj.BVA_non(v) = max(abs(gA_non));
                obj.BVA_lin(v) = max(abs(gA_lin));
                
                obj.RMSA_non(v) = rms(abs(gA_non));
                obj.RMSA_lin(v) = rms(abs(gA_lin));
                
                TD_non = (obj.init.ku.*(gX_non(:,3) - obj.road.dis_t(gT)))./((obj.init.ms + obj.init.mu)*10);
                TD_lin = (obj.init.ku.*(gX_lin(:,3) - obj.road.dis_t(gT)))./((obj.init.ms + obj.init.muLinear)*10);
                
                obj.TDL_non(v) = max(abs(TD_non));
                obj.TDL_lin(v) = max(abs(TD_lin));
            end
        end
        
        function SolvingTimeResponse(obj)
            [obj.T, obj.X_lin]  = ode45(@obj.PTVP_lin, obj.t, [0; 0; 0; 0]); 
            [obj.T, obj.X_non]  = ode45(@obj.PTVP_non, obj.t, [0; 0; 0; 0]); 
            obj.a_non = -(polyval(obj.congthucStiff, obj.X_non(:,3)-obj.X_non(:,1))/obj.init.ms).*(obj.X_non(:,3)-obj.X_non(:,1)) ... 
                -(obj.init.cs/obj.init.ms).*(obj.X_non(:,4)-obj.X_non(:,2));
            obj.a_lin = -(obj.init.ks/obj.init.ms).*(obj.X_lin(:,3)-obj.X_lin(:,1)) ... 
                -(obj.init.cs/obj.init.ms).*(obj.X_lin(:,4)-obj.X_lin(:,2));
            
            obj.rev_X_non = obj.X_non(:,3) - obj.X_non(:,1);
            obj.rev_X_lin = obj.X_lin(:,3) - obj.X_lin(:,1);
        end
        
        function dxdt = PTVP_lin(obj, t, x)
            y = obj.road.dis_t(t);
            k_s = obj.init.ks;
            m_s = obj.init.ms;
            m_u_lin = obj.init.muLinear;
            c_s = obj.init.cs;
            k_u = obj.init.ku;
            
            a = x(2);
            b = (k_s/m_u_lin)*(x(3)-x(1))+(c_s/m_u_lin)*(x(4)-x(2))-(k_u/m_u_lin)*(x(1)-y);
            c = x(4);
            d = -(k_s/m_s)*(x(3)-x(1))-(c_s/m_s)*(x(4)-x(2));
            dxdt = [a; b; c; d];
        end
        
        function dxdt = PTVP_non(obj, t, x)
            y = obj.road.dis_t(t);
            k_s = polyval(obj.congthucStiff, x(3) - x(1));
            if k_s < obj.init.as.KS_MIN
                k_s = obj.init.as.KS_MIN;
            elseif k_s > obj.init.as.KS_MAX
                k_s = obj.init.as.KS_MAX;
            end
            m_s = obj.init.ms;
            m_u = obj.init.mu;
            c_s = obj.init.cs;
            k_u = obj.init.ku;
            
            a = x(2);
            b = (k_s/m_u)*(x(3)-x(1))+(c_s/m_u)*(x(4)-x(2))-(k_u/m_u)*(x(1)-y);
            c = x(4);
            d = -(k_s/m_s)*(x(3)-x(1))-(c_s/m_s)*(x(4)-x(2));
            dxdt = [a; b; c; d];
        end
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
end

