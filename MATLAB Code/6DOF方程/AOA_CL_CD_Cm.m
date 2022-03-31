%% ��ջ���
clc,clear;
%% ����ӭ�����ȫ��ϵ��
load 'AOA_CL_CD_Cm.txt';
AOA = AOA_CL_CD_Cm(:,1);
CL = AOA_CL_CD_Cm(:,2);
CD = AOA_CL_CD_Cm(:,3);
Cm = AOA_CL_CD_Cm(:,4);
%% ������������ֵ����spline���в�ֵ���
d = 0.01;                                           %��ֵ���
x = -15:d:25;                                    
yL = spline(AOA,CL,x);                              %����������ֵ
yD = spline(AOA,CD,x);
ym = spline(AOA,Cm,x);
%% ��ͼ
plot(AOA,CL,'ro',x,yL,'r');hold on;
plot(AOA,CD,'go',x,yD,'g');hold on;
plot(AOA,Cm,'bo',x,ym,'b');hold on;
title('����ϵ��/����ϵ��/��������ϵ����ӭ�ǵı仯���');
%% ��ؼ�����
[yL0,ZLI] = min(abs(yL));                           %ZLI:Zero-lift AOA Index
alpha0 = x(ZLI);                                    %����ӭ��  
fprintf('����ӭ��alpha0:% .2f\n',alpha0);
[yLmax,CI] = max(yL);                               %CI:Critical AOA Index
alphaC = x(CI);                                     %�ٽ�ӭ��
fprintf('�ٽ�ӭ��alphaC:% .2f\n',alphaC);
CL0 = yL(find(~x));                                 %��ӭ������ϵ��
fprintf('��ӭ������ϵ��CL0:% .6f\n',CL0);
CD0 = yD(find(~x));                                 %��ӭ������ϵ��
fprintf('��ӭ������ϵ��CD0:% .6f\n',CD0);
Cm0 = ym(ZLI);                                      %��������ϵ��
fprintf('������������ϵ��Cm0:% .6f\n',Cm0);
%% �����Ի���Χ����������������������ϵ��������
yL_linear = yL(ZLI:CI-5/d);                         %����ϵ��-ӭ���������Բ��֣�����ӭ�����ٽ�ӭ��-5�㣩
CLalpha = mean(diff(yL_linear)/d);                  %����ϵ����ӭ�Ǳ仯�ĵ���
fprintf('����ϵ����ӭ�Ǳ仯�ĵ���CLalpha:% .6f\n',CLalpha);
yD_linear = yD(ZLI:CI-5/d);                         %����ϵ��-ӭ���������Բ��֣�����ӭ�����ٽ�ӭ��-5�㣩
CDalpha = mean(diff(yD_linear)/d);                  %����ϵ����ӭ�Ǳ仯�ĵ���
fprintf('����ϵ����ӭ�Ǳ仯�ĵ���CDalpha:% .6f\n',CDalpha);
ym_linear = ym(ZLI:CI-5/d);                         %��������ϵ��-ӭ���������Բ��֣�����ӭ�����ٽ�ӭ��-5�㣩
Cmalpha = mean(diff(ym_linear)/d);                  %����ϵ����ӭ�Ǳ仯�ĵ���
fprintf('��������ϵ����ӭ�Ǳ仯�ĵ���Cmalpha:% .6f\n',Cmalpha);
%% ���ظ�������������������ϵ�����Ա�Simulinkģ��ʹ��
CYbeta = -0.00668;  Cnbeta = 0.00104;   Clbeta = -0.00072;
CLdelta_e = 0.00656;    CDdelta_e = 0.00036;    Cmdelta_e = -0.01684;
CYdelta_r = 0.00484;    Cndelta_r = -0.00122;   Cldelta_r = -0.00008;
CYdelta_a = 0.00018;    Cndelta_a = 0.00034;    Cldelta_a = -0.00393;
Cmqbar = -7.58;     Cmalphadot = -1.64;
Cnr = -0.04;    Clp = -0.62;    Clr = -0.01;    Cnp = 0.004;
Ix = 1.986;    Iy = 3.447;    Iz = 5.392;    Ixy = 0;    Ixz = 0.011;    Iyz = 0;
%% Simulinkģ�ͷ��桢���Ի���ƽ�����������
h = 1000;     V = [25, 0, 0];         
t = 10;     Beta = eps;     delta_r = eps;     delta_a = eps;
T = 31.682558;      Alpha = 0.986199;    delta_e = 	-2.662714;
      

