close all
clear 


%% 加载原始波形
yuan_data_path = 'E:\Desktop\dianci\Python_code\mat\';  %106to114_oneDim 文件路径
yuan_data_name = '106to114_oneDim';

dat = load([yuan_data_path, yuan_data_name, '.mat']);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
data_yuan = getfield(dat, name);    %根据字段名读取原数据

%% ARIMA预测
%参数设定
AR_Order = 9;
MA_Order = 8;
diff_num = 1;
len = length(data_yuan);
% 拟合
Mdl = arima(AR_Order, diff_num, MA_Order);
EstMdl = estimate(Mdl,data_yuan);
step = 6;  %预测步数
% 单步预测
for i = 50:step:len
    forcastData(i+1:i+step) = Fun_ARIMA_Forecast(data_yuan(i-30:i), EstMdl,step,'off');
end

figure()
% 绘制原始波形
plot(51:len,data_yuan(51:len))
hold on
% 绘制预测波形
plot(51:len,forcastData(51:len), 'red')
legend('原始数据','单步预测数据')
