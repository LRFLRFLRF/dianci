%% ��ʾspec_mat
data_path = 'E:\Desktop\dianci\Python_code\mat\mat_python\spec_mat\';  
band = 1e6*[[870 880];[935 960];[1805 1840];[1840 1875];[2110 2170];[2400 2483];[2555 2655]];
[m, n] = size(band); %�������Ͳ�����ֹƵ��
file_number = size(dir(data_path));  %·�����ļ�����
res_rmse = []; %������ ������
res_sr = [];   %ƽ���͵ĸ� ������
for i = 1:file_number
    %���ز���
    file=dir([data_path num2str(i) ';*']);
    dat = load([data_path, file.name]);   
    fieldname = fieldnames(dat);   %��ȡ�ֶ���
    name = fieldname{1};
    yuan = getfield(dat, name);    %�����ֶ�����ȡ����
    %��ȡ����1
    trace1 = yuan(145:32145, 1:2); 
    %�����mV/m
    Vm1 = (10.^(trace1(:,1)./20))/1000;
    
    %����band
    for b = 1:m
        start_band = band(b,1); 
        end_band = band(b,2);
        F = find((trace1(:,2)<=end_band) & (trace1(:,2)>=start_band)); %�ҵ�����band����������
        tra = trace1(F,:); %ȡ����Ӧ�Ĳ�������
        
        %������
        rmse = sqrt(sum(tra(:,1).^2)/(end_band-start_band)*1e6);
        res_rmse(i, b) = rmse;  %��������Ż�band����
        
        %ƽ���͵ĸ�
        sr = sqrt(sum(tra(:,1).^2));
        res_sr(i, b) = sr;  %��������Ż�band����
    end
end

%% ����
save(['E:\Desktop\dianci\Python_code\mat\mat_python\spec_cal_result\res_SR.mat'],'res_sr')
save(['E:\Desktop\dianci\Python_code\mat\mat_python\spec_cal_result\res_RMSE.mat'],'res_rmse')

%% ��mat���ؼ�����
data_path = 'E:\Desktop\dianci\Python_code\mat\mat_python\spec_cal_result\'; 
data_name = 'res_RMSE.mat';
dat = load([data_path data_name]);   
fieldname = fieldnames(dat);   %��ȡ�ֶ���
name = fieldname{1};
rmse = getfield(dat, name);    %�����ֶ�����ȡ����

data_name = 'res_SR.mat';
dat = load([data_path data_name]);   
fieldname = fieldnames(dat);   %��ȡ�ֶ���
name = fieldname{1};
sr = getfield(dat, name);    %�����ֶ�����ȡ����
[m, n] = size(sr)

%% ���Ƹ�Ƶ��RMSE���
[m, n] = size(sr);
color = ['r','g','b','k','m','c','y'];
figure('color','w');
for i =1:n
    plot(sr(:,i),color(i));
    if i==1
        hold on;
    end
end
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����
h = legend('band1','band2','band3','band4','band5','band6','band7','northeast');
set(h, 'FontSize', 15);

%%boxplot
figure('color','w');
[m, n] = size(band);
temp = cell(1,m);
for i = 1:m
    temp{i} = [num2str(band(i,1)/1e6) 'MHz to ' num2str(band(i,2)/1e6) 'MHz'];
end
boxplot(sr,'Notch','marker','Labels',temp,'Whisker',1)
title('example')

%% �ܶȷֲ�ͼ
figure('color','w');
[m, n] = size(sr);
for i =1:n
    [f,xi] = ksdensity(sr(:,i));
    plot(xi,f, color(i), 'Linewidth', 1.5);
    if i==1
        hold on;
    end
end
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����
h = legend('band1','band2','band3','band4','band5','band6','band7','northeast');
set(h, 'FontSize', 15);

