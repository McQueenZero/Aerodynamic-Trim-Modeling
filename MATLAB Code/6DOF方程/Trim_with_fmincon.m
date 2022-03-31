%% 清空环境
clc,clear;
%% 设置高度值，速度值；设置起始点
global h V
h = 5000;      V = 75;
x0 = [V, 0, 0, 0, 0, 0, 0, 0, 0, 0, h];
Trim_Result = Trim_by_fmincon(x0);
disp('变量取值：');
fprintf('%.6f\t',Trim_Result);
%% 采用MATLAB内置fmincon优化函数，默认设置
function [x,fval,exitflag,output,lambda,grad,hessian] = Trim_by_fmincon(x0)
options = optimoptions('fmincon');
% 配平值输出与迭代图示
options = optimoptions(options,'Display', 'off');
options = optimoptions(options,'PlotFcn', { @optimplotfval });
[x,fval,exitflag,output,lambda,grad,hessian] = ...
fmincon(@Trans_Trim_Objective,x0,[],[],[],[],[],[],@cons,options);
end