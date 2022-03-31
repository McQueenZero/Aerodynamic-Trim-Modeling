%% 清空环境
clc,clear;
%% 三种配平方法评价
load 'Trim by PSO.txt';
load 'Trim by fmincon.txt';
load 'Trim by findop.txt';
% 计算配平目标函数值
for i = 1:9
    f1(i,1) = Trans_Trim_Objective(Trim_by_PSO(i,:));       % 粒子群算法
    f2(i,1) = Trans_Trim_Objective(Trim_by_fmincon(i,:));   % fmincon函数
    f3(i,1) = Trans_Trim_Objective(Trim_by_findop(i,:));    % findop方法
end
%% 比较并生成选择值矩阵F（0-1矩阵）
F = zeros (9,3);
for i = 1:9
    if f1(i,1) < f2(i,1)
        if f1(i,1) < f3(i,1)
            F(i,1) = 1;
        else
            F(i,3) = 1;
        end
    else
        if f2(i,1) < f3(i,1)
            F(i,2) = 1;
        else
            F(i,3) = 1;
        end
    end
end
%% 生成最终配平状态点
Final_Trim = zeros(9,11);
for i = 1:9
    if F(i,1) == 1
        Final_Trim(i,:) = Trim_by_PSO(i,:);
    end
    if F(i,2) == 1
        Final_Trim(i,:) = Trim_by_fmincon(i,:);
    end
    if F(i,3) == 1
        Final_Trim(i,:) = Trim_by_findop(i,:);
    end
end