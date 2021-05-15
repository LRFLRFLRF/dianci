%%%%%%%%%%%%%%%��ʧ��%%%%%%%%%%%%%%%%%%
clc;
clear;
load 106to114_oneDim.mat
signal = data_1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% f=100;     %%Ƶ��
% t=0.002;   %%�������
% n=1:100;
% signal=sin(f.*t.*n);  %%��ȡ�ź�
figure(1)
plot(signal);
grid on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%�����ҽ�����������ʧ�����ֽ�signal%%%%
N1=2;
N2=5;
N3=10;
%%%%%%%%%%%����dwt����%%%%%%%%%%%%%%%%%%
[L1,H1]=dwt(signal,'db2');
figure(2)
subplot(321)
plot(L1);
title('��ʧ��2�ĵ�Ƶ����');
grid on;

subplot(322);
plot(H1);
title('��ʧ��2�ĸ�Ƶ����');
grid on;

[L2,H2]=dwt(signal,'db5');
subplot(323)
plot(L2)
title('��ʧ��5�ĵ�Ƶ����');
grid on;

subplot(324);
plot(H2);
title('��ʧ��5�ĸ�Ƶ����');
grid on;

[L3,H3]=dwt(signal,'db10');
subplot(325)
plot(L3)
title('��ʧ��10�ĵ�Ƶ����');
grid on;

subplot(326);
plot(H3);
title('��ʧ��10�ĸ�Ƶ����');

grid on;

%%%%%%%%%%%%%%%%%%%%%