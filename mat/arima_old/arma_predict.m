close all
clear 


%% ����ԭʼ����
yuan_data_path = 'E:\Desktop\dianci\Python_code\mat\mat_xls_file\';  %106to114_oneDim �ļ�·��
yuan_data_name = 'wp_4_db8_rec';

dat = load([yuan_data_path, yuan_data_name, '.mat']);   
fieldname = fieldnames(dat);   %��ȡ�ֶ���
name = fieldname{1};
data_yuan = getfield(dat, name)';    %�����ֶ�����ȡԭ����

%% ARIMAԤ��
%�����趨
AR_Order = 2;
MA_Order = 2;
diff_num = 0;
len = length(data_yuan);
% ���
Mdl = arima('Constant', 0,'ARLags', [1,2],'MALags', [1,2], 'Seasonality', 120);
EstMdl = estimate(Mdl,data_yuan);
step = 10;  %Ԥ�ⲽ��
% ����Ԥ��
for i = 241:step:len
    forcastData(i+1:i+step) = Fun_ARIMA_Forecast(data_yuan(i-150:i), EstMdl,step,'off');
end

figure()
% ����ԭʼ����
plot(1:len,data_yuan(1:len))
hold on
% ����Ԥ�Ⲩ��
plot(241:len,forcastData(241:len), 'red')
legend('ԭʼ����','����Ԥ������')
