%% 清空环境
clc,clear;
%% 加载迎角相关全机系数
load 'AOA_CL_CD_Cm.txt';
AOA = AOA_CL_CD_Cm(:,1);
CL = AOA_CL_CD_Cm(:,2);
CD = AOA_CL_CD_Cm(:,3);
Cm = AOA_CL_CD_Cm(:,4);
%% 用三次样条插值函数spline进行插值拟合
d = 0.01;                                           %插值间隔
x = -15:d:25;                                    
yL = spline(AOA,CL,x);                              %三次样条插值
yD = spline(AOA,CD,x);
ym = spline(AOA,Cm,x);
%% 绘图
plot(AOA,CL,'ro',x,yL,'r');hold on;
plot(AOA,CD,'go',x,yD,'g');hold on;
plot(AOA,Cm,'bo',x,ym,'b');hold on;
title('升力系数/阻力系数/俯仰力矩系数随迎角的变化情况');
%% 求关键参数
[yL0,ZLI] = min(abs(yL));                           %ZLI:Zero-lift AOA Index
alpha0 = x(ZLI);                                    %零升迎角  
fprintf('零升迎角alpha0:% .2f\n',alpha0);
[yLmax,CI] = max(yL);                               %CI:Critical AOA Index
alphaC = x(CI);                                     %临界迎角
fprintf('临界迎角alphaC:% .2f\n',alphaC);
CL0 = yL(find(~x));                                 %零迎角升力系数
fprintf('零迎角升力系数CL0:% .6f\n',CL0);
CD0 = yD(find(~x));                                 %零迎角阻力系数
fprintf('零迎角阻力系数CD0:% .6f\n',CD0);
Cm0 = ym(ZLI);                                      %零升力矩系数
fprintf('零升俯仰力矩系数Cm0:% .6f\n',Cm0);
%% 在线性化范围求纵向气动力、气动力矩系数静导数
yL_linear = yL(ZLI:CI-5/d);                         %升力系数-迎角曲线线性部分（零升迎角至临界迎角-5°）
CLalpha = mean(diff(yL_linear)/d);                  %升力系数随迎角变化的导数
fprintf('升力系数随迎角变化的导数CLalpha:% .6f\n',CLalpha);
yD_linear = yD(ZLI:CI-5/d);                         %阻力系数-迎角曲线线性部分（零升迎角至临界迎角-5°）
CDalpha = mean(diff(yD_linear)/d);                  %阻力系数随迎角变化的导数
fprintf('阻力系数随迎角变化的导数CDalpha:% .6f\n',CDalpha);
ym_linear = ym(ZLI:CI-5/d);                         %俯仰力矩系数-迎角曲线线性部分（零升迎角至临界迎角-5°）
Cmalpha = mean(diff(ym_linear)/d);                  %俯仰系数随迎角变化的导数
fprintf('俯仰力矩系数随迎角变化的导数Cmalpha:% .6f\n',Cmalpha);
%% 加载给定气动力、气动力矩系数，以便Simulink模型使用
CYbeta = -0.00668;  Cnbeta = 0.00104;   Clbeta = -0.00072;
CLdelta_e = 0.00656;    CDdelta_e = 0.00036;    Cmdelta_e = -0.01684;
CYdelta_r = 0.00484;    Cndelta_r = -0.00122;   Cldelta_r = -0.00008;
CYdelta_a = 0.00018;    Cndelta_a = 0.00034;    Cldelta_a = -0.00393;
Cmqbar = -7.58;     Cmalphadot = -1.64;
Cnr = -0.04;    Clp = -0.62;    Clr = -0.01;    Cnp = 0.004;
Ix = 1.986;    Iy = 3.447;    Iz = 5.392;    Ixy = 0;    Ixz = 0.011;    Iyz = 0;
%% Simulink模型仿真、线性化配平输入参数设置
h = 1000;     V = [25, 0, 0];         
t = 10;     Beta = eps;     delta_r = eps;     delta_a = eps;
T = 31.682558;      Alpha = 0.986199;    delta_e = 	-2.662714;
      

