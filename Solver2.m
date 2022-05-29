classdef Solver2 < handle
    %SOLVER2 Summary of this class goes here
    %   Detailed explanation goes here
    properties
        Vlin;
        road;
    end
    properties
        FirstT;
        
        FirstV;
    end
    
    
    methods
        function obj = Solver2(init, road, airspring, t, Vlin, v)
            obj.Vlin = Vlin;
            obj.road = road;
            obj.FirstT = SolverT(init, road, airspring, t, v);
            obj.FirstT.SolvingTimeResponse(road.v);
            
            obj.FirstV = SolverV(obj.FirstT, Vlin);
            obj.FirstV.SolvingFreqResponse();
        end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    end
    
end

