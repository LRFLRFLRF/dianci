clc;
clear;

yuan_data_path = 'E:\Desktop\dianci\Python_code\mat\';  %106to114_oneDim 文件路径
yuan_data_name = '107to113_oneDim';

%% 加载原始波形
dat = load([yuan_data_path, yuan_data_name, '.mat']);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
data_yuan = getfield(dat, name);    %根据字段名读取数据
%data_yuan = data_yuan(1:length(data_yuan)*5/7);   %前五天的

%% 自相关函数图
numLags = 100*5;
figure('color','w');
title('自相关函数','FontSize',18);
[acf, lags, bounds] = autocorr(data_yuan, numLags);
lineHandles = stem(lags,acf,'filled','black');
set(lineHandles(1),'MarkerSize',4)
grid('on')
xlabel('滞后','FontSize',18)
ylabel('样本自相关','FontSize',18)
title('样本自相关函数','FontSize',18)
hold('on');
plot([0+0.5 0+0.5; numLags numLags],[bounds([1 1]) bounds([2 2])],'-b');
plot([0 numLags],[0 0],'-k');


%% fft变换
Fs = 48*5;            % 采样频率   单位：次/天    6min一个点那一天24h 就是每天48*5的采样频率                 
T = 1/Fs;             % Sampling period       
n = length(data_yuan);             % Length of signal

data = data_yuan - mean(data_yuan);   %去除直流分量
Y = fft(data, n);


%% 绘图
% Y乘Y共轭=a方加b方   复数Y = a + ib
Pyy = Y.*conj(Y)/n;
%频率序列f  其中（0：n/x）的x控制plot显示频率范围         Fs/n频谱分辨率
f = Fs/n*(0:n/12);
figure('color','w');
plot(f,Pyy(1:n/12+1) , 'color', 'black', 'LineWidth', 1.5)
%title('频谱强度','FontSize',18)
set(gca,'XTick',[0:1:30],'FontSize',20);%设置要显示坐标刻度
xlabel('Frequency[1/24h]','FontSize',20);
ylabel('Amplitude[V/m]','FontSize',20);
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格
%% IFFT反变换
R2 = [];
for i= 1:length(data_yuan)/8
    %反变换
    Y1 = Y';
    Y1(8*i:end) = 0;
    yifft = ifft(Y1');
    y_ifft = real(yifft);
    y_ifft = y_ifft + mean(data_yuan);
    
    %计算解释方差
    SS_res = sum((data_yuan-y_ifft).^2);  %残差平方和
    SS_tot = sum((data_yuan - mean(data_yuan)).^2);  %总平方和
    R2 = [R2;i 1-(SS_res/SS_tot)];
    
end

%绘图
figure('color','w');
plot(y_ifft);
hold on;
plot(data_yuan)







