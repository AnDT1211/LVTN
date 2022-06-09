clc; clear; close all;


thang = 12;
nam = 10;
tk = 0.5;
luongkhoidiem = 10;
tangluong = 2;


luong = luongkhoidiem;

tongtietkiem = 0;
for i = 1 : nam
    tongtietkiem = tongtietkiem + luong*thang*tk;
    
    luong = luong + tangluong
end

tongtietkiem














