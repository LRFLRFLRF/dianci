
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

%% 加载 sum 预测数据 10steps
data_path = 'E:\Desktop\dianci\Python_code\mat\mat_python\';  
data_name = 'sum_pred_10step';
%加载波形
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
sum_pred_10step = getfield(dat, name);    %根据字段名读取数据

%% 加载 sum 预测数据 5steps
data_path = 'E:\Desktop\dianci\Python_code\mat\mat_python\';  
data_name = 'sum_pred_5step';
%加载波形
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
sum_pred = getfield(dat, name);    %根据字段名读取数据

%% 加载 sum 预测数据 3steps
data_path = 'E:\Desktop\dianci\Python_code\mat\mat_python\';  
data_name = 'sum_pred_3step';
%加载波形
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
sum_pred_3step = getfield(dat, name);    %根据字段名读取数据

%% 加载 sum 预测数据 1steps
data_path = 'E:\Desktop\dianci\Python_code\mat\mat_python\';  
data_name = 'sum_pred_1step';
%加载波形
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
sum_pred_1step = getfield(dat, name);    %根据字段名读取数据

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

%% 绘制yuan数据 和 sum预测数据图 10step
sum_pred_10step = sum_pred_10step(2:end);    %数据对齐！！！！！ 

figure('color','w');
plot(yuan,'black');
hold on;
x = [120*4+1:120*4+length(sum_pred_10step)];
plot(x,sum_pred_10step','-r.');
ylim([0.15,0.7]);
xlim([0,7*120]);
xlabel('Time[Day]','fontsize',20);
ylabel('E[V/m]','fontsize',20);
set(gca,'XTick',1:120:120*7,'fontsize',20);
set(gca,'XTicklabel',{'1','2','3','4','5','6','7','8'})
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格

% 计算 整体指标
observed = yuan(481:481+length(sum_pred_10step)-1);
mape = mean(abs((observed - sum_pred_10step(:,1))./observed))*100
mae = mean(abs(observed - sum_pred_10step(:,1)))
rmse = sqrt(mean((observed - sum_pred_10step(:,1)).^2))
res_junzhi = mean(observed - sum_pred_10step(:,1));
sde = sqrt(mean((observed - sum_pred_10step(:,1) - res_junzhi).^2))
p = corr(observed,sum_pred_10step(:,1),'type','Pearson')


%% 绘制yuan数据 和 sum预测数据图 5steps
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

% 计算 整体指标
observed = yuan(481:481+length(sum_pred)-1);
mape = mean(abs((observed - sum_pred(:,1))./observed))*100
mae = mean(abs(observed - sum_pred(:,1)))
rmse = sqrt(mean((observed - sum_pred(:,1)).^2))
res_junzhi = mean(observed - sum_pred(:,1));
sde = sqrt(mean((observed - sum_pred(:,1) - res_junzhi).^2))
p = corr(observed,sum_pred(:,1),'type','Pearson')


mape_sum5_cube = [];
mae_sum5_cube = [];
rmse_sum5_cube = [];
sde_sum5_cube = [];
p_sum5_cube = [];
%计算 分段mape
for i=1:9
    if i==9
        observed = yuan(481+40*(i-1):end-5);
        pre = sum_pred(1+(i-1)*40:end);
    else
        observed = yuan(481+40*(i-1):481+40*i-1);
        pre = sum_pred(1+(i-1)*40:40*i);
    end
 
    mape_fenduan = mean(abs((observed - pre)./observed))*100;
    mae_fenduan = mean(abs(observed - pre));
    rmse_fenduan = sqrt(mean((observed - pre).^2));
    res_junzhi = mean(observed - pre);
    sde_fenduan = sqrt(mean((observed - pre - res_junzhi).^2));
    p_fenduan = corr(observed,pre,'type','Pearson');
    
    mape_sum5_cube = [mape_sum5_cube mape_fenduan];
    mae_sum5_cube = [mae_sum5_cube mae_fenduan];
    rmse_sum5_cube = [rmse_sum5_cube rmse_fenduan];
    sde_sum5_cube = [sde_sum5_cube sde_fenduan];
    p_sum5_cube = [p_sum5_cube p_fenduan];
end

%% 绘制yuan数据 和 sum预测数据图 3step
sum_pred_3step = sum_pred_3step(2:end);    %数据对齐！！！！！  就step为3时用到

figure('color','w');
plot(yuan,'black');
hold on;
x = [120*4+1:120*4+length(sum_pred_3step)];
plot(x,sum_pred_3step','-r.');
ylim([0.15,0.7]);
xlim([0,7*120]);
xlabel('Time[Day]','fontsize',20);
ylabel('E[V/m]','fontsize',20);
set(gca,'XTick',1:120:120*7,'fontsize',20);
set(gca,'XTicklabel',{'1','2','3','4','5','6','7','8'})
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格

% 计算 整体指标
observed = yuan(481:481+length(sum_pred_3step)-1);
mape = mean(abs((observed - sum_pred_3step(:,1))./observed))*100
mae = mean(abs(observed - sum_pred_3step(:,1)))
rmse = sqrt(mean((observed - sum_pred_3step(:,1)).^2))
res_junzhi = mean(observed - sum_pred_3step(:,1));
sde = sqrt(mean((observed - sum_pred_3step(:,1) - res_junzhi).^2))
p = corr(observed,sum_pred_3step(:,1),'type','Pearson')


%% 绘制yuan数据 和 sum预测数据图 1step
figure('color','w');
plot(yuan,'black');
hold on;
x = [120*4+1:120*4+length(sum_pred_1step)];
plot(x,sum_pred_1step','-r.');
ylim([0.15,0.7]);
xlim([0,7*120]);
xlabel('Time[Day]','fontsize',20);
ylabel('E[V/m]','fontsize',20);
set(gca,'XTick',1:120:120*7,'fontsize',20);
set(gca,'XTicklabel',{'1','2','3','4','5','6','7','8'})
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格

% 计算 整体指标
observed = yuan(481:481+length(sum_pred_1step)-1);
mape = mean(abs((observed - sum_pred_1step(:,1))./observed))*100
mae = mean(abs(observed - sum_pred_1step(:,1)))
rmse = sqrt(mean((observed - sum_pred_1step(:,1)).^2))
res_junzhi = mean(observed - sum_pred_1step(:,1));
sde = sqrt(mean((observed - sum_pred_1step(:,1) - res_junzhi).^2))
p = corr(observed,sum_pred_1step(:,1),'type','Pearson')

mape_sum1_cube = [];
mae_sum1_cube = [];
rmse_sum1_cube = [];
sde_sum1_cube = [];
p_sum1_cube = [];
%计算 分段mape
for i=1:9
    if i==9
        observed = yuan(481+40*(i-1):end-1);
        pre = sum_pred_1step(1+(i-1)*40:end);
    else
        observed = yuan(481+40*(i-1):481+40*i-1);
        pre = sum_pred_1step(1+(i-1)*40:40*i);
    end
 
    mape_fenduan = mean(abs((observed - pre)./observed))*100;
    mae_fenduan = mean(abs(observed - pre));
    rmse_fenduan = sqrt(mean((observed - pre).^2));
    res_junzhi = mean(observed - pre);
    sde_fenduan = sqrt(mean((observed - pre - res_junzhi).^2));
    p_fenduan = corr(observed,pre,'type','Pearson');
    
    mape_sum1_cube = [mape_sum1_cube mape_fenduan];
    mae_sum1_cube = [mae_sum1_cube mae_fenduan];
    rmse_sum1_cube = [rmse_sum1_cube rmse_fenduan];
    sde_sum1_cube = [sde_sum1_cube sde_fenduan];
    p_sum1_cube = [p_sum1_cube p_fenduan];
end


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

% 计算 整体指标
observed = yuan(481:481+length(single_sum_pred)-1);
mape = mean(abs((observed - single_sum_pred(:,1))./observed))*100
mae = mean(abs(observed - single_sum_pred(:,1)))
rmse = sqrt(mean((observed - single_sum_pred(:,1)).^2))
res_junzhi = mean(observed - single_sum_pred(:,1));
sde = sqrt(mean((observed - single_sum_pred(:,1) - res_junzhi).^2))
p = corr(observed,single_sum_pred(:,1),'type','Pearson')


mape_sar_cube = [];
mae_sar_cube = [];
rmse_sar_cube = [];
sde_sar_cube = [];
p_sar_cube = [];
%计算 分段指标
for i=1:9
    observed = yuan(481+40*(i-1):481+40*i-1);
    pre = single_sum_pred(1+(i-1)*40:40*i);
  
    mape_fenduan = mean(abs((observed - pre)./observed))*100;
    mae_fenduan = mean(abs(observed - pre));
    rmse_fenduan = sqrt(mean((observed - pre).^2));
    res_junzhi = mean(observed - pre);
    sde_fenduan = sqrt(mean((observed - pre - res_junzhi).^2));
    p_fenduan = corr(observed,pre,'type','Pearson');
    
    mape_sar_cube = [mape_sar_cube mape_fenduan];
    mae_sar_cube = [mae_sar_cube mae_fenduan];
    rmse_sar_cube = [rmse_sar_cube rmse_fenduan];
    sde_sar_cube = [sde_sar_cube sde_fenduan];
    p_sar_cube = [p_sar_cube p_fenduan];
end


%% 绘制yuan数据 和lstm预测数据图 以及计算mape mae
figure('color','w');
plot(yuan(481-120:end),'black','LineWidth',1.0);
hold on;
x = [1+120:length(lstm_pred)+120];
plot(x,lstm_pred(:,2)','-g.');
hold on;
x = [1+120:length(single_sum_pred)+120];
plot(x,single_sum_pred','-b.');
hold on;
x = [1+120:length(sum_pred)+120];
plot(x,sum_pred','-r.');
ylim([0.15,0.7]);
xlim([0,4*120]);
xlabel('Time[Day]','fontsize',20);
ylabel('E[V/m]','fontsize',20);
set(gca,'XTick',1:120:120*4,'fontsize',20);
set(gca,'XTicklabel',{'4','5','6','7','8'})
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格
h = legend('The raw signal','LSTM  1-step','SARIMA  1-step','Hybrid method  5-steps','northeast');
set(h, 'FontSize', 15);

% 计算 整体指标
observed = yuan(481:481+length(lstm_pred)-1);
mape = mean(abs((observed - lstm_pred(:,2))./observed))*100
mae = mean(abs(observed - lstm_pred(:,2)))
rmse = sqrt(mean((observed - lstm_pred(:,2)).^2))
res_junzhi = mean(observed - lstm_pred(:,2));
sde = sqrt(mean((observed - lstm_pred(:,2) - res_junzhi).^2))
p = corr(observed,lstm_pred(:,2),'type','Pearson')


%计算 分段指标
mape_lstm_cube = [];
mae_lstm_cube = [];
rmse_lstm_cube = [];
sde_lstm_cube = [];
p_lstm_cube = [];
for i=1:9
    if i==9
        observed = yuan(481+40*(i-1):end-4);
        pre = lstm_pred(1+(i-1)*40:end,2);
    else
        observed = yuan(481+40*(i-1):481+40*i-1);
        pre = lstm_pred(1+(i-1)*40:40*i,2);
    end
    mape_fenduan = mean(abs((observed - pre)./observed))*100;
    mae_fenduan = mean(abs(observed - pre));
    rmse_fenduan = sqrt(mean((observed - pre).^2));
    res_junzhi = mean(observed - pre);
    sde_fenduan = sqrt(mean((observed - pre - res_junzhi).^2));
    p_fenduan = corr(observed,pre,'type','Pearson');
    
    mape_lstm_cube = [mape_lstm_cube mape_fenduan];
    mae_lstm_cube = [mae_lstm_cube mae_fenduan];
    rmse_lstm_cube = [rmse_lstm_cube rmse_fenduan];
    sde_lstm_cube = [sde_lstm_cube sde_fenduan];
    p_lstm_cube = [p_lstm_cube p_fenduan];
end

%% 绘制mape折线图

hybrid_1_mape = [1.8696,3.7333,2.7634,2.4048,2.9681,8.3789,3.6414,3.9007,7.8577];
hybrid_5_mape = [2.4035,4.1002,3.218,2.7014,3.6543,9.2298,3.9787,5.0952,11.0329];
lstm_mape = [3.4483,5.2486,2.9851,2.1018,3.6756,8.2181,2.4987,4.228,8.3138];
sarma_mape = [3.4548,5.626,8.4636,3.3421,5.1117,12.555,6.057,8.9715,11.6865];

figure('color','w');
x = [0.5:8.5];
plot(x,hybrid_1_mape,'-r*', 'Linewidth', 1.5);
hold on;
plot(x,hybrid_5_mape,'-k*', 'Linewidth', 1.5);
plot(x,lstm_mape,'-g*', 'Linewidth', 1.5);
plot(x,sarma_mape,'-b*', 'Linewidth', 1.5);
%xlim([0,9]);
xlabel('Time and windows','fontsize',20);
ylabel('MAPE[%]','fontsize',20);
set(gca,'XTick',0:9,'fontsize',17);
%'0-8o''clock','8-16o''clock','16-24o''clock'
set(gca,'XTicklabel',[]);
yLabels = {'5-A','5-B','5-C','6-A','6-B','6-C','7-A','7-B','7-C'};
for i = 1 : length(yLabels)
    text(-0.7+1 * i,-0.5,  yLabels(i),'fontsize',17);   % 用文本的方式添加，位置可以自定义
end
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格
h = legend('Hybrid method  1-step','Hybrid method  5-steps','LSTM  1-step','SARIMA  1-step','northeast');
set(h, 'FontSize', 15);

%% 绘制 mae  折线图
hybrid_1_mae = [0.005,0.0139,0.0086,0.0074,0.0111,0.0323,0.0135,0.014,0.0311];
hybrid_5_mae = [0.0064,0.0156,0.0101,0.0083,0.0136,0.0359,0.0147,0.0182,0.043];
lstm_mae = [0.009,0.021,0.0094,0.0064,0.0143,0.0342,0.0105,0.0157,0.035];
sarma_mae = [0.0094,0.0212,0.0258,0.0104,0.019,0.0499,0.0225,0.0317,0.0479];

figure('color','w');
x = [0.5:8.5];
plot(x,hybrid_1_mae,'-r*', 'Linewidth', 1.5);
hold on;
plot(x,hybrid_5_mae,'-k*', 'Linewidth', 1.5);
plot(x,lstm_mae,'-g*', 'Linewidth', 1.5);
plot(x,sarma_mae,'-b*', 'Linewidth', 1.5);
ylim([0,0.055]);
xlabel('Time and windows','fontsize',20);
ylabel('MAE[V/m]','fontsize',20);
set(gca,'XTick',0:9,'fontsize',17);
%'0-8o''clock','8-16o''clock','16-24o''clock'
set(gca,'XTicklabel',[]);
yLabels = {'5-A','5-B','5-C','6-A','6-B','6-C','7-A','7-B','7-C'};
for i = 1 : length(yLabels)
    text(-0.7+1 * i,-0.002,  yLabels(i),'fontsize',17);   % 用文本的方式添加，位置可以自定义
end

set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格
h = legend('Hybrid method  1-step','Hybrid method  5-steps','LSTM  1-step','SARIMA  1-step','northeast');
set(h, 'FontSize', 15);

%% 绘制 rmse  折线图
hybrid_1_rmse = rmse_sum1_cube;
hybrid_5_rmse = rmse_sum5_cube;
lstm_rmse = rmse_lstm_cube;
sarma_rmse = rmse_sar_cube;

figure('color','w');
x = [0.5:8.5];
plot(x,hybrid_1_rmse,'-r*', 'Linewidth', 1.5);
hold on;
plot(x,hybrid_5_rmse,'-k*', 'Linewidth', 1.5);
plot(x,lstm_rmse,'-g*', 'Linewidth', 1.5);
plot(x,sarma_rmse,'-b*', 'Linewidth', 1.5);
ylim([0,0.09]);
xlabel('Time and windows','fontsize',20);
ylabel('RMSE[V/m]','fontsize',20);
set(gca,'XTick',0:9,'fontsize',17);
%'0-8o''clock','8-16o''clock','16-24o''clock'
set(gca,'XTicklabel',[]);
yLabels = {'5-A','5-B','5-C','6-A','6-B','6-C','7-A','7-B','7-C'};
for i = 1 : length(yLabels)
    text(-0.7+1 * i,-0.002,  yLabels(i),'fontsize',17);   % 用文本的方式添加，位置可以自定义
end

set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格
h = legend('Hybrid method  1-step','Hybrid method  5-steps','LSTM  1-step','SARIMA  1-step','northeast');
set(h, 'FontSize', 15);

%% 绘制 SDE  折线图
hybrid_1_sde = sde_sum1_cube;
hybrid_5_sde = sde_sum5_cube;
lstm_sde = sde_lstm_cube;
sarma_sde = sde_sar_cube;

figure('color','w');
x = [0.5:8.5];
plot(x,hybrid_1_sde,'-r*', 'Linewidth', 1.5);
hold on;
plot(x,hybrid_5_sde,'-k*', 'Linewidth', 1.5);
plot(x,lstm_sde,'-g*', 'Linewidth', 1.5);
plot(x,sarma_sde,'-b*', 'Linewidth', 1.5);
ylim([0,0.09]);
xlabel('Time and windows','fontsize',20);
ylabel('SDE[V/m]','fontsize',20);
set(gca,'XTick',0:9,'fontsize',17);
%'0-8o''clock','8-16o''clock','16-24o''clock'
set(gca,'XTicklabel',[]);
yLabels = {'5-A','5-B','5-C','6-A','6-B','6-C','7-A','7-B','7-C'};
for i = 1 : length(yLabels)
    text(-0.7+1 * i,-0.002,  yLabels(i),'fontsize',17);   % 用文本的方式添加，位置可以自定义
end

set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格
h = legend('Hybrid method  1-step','Hybrid method  5-steps','LSTM  1-step','SARIMA  1-step','northeast');
set(h, 'FontSize', 15);

%% 绘制 Pearson 折线图
hybrid_1_p = p_sum1_cube;
hybrid_5_p = p_sum5_cube;
lstm_p = p_lstm_cube;
sarma_p = p_sar_cube;

figure('color','w');
x = [0.5:8.5];
plot(x,hybrid_1_p,'-r*', 'Linewidth', 1.5);
hold on;
plot(x,hybrid_5_p,'-k*', 'Linewidth', 1.5);
plot(x,lstm_p,'-g*', 'Linewidth', 1.5);
plot(x,sarma_p,'-b*', 'Linewidth', 1.5);
ylim([0,1]);
xlabel('Time and windows','fontsize',20);
ylabel('Pearson Correlation Coefficient','fontsize',20);
set(gca,'XTick',0:9,'fontsize',17);
%'0-8o''clock','8-16o''clock','16-24o''clock'
set(gca,'XTicklabel',[]);
yLabels = {'5-A','5-B','5-C','6-A','6-B','6-C','7-A','7-B','7-C'};
for i = 1 : length(yLabels)
    text(-0.7+1 * i,-0.025,  yLabels(i),'fontsize',17);   % 用文本的方式添加，位置可以自定义
end

set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格
h = legend('Hybrid method  1-step','Hybrid method  5-steps','LSTM  1-step','SARIMA  1-step','northeast');
set(h, 'FontSize', 15);