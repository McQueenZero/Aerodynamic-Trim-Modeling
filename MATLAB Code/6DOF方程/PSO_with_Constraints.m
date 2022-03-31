%% ��ջ���
clc;clear;
%% Ŀ�꺯��
%    TOBJ = Trans_Trim_Objective(x) 
%    nvars = 11
%    Լ������Ϊ��
%    x(2) >= 0;            ��������0
%    x(3) < 16.35;         ӭ��С���ٽ�ӭ��
%    |x(4)| < 25;          ������ƫ��С��25�� 
%    x(1) = V;            �����ٶ�V
%    x(11) = h;           ���и߶�h
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
epsilon = eps;                %��ʽԼ���ݲ�
fun = @Trans_Trim_Objective;
cons1 = @(X)(c1*X>=0);
cons2 = @(X)(c2*X<16.35);
cons3 = @(X)(abs(c3*X)<25);
cons4 = @(X)(abs(ceq1*X-V)<=epsilon);
cons5 = @(X)(abs(ceq2*X-h)<=epsilon*h/10); %V,h������ͬ���ݲ���ת��ϵ��
cons6 = @(X)(abs(ceq3*X)<=epsilon);
cons7 = @(X)(abs(ceq4*X)<=epsilon);
cons8 = @(X)(abs(ceq5*X)<=epsilon);
cons9 = @(X)(abs(ceq6*X)<=epsilon);
cons10 = @(X)(abs(ceq7*X)<=epsilon);
cons11 = @(X)(abs(ceq8*X)<=epsilon);
%% ������Ⱥ����
sizepop = 500;                         % ��ʼ��Ⱥ����
dim = 11;                           % �ռ�ά��/��nvars�ı�
ger = 500;                       % ����������    (���鷶Χ50~1000)
xlimit_max = 100*ones(dim,1);     % ����λ�ò�������
xlimit_min = -100*ones(dim,1);
vlimit_max = 1*ones(dim,1);      % �����ٶ�����
vlimit_min = -1*ones(dim,1);
c_1 = 0.5;                       % ��ʼ����Ȩ��
c_2 = 2;                       % ����ѧϰ����
c_3 = 2;                       % Ⱥ��ѧϰ���� 
PV = 10^10;                      % ԭʼ�ͷ�ֵ
%% ���ɳ�ʼ��Ⱥ
%  ����������ɳ�ʼ��Ⱥλ��
%  Ȼ��������ɳ�ʼ��Ⱥ�ٶ�
%  Ȼ���ʼ��������ʷ���λ�ã��Լ�������ʷ�����Ӧ��
%  Ȼ���ʼ��Ⱥ����ʷ���λ�ã��Լ�Ⱥ����ʷ�����Ӧ��
for i=1:dim
    for j=1:sizepop
        pop_x(i,j) = xlimit_min(i)+(xlimit_max(i) - xlimit_min(i))*rand;  % ��ʼ��Ⱥ��λ��
        pop_v(i,j) = vlimit_min(i)+(vlimit_max(i) - vlimit_min(i))*rand;  % ��ʼ��Ⱥ���ٶ�
        pop_x(1,j) = V;                                                   % ǿ���趨��ʼ��Ⱥ��λ��
        pop_x(11,j) = h;                                                  % �ֱ��ӦV, delta_e, delta_r, 
        pop_x(5,j) = 0;                                                   % pbar, qbar, rbar, alphadot, h
        pop_x(6,j) = 0;
        pop_x(7,j) = 0;                                                     
        pop_x(8,j) = 0;
        pop_x(9,j) = 0;
        pop_x(10,j) = 0;
    end
end                 
pbest = pop_x;                                % ÿ���������ʷ���λ��
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
                                                fitness_pbest(j) = fun(pop_x(:,j));     % ÿ���������ʷ�����Ӧ��
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
% ��ʼ����Ⱥʱʵ�ʳͷ�ֵ��С���ﵽ���������ռ��Ŀ��
gbest = pop_x(:,1);                           % ��Ⱥ����ʷ���λ��
fitness_gbest = fitness_pbest(1);             % ��Ⱥ����ʷ�����Ӧ��
for j=1:sizepop
    if fitness_pbest(j) < fitness_gbest       % �������Сֵ����Ϊ<; ��������ֵ����Ϊ>; 
        gbest = pop_x(:,j);
        fitness_gbest=fitness_pbest(j);
    end
end
 
 
%% ����Ⱥ����
%    �����ٶȲ����ٶȽ��б߽紦��    
%    ����λ�ò���λ�ý��б߽紦��
%    ��������Ӧ����
%    ����Լ�������жϲ���������Ⱥ��������λ�õ���Ӧ��
%    ����Ӧ���������ʷ�����Ӧ�����Ƚ�
%    ������ʷ�����Ӧ������Ⱥ��ʷ�����Ӧ�����Ƚ�
%    �ٴ�ѭ�������
 
iter = 1;                        %��������
record = zeros(ger, 1);          % ��¼��
while iter <= ger
    for j=1:sizepop
        %    �����ٶȲ����ٶȽ��б߽紦��
        %    ����Ȩ�����ӵ������Ժ�����ʹ֮������������Ӷ���С
        pop_v(:,j)= c_1*(-1/ger*iter+1) * pop_v(:,j) + c_2*rand*(pbest(:,j)-pop_x(:,j))+c_3*rand*(gbest-pop_x(:,j));% �ٶȸ���
        for i=2:dim-1
            if  pop_v(i,j) > vlimit_max(i)
                pop_v(i,j) = vlimit_max(i);
            end
            if  pop_v(i,j) < vlimit_min(i)
                pop_v(i,j) = vlimit_min(i);
            end
        end
        
        %    ����λ�ò���λ�ý��б߽紦��
        pop_x(:,j) = pop_x(:,j) + pop_v(:,j);% λ�ø���
        for i=2:dim-7                                   %��������Ⱥ��1��Ԫ�أ���5-11��Ԫ�ص�ֵ
            if  pop_x(i,j) > xlimit_max(i)
                pop_x(i,j) = xlimit_max(i);
            end
            if  pop_x(i,j) < xlimit_min(i)
                pop_x(i,j) = xlimit_min(i);
            end
        end
        
        %    ��������Ӧ����
        if rand > 0.85
            i=ceil(dim*rand);
            if i > 1
                if i < 5                                %��������Ⱥ��1��Ԫ�أ���5-11��Ԫ�ص�ֵ
                    pop_x(i,j)=xlimit_min(i) + (xlimit_max(i) - xlimit_min(i)) * rand;
                end
            end
        end
  
        %    ����Լ�������жϲ���������Ⱥ��������λ�õ���Ӧ��
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
                                                    fitness_pop(j) = fun(pop_x(:,j));   % ��ǰ�������Ӧ��
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
        % ������Ӧֵ�����任��
        % ����ʱ�ͷ�ϵ��������Sigmoid�������൱��ʵ�ʳͷ�ֵ���Ŵ������������
        % ������ʼʱ��ʵ�ʳͷ�ֵС�����ƾ���������������Χ��
        % ��������ʱ��ʵ�ʳͷ�ֵ�󣬹����������ӿ������ٶȡ�
        
        %    ����Ӧ���������ʷ�����Ӧ�����Ƚ�
        if fitness_pop(j) < fitness_pbest(j)       % �������Сֵ����Ϊ<; ��������ֵ����Ϊ>; 
            pbest(:,j) = pop_x(:,j);               % ���¸�����ʷ���λ��            
            fitness_pbest(j) = fitness_pop(j);     % ���¸�����ʷ�����Ӧ��
        end   
        
        %    ������ʷ�����Ӧ������Ⱥ��ʷ�����Ӧ�����Ƚ�
        if fitness_pbest(j) < fitness_gbest        % �������Сֵ����Ϊ<; ��������ֵ����Ϊ>; 
            gbest = pbest(:,j);                    % ����Ⱥ����ʷ���λ��  
            fitness_gbest=fitness_pbest(j);        % ����Ⱥ����ʷ�����Ӧ��  
        end    
    end
    
    record(iter) = fitness_gbest;%���ֵ��¼
    
    iter = iter+1;
 
end
%% ����������
 
plot(record);title('��������');
disp(['����ֵ��',num2str(fitness_gbest)]);
disp('����ȡֵ��');
fprintf('%.6f\t',gbest);