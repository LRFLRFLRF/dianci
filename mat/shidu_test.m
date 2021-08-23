%% ������ʪ�Ȳ��� csv�ļ���mat
filepath = 'E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\';
filename = {'resample_6'};
index_r = 1;  %�޸ĳ� 1 2 3 
data_1 = csvread([filepath,filename{index_r},'.csv']);
save(['E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\' filename{index_r} '.mat'],'data_1')

%% ����Ԥ����csv ��mat
filepath = 'E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\';
filename = {'pred_3step', 'pred_5step','pred_10step'};
index_r = 1;  %�޸ĳ� 1 2 3 
data_1 = csvread([filepath,filename{index_r},'.csv']);
save(['E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\' filename{index_r} '.mat'],'data_1')

%% ����ԭ���γ�ϡ��� csv ��mat
filepath = 'E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\';
filename = {'cor_resample'};
index_r = 1;  %�޸ĳ� 1 2 3 
data_1 = csvread([filepath,filename{index_r},'.csv']);
save(['E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\' filename{index_r} '.mat'],'data_1')


%% ����mat
data_path = 'E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\';  

%����δ��������
data_name = 'resample_6';
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %��ȡ�ֶ���
name = fieldname{1};
org = getfield(dat, name);    %�����ֶ�����ȡ����


%������������
data_name = 'cor';
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %��ȡ�ֶ���
name = fieldname{1};
yuan = getfield(dat, name);    %�����ֶ�����ȡ����
%yuan = yuan(:,6);

%���ؽ��construct����
data_name = 'db7_4';
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %��ȡ�ֶ���
name = fieldname{1};
data_node = getfield(dat, name)';
data_node = data_node(:,4);
 %% д��excel  ���������ź� ��Ƶ�ź� �Ͳв���excel
write_sig = yuan;  %ƴ��ԭ����ǰ����ʱ������
xlswrite('E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\cor.xls', write_sig)    %д��ָ������ construc����
 
write_date_den = [yuan(:,1:5) data_node];  %ƴ��ԭ����ǰ����ʱ������
xlswrite(['E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\', data_name, '_DEN.xls'], write_date_den)    %д��ָ������ construc����

res = yuan(:,6) - data_node; %����в�
write_date_res = [yuan(:,1:5) res];
xlswrite(['E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\', data_name, '_RES.xls'], write_date_res)    %д��ָ������ �в��
%% ��������
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
Ymax=max(cor);%�������ֵ
Ymin=min(cor);%������Сֵ
k=(b-a)/(Ymax-Ymin);
cor=a+k*(cor-Ymin);

cor_pinjie = [org(:,1:5) cor];
save('E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\cor.mat','cor_pinjie');

%%����6minԭ����ͼ
figure('color','w');
plot(cor(:,1),'black');
%ylim([0.15,1]);
xlim([0,5*240]);
xlabel('Time[Day]','fontsize',20);
ylabel('E[V/m]','fontsize',20);
set(gca,'XTick',1:240:240*5,'fontsize',20); 
set(gca,'XTicklabel',{'1','2','3','4','5'})
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����


%% ����Ԥ���� mat
data_path = 'E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\';  

%����Ԥ����
data_name = 'pred_10step';
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %��ȡ�ֶ���
name = fieldname{1};
pred = getfield(dat, name);    %�����ֶ�����ȡ����

data_name = 'cor_resample';
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %��ȡ�ֶ���
name = fieldname{1};
yuan_resample = getfield(dat, name);    %�����ֶ�����ȡ����

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
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����

% ���� ����ָ��
observed = yuan_resample(361:361+length(pred)-1);
mape = mean(abs((observed - pred(:,1))./observed))*100
mae = mean(abs(observed - pred(:,1)))
rmse = sqrt(mean((observed - pred(:,1)).^2))
res_junzhi = mean(observed - pred(:,1));
sde = sqrt(mean((observed - pred(:,1) - res_junzhi).^2))
p = corr(observed,pred(:,1),'type','Pearson')