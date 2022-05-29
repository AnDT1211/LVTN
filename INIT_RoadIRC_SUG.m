classdef INIT_RoadIRC_SUG < handle
    %INIT__ROADGBT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        d2 = 0.05;
        d1 = 1;
        roadtype = 'IRC Suggestion type';
    end
    
    properties
        init_params;
        v;
    end
    
    methods
        function obj = INIT_RoadIRC_SUG(init_params)
            obj.v = init_params.v;
            obj.init_params = init_params;
        end
    end
    
end

