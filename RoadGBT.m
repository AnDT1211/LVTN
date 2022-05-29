classdef RoadGBT < handle
    %ROADGBT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        d2;
        d1;
        v;
        roadtype;
    end
    
    methods
%         function obj = RoadGBT(d2, d1, v, roadtype)
%             obj.d2 = d2;
%             obj.d1 = d1;
%             obj.v = v;
%             obj.roadtype = roadtype;
%         end
        function obj = RoadGBT(init_roadGBT)
            obj.d2 = init_roadGBT.d2;
            obj.d1 = init_roadGBT.d1;
            obj.v = init_roadGBT.v;
            obj.roadtype = init_roadGBT.roadtype;
            
        end
        
        function y = dis_t(obj,t)
            y = 2*obj.d2/obj.d1*obj.v.*t.*(t <= obj.d1/(2*obj.v)) ...
                + (2*obj.d2 - 2*obj.d2/obj.d1*obj.v.*t).*(t > obj.d1/(2*obj.v) & t <= obj.d1/(obj.v));
        end
%         function Plotitng_t(obj, t)
%             close all;
%             Y = dis_t(obj,t);
%             figure(1)
%             plot(t, Y);
%             grid on
%             grid minor
%             tit = strcat('Road Displacement - ', obj.roadtype);
%             title(tit);
%             xlabel('Time [s]');
%             ylabel('Displacement [m]');
%         end
%         function Plotitng_s(obj, t)
%             close all;
%             figure(1)
%             Y = dis_t(obj,t);
%             plot(t*obj.v, Y);
%             grid on
%             grid minor
%             tit = strcat('Road Displacement - ', obj.roadtype);
%             title(tit);
%             xlabel('Displacement [m]');
%             ylabel('Displacement [m]');
%             xlim([0 obj.d1]);
%         end
        
    end
end

