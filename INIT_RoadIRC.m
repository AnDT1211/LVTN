classdef INIT_RoadIRC < handle
    %INIT__ROADGBT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        d2 = 0.1;
        d1 = 5;
        roadtype = 'IRC type';
    end
    
    properties
        init_params;
        v;
    end
    
    methods
        function obj = INIT_RoadIRC(init_params)
            obj.v = init_params.v;
            obj.init_params = init_params;
        end
    end
    
end

