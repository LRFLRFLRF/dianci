
clc;
clear;
%% 加载diff1
data_path = 'E:\Desktop\dianci\Python_code\mat\xls_r\';  
data_name = 'app_diff1';
%加载波形
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
data_diff = getfield(dat, name);    %根据字段名读取数据

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

%% 绘制app 和 app预测数据图


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
