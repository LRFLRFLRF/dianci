clc;
clear;

yuan_data_path = 'E:\Desktop\dianci\Python_code\mat\';  %106to114_oneDim 文件路径
yuan_data_name = '107to113_oneDim';

%% 加载原始波形
dat = load([yuan_data_path, yuan_data_name, '.mat']);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
data_yuan = getfield(dat, name);    %根据字段名读取数据

%% STFT
len = length(data_yuan);

%如果window为一个整数，x将被分成window长的段，每段使用Hamming窗函数加窗。
window = 10*24/2;    %窗口数量   

%它必须为一个小于window或length(window)的整数。
%其意思为两个相邻窗不是尾接着头的，而是两个窗有交集，有重叠的部分。
% 重叠为0，window等于10*24时，正好时间轴7格，一格代表一天   若重叠率为0.5  则时间轴14格
noverlap = window*0;    %每一段的重叠样本数,


f_len = 10;     %频率轴分几份
f = linspace(0, 1e10, f_len);   %第二参数为频率轴显示范围

%离散傅里叶点数
nfft = window;

%采样频率
fs = 10*24; %一天折合成1s   采样频率 10*24
[s, f, t] = spectrogram(data_yuan, window, noverlap, nfft, fs);
figure;
imagesc(t, f./(fs/2), 10*log10((abs(s)/len)));   %功率谱密度 20*log10((abs(s)))
xlabel('天数','FontSize',18); ylabel('归一化频率','FontSize',18);
colorbar;
colormap(jet);
ylabel(colorbar,'功率谱密度 [db/HZ]','FontSize',18);
title('综合电场强度序列功率谱密度图','FontSize',18)
