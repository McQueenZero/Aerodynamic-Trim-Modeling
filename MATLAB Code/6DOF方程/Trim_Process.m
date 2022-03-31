function [x,fval,exitflag,output,lambda,grad,hessian] = Trim_Process(x0)
%% This is an auto generated MATLAB file from Optimization Tool.

%% Start with the default options
options = optimoptions('fmincon');
%% Modify options setting
options = optimoptions(options,'Display', 'off');
options = optimoptions(options,'PlotFcn', { @optimplotfval });
[x,fval,exitflag,output,lambda,grad,hessian] = ...
fmincon(@Trans_Trim_Objective,x0,[],[],[],[],[],[],@cons,options);
