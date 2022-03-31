%% 清空环境
clc;clear;
%% 目标函数
%    TOBJ = Trans_Trim_Objective(x) 
%    nvars = 11
%    约束条件为：
%    x(2) >= 0;            推力大于0
%    x(3) < 16.35;         迎角小于临界迎角
%    |x(4)| < 25;          升降舵偏度小于25° 
%    x(1) = V;            飞行速度V
%    x(11) = h;           飞行高度h
%    x(5~10) = 0;          delta_r=delta_a=pbar=qbar=rbar=alphadot=0        
h = 5000;         V = 25;
c1 = [0,1,0,0,0,0,0,0,0,0,0];
c2 = [0,0,1,0,0,0,0,0,0,0,0];
c3 = [0,0,0,1,0,0,0,0,0,0,0];
ceq1 = [1,0,0,0,0,0,0,0,0,0,0];
ceq2 = [0,0,0,0,0,0,0,0,0,0,1];
ceq3 = [0,0,0,0,1,0,0,0,0,0,0];
ceq4 = [0,0,0,0,0,1,0,0,0,0,0];
ceq5 = [0,0,0,0,0,0,1,0,0,0,0];
ceq6 = [0,0,0,0,0,0,0,1,0,0,0];
ceq7 = [0,0,0,0,0,0,0,0,1,0,0];
ceq8 = [0,0,0,0,0,0,0,0,0,1,0];
epsilon = eps;                %等式约束容差
fun = @Trans_Trim_Objective;
cons1 = @(X)(c1*X>=0);
cons2 = @(X)(c2*X<16.35);
cons3 = @(X)(abs(c3*X)<25);
cons4 = @(X)(abs(ceq1*X-V)<=epsilon);
cons5 = @(X)(abs(ceq2*X-h)<=epsilon*h/10); %V,h量级不同，容差有转换系数
cons6 = @(X)(abs(ceq3*X)<=epsilon);
cons7 = @(X)(abs(ceq4*X)<=epsilon);
cons8 = @(X)(abs(ceq5*X)<=epsilon);
cons9 = @(X)(abs(ceq6*X)<=epsilon);
cons10 = @(X)(abs(ceq7*X)<=epsilon);
cons11 = @(X)(abs(ceq8*X)<=epsilon);
%% 设置种群参数
sizepop = 500;                         % 初始种群个数
dim = 11;                           % 空间维数/随nvars改变
ger = 500;                       % 最大迭代次数    (建议范围50~1000)
xlimit_max = 100*ones(dim,1);     % 设置位置参数限制
xlimit_min = -100*ones(dim,1);
vlimit_max = 1*ones(dim,1);      % 设置速度限制
vlimit_min = -1*ones(dim,1);
c_1 = 0.5;                       % 初始惯性权重
c_2 = 2;                       % 自我学习因子
c_3 = 2;                       % 群体学习因子 
PV = 10^10;                      % 原始惩罚值
%% 生成初始种群
%  首先随机生成初始种群位置
%  然后随机生成初始种群速度
%  然后初始化个体历史最佳位置，以及个体历史最佳适应度
%  然后初始化群体历史最佳位置，以及群体历史最佳适应度
for i=1:dim
    for j=1:sizepop
        pop_x(i,j) = xlimit_min(i)+(xlimit_max(i) - xlimit_min(i))*rand;  % 初始种群的位置
        pop_v(i,j) = vlimit_min(i)+(vlimit_max(i) - vlimit_min(i))*rand;  % 初始种群的速度
        pop_x(1,j) = V;                                                   % 强制设定初始种群的位置
        pop_x(11,j) = h;                                                  % 分别对应V, delta_e, delta_r, 
        pop_x(5,j) = 0;                                                   % pbar, qbar, rbar, alphadot, h
        pop_x(6,j) = 0;
        pop_x(7,j) = 0;                                                     
        pop_x(8,j) = 0;
        pop_x(9,j) = 0;
        pop_x(10,j) = 0;
    end
end                 
pbest = pop_x;                                % 每个个体的历史最佳位置
for j=1:sizepop
    if cons1(pop_x(:,j))
        if cons2(pop_x(:,j))
            if cons3(pop_x(:,j))
                if cons4(pop_x(:,j))
                    if cons5(pop_x(:,j))
                        if cons6(pop_x(:,j))
                            if cons7(pop_x(:,j))
                                if cons8(pop_x(:,j))
                                    if cons9(pop_x(:,j))
                                        if cons10(pop_x(:,j))
                                            if cons11(pop_x(:,j))
                                                fitness_pbest(j) = fun(pop_x(:,j));     % 每个个体的历史最佳适应度
                                            else
                                                fitness_pbest(j) = PV/10^6;
                                            end
                                        else
                                            fitness_pbest(j) = PV/10^6;
                                        end
                                    else
                                        fitness_pbest(j) = PV/10^6;
                                    end
                                    
                                else
                                    fitness_pbest(j) = PV/10^6;
                                end
                            else
                                fitness_pbest(j) = PV/10^6;
                            end
                        else
                            fitness_pbest(j) = PV/10^6;
                        end
                    else
                        fitness_pbest(j) = PV/10^6;
                    end
                else
                    fitness_pbest(j) = PV/10^6;
                end
            else
                fitness_pbest(j) = PV/10^6;
            end
        else
            fitness_pbest(j) = PV/10^6;
        end
    else
        fitness_pbest(j) = PV/10^6;
    end
end
% 初始化种群时实际惩罚值较小，达到扩大搜索空间的目的
gbest = pop_x(:,1);                           % 种群的历史最佳位置
fitness_gbest = fitness_pbest(1);             % 种群的历史最佳适应度
for j=1:sizepop
    if fitness_pbest(j) < fitness_gbest       % 如果求最小值，则为<; 如果求最大值，则为>; 
        gbest = pop_x(:,j);
        fitness_gbest=fitness_pbest(j);
    end
end
 
 
%% 粒子群迭代
%    更新速度并对速度进行边界处理    
%    更新位置并对位置进行边界处理
%    进行自适应变异
%    进行约束条件判断并计算新种群各个个体位置的适应度
%    新适应度与个体历史最佳适应度做比较
%    个体历史最佳适应度与种群历史最佳适应度做比较
%    再次循环或结束
 
iter = 1;                        %迭代次数
record = zeros(ger, 1);          % 记录器
while iter <= ger
    for j=1:sizepop
        %    更新速度并对速度进行边界处理
        %    惯性权重因子叠加线性函数，使之随迭代次数增加而减小
        pop_v(:,j)= c_1*(-1/ger*iter+1) * pop_v(:,j) + c_2*rand*(pbest(:,j)-pop_x(:,j))+c_3*rand*(gbest-pop_x(:,j));% 速度更新
        for i=2:dim-1
            if  pop_v(i,j) > vlimit_max(i)
                pop_v(i,j) = vlimit_max(i);
            end
            if  pop_v(i,j) < vlimit_min(i)
                pop_v(i,j) = vlimit_min(i);
            end
        end
        
        %    更新位置并对位置进行边界处理
        pop_x(:,j) = pop_x(:,j) + pop_v(:,j);% 位置更新
        for i=2:dim-7                                   %不更新种群第1个元素，第5-11个元素的值
            if  pop_x(i,j) > xlimit_max(i)
                pop_x(i,j) = xlimit_max(i);
            end
            if  pop_x(i,j) < xlimit_min(i)
                pop_x(i,j) = xlimit_min(i);
            end
        end
        
        %    进行自适应变异
        if rand > 0.85
            i=ceil(dim*rand);
            if i > 1
                if i < 5                                %不变异种群第1个元素，第5-11个元素的值
                    pop_x(i,j)=xlimit_min(i) + (xlimit_max(i) - xlimit_min(i)) * rand;
                end
            end
        end
  
        %    进行约束条件判断并计算新种群各个个体位置的适应度
        if cons1(pop_x(:,j))
            if cons2(pop_x(:,j))
                if cons3(pop_x(:,j))
                    if cons4(pop_x(:,j))
                        if cons5(pop_x(:,j))
                            if cons6(pop_x(:,j))
                                if cons7(pop_x(:,j))
                                    if cons8(pop_x(:,j))
                                        if cons9(pop_x(:,j))
                                            if cons10(pop_x(:,j))
                                                if cons11(pop_x(:,j))
                                                    fitness_pop(j) = fun(pop_x(:,j));   % 当前个体的适应度
                                                else
                                                    fitness_pop(j) = PV/(1+1.05^(-iter+ger/3));
                                                end
                                            else
                                                fitness_pop(j) = PV/(1+1.05^(-iter+ger/3));
                                            end
                                        else
                                            fitness_pop(j) = PV/(1+1.05^(-iter+ger/3));
                                        end
                                        
                                    else
                                        fitness_pop(j) = PV/(1+1.05^(-iter+ger/3));
                                    end
                                else
                                    fitness_pop(j) = PV/(1+1.05^(-iter+ger/3));
                                end
                            else
                                fitness_pop(j) = PV/(1+1.05^(-iter+ger/3));
                            end
                        else
                            fitness_pop(j) = PV/(1+1.05^(-iter+ger/3));
                        end
                    else
                        fitness_pop(j) = PV/(1+1.05^(-iter+ger/3));
                    end
                else
                    fitness_pop(j) = PV/(1+1.05^(-iter+ger/3));
                end
            else
                fitness_pop(j) = PV/(1+1.05^(-iter+ger/3));
            end
        else
            fitness_pop(j) = PV/(1+1.05^(-iter+ger/3));
        end
        % 进行适应值比例变换：
        % 迭代时惩罚系数叠加类Sigmoid函数，相当于实际惩罚值随着代际增大而增大。
        % 迭代开始时，实际惩罚值小，抑制竞争，扩大搜索范围；
        % 迭代后期时，实际惩罚值大，鼓励竞争，加快收敛速度。
        
        %    新适应度与个体历史最佳适应度做比较
        if fitness_pop(j) < fitness_pbest(j)       % 如果求最小值，则为<; 如果求最大值，则为>; 
            pbest(:,j) = pop_x(:,j);               % 更新个体历史最佳位置            
            fitness_pbest(j) = fitness_pop(j);     % 更新个体历史最佳适应度
        end   
        
        %    个体历史最佳适应度与种群历史最佳适应度做比较
        if fitness_pbest(j) < fitness_gbest        % 如果求最小值，则为<; 如果求最大值，则为>; 
            gbest = pbest(:,j);                    % 更新群体历史最佳位置  
            fitness_gbest=fitness_pbest(j);        % 更新群体历史最佳适应度  
        end    
    end
    
    record(iter) = fitness_gbest;%最大值记录
    
    iter = iter+1;
 
end
%% 迭代结果输出
 
plot(record);title('收敛过程');
disp(['最优值：',num2str(fitness_gbest)]);
disp('变量取值：');
fprintf('%.6f\t',gbest);