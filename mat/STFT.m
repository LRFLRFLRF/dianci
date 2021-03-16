clc;
clear;

yuan_data_path = 'E:\Desktop\dianci\Python_code\mat\';  %106to114_oneDim �ļ�·��
yuan_data_name = '107to113_oneDim';

%% ����ԭʼ����
dat = load([yuan_data_path, yuan_data_name, '.mat']);   
fieldname = fieldnames(dat);   %��ȡ�ֶ���
name = fieldname{1};
data_yuan = getfield(dat, name);    %�����ֶ�����ȡ����

data = data_yuan - mean(data_yuan);   %ȥ��ֱ������

%% STFT
len = length(data);

%���windowΪһ��������x�����ֳ�window���ĶΣ�ÿ��ʹ��Hamming�������Ӵ���
window = 10*24/3;    %��������   

%������Ϊһ��С��window��length(window)��������
%����˼Ϊ�������ڴ�����β����ͷ�ģ������������н��������ص��Ĳ��֡�
% �ص�Ϊ0��window����10*24ʱ������ʱ����7��һ�����һ��   ���ص���Ϊ0.5  ��ʱ����14��
noverlap = window*0;    %ÿһ�ε��ص�������,


f_len = 10;     %Ƶ����ּ���
f = linspace(0, 1e10, f_len);   %�ڶ�����ΪƵ������ʾ��Χ

%��ɢ����Ҷ����
nfft = window;

%����Ƶ��
fs = 10*24; %һ���ۺϳ�1s   ����Ƶ�� 10*24


[s, f, t] = spectrogram(data, window, noverlap, nfft, fs);
figure('color','w');

%% �������ܶ� db/hz
% imagesc(t, f./(fs/2), 10*log10(abs(s)/len));   %�������ܶ�
% title('�ۺϵ糡ǿ�����й������ܶ�ͼ','FontSize',18);
% xlabel('����','FontSize',18); ylabel('��һ��Ƶ��','FontSize',18);
% colorbar;
% ylabel(colorbar,'�������ܶ� [dB/HZ]','FontSize',18);
% colormap(jet);


%% ��ȫ�ַ�ֵ�����ȹ�һ��
imagesc(t, f./(fs/2), 10*log10(abs(s)/max(max(abs(s)))));   %Ƶ�׷��ȹ�һ��
%surf(t, f./(fs/2), 10*log10(abs(s)/max(max(abs(s)))));
title('�ۺϵ糡ǿ������Ƶ��ͼ','FontSize',18);
xlabel('����','FontSize',18); ylabel('��һ��Ƶ��','FontSize',18);
colorbar;
ylabel(colorbar,'ȫ�ַ������ֵ��һ������ [dB]','FontSize',18);
colormap(jet);

    
%% �����շ�ֵ�����ȹ�һ��
% max_col = repmat(max(abs(s),[],1), size(s,1), 1);
% s_1 = abs(s)./max_col;
% imagesc(t, f./(fs/2), 10*log10(s_1) );   %Ƶ�׷��ȹ�һ��
% title('�ۺϵ糡ǿ������Ƶ��ͼ','FontSize',18);
% xlabel('����','FontSize',18); ylabel('��һ��Ƶ��','FontSize',18);
% colorbar;
% ylabel(colorbar,'���շ������ֵ��һ������ [dB]','FontSize',18);
% colormap(jet);

%% ��ʾ[������]��ǩ����
yLabels = {'0-8��', '8-16��', '16-24��'};  % �����ӵı�ǩ
lenlab = length(yLabels);
for i = 0 : length(yLabels)*7-1
    text(1/lenlab * i+0.05, 1-0.025, yLabels(mod(i,3)+1));   % ���ı��ķ�ʽ���ӣ�λ�ÿ����Զ���
end


%% Ƶ��������ȡ
norm_freq_mat = repmat(f./(fs/2), 1, size(s, 2));%��һ��Ƶ�ʾ���

%ƽ��Ƶ�� MF
MF = mean(abs(s), 1);

%����Ƶ�� FC
numer = sum(norm_freq_mat.*abs(s));
denomin = sum(abs(s));
FC = numer./denomin;

%����Ƶ��MSF





