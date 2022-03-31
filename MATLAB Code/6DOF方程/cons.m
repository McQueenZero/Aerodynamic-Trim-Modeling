function [c,ceq] = cons(x)
global h V
c(1) = -x(2);                       %����T����0
c(2) = x(3) - 16.35;                %ӭ��AlphaС���ٽ�ӭ��
c(3) = x(4) - 25;                   %������ƫ��С��25��
c(4) = -(x(4) + 25);
epsilon = eps;                          %�������ݲ�epsilon
c(5) = x(5) - epsilon;                  %delta_r < epsilon
c(6) = -(x(5) + epsilon);
c(7) = x(6) - epsilon;                  %delta_a < epsilon
c(8) = -(x(6) + epsilon);
c(9) = x(7) - epsilon;                  %|pbar| < epsilon
c(10) = -(x(7) + epsilon);
c(11) = x(8) - epsilon;                  %|qbar| < epsilon
c(12) = -(x(8) + epsilon);
c(13) = x(9) - epsilon;                  %|rbar| < epsilon
c(14) = -(x(9) + epsilon);
c(15) = x(10) - epsilon;                 %|alphadot| < epsilon
c(16) = -(x(10) + epsilon);

ceq(1) = x(1) - V;                  %�ٶ�V
ceq(2) = x(11) - h;                 %�߶�h
