classdef INIT < handle
    %INIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        t;
        
        ms;
        cs;
        ks;
        mu;
        ku;
        muLinear;
        as;
        
        fn_lin;
        fn_non;
        
        zt_lin;
        zt_non;
    end
    
    methods
        function obj = INIT(init_params, airspring)    %cs, mu_non, mu_lin, ku
            obj.t = init_params.t;
            
            obj.ms = airspring.Mass_DES;
            obj.ks = airspring.Get_LinearStiff();
            obj.as = airspring;
            
            obj.cs = init_params.cs;
            obj.mu = init_params.mu_non;
            obj.ku = init_params.ku;
            obj.muLinear = init_params.mu_lin;
            
            
            KS = airspring.Get_LinearStiff();
            M_lin = [obj.mu     0;
                        0   obj.ms];
                    
            K_lin = [KS + obj.ku, -KS; 
                        -KS,   KS];
                    
            C_lin = [obj.cs , -obj.cs;
                     -obj.cs,  obj.cs];
                
%             sqrt(K_lin./M_lin)
            
            syms w;
            eqn = det(K_lin - w.^2.*M_lin) == 0;
            W = double(solve(eqn, w));
%             disp(num2str(W))
            ffn = W/(2*pi);
            
            
            FN = zeros(2,2);
            FN(1,1) = ffn(4);
            FN(1,2) = ffn(1);
            FN(2,1) = ffn(2);
            FN(2,2) = ffn(3);
            
%             FN
            
            
            
            A = inv(M_lin)*K_lin;
            [~,D]   = eig(A);
            
%             FN = sqrt(D)/(2*pi)
            ZETA = C_lin/(2*M_lin*sqrt(D));
            
            
            
%             zetaxx = C_lin/(2*sqrt(norm(K_lin)*M_lin))
            
            obj.fn_lin = FN(2,2);
            obj.zt_lin = ZETA(2,2);
            
%             w_s     = sqrt(D(2,2));
%             fns     = w_s/(2*pi);
%             obj.fn_lin = w_s/(2*pi);
%             obj.zt_lin = obj.cs/(4*pi*obj.ms*fns);
            
%             w = sqrt(D)
            
            
            
            
            M_lin = [obj.muLinear       0;
                        0 ,     airspring.Mass_DES];
            K_lin = [KS + obj.ku , -KS;
                        -KS  ,  KS];
            
            A = inv(M_lin)*K_lin;
            [~,D]   = eig(A);
            
            
            FN = sqrt(D)/(2*pi);
            ZETA = C_lin/(4*pi*M_lin*FN);
            
            obj.fn_non = FN(2,2);
            obj.zt_non = ZETA(2,2);
            
%             A = inv(M_lin)*K_lin;
%             [~,D]   = eig(A);
%             w_s     = sqrt(D(2,2));
%             fns     = w_s/(2*pi);
%             obj.fn_non = w_s/(2*pi);
%             obj.zt_non = obj.cs/(4*pi*obj.ms*fns);
        end
        
        function ShowThongSo(obj)
            disp(['Sprung mass = ',num2str(obj.ms),' kg']);
            disp(['Sprung damping coeeficiency = ',num2str(obj.cs),' N/(m/s)']);
            disp(['Sprung Stiffness Linear = ',num2str(obj.ks),' N/m']);
            disp(['Unsprung mass nonlinear = ',num2str(obj.mu),' kg']);
            disp(['Unsprung mass linear = ',num2str(obj.muLinear),' kg']);
            disp(['Unsprung stiffness = ',num2str(obj.ku),' N/m']);
            disp(['Natural frequency linear = ',num2str(obj.fn_lin),' Hz']);
            disp(['Natural frequency nonlinear = ',num2str(obj.fn_non),' Hz']);
            disp(['ZETA linear = ',num2str(obj.zt_lin),' ']);
            disp(['ZETA nonlinear = ',num2str(obj.zt_non),' ']);
            
            
            
            disp(['Design height of airspring = ',num2str(obj.as.Get_DesignHeight()),' m']);
            disp(['Airspring pressure = ',num2str(obj.as.PSI_DES),' PSI']);
            
            
            
            
        end
    end
    
end

