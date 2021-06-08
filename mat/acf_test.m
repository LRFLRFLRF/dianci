
clc;
clear;
%% ����6minԭ����
data_path = 'E:\Desktop\dianci\Python_code\mat\mat_xls_file\';  
data_name = 'sig';
%���ز���
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %��ȡ�ֶ���
name = fieldname{1};
yuan = getfield(dat, name);    %�����ֶ�����ȡ����

%% ����12minԭ����
data_path = 'E:\Desktop\dianci\Python_code\mat\mat_python\';  
data_name = 'sig_7_13_12min';
%���ز���
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %��ȡ�ֶ���
name = fieldname{1};
yuan = getfield(dat, name);    %�����ֶ�����ȡ����

%% ���� lstm Ԥ������
data_path = 'E:\Desktop\dianci\Python_code\mat\mat_python\';  
data_name = 'lstm_onepoint';
%���ز���
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %��ȡ�ֶ���
name = fieldname{1};
lstm_pred = getfield(dat, name);    %�����ֶ�����ȡ����

%% ���� sum Ԥ������
data_path = 'E:\Desktop\dianci\Python_code\mat\mat_python\';  
data_name = 'sum_pred';
%���ز���
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %��ȡ�ֶ���
name = fieldname{1};
sum_pred = getfield(dat, name);    %�����ֶ�����ȡ����

%% ����single sarima sum Ԥ������
data_path = 'E:\Desktop\dianci\Python_code\mat\mat_python\';  
data_name = 'single_sarima_pred';
%���ز���
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %��ȡ�ֶ���
name = fieldname{1};
single_sum_pred = getfield(dat, name);    %�����ֶ�����ȡ����

%% ����app ����
data_path = 'E:\Desktop\dianci\Python_code\mat\mat_python\';  
data_name = 'app_7_13_12min';
%���ز���
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %��ȡ�ֶ���
name = fieldname{1};
data = getfield(dat, name);    %�����ֶ�����ȡ����

%% ����appԤ������
data_path = 'E:\Desktop\dianci\Python_code\mat\mat_python\';  
data_name = 'app_sarima_212_010_pred';
%���ز���
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %��ȡ�ֶ���
name = fieldname{1};
data_pred = getfield(dat, name);    %�����ֶ�����ȡ����


%% ����res ����
data_path = 'E:\Desktop\dianci\Python_code\mat\mat_python\';  
data_name = 'res_7_13_12min';
%���ز���
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %��ȡ�ֶ���
name = fieldname{1};
data_res = getfield(dat, name);    %�����ֶ�����ȡ����

%% ����resԤ������
data_path = 'E:\Desktop\dianci\Python_code\mat\mat_python\';  
data_name = 'res_arima_602_pred';
%���ز���
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %��ȡ�ֶ���
name = fieldname{1};
data_res_pred = getfield(dat, name);    %�����ֶ�����ȡ����


%% ����6minԭ����ͼ
figure('color','w');
plot(yuan(:,6),'black');
ylim([0.15,1]);
xlim([0,7*240]);
xlabel('Time[Day]','fontsize',20);
ylabel('E[V/m]','fontsize',20);
set(gca,'XTick',1:240:240*7,'fontsize',20);
set(gca,'XTicklabel',{'1','2','3','4','5','6','7','8'})
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����

%% ����app �� appԤ������ͼ
figure('color','w');
plot(data,'black');
hold on;
x = [120*4+1:120*4+length(data_pred)];
plot(x,data_pred','-r.');
ylim([0.15,0.6]);
xlim([0,7*120]);
xlabel('Time[Day]','fontsize',20);
ylabel('E[V/m]','fontsize',20);
set(gca,'XTick',1:120:120*7,'fontsize',20);
set(gca,'XTicklabel',{'1','2','3','4','5','6','7','8'})
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����

%% ����res �� resԤ������ͼ
figure('color','w');
plot(data_res,'black');
hold on;
x = [120*4+1:120*4+length(data_res_pred)];
plot(x,data_res_pred','-r.');
%ylim([0.15,0.6]);
xlim([0,7*120]);
xlabel('Time[Day]','fontsize',20);
ylabel('E[V/m]','fontsize',20);
set(gca,'XTick',1:120:120*7,'fontsize',20);
set(gca,'XTicklabel',{'1','2','3','4','5','6','7','8'})
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����

%% ����yuan���� �� sumԤ������ͼ
figure('color','w');
plot(yuan,'black');
hold on;
x = [120*4+1:120*4+length(sum_pred)];
plot(x,sum_pred','-r.');
ylim([0.15,0.7]);
xlim([0,7*120]);
xlabel('Time[Day]','fontsize',20);
ylabel('E[V/m]','fontsize',20);
set(gca,'XTick',1:120:120*7,'fontsize',20);
set(gca,'XTicklabel',{'1','2','3','4','5','6','7','8'})
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����

%% ����yuan���� ��single sarima sumԤ������ͼ
figure('color','w');
plot(yuan,'black');
hold on;
x = [120*4+1:120*4+length(single_sum_pred)];
plot(x,single_sum_pred','-r.');
ylim([0.15,0.7]);
xlim([0,7*120]);
xlabel('Time[Day]','fontsize',20);
ylabel('E[V/m]','fontsize',20);
set(gca,'XTick',1:120:120*7,'fontsize',20);
set(gca,'XTicklabel',{'1','2','3','4','5','6','7','8'})
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����

%% ����yuan���� ��lstmԤ������ͼ
figure('color','w');
plot(yuan,'black');
hold on;
x = [120*4+1:120*4+length(lstm_pred)];
plot(x,lstm_pred(:,2)','-r.');
ylim([0.15,0.7]);
xlim([0,7*120]);
xlabel('Time[Day]','fontsize',20);
ylabel('E[V/m]','fontsize',20);
set(gca,'XTick',1:120:120*7,'fontsize',20);
set(gca,'XTicklabel',{'1','2','3','4','5','6','7','8'})
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����



%% adf����ƽ����
%[H,pValue,stat,cValue,reg] = adftest(data)

%% acf pacf
% data1 = diff(data, 120);
% data2 = diff(data1, 1);
plot(data)
figure('color','w');
autocorr(data)       %���������ͼ��ͼ�������������߷ֱ��ʾ�����ϵ�������½磬�����߽�Ĳ��ֱ�ʾ������ع�ϵ��
[a,b] = autocorr(data)   %a Ϊ���׵����ϵ����b Ϊ�ͺ����'

figure('color','w');
parcorr(data)  %����ƫ�����ͼ
[c,d] = parcorr(data)    %c Ϊ���׵�ƫ�����ϵ����d Ϊ�ͺ����

