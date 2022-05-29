classdef SolverV < handle
    %SOLVERV Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        SDD_non;
        SDD_lin;
        
        BVA_non;
        BVA_lin;
        
        RMSA_non;
        RMSA_lin;
        
        TDL_non;
        TDL_lin;
    end
    properties
        solverT;
        vLin;
    end
    methods
        function obj = SolverV(solverT, init_params)
            obj.solverT = solverT;
            obj.vLin = init_params.vLin;
        end
        
        function SolvingFreqResponse(obj)
            for v = 1:length(obj.vLin)
                obj.solverT.SolvingTimeResponse(obj.vLin(v)/3.6);
                
                gT = obj.solverT.T;
                gX_lin = obj.solverT.X_lin;
                gX_non = obj.solverT.X_non;
                
                gA_lin = obj.solverT.a_lin;
                gA_non = obj.solverT.a_non;
                
                TD_non = (obj.solverT.init.ku.*(gX_non(:,3) - obj.solverT.road.dis_t(gT)))./((obj.solverT.init.ms + obj.solverT.init.mu)*10);
                TD_lin = (obj.solverT.init.ku.*(gX_lin(:,3) - obj.solverT.road.dis_t(gT)))./((obj.solverT.init.ms + obj.solverT.init.muLinear)*10);
                
                
                
                obj.SDD_lin(v) = max(abs(gX_lin(:,3) - gX_lin(:,1)));
                obj.SDD_non(v) = max(abs(gX_non(:,3) - gX_non(:,1)));
                
                obj.BVA_non(v) = max(abs(gA_non));
                obj.BVA_lin(v) = max(abs(gA_lin));
                
                obj.RMSA_non(v) = rms(abs(gA_non));
                obj.RMSA_lin(v) = rms(abs(gA_lin));
                
                obj.TDL_non(v) = max(abs(TD_non));
                obj.TDL_lin(v) = max(abs(TD_lin));
            end
        end
    end
    
end

