%% 读取近似信号数据
node_data_path = 'E:\Desktop\dianci\Python_code\mat\mat_xls_file\';    %node文件路径
node_data_name = 'wp_4_db8_rec';      %得到变量名字符串
dat = load([node_data_path, node_data_name, '.mat']);      
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
sig_a = getfield(dat, name)';

%% arima




