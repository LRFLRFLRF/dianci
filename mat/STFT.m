clc;
clear;

yuan_data_path = 'E:\Desktop\dianci\Python_code\mat\';  %106to114_oneDim 文件路径
yuan_data_name = '107to113_oneDim';

%% 加载原始波形
dat = load([yuan_data_path, yuan_data_name, '.mat']);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
data_yuan = getfield(dat, name);    %根据字段名读取数据

data = data_yuan - mean(data_yuan);   %去除直流分量

%% STFT
len = length(data);

%如果window为一个整数，x将被分成window长的段，每段使用Hamming窗函数加窗。
window = 10*24/3;    %窗口数量   

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


[s, f, t] = spectrogram(data, window, noverlap, nfft, fs);
figure('color','w');


%% 功率谱密度 db/hz
% imagesc(t, f./(fs/2), 10*log10(abs(s)/len));   %功率谱密度
% title('综合电场强度序列功率谱密度图','FontSize',18);
% xlabel('天数','FontSize',18); ylabel('归一化频率','FontSize',18);
% colorbar;
% ylabel(colorbar,'功率谱密度 [dB/HZ]','FontSize',18);
% colormap(jet);


%% 按全局峰值做幅度归一化
% imagesc(t, f./(fs/2), 10*log10(abs(s)/max(max(abs(s)))));   %频谱幅度归一化
% %surf(t, f./(fs/2), 10*log10(abs(s)/max(max(abs(s)))));
% title('综合电场强度序列频谱图','FontSize',18);
% xlabel('天数','FontSize',18); ylabel('归一化频率','FontSize',18);
% colorbar;
% ylabel(colorbar,'归一化频谱幅度 [dB]','FontSize',18);
% colormap(jet);

    
%% 按单日峰值做幅度归一化
max_col = repmat(max(abs(s),[],1), size(s,1), 1);
s_1 = abs(s)./max_col;
imagesc(t, f./(fs/2), 10*log10(s_1) );   %频谱幅度归一化
title('综合电场强度序列频谱图','FontSize',18);
xlabel('天数','FontSize',18); ylabel('归一化频率','FontSize',18);
colorbar;
ylabel(colorbar,'归一化频谱幅度 [dB]','FontSize',18);
colormap(jet);

%% 显示[上下午]标签文字
yLabels = {'0-8点', '8-16点', '16-24点'};  % 待添加的标签
lenlab = length(yLabels);
for i = 0 : length(yLabels)*7-1
    text(1/lenlab * i+0.05, 1-0.025, yLabels(mod(i,3)+1));   % 用文本的方式添加，位置可以自定义
end

% x轴位于上方
ax = gca;
ax.XAxisLocation = 'top';
set(gca, 'XGrid', 'on');% 显示网格
set(gca,'LineWid',1.5);  %网格线宽
set(gca, 'GridAlpha', 1);  % 设置透明度
%% 频率特征提取
norm_freq_mat = repmat(f./(fs/2), 1, size(s, 2));%归一化频率矩阵

%平均电场强度 MS
MS = [];
size(s, 2)
for i=1:size(s, 2)
    MS = [MS mean( data_yuan((i-1)*fs/3+1:i*fs/3) )];
end

%平均频率 MF
MF = mean(abs(s), 1);

%重心频率 FC
numer = sum(norm_freq_mat.*abs(s));
denomin = sum(abs(s));
FC = numer./denomin;
FC_mat = repmat(FC, size(s, 1), 1);%重心频率扩展矩阵

%均方频率MSF
numer = sum((norm_freq_mat.^2).*abs(s));
denomin = sum(abs(s));
MSF = numer./denomin;

%频率方差 VF
numer = sum(((norm_freq_mat - FC_mat).^2).*abs(s));
denomin = sum(abs(s));
VF = numer./denomin;

% 合并结果
result = [MF; 
    FC; 
    MSF; 
    VF];
%imagesc(result)
save('E:\Desktop\dianci\Python_code\mat\freq_feat.mat','result')

%% 指标显示
% 坐标轴下方显示 FC指标
text(-0.3, 1+0.05, 'FC:');  %显示指标名称
reshape_mat = reshape(FC, 3, 7);  %方便求每天FC最大值
[max1, loc_max] = max(reshape_mat,[],1);   %max  最大值  loc最大值位置
[min1, loc_min] = min(reshape_mat,[],1);   %min  最小值  loc最小值位置
for i = 1 : size(FC, 2)
    if mod(i-1, 3)+1 == loc_max(floor((i-1)/3)+1)
        % 每天的最大值时间段高亮显示
        text(1/lenlab * (i-1)+0.045, 1+0.05, num2str(FC(1, i),'%.3f'),'backgroundcolor', [255,64,0]./255 , 'edgecolor', 'white'); 
    elseif mod(i-1, 3)+1 == loc_min(floor((i-1)/3)+1)
        text(1/lenlab * (i-1)+0.045, 1+0.05, num2str(FC(1, i),'%.3f'),'backgroundcolor', [0,191,255]./255, 'edgecolor', 'white');     
    else
        text(1/lenlab * (i-1)+0.045, 1+0.05, num2str(FC(1, i),'%.3f'),'backgroundcolor', [154,254,46]./255, 'edgecolor', 'white');   % 用文本的方式添加
    end
end


% 坐标轴下方显示 MS指标
text(-0.3, 1+0.05*2, 'MS:');  %显示指标名称
reshape_mat = reshape(MS, 3, 7);  %方便求每天MS最大值
[max1, loc_max] = max(reshape_mat,[],1);   %max  最大值  loc最大值位置
[min1, loc_min] = min(reshape_mat,[],1);   %min  最小值  loc最小值位置
for i = 1 : size(MS, 2)
    if mod(i-1, 3)+1 == loc_max(floor((i-1)/3)+1)
        % 每天的最大值时间段高亮显示
        text(1/lenlab * (i-1)+0.045, 1+0.05*2, num2str(MS(1, i),'%.3f'),'backgroundcolor', [255,64,0]./255 , 'edgecolor', 'white'); 
    elseif mod(i-1, 3)+1 == loc_min(floor((i-1)/3)+1)
        text(1/lenlab * (i-1)+0.045, 1+0.05*2, num2str(MS(1, i),'%.3f'),'backgroundcolor', [0,191,255]./255, 'edgecolor', 'white');     
    else
        text(1/lenlab * (i-1)+0.045, 1+0.05*2, num2str(MS(1, i),'%.3f'),'backgroundcolor', [154,254,46]./255, 'edgecolor', 'white');   % 用文本的方式添加
    end
end


