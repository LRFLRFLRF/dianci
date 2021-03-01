clc;
clear;

yuan_data_path = 'E:\Desktop\dianci\Python_code\mat\';  %106to114_oneDim 文件路径
yuan_data_name = '106to114_oneDim';

%% 加载原始波形
dat = load([yuan_data_path, yuan_data_name, '.mat']);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
data_yuan = getfield(dat, name);    %根据字段名读取数据



%% fft变换
Fs = 48;            % Sampling frequency   单位：HZ                 
T = 1/Fs;             % Sampling period       
n = length(data_yuan);             % Length of signal

mean(data_yuan)
data = data_yuan - mean(data_yuan);   %去除直流分量
Y = fft(data);


%% 绘图
Pyy = Y.*conj(Y)/n;
f = Fs/n*(0:n/16);
plot(f,Pyy(1:n/16+1))
title('Power spectral density')
xlabel('Frequency (Hz)')




