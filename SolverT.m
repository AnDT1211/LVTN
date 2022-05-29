classdef SolverT < handle
    %SOLVERT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        road;
        airspring;
        init;
        
        congthucStiff;
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
        
    end
    methods
        
        function obj = SolverT(init, road, airspring)
            obj.init = init;
            obj.road = road;
            obj.airspring = airspring;
            
            
            obj.t = init.t;
            obj.congthucStiff = airspring.Get_CongthucStiff();
        end
        
        
        function SolvingTimeResponse(obj, v)
            obj.road.v = v;
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

