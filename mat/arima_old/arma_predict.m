close all
clear 


%% ����ԭʼ����
yuan_data_path = 'E:\Desktop\dianci\Python_code\mat\';  %106to114_oneDim �ļ�·��
yuan_data_name = '106to114_oneDim';

dat = load([yuan_data_path, yuan_data_name, '.mat']);   
fieldname = fieldnames(dat);   %��ȡ�ֶ���
name = fieldname{1};
data_yuan = getfield(dat, name);    %�����ֶ�����ȡԭ����

%% ARIMAԤ��
%�����趨
AR_Order = 9;
MA_Order = 8;
diff_num = 1;
len = length(data_yuan);
% ���
Mdl = arima(AR_Order, diff_num, MA_Order);
EstMdl = estimate(Mdl,data_yuan);
step = 6;  %Ԥ�ⲽ��
% ����Ԥ��
for i = 50:step:len
    forcastData(i+1:i+step) = Fun_ARIMA_Forecast(data_yuan(i-30:i), EstMdl,step,'off');
end

figure()
% ����ԭʼ����
plot(51:len,data_yuan(51:len))
hold on
% ����Ԥ�Ⲩ��
plot(51:len,forcastData(51:len), 'red')
legend('ԭʼ����','����Ԥ������')
