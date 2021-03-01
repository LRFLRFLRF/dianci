clc;
clear;

yuan_data_path = 'E:\Desktop\dianci\Python_code\mat\';  %106to114_oneDim �ļ�·��
yuan_data_name = '106to114';

%% ����ԭʼ����
dat = load([yuan_data_path, yuan_data_name, '.mat']);   
fieldname = fieldnames(dat);   %��ȡ�ֶ���
name = fieldname{1};
data_yuan = getfield(dat, name);    %�����ֶ�����ȡ����

%% fft�任
Fs = 48;            % Sampling frequency   ��λ��HZ                 
T = 1/Fs;             % Sampling period       
n = length(data_yuan);             % Length of signal

Y = fft(data_yuan);



%% ��ͼ
Pyy = Y.*conj(Y)/n;
f = Fs/n*(0:n/32);
plot(f,Pyy(1:n/32+1))
title('Power spectral density')
xlabel('Frequency (Hz)')




