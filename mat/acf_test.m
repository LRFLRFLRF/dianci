
clc;
clear;
%% 加载6min原数据
data_path = 'E:\Desktop\dianci\Python_code\mat\mat_xls_file\';  
data_name = 'sig';
%加载波形
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
yuan = getfield(dat, name);    %根据字段名读取数据

%% 加载12min原数据
data_path = 'E:\Desktop\dianci\Python_code\mat\mat_python\';  
data_name = 'sig_7_13_12min';
%加载波形
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
yuan = getfield(dat, name);    %根据字段名读取数据

%% 加载 lstm 预测数据
data_path = 'E:\Desktop\dianci\Python_code\mat\mat_python\';  
data_name = 'lstm_onepoint';
%加载波形
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
lstm_pred = getfield(dat, name);    %根据字段名读取数据

%% 加载 sum 预测数据
data_path = 'E:\Desktop\dianci\Python_code\mat\mat_python\';  
data_name = 'sum_pred';
%加载波形
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
sum_pred = getfield(dat, name);    %根据字段名读取数据

%% 加载single sarima sum 预测数据
data_path = 'E:\Desktop\dianci\Python_code\mat\mat_python\';  
data_name = 'single_sarima_pred';
%加载波形
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
single_sum_pred = getfield(dat, name);    %根据字段名读取数据

%% 加载app 数据
data_path = 'E:\Desktop\dianci\Python_code\mat\mat_python\';  
data_name = 'app_7_13_12min';
%加载波形
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
data = getfield(dat, name);    %根据字段名读取数据

%% 加载app预测数据
data_path = 'E:\Desktop\dianci\Python_code\mat\mat_python\';  
data_name = 'app_sarima_212_010_pred';
%加载波形
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
data_pred = getfield(dat, name);    %根据字段名读取数据


%% 加载res 数据
data_path = 'E:\Desktop\dianci\Python_code\mat\mat_python\';  
data_name = 'res_7_13_12min';
%加载波形
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
data_res = getfield(dat, name);    %根据字段名读取数据

%% 加载res预测数据
data_path = 'E:\Desktop\dianci\Python_code\mat\mat_python\';  
data_name = 'res_arima_602_pred';
%加载波形
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
data_res_pred = getfield(dat, name);    %根据字段名读取数据


%% 绘制6min原数据图
figure('color','w');
plot(yuan(:,6),'black');
ylim([0.15,1]);
xlim([0,7*240]);
xlabel('Time[Day]','fontsize',20);
ylabel('E[V/m]','fontsize',20);
set(gca,'XTick',1:240:240*7,'fontsize',20);
set(gca,'XTicklabel',{'1','2','3','4','5','6','7','8'})
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格

%% 绘制app 和 app预测数据图
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
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格

%% 绘制res 和 res预测数据图
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
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格

%% 绘制yuan数据 和 sum预测数据图
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
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格

%% 绘制yuan数据 和single sarima sum预测数据图
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
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格

%% 绘制yuan数据 和lstm预测数据图
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
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格



%% adf检验平稳性
%[H,pValue,stat,cValue,reg] = adftest(data)

%% acf pacf
% data1 = diff(data, 120);
% data2 = diff(data1, 1);
plot(data)
figure('color','w');
autocorr(data)       %画出自相关图，图中上下两条横线分别表示自相关系数的上下界，超出边界的部分表示存在相关关系。
[a,b] = autocorr(data)   %a 为各阶的相关系数，b 为滞后阶数'

figure('color','w');
parcorr(data)  %画出偏自相关图
[c,d] = parcorr(data)    %c 为各阶的偏自相关系数，d 为滞后阶数

