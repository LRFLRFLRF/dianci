%% 加载温湿度测试 csv文件至mat
filepath = 'E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\';
filename = {'resample_6'};
index_r = 1;  %修改成 1 2 3 
data_1 = csvread([filepath,filename{index_r},'.csv']);
save(['E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\' filename{index_r} '.mat'],'data_1')

%% 加载预测结果csv 至mat
filepath = 'E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\';
filename = {'pred_3step', 'pred_5step','pred_10step'};
index_r = 1;  %修改成 1 2 3 
data_1 = csvread([filepath,filename{index_r},'.csv']);
save(['E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\' filename{index_r} '.mat'],'data_1')

%% 加载原波形抽稀结果 csv 至mat
filepath = 'E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\';
filename = {'cor_resample'};
index_r = 1;  %修改成 1 2 3 
data_1 = csvread([filepath,filename{index_r},'.csv']);
save(['E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\' filename{index_r} '.mat'],'data_1')


%% 加载mat
data_path = 'E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\';  

%加载未修正数据
data_name = 'resample_6';
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
org = getfield(dat, name);    %根据字段名读取数据


%加载修正后波形
data_name = 'cor';
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
yuan = getfield(dat, name);    %根据字段名读取数据
%yuan = yuan(:,6);

%加载结点construct波形
data_name = 'db7_4';
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
data_node = getfield(dat, name)';
data_node = data_node(:,4);
 %% 写入excel  保存修正信号 低频信号 和残差至excel
write_sig = yuan;  %拼接原表格前五列时间数据
xlswrite('E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\cor.xls', write_sig)    %写入指定结点的 construc波形
 
write_date_den = [yuan(:,1:5) data_node];  %拼接原表格前五列时间数据
xlswrite(['E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\', data_name, '_DEN.xls'], write_date_den)    %写入指定结点的 construc波形

res = yuan(:,6) - data_node; %计算残差
write_date_res = [yuan(:,1:5) res];
xlswrite(['E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\', data_name, '_RES.xls'], write_date_res)    %写入指定结点的 残差波形
%% 数据修正
cor = org(:, 6);
cor(134:156,1) = (1.05-cor(134:156,1))+1.05;
cor(164:185,1) = (1.1-cor(164:185,1))+1.1;
cor(371:414,1) = (1.05-cor(371:414,1))+1.05;
cor(415:455,1) = cor(415:455,1)+0.15;
cor(624:636,1) = (1.15-cor(624:636,1))+1.15;
cor(872:920,1) = (1.05-cor(872:920,1))+1.05;
cor(1059:1131,1) = (1.05-cor(1059:1131,1))+1.05;
cor(1112:1151,1) = (1.1-cor(1112:1151,1))+1.1;
cor(1172:1185,1) = (0.9-cor(1172:1185,1))+0.9;

a=0.25;
b=0.65;
Ymax=max(cor);%计算最大值
Ymin=min(cor);%计算最小值
k=(b-a)/(Ymax-Ymin);
cor=a+k*(cor-Ymin);

cor_pinjie = [org(:,1:5) cor];
save('E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\cor.mat','cor_pinjie');

%%绘制6min原数据图
figure('color','w');
plot(cor(:,1),'black');
%ylim([0.15,1]);
xlim([0,5*240]);
xlabel('Time[Day]','fontsize',20);
ylabel('E[V/m]','fontsize',20);
set(gca,'XTick',1:240:240*5,'fontsize',20); 
set(gca,'XTicklabel',{'1','2','3','4','5'})
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格


%% 加载预测结果 mat
data_path = 'E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\';  

%加载预测结果
data_name = 'pred_10step';
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
pred = getfield(dat, name);    %根据字段名读取数据

data_name = 'cor_resample';
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
yuan_resample = getfield(dat, name);    %根据字段名读取数据

figure('color','w');
plot(yuan_resample,'black');
hold on;
x = [120*3+1:120*3+length(pred)];
plot(x,pred','-r.');
ylim([0.15,0.7]);
xlim([0,5*120]);
xlabel('Time[Day]','fontsize',20);
ylabel('E[V/m]','fontsize',20);
set(gca,'XTick',1:120:120*7,'fontsize',20);
set(gca,'XTicklabel',{'1','2','3','4','5','6','7','8'})
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格

% 计算 整体指标
observed = yuan_resample(361:361+length(pred)-1);
mape = mean(abs((observed - pred(:,1))./observed))*100
mae = mean(abs(observed - pred(:,1)))
rmse = sqrt(mean((observed - pred(:,1)).^2))
res_junzhi = mean(observed - pred(:,1));
sde = sqrt(mean((observed - pred(:,1) - res_junzhi).^2))
p = corr(observed,pred(:,1),'type','Pearson')
