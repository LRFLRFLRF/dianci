
clc;
clear;

data_path = 'E:\Desktop\dianci\Python_code\mat\mat_python\';  
data_name = 'res_7_13_12min';
%���ز���
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %��ȡ�ֶ���
name = fieldname{1};
data = getfield(dat, name);    %�����ֶ�����ȡ����

figure('color','w');
autocorr(data,250)       %���������ͼ��ͼ�������������߷ֱ��ʾ�����ϵ�������½磬�����߽�Ĳ��ֱ�ʾ������ع�ϵ��
[a,b] = autocorr(data,250)   %a Ϊ���׵����ϵ����b Ϊ�ͺ����'

%figure('color','w');
% parcorr(data)  %����ƫ�����ͼ
% [c,d] = parcorr(data)    %c Ϊ���׵�ƫ�����ϵ����d Ϊ�ͺ����



