classdef INIT_RoadGBT < handle
    %INIT__ROADGBT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        d2 = 0.04;
        d1 = 0.4;
        roadtype = 'GB/T';
    end
    
    properties
        init_params;
        v;
    end
    
    methods
        function obj = INIT_RoadGBT(init_params)
            obj.v = init_params.v;
            obj.init_params = init_params;
        end
    end
    
end

