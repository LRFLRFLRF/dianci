clc;
clear;

yuan_data_path = 'E:\Desktop\dianci\Python_code\mat\';  %106to114_oneDim �ļ�·��
yuan_data_name = '107to113_oneDim';

%% ����ԭʼ����
dat = load([yuan_data_path, yuan_data_name, '.mat']);   
fieldname = fieldnames(dat);   %��ȡ�ֶ���
name = fieldname{1};
data_yuan = getfield(dat, name);    %�����ֶ�����ȡ����
%data_yuan = data_yuan(1:length(data_yuan)*5/7);   %ǰ�����


%% fft�任
Fs = 48*5;            % ����Ƶ��   ��λ����/��    6minһ������һ��24h ����ÿ��48*5�Ĳ���Ƶ��                 
T = 1/Fs;             % Sampling period       
n = length(data_yuan);             % Length of signal

data = data_yuan - mean(data_yuan);   %ȥ��ֱ������
Y = fft(data, n);


%% ��ͼ
% Y��Y����=a����b��   ����Y = a + ib
Pyy = Y.*conj(Y)/n;
%Ƶ������f  ���У�0��n/x����x����plot��ʾƵ�ʷ�Χ         Fs/nƵ�׷ֱ���
f = Fs/n*(0:n/12);
figure('color','w');
plot(f,Pyy(1:n/12+1) , 'color', 'black', 'LineWidth', 1.5)
title('Ƶ��ǿ��','FontSize',18)
set(gca,'XTick',[0:1:30]);%����Ҫ��ʾ����̶�
xlabel('Ƶ�� [1/24h]','FontSize',18);


%% IFFT���任
R2 = [];
for i= 1:length(data_yuan)/8
    %���任
    Y1 = Y';
    Y1(8*i:end) = 0;
    yifft = ifft(Y1');
    y_ifft = real(yifft);
    y_ifft = y_ifft + mean(data_yuan);
    
    %������ͷ���
    SS_res = sum((data_yuan-y_ifft).^2);  %�в�ƽ����
    SS_tot = sum((data_yuan - mean(data_yuan)).^2);  %��ƽ����
    R2 = [R2;i 1-(SS_res/SS_tot)];
    
end

% %��ͼ
% figure('color','w');
% plot(y_ifft);
% hold on;
% plot(data_yuan)







