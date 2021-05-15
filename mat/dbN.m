%%%%%%%%%%%%%%%消失矩%%%%%%%%%%%%%%%%%%
clc;
clear;
load 106to114_oneDim.mat
signal = data_1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% f=100;     %%频率
% t=0.002;   %%抽样间隔
% n=1:100;
% signal=sin(f.*t.*n);  %%采取信号
figure(1)
plot(signal);
grid on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%下面我将采用三种消失矩来分解signal%%%%
N1=2;
N2=5;
N3=10;
%%%%%%%%%%%采用dwt函数%%%%%%%%%%%%%%%%%%
[L1,H1]=dwt(signal,'db2');
figure(2)
subplot(321)
plot(L1);
title('消失矩2的低频分量');
grid on;

subplot(322);
plot(H1);
title('消失矩2的高频分量');
grid on;

[L2,H2]=dwt(signal,'db5');
subplot(323)
plot(L2)
title('消失矩5的低频分量');
grid on;

subplot(324);
plot(H2);
title('消失矩5的高频分量');
grid on;

[L3,H3]=dwt(signal,'db10');
subplot(325)
plot(L3)
title('消失矩10的低频分量');
grid on;

subplot(326);
plot(H3);
title('消失矩10的高频分量');

grid on;

%%%%%%%%%%%%%%%%%%%%%