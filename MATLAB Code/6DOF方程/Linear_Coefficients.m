%% 清空环境
clc,clear;
%% 加载工作点数据、飞机结构参数 
load 'Operating Point'.txt;
h0 = Operating_Point(:,1);     %高度h
V0 = Operating_Point(:,2);     %速度V
% 定义全局变量
global m Sw cA b g zt G L0 M0 CDM  CLM CmM TV
m = 25; Sw = 0.8;   cA = 0.26881; b = 3; g = 9.80665;   zt = 0; 
T_delta_t = 0;
% 在基准运动和小扰动情况下，有T0 = D0、L0 = G，M0 = 0，有：
G = m * g;  L0 = G; M0 = 0;
% 低速飞行，各系数不随马赫数变化，有：
CDM = 0;    CLM = 0;    CmM = 0;    TV = 0;
%% 计算每个工作点的大导数
Longi = zeros(3,6,9);           % 纵向
Lati = zeros(3,5,9);            % 横侧向
for i = 1:9
    Longi(:, :, i) = [fX_V(V0(i), fQ(h0(i), V0(i))) fX_alpha(V0(i), fQ(h0(i), V0(i))) fX(V0(i)) fX_delta_t(T_delta_t, V0(i)) eps eps; ...
                      fZ_V(V0(i), fQ(h0(i), V0(i))) fZ_alpha(V0(i), fQ(h0(i), V0(i))) fZ_delta_e(V0(i), fQ(h0(i), V0(i))) eps eps eps; ...
                      fM_V(V0(i), fQ(h0(i), V0(i))) fM_alpha(fQ(h0(i), V0(i))) fM_alphadot(V0(i), fQ(h0(i), V0(i))) ...
                      fM_q(V0(i), fQ(h0(i), V0(i))) fM_delta_e(V0(i), fQ(h0(i), V0(i))) fM_delta_t(T_delta_t)];
    Lati(:, :, i) = [fY_beta(V0(i), fQ(h0(i), V0(i))) fY_phi(V0(i)) fY_delta_r(V0(i), fQ(h0(i), V0(i))) eps eps; ...
                     fL_beta(fQ(h0(i), V0(i))) fL_p(V0(i), fQ(h0(i), V0(i))) fL_r(V0(i), fQ(h0(i), V0(i))) ...
                     fL_delta_a(fQ(h0(i), V0(i))) fL_delta_r(fQ(h0(i), V0(i))); ...
                     fN_beta(fQ(h0(i), V0(i))) fN_r(V0(i), fQ(h0(i), V0(i))) fN_p(V0(i), fQ(h0(i), V0(i))) ...
                     fN_delta_a(fQ(h0(i), V0(i))) fN_delta_r(fQ(h0(i), V0(i)))];
end
%% 以表格形式输出
LongiCo = zeros(9, 13);
LatiCo = zeros(9, 13);
for k = 1:9
    %每个工作点的纵向线性化方程大导数
    for j = 1:4
        LongiCo(k, j) = Longi(1, j, k);
    end
    for j = 1:3
        LongiCo(k, j+4) = Longi(2, j, k);
    end
    for j = 1:6
        LongiCo(k, j+7) = Longi(3, j, k);
    end
    %每个工作点的横侧向线性化方程大导数
    for j =1:3
        LatiCo(k, j) = Lati(1, j, k);
    end
    for j =1:5
        LatiCo(k, j+3) = Lati(2, j, k);
    end
    for j =1:5
        LatiCo(k, j+8) = Lati(3, j, k);
    end
end
TransLongiCo = LongiCo';
TransLatiCo = LatiCo';
%% 大导数计算公式
function X_V = fX_V(V0, Q)
global m Sw M0 CDM TV
CD0 = 0.051832;
X_V = 1 / (m * V0) * (Q * Sw * (2*CD0 + M0 * CDM) - V0 * TV);
end

function X_alpha = fX_alpha(V0, Q)
global m Sw G 
CDalpha = 0.006587;
X_alpha = 1 / (m * V0) * (CDalpha * Q * Sw - G);
end

function X_theta = fX(V0)
global g
X_theta = g / V0;
end

function X_delta_t = fX_delta_t(T_delta_t,V0)
global m 
X_delta_t = -T_delta_t / (m * V0);
end

function Z_V = fZ_V(V0, Q)
global m Sw M0 CLM 
CL0 = 0.647910;
Z_V = 1 / (m * V0) * Q * Sw * (2*CL0 + M0 * CLM);
end

function Z_alpha = fZ_alpha(V0, Q)
global m Sw 
CLalpha = 0.088485;
Z_alpha = 1 / (m * V0) * CLalpha * Q * Sw;
end

function Z_delta_e = fZ_delta_e(V0, Q)
global m Sw 
CLdelta_e = 0.00328;
Z_delta_e = 1 / (m * V0) * CLdelta_e * Q * Sw;
end

function M_V = fM_V(V0, Q)
global Sw cA zt M0 CmM TV
Cm0 = -0.036061;    Iy = 3.447;
M_V = -1 / Iy * (Q * cA * Sw * (2*Cm0 + M0 * CmM) + V0 * TV * zt); 
end

function M_alpha = fM_alpha(Q)
global  Sw cA 
Cmalpha = -0.008902;    Iy = 3.447;
M_alpha = -1 / Iy * Q * cA * Sw * Cmalpha;
end

function M_alphadot = fM_alphadot(V0, Q)
global Sw cA
Cmalpha = -0.008902;    Iy = 3.447;
M_alphadot = -1 / Iy * Q * cA^2 / (2*V0) * Sw * Cmalpha;
end

function M_q = fM_q(V0, Q)
global Sw cA
Cmqbar = -7.58;     Iy = 3.447;
M_q = -1 / Iy * Q * cA^2 / (2*V0) * Sw * Cmqbar;
end

function M_delta_e = fM_delta_e(V0, Q)
global Sw cA 
Cmdelta_e = -0.00842;   Iy = 3.447;
M_delta_e = -1 / Iy * Q * cA^2 / (2*V0) * Sw * Cmdelta_e;
end

function M_delta_t = fM_delta_t(T_delta_t)
global zt
Iy = 3.447;
M_delta_t = -T_delta_t * zt / Iy;
end

function Y_beta = fY_beta(V0, Q)
global m Sw 
CYbeta = -0.00668;
Y_beta = Q * Sw * CYbeta / (m * V0);
end

function Y_phi = fY_phi(V0)
global g
Y_phi = g / V0;
end

function Y_delta_r = fY_delta_r(V0, Q)
global m Sw 
CYdelta_r = 0.00242;
Y_delta_r = -Q * Sw * CYdelta_r / (m * V0);
end

function L_beta = fL_beta(Q)
global Sw b 
Clbeta = -0.00072;  Ix = 1.986;
L_beta = Q * Sw * b * Clbeta / Ix;
end

function L_p = fL_p(V0, Q)
global Sw b
Clp = -0.62;    Ix = 1.986;
L_p = Q * Sw * b^2 / (2*V0) * Clp / Ix;
end

function L_r = fL_r(V0, Q)
global Sw b
Clr = -0.01;    Ix = 1.986;
L_r = Q * Sw * b^2 / (2*V0) * Clr / Ix;
end

function L_delta_a = fL_delta_a(Q)
global Sw 
CYdelta_a = 0.00018;    Ix = 1.986;
L_delta_a = Q * Sw * CYdelta_a / Ix;
end

function L_delta_r = fL_delta_r(Q)
global Sw 
CYdelta_r = 0.00242;    Ix = 1.986;
L_delta_r = Q * Sw * CYdelta_r / Ix;
end

function N_beta = fN_beta(Q)
global Sw 
Cnbeta = 0.00104;   Iz = 5.392;
N_beta = Q * Sw * Cnbeta / Iz;
end

function N_r = fN_r(V0, Q)
global Sw b
Cnr = -0.04;    Iz = 5.392;	
N_r = Q * Sw * b^2 / (2*V0) * Cnr / Iz;
end

function N_p = fN_p(V0, Q)
global Sw b
Cnp = 0.004;    Iz = 5.392;
N_p = Q * Sw * b^2 / (2*V0) * Cnp / Iz;
end

function N_delta_a = fN_delta_a(Q)
global Sw
Cndelta_a = 0.00034;    Iz = 5.392;
N_delta_a = Q * Sw * Cndelta_a / Iz;
end

function N_delta_r = fN_delta_r(Q)
global Sw
Cndelta_r = -0.00061;   Iz = 5.392;
N_delta_r = Q * Sw * Cndelta_r / Iz;
end
