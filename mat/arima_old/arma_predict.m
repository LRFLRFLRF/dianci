close all
clear 


%% 加载原始波形
yuan_data_path = 'E:\Desktop\dianci\Python_code\mat\mat_xls_file\';  %106to114_oneDim 文件路径
yuan_data_name = 'wp_4_db8_rec';

dat = load([yuan_data_path, yuan_data_name, '.mat']);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
data_yuan = getfield(dat, name)';    %根据字段名读取原数据

%% ARIMA预测
%参数设定
AR_Order = 2;
MA_Order = 2;
diff_num = 0;
len = length(data_yuan);
% 拟合
Mdl = arima('Constant', 0,'ARLags', [1,2],'MALags', [1,2], 'Seasonality', 120);
EstMdl = estimate(Mdl,data_yuan);
step = 10;  %预测步数
% 单步预测
for i = 241:step:len
    forcastData(i+1:i+step) = Fun_ARIMA_Forecast(data_yuan(i-150:i), EstMdl,step,'off');
end

figure()
% 绘制原始波形
plot(1:len,data_yuan(1:len))
hold on
% 绘制预测波形
plot(241:len,forcastData(241:len), 'red')
legend('原始数据','单步预测数据')
