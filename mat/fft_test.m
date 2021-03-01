clc;
clear;

yuan_data_path = 'E:\Desktop\dianci\Python_code\mat\';  %106to114_oneDim �ļ�·��
yuan_data_name = '106to114_oneDim';

%% ����ԭʼ����
dat = load([yuan_data_path, yuan_data_name, '.mat']);   
fieldname = fieldnames(dat);   %��ȡ�ֶ���
name = fieldname{1};
data_yuan = getfield(dat, name);    %�����ֶ�����ȡ����



%% fft�任
Fs = 48;            % Sampling frequency   ��λ��HZ                 
T = 1/Fs;             % Sampling period       
n = length(data_yuan);             % Length of signal

mean(data_yuan)
data = data_yuan - mean(data_yuan);   %ȥ��ֱ������
Y = fft(data);


%% ��ͼ
Pyy = Y.*conj(Y)/n;
f = Fs/n*(0:n/16);
plot(f,Pyy(1:n/16+1))
title('Power spectral density')
xlabel('Frequency (Hz)')




