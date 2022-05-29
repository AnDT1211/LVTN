classdef RoadIRC < handle
    %ROADIRC Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        d2;
        d1;
        v;
        roadtype;
    end
    
    methods
%         function obj = RoadIRC(d2, d1, v, roadtype)
%             obj.d2 = d2;
%             obj.d1 = d1;
%             obj.v = v;
%             obj.roadtype = roadtype;
%         end
        function obj = RoadIRC(init_roadGBT)
            obj.d2 = init_roadGBT.d2;
            obj.d1 = init_roadGBT.d1;
            obj.v = init_roadGBT.v;
            obj.roadtype = init_roadGBT.roadtype;
        end
        
        
        function y = dis_t(obj,t)
            y = obj.d2.*(sin(pi*obj.v.*t/obj.d1)).^2.*(t > 0 & t < obj.d1/obj.v);
        end
        
        function ddy = acc_t(obj, t)
            ddy = ((2*obj.d2*obj.v^2*pi^2.*cos((pi.*t*obj.v)/obj.d1).^2)./obj.d1.^2 ...
                - (2*obj.d2.*obj.v.^2.*pi^2.*sin((pi.*t.*obj.v)/obj.d1).^2)/obj.d1.^2).*(t > 0 & t < obj.d1/obj.v);
        end
        
        function Plotitng_t(obj, t)
            close all;
            figure(1)
            Y = dis_t(obj,t);
            plot(t, Y);
            grid on
            grid minor
            tit = strcat('Road Displacement - ', obj.roadtype);
            title(tit);
            xlabel('Time [s]');
            ylabel('Displacement [m]');
            
        end
        function Plotitng_s(obj, t, mau)
            close all;
            figure(1);
            Y = dis_t(obj,t);
            plot(t*obj.v, Y, mau);
            grid on
            grid minor
            tit = strcat('Road Displacement - ', obj.roadtype);
            title(tit);
            xlabel('Displacement [m]');
            ylabel('Displacement [m]');
            xlim([0 obj.d1]);
            
        end
        
    end
    
end

