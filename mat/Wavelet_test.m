
load 106to114_oneDim.mat
x = data_1;

%% 计算最大信噪比
SNR = [];
cengshu = 4;
jieshu = 10;
for j = 1:cengshu
    for i = 1:jieshu
        %信号分解
        [c, l] = wavedec(x, j, ['db', num2str(i)]);

        %重构信号
        c_new = c;
        c_new(l(2):end) = 0;  %只选择近似系数a
        y = waverec(c_new, l, ['db', num2str(i)]);

        %计算信噪比
        M = mean(y);   %平均值
        SD = std(y, 1);
        %SNR = [SNR 10*log10(M/SD)];
        SNR = [SNR snr(y,x-y)];
    end
end
SNR = reshape(SNR, jieshu, cengshu)';
snr_max = max(max(SNR));
[x_max, y_max] = find(SNR==max(max(SNR)));
disp(['层数：' , num2str(x_max)])
disp(['阶数：', num2str(y_max)])

%% 根据最大信噪比选择db波阶数
%信号分解
y_max = 8;
x_max = 4;
[c, l] = wavedec(x, x_max, ['db', num2str(y_max)]);

%近似信号a重构
c_new = c;
c_new(l(2):end) = 0;  %只选择近似系数a
a = waverec(c_new, l, ['db', num2str(y_max)]);

%细节信号D重构
coef = [];    %近似信号a   和细节信号d  的coef矩阵
x_cursor = 0;
for i=1:(length(l)-1)
    c_new = c;
    c_new(1 : x_cursor) = 0;
    c_new((l(i) + x_cursor + 1) : end) = 0;
    coef = [coef  waverec(c_new, l, ['db', num2str(y_max)])];
    x_cursor = l(i) + x_cursor;
end



%% 绘制原信号coef  并染色
figure;
subplot(211);
rgb = ['r','g','b','c','y','k','m','r','g','b','c','y','k','m'];
x_cursor = 1;
for i=1:(length(l)-1)
    x_label = x_cursor : (l(i) + x_cursor - 1);
    plot(x_label, c(x_cursor : (l(i) + x_cursor - 1)), rgb(i));
    hold on;
    x_cursor = l(i) + x_cursor - 1;
end
xlim([1 2015]);
% 绘制近似波形
subplot(212);
plot(a);
ylim([0.1 0.5]);

%% 保存
data = y';
save('E:\Desktop\dianci\Python_code\mat\mat_xls_file\wp_4_db8_rec.mat','data');


%% 细节信号D的fft频谱检验
Fs = 48*5;            % 采样频率                  
T = 1/Fs;             % Sampling period   
figure('color','w');
for i =1 :size(coef,2)
    s = coef(:, i);   %近似信号
    n = length(s);             % Length of signal
    s = s - mean(s);   %去除直流分量
    Y = fft(s, n);
    %%%%绘图
    % Y乘Y共轭=a方加b方   复数Y = a + ib
    Pyy = Y.*conj(Y)/n;
    %频率序列f  其中（0：n/x）的x控制plot显示频率范围         Fs/n频谱分辨率
    f = Fs/n*(0:n/2);
    subplot(str2num([num2str(size(coef,2)) '1', num2str(i)]));
    plot(f,Pyy(1:n/2+1) , 'color', 'black', 'LineWidth', 1.5)
    set(gca,'XTick',[0:5:150]);%设置要显示坐标刻度
    if i == 1
        title(['近似信号A' num2str(size(coef,2) -1) '频谱强度'],'FontSize',18)
    else
        title(['细节信号D' num2str(size(coef,2) - i +1) '频谱强度'],'FontSize',18)
    end
    hold on;
end
xlabel('频率 [1/24h]','FontSize',18);