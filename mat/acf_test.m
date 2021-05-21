
clc;
clear;
%% ����diff1
data_path = 'E:\Desktop\dianci\Python_code\mat\xls_r\';  
data_name = 'app_diff1';
%���ز���
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %��ȡ�ֶ���
name = fieldname{1};
data_diff = getfield(dat, name);    %�����ֶ�����ȡ����

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

%% ����app �� appԤ������ͼ


figure('color','w');
plot(data,'black');
hold on;
x = [120*4+1:120*4+length(data_pred)];
plot(x,data_pred','-r.');
ylim([0.15,0.6]);
xlim([0,7*120]);
xlabel('Time[Day]');
ylabel('E[V/m]');
set(gca,'XTick',1:120:120*7);
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

%% bic
LOGL = zeros(3,3); %Initialize
PQ = zeros(3,3);
for p = 1:3
    for q = 1:3
        mod = arima(p,0,q);
        [fit,~,logL] = estimate(mod,data,'print',false);
        LOGL(p,q) = logL;
        PQ(p,q) = p+q;
     end
end
LOGL = reshape(LOGL,9,1);
PQ = reshape(PQ,9,1);
[aic,bic] = aicbic(LOGL,PQ+1,length(data));
result_aic = reshape(aic,3,3)
result_bic = reshape(bic,3,3)