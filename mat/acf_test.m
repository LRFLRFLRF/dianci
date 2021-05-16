
clc;
clear;

data_path = 'E:\Desktop\dianci\Python_code\mat\mat_python\';  
data_name = 'res_7_13_12min';
%加载波形
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
data = getfield(dat, name);    %根据字段名读取数据

figure('color','w');
autocorr(data,250)       %画出自相关图，图中上下两条横线分别表示自相关系数的上下界，超出边界的部分表示存在相关关系。
[a,b] = autocorr(data,250)   %a 为各阶的相关系数，b 为滞后阶数'

%figure('color','w');
% parcorr(data)  %画出偏自相关图
% [c,d] = parcorr(data)    %c 为各阶的偏自相关系数，d 为滞后阶数



