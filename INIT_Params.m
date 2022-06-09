classdef INIT_Params < handle
    %INIT_PARAMS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        v = 10/3.6;
        t = linspace(0,3,1e4);
        vLin = linspace(0,100,1.5e2);
    end
    
    properties
        cs = 9e3;
        ku = 870000;
        mu_non = 200;
        mu_lin = 250;
    end
    
    methods
    end
    
end

