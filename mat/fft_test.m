clc;
clear;
load('F:\Desktop\j_signal.mat')
x=VarName3;
mean = mean(x(:));
x = x - mean;
N = size(x);
n = 0:1:N(1,1)-1;
figure(1);
Xk=fft(x,N);      % 傅立叶变换
subplot(311);
plot(n,x);hold on;
title('原信号');

subplot(312);
plot(n,abs(Xk));
title('FFT变换')


y1 = ifft(Xk(1:1730),N);

x1 = 1:N;
% w0 = 2*pi;
% w1 = 2*pi/15;
% y1 = zeros(1,length(x1));
% for i=1:1737
%     y1 = y1 + Xk(i)*1e-2*sin(w0/i*x1);
% end

%y1 = 1.14*sin(w0*x1)+1.06*sin(w1*x1);
subplot(311);
plot(x1,y1);hold on;