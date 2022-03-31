%% ��ջ���
clc,clear;
%% ���ø߶�ֵ���ٶ�ֵ��������ʼ��
global h V
h = 5000;      V = 75;
x0 = [V, 0, 0, 0, 0, 0, 0, 0, 0, 0, h];
Trim_Result = Trim_by_fmincon(x0);
disp('����ȡֵ��');
fprintf('%.6f\t',Trim_Result);
%% ����MATLAB����fmincon�Ż�������Ĭ������
function [x,fval,exitflag,output,lambda,grad,hessian] = Trim_by_fmincon(x0)
options = optimoptions('fmincon');
% ��ƽֵ��������ͼʾ
options = optimoptions(options,'Display', 'off');
options = optimoptions(options,'PlotFcn', { @optimplotfval });
[x,fval,exitflag,output,lambda,grad,hessian] = ...
fmincon(@Trans_Trim_Objective,x0,[],[],[],[],[],[],@cons,options);
end