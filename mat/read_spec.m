%% ��ʾspec_mat
data_path = 'E:\Desktop\dianci\sample_data\20210816\spec_mat\';  
band = 1e6*[[870 880];[935 960];[1805 1840];[1840 1875];[2110 2170];[2400 2483];[2555 2655]];
[m, n] = size(band); %�������Ͳ�����ֹƵ��
file_number = size(dir(data_path));  %·�����ļ�����
res_rmse = []; %������ ������
res_sr = [];   %ƽ���͵ĸ� ������
res_peak = [];  %ƽ��ֵ ������
for j = 1:2   %��������trace
    for i = 1:file_number-2
        %���ز���
        file=dir([data_path num2str(i) ';*']);
        dat = load([data_path, file.name]);   
        fieldname = fieldnames(dat);   %��ȡ�ֶ���
        name = fieldname{1};
        yuan = getfield(dat, name);    %�����ֶ�����ȡ����
        %��ȡ����1��2
        if j ==1
            trace = yuan(145:32145, 1:2); 
            %�����mV/m
            Vm = trace;
            Vm(:,1) = (10.^(trace(:,1)./20))/1000;
        else
            trace = yuan(32151:64151, 1:2);
            %�����mV/m
            Vm = trace;
            Vm(:,1) = (10.^(trace(:,1)./20))/1000;
        end
  
        %����band
        for b = 1:m
            start_band = band(b,1); 
            end_band = band(b,2);
            F = find((Vm(:,2)<=end_band) & (Vm(:,2)>=start_band)); %�ҵ�����band����������
            tra = Vm(F,:); %ȡ����Ӧ�Ĳ�������

            %������
            rmse = sqrt(sum(tra(:,1).^2)/(end_band-start_band)*1e6);
            res_rmse(i, b) = rmse;  %��������Ż�band����
            %ƽ���͵ĸ�
            sr = sqrt(sum(tra(:,1).^2));
            res_sr(i, b) = sr;  %��������Ż�band����
            %�ŵ���ֵ
            peak = max(tra(:,1));
            res_peak(i,b) = peak;
        end 
    end
    %%����
    if j == 1 
        save(['E:\Desktop\dianci\Python_code\mat\mat_python\spec_cal_result\20210816\trace1\res_SR.mat'],'res_sr')
        save(['E:\Desktop\dianci\Python_code\mat\mat_python\spec_cal_result\20210816\trace1\res_RMSE.mat'],'res_rmse')
        save(['E:\Desktop\dianci\Python_code\mat\mat_python\spec_cal_result\20210816\trace1\res_PEAK.mat'],'res_peak')
    else
        save(['E:\Desktop\dianci\Python_code\mat\mat_python\spec_cal_result\20210816\trace2\res_SR.mat'],'res_sr')
        save(['E:\Desktop\dianci\Python_code\mat\mat_python\spec_cal_result\20210816\trace2\res_RMSE.mat'],'res_rmse')
        save(['E:\Desktop\dianci\Python_code\mat\mat_python\spec_cal_result\20210816\trace2\res_PEAK.mat'],'res_peak')
    end  
end

%% ����һ֡Ƶ��
data_path = 'E:\Desktop\dianci\sample_data\20210816\spec_mat\'; 
data_name = '189;SPECTRUM;16-Aug-2021 21_20_23';
dat = load([data_path data_name]);   
fieldname = fieldnames(dat);   %��ȡ�ֶ���
name = fieldname{1};
yuan = getfield(dat, name);    %�����ֶ�����ȡ����

trace = yuan(32151:64151, 1:2);
Vm = trace;
Vm(:,1) = (10.^(trace(:,1)./20))/1000;
figure('color','w');
plot(Vm(:,2), Vm(:,1));


%% ��mat���ؼ�����
data_path = 'E:\Desktop\dianci\Python_code\mat\mat_python\spec_cal_result\20210816\trace2\'; 
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

data_name = 'res_PEAK.mat';
dat = load([data_path data_name]);   
fieldname = fieldnames(dat);   %��ȡ�ֶ���
name = fieldname{1};
peak = getfield(dat, name);    %�����ֶ�����ȡ����
[m, n] = size(sr)


%% ���Ƹ�Ƶ�ν��
aa = 20*log(peak);
[m, n] = size(aa);
color = ['r','g','b','k','m','c','y'];
figure('color','w');
for i =1:n
    plot(aa(:,i),color(i));
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
boxplot(aa,'Notch','marker','Labels',temp,'Whisker',1)
%title('example');
ylabel('E[dBmV/m]','FontSize',15);

%%�ܶȷֲ�ͼ
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
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����
h = legend('band1','band2','band3','band4','band5','band6','band7','northeast');
set(h, 'FontSize', 15);

%% �����ڷֶμ���box
%aa = peak;
[m, n] = size(aa);

a1(1:73,1:n) = aa(1:73,:); %0-8Сʱ����
a2(1:152-74+1, 1:n) = aa(74:152,:);
a3(1:213-153+1, 1:n) = aa(153:213,:);

%%boxplot
figure('color','w');
[m, n] = size(band);
temp = cell(1,m);
for i = 1:m
    temp{i} = [num2str(band(i,1)/1e6) 'MHz to ' num2str(band(i,2)/1e6) 'MHz'];
end
title('example');
subplot(3,1,1);
boxplot(a1,'Notch','marker','Labels',temp,'Whisker',1)
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����
%ylim([-0.2,4]);
ylabel('E[mV/m]','FontSize',15);

subplot(3,1,2);
boxplot(a2,'Notch','marker','Labels',temp,'Whisker',1)
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����
%ylim([-0.2,4]);
ylabel('E[mV/m]','FontSize',15);

subplot(3,1,3);
boxplot(a3,'Notch','marker','Labels',temp,'Whisker',1)
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����
%ylim([-0.2,4]);
ylabel('E[mV/m]','FontSize',15);
