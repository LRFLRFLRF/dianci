clc;
clear;

yuan_data_path = 'E:\Desktop\dianci\Python_code\mat\';  %106to114_oneDim �ļ�·��
yuan_data_name = '107to113_oneDim';

%% ����ԭʼ����
dat = load([yuan_data_path, yuan_data_name, '.mat']);   
fieldname = fieldnames(dat);   %��ȡ�ֶ���
name = fieldname{1};
data_yuan = getfield(dat, name);    %�����ֶ�����ȡ����

%% STFT
%���windowΪһ��������x�����ֳ�window���ĶΣ�ÿ��ʹ��Hamming�������Ӵ���
window = 10*24/2;    %��������   

%������Ϊһ��С��window��length(window)��������
%����˼Ϊ�������ڴ�����β����ͷ�ģ������������н��������ص��Ĳ��֡�
% �ص�Ϊ0��window����10*24ʱ������ʱ����7��һ�����һ��   ���ص���Ϊ0.5  ��ʱ����14��
noverlap = window*0.5;    %ÿһ�ε��ص�������,


f_len = 15;     %Ƶ����ּ���
f = linspace(0, 1e3, f_len);   %�ڶ�����ΪƵ������ʾ��Χ

%����Ƶ��
fs = 10*24; %һ���ۺϳ�1s   ����Ƶ�� 10*24
[s, f, t] = spectrogram(data_yuan, window, noverlap, f, fs);
figure;
imagesc(t, f, 20*log10((abs(s))));xlabel('Samples'); ylabel('Freqency');
colorbar;

