classdef SolverFnZt < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        VLin;
        
        init_fnzt;
        solveT_IRC;
        
        FN_CAL_non;
        FN_CAL_lin;
        
        ZT_CAL_non;
        ZT_CAL_lin;
    end
    
    methods
        function obj = SolverFnZt(VLin, init_fnzt, solveT_IRC)
            obj.VLin = VLin;
            obj.init_fnzt = init_fnzt;
            obj.solveT_IRC = solveT_IRC;
        end
        
        
        function CalculateFnZT(obj, idxMaxA_non, idxMaxA_lin, idxMaxX_non, idxMaxX_lin)
            
            pT_non = obj.solveT_IRC.T(idxMaxA_non(obj.init_fnzt.i2_fn_non)) - obj.solveT_IRC.T(idxMaxA_non(obj.init_fnzt.i1_fn_non));
            obj.FN_CAL_non(1) = 1/pT_non;
            
            pT_lin = obj.solveT_IRC.T(idxMaxA_lin(obj.init_fnzt.i2_fn_lin)) - obj.solveT_IRC.T(idxMaxA_lin(obj.init_fnzt.i1_fn_lin));
            obj.FN_CAL_lin(1) = 1/pT_lin;
            
            
            pX_non = log(abs(obj.solveT_IRC.X_non(idxMaxX_non(obj.init_fnzt.i1_zt_non),3)/obj.solveT_IRC.X_non(idxMaxX_non(obj.init_fnzt.i2_zt_non),3)))/(obj.init_fnzt.i2_zt_non-obj.init_fnzt.i1_zt_non);
            obj.ZT_CAL_non(1) = pX_non/sqrt(4*pi^2 + pX_non^2);
            
            pX_lin = log(abs(obj.solveT_IRC.X_lin(idxMaxX_lin(obj.init_fnzt.i1_zt_lin),3)/obj.solveT_IRC.X_lin(idxMaxX_lin(obj.init_fnzt.i2_zt_lin),3)))/(obj.init_fnzt.i2_zt_lin-obj.init_fnzt.i1_zt_lin);
            obj.ZT_CAL_lin(1) = pX_lin/sqrt(4*pi^2 + pX_lin^2);

            
            
            
            for i = 2:length(obj.VLin)

                obj.solveT_IRC.SolvingTimeResponse(obj.VLin(i));



                [~, idxMaxA_lin] = findpeaks(-1*obj.solveT_IRC.a_lin);
                idx_lin = 1;
                for j = 2 : length(idxMaxA_lin)

                    for k = 1 : j - 1;
                        pT_non = obj.solveT_IRC.T(idxMaxA_lin(j)) - obj.solveT_IRC.T(idxMaxA_lin(k));

                        FN_test_lin(idx_lin, 1) = 1/pT_non;
                        FN_test_lin(idx_lin, 2) = abs( 1/pT_non - obj.FN_CAL_lin(i - 1));

                        idx_lin = idx_lin + 1;

                    end
                end

                [res, idxmin] = min(FN_test_lin(:,2));
                obj.FN_CAL_lin(i) = FN_test_lin(idxmin, 1);





                [~, idxMaxA_non] = findpeaks(-1*obj.solveT_IRC.a_non);
                idx_non = 1;
                for j = 2 : length(idxMaxA_non)

                    for k = 1 : j - 1;
                        pT_non = obj.solveT_IRC.T(idxMaxA_non(j)) - obj.solveT_IRC.T(idxMaxA_non(k));

                        FN_test_non(idx_non, 1) = 1/pT_non;
                        FN_test_non(idx_non, 2) = abs( 1/pT_non - mean(obj.FN_CAL_non));
%                         FN_test_non(idx_non, 2) = abs( 1/pT_non - obj.FN_CAL_non(i - 1));

                        idx_non = idx_non + 1;

                    end
                end

                [res, idxmin] = min(FN_test_non(:,2));
                obj.FN_CAL_non(i) = FN_test_non(idxmin, 1);

                
                
                
                
                
                
                
                
                
                
                [~, idxMaxX_non] = findpeaks(obj.solveT_IRC.X_non(:,3));
                idx_non = 1;
                for j = 2 : length(idxMaxX_non)

                    for k = 1 : j - 1;
                        pX_non = log(abs(obj.solveT_IRC.X_non(idxMaxX_non(k),3)/obj.solveT_IRC.X_non(idxMaxX_non(j),3)))/(j-k);
                        ZT_test_non(idx_non, 1) = pX_non/sqrt(4*pi^2 + pX_non^2);
                        ZT_test_non(idx_non, 2) = abs(obj.ZT_CAL_non(i - 1) - ZT_test_non(idx_non, 1));
                        idx_non = idx_non + 1;
                    end

                end
                [res, idxmin] = min(ZT_test_non(:,2));
                obj.ZT_CAL_non(i) = ZT_test_non(idxmin, 1);







                [~, idxMaxX_lin] = findpeaks(obj.solveT_IRC.X_lin(:,3));
                idx_lin = 1;
                for j = 2 : length(idxMaxX_lin)

                    for k = 1 : j - 1;
                        pX_lin = log(abs(obj.solveT_IRC.X_lin(idxMaxX_lin(k),3)/obj.solveT_IRC.X_lin(idxMaxX_lin(j),3)))/(j-k);
                        ZT_test_lin(idx_lin, 1) = pX_lin/sqrt(4*pi^2 + pX_lin^2);
                        ZT_test_lin(idx_lin, 2) = abs(obj.ZT_CAL_lin(i - 1) - ZT_test_lin(idx_lin, 1));
                        idx_lin = idx_lin + 1;
                    end

                end
                [res, idxmin] = min(ZT_test_lin(:,2));
                obj.ZT_CAL_lin(i) = ZT_test_lin(idxmin, 1);
                
            end
            
            
            
        end
    end
    
end

