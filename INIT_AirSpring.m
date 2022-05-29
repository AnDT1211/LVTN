classdef INIT_AirSpring < handle
    %INIT_AIRSPRING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Height = [3.5, 4, 5, 6, 7, 8, 9, 10, 11, 13]*0.0254;
        Force = [2100, 1800, 1700, 1400, 1200, 1200, 1150, 1100, 850, 60;      %20 PSI
                3600, 3400, 3100,  2700,  2500, 2600, 2400,2200, 1700, 460;     %40 PSI
                5100, 5000, 4600, 4000, 3800, 3900, 3600, 3200, 2700, 1100;    %60 PSI
                6700, 6600, 6100, 5400, 5200, 5300, 4900, 4300, 3600, 1800;    %80 PSI
                8300, 8200, 7600, 6700, 6500, 6600, 5800, 5500, 4600, 2300] * 4.44822162;
        PSI = [20; 40; 60; 80; 100];

        % INPUT
        Des_PSI = 70;
        Des_MASS = 2e3;
    end
    
    methods
    end
    
end

