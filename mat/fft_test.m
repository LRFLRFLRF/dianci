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
Fs = 48*5;            % 采样频率   单位：次/天    6min一个点那一天24h 就是每天48*5的采样频率                 
T = 1/Fs;             % Sampling period       
n = length(data_yuan);             % Length of signal

data = data_yuan - mean(data_yuan);   %去除直流分量
Y = fft(data, n);


%% 绘图
% Y乘Y共轭=a方加b方   复数Y = a + ib
Pyy = Y.*conj(Y)/n;
%频率序列f  其中（0：n/x）的x控制plot显示频率范围      
f = Fs/n*(0:n/12);
plot(f,Pyy(1:n/12+1))
title('频谱强度')
set(gca,'XTick',[0:1:20]);%设置要显示坐标刻度
xlabel('频率 (次/天)')

%% IFFT反变换
Y1 = Y';
Y1(100:end) = 0;
yifft = ifft(Y1');
y_ifft = real(yifft);
plot(y_ifft + mean(data_yuan))

