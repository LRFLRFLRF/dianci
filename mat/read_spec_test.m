%% 显示spec_mat
data_path = 'E:\Desktop\dianci\sample_data\20210816\spec_mat\';  

band = 1e6*[[870 880];[930 935];[935 954];[954 960];[1805 1830];[1830 1850];
[1880 1920];[2110 2125];[2130 2145];[1850 1880];[2145 2170];[2555 2575];[2575 2635];[2635 2655];
[2402 2422];[2407 2427];[2412 2432];[2417 2437];[2422 2442];[2427 2447];[2432 2452];[2437 2457];[2442 2462];[2447 2467];[2452 2472];[2457 2472];[2462 2482]];
%band = 1e6*[[870 880];[935 960];[1805 1840];[1840 1875];[2110 2170];[2400 2483];[2555 2655]];
[m, n] = size(band); %波段数和波段起止频率
file_number = size(dir(data_path));  %路径下文件数量
res_rmse = []; %均方根 结果存放
res_sr = [];   %平方和的根 结果存放
res_peak = [];  %平均值 结果存放
for j = 1:2   %遍历两个trace
    for i = 1:file_number-2
        %加载波形
        file=dir([data_path num2str(i) ';*']);
        dat = load([data_path, file.name]);   
        fieldname = fieldnames(dat);   %获取字段名
        name = fieldname{1};
        yuan = getfield(dat, name);    %根据字段名读取数据
        %提取波形1或2
        if j ==1
            trace = yuan(145:32145, 1:2); 
            %换算成mV/m
            Vm = trace;
            Vm(:,1) = (10.^(trace(:,1)./20))/1000;
        else
            trace = yuan(32151:64151, 1:2);
            %换算成mV/m
            Vm = trace;
            Vm(:,1) = (10.^(trace(:,1)./20))/1000;
        end
  
        %遍历band
        for b = 1:m
            start_band = band(b,1); 
            end_band = band(b,2);
            F = find((Vm(:,2)<=end_band) & (Vm(:,2)>=start_band)); %找到符合band条件行索引
            tra = Vm(F,:); %取出对应的波形数据

            %均方根
            rmse = sqrt(sum(tra(:,1).^2)/(end_band-start_band)*1e6);
            res_rmse(i, b) = rmse;  %计算结果存放回band矩阵
            %平方和的根
            sr = sqrt(sum(tra(:,1).^2));
            res_sr(i, b) = sr;  %计算结果存放回band矩阵
            %信道峰值
            peak = max(tra(:,1));
            res_peak(i,b) = peak;
        end 
    end
    %%保存
    if j == 1 
        save(['E:\Desktop\dianci\Python_code\mat\mat_python\spec_cal_result\20210816\trace1\res_SR_band.mat'],'res_sr')
        save(['E:\Desktop\dianci\Python_code\mat\mat_python\spec_cal_result\20210816\trace1\res_RMSE_band.mat'],'res_rmse')
        save(['E:\Desktop\dianci\Python_code\mat\mat_python\spec_cal_result\20210816\trace1\res_PEAK_band.mat'],'res_peak')
    else
        save(['E:\Desktop\dianci\Python_code\mat\mat_python\spec_cal_result\20210816\trace2\res_SR_band.mat'],'res_sr')
        save(['E:\Desktop\dianci\Python_code\mat\mat_python\spec_cal_result\20210816\trace2\res_RMSE_band.mat'],'res_rmse')
        save(['E:\Desktop\dianci\Python_code\mat\mat_python\spec_cal_result\20210816\trace2\res_PEAK_band.mat'],'res_peak')
    end  
end

%% 加载一帧频谱
data_path = 'E:\Desktop\dianci\sample_data\20210816\spec_mat\'; 
data_name = '189;SPECTRUM;16-Aug-2021 21_20_23';
dat = load([data_path data_name]);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
yuan = getfield(dat, name);    %根据字段名读取数据

trace = yuan(32151:64151, 1:2);
Vm = trace;
Vm(:,1) = (10.^(trace(:,1)./20))/1000;
figure('color','w');
plot(Vm(:,2), Vm(:,1));


%% 从mat加载计算结果
data_path = 'E:\Desktop\dianci\Python_code\mat\mat_python\spec_cal_result\20210816\trace1\'; 
data_name = 'res_RMSE.mat';
dat = load([data_path data_name]);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
rmse = getfield(dat, name);    %根据字段名读取数据

data_name = 'res_SR.mat';
dat = load([data_path data_name]);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
sr = getfield(dat, name);    %根据字段名读取数据
[m, n] = size(sr)

data_name = 'res_PEAK_band.mat';
dat = load([data_path data_name]);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
peak = getfield(dat, name);    %根据字段名读取数据
[m, n] = size(sr)



%% 
aa = peak;
gsm900 = sqrt(sum(aa(:,1:4).^2,2));
dcs1800 = sqrt(sum(aa(:,5:6).^2,2));
utms2100 = sqrt(sum(aa(:,7:9).^2,2));
fdd_lte = sqrt(sum(aa(:,10:11).^2,2));
tdd_lte = sqrt(sum(aa(:,11:14).^2,2));
wifi = sqrt(sum(aa(:,15:end).^2,2));
bandtable = [gsm900 dcs1800 utms2100 fdd_lte tdd_lte wifi];

%%时间序列
[m, n] = size(bandtable);
N0=datenum([0 0 0 0 0 0]); %起始时间 
timecrease = 24*60/m;
dN=datenum([0 0 0 0 timecrease 0]); %时间增量，1分钟
N=N0+(0:m-1)*dN; %根据数据点数，产生间隔时间点
figure('color','w');
for i =1:n
    plot(N,20*log(bandtable(:,i)),color(i), 'Linewidth', 1.5);
    if i==1
        hold on;
    end
end
datetick(gca,'x','HH:MM');
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格
h = legend('GSM900', 'DCS1800', 'UTMS2100', 'FDD LTE', 'TDD LTE', 'WIFI','northeast');
set(h, 'FontSize', 15);
xlabel('Time','FontSize',20);
ylabel('E[dBmV/m]','FontSize',20);

%%boxplot
figure('color','w');
temp = {'GSM900', 'DCS1800', 'UTMS2100', 'FDD LTE', 'TDD LTE', 'WIFI'};
boxplot(20*log(bandtable),'Notch','marker','Labels',temp,'Whisker',1)
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格
%title('example');
ylabel('E[dBmV/m]','FontSize',20);


%%密度分布图
figure('color','w');
color = ['r','g','b','k','m','c','y'];
[m, n] = size(bandtable);
for i =1:n
    [f,xi] = ksdensity(20*log(bandtable(:,i)));
    plot(xi,f, color(i), 'Linewidth', 1.5);
    if i==1
        hold on;
    end
end
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格
h = legend('GSM900', 'DCS1800', 'UTMS2100', 'FDD LTE', 'TDD LTE', 'WIFI','northeast');
set(h, 'FontSize', 20);
xlabel('E[dBmV/m]','FontSize',20);
ylabel('Density','FontSize',20);

%%所有波段总体
[m, n] = size(bandtable);
total = sqrt(sum(bandtable(:,1:n).^2,2));
figure('color','w');
plot(N,20*log(total),'black', 'Linewidth', 1.5);
datetick(gca,'x','HH:MM');
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格
xlabel('Time','FontSize',20);
ylabel('E[dBmV/m]','FontSize',20);

%% 按窗口分段计算box
aa = bandtable;

a1(1:73,1:n) = 20*log(aa(1:73,:)); %0-8小时数据
a2(1:152-74+1, 1:n) = 20*log(aa(74:152,:));
a3(1:213-153+1, 1:n) = 20*log(aa(153:213,:));

%%boxplot
figure('color','w');
[m, n] = size(aa);
temp = {'GSM900', 'DCS1800', 'UTMS2100', 'FDD LTE', 'TDD LTE', 'WIFI'};
%title('example');
subplot(3,1,1);
boxplot(a1,'Notch','marker','Labels',temp,'Whisker',1)
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格
%ylim([-0.2,4]);
ylabel('E[dBmV/m]','FontSize',20);

subplot(3,1,2);
boxplot(a2,'Notch','marker','Labels',temp,'Whisker',1)
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格
%ylim([-0.2,4]);
ylabel('E[dBmV/m]','FontSize',20);

subplot(3,1,3);
boxplot(a3,'Notch','marker','Labels',temp,'Whisker',1)
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格
%ylim([-0.2,4]);
ylabel('E[dBmV/m]','FontSize',20);

%% 绘制各频段结果  旧！！！！
aa = peak;
[m, n] = size(aa);
color = ['r','g','b','k','m','c','y'];
figure('color','w');
for i =1:n
    plot(aa(:,i),color(i));
    if i==1
        hold on;
    end
end
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格
h = legend('band1','band2','band3','band4','band5','band6','band7','northeast');
set(h, 'FontSize', 20);

%%boxplot
figure('color','w');
[m, n] = size(band);
temp = cell(1,m);
for i = 1:m
    temp{i} = [num2str(band(i,1)/1e6) 'MHz to ' num2str(band(i,2)/1e6) 'MHz'];
end
boxplot(20*log(aa),'Notch','marker','Labels',temp,'Whisker',1)
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格
%title('example');
ylabel('E[dBmV/m]','FontSize',20);

%%密度分布图
figure('color','w');
[m, n] = size(aa);
for i =1:n
    [f,xi] = ksdensity(aa(:,i));
    plot(xi,f, color(i), 'Linewidth', 1.5);

%     [mu,sigma] = normfit(aa(:,i));
%     d=pdf('norm',aa(:,i),mu,sigma);
%     plot(aa(:,i),d,'.');
%     xlim([0,1.5]);
    if i==1
        hold on;
    end
end
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格
h = legend('band1','band2','band3','band4','band5','band6','band7','northeast');
set(h, 'FontSize', 20);