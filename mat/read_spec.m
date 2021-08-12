%% 加载spec csv文件至mat
filepath = 'E:\Desktop\dianci\sample_data\20210808\spectrum_csv1\';
filename = {'11705;SPECTRUM;08-Aug-2021 20_50_10'};
index = 1;  %修改成 1 2 3   分别存app res sig 到mat里
data_1 = xlsread([filepath,filename{index},'.csv']);
save(['E:\Desktop\dianci\Python_code\mat\mat_python\spec_mat\' filename{index} '.mat'],'data_1')

%% 显示spec_mat
data_path = 'E:\Desktop\dianci\Python_code\mat\mat_python\spec_mat\';  
data_name = '11705;SPECTRUM;08-Aug-2021 20_50_10';
%加载波形
dat = load([data_path, data_name, '.mat']);   
fieldname = fieldnames(dat);   %获取字段名
name = fieldname{1};
yuan = getfield(dat, name);    %根据字段名读取数据

trace1 = yuan(145:32145, 1:2);
%trace2 = yuan(32151:64151, 1:2);

Vm1 = (10.^(trace1(:,1)./20))/1000000;

figure();
plot(trace1(:,2), Vm1);
xlim([trace1(1,2),trace1(end,2)]);

wideVm1 = sqrt(sum(Vm1.^2))
wideVm1 = Vm1

