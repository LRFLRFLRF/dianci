%% ����python�ز�����ԭ���У��������У��в�����
filepath = 'E:\Desktop\dianci\Python_code\mat\mat_python\';
filename = {'app_7_13_12min', 'res_7_13_12min', 'sig_7_13_12min'};
index = 1;  %�޸ĳ� 1 2 3   �ֱ��app res sig ��mat��
data_1 = xlsread([filepath,filename{index},'.xlsx']);
save(['E:\Desktop\dianci\Python_code\mat\mat_python\' filename{index} '.mat'],'data_1')

%% ����python single sarima sumԤ������
filepath = 'E:\Desktop\dianci\Python_code\mat\mat_python\';
filename = {'single_sarima_pred'};
index_pred = 1;  %�޸ĳ� 1 2 3   �ֱ��app res sig ��mat��
data_1 = xlsread([filepath,filename{index_pred},'.xlsx']);
save(['E:\Desktop\dianci\Python_code\mat\mat_python\' filename{index_pred} '.mat'],'data_1')

%% ����6minԭ����
filepath = 'E:\Desktop\dianci\Python_code\mat\mat_xls_file\';
filename = {'sig'};
index_pred = 1;  %�޸ĳ� 1 2 3   �ֱ��app res sig ��mat��
data_1 = xlsread([filepath,filename{index_pred},'.xls']);
save(['E:\Desktop\dianci\Python_code\mat\mat_xls_file\' filename{index_pred} '.mat'],'data_1')

%% ����python sumԤ������ 10steps
filepath = 'E:\Desktop\dianci\Python_code\mat\mat_python\';
filename = {'sum_pred_10step'};
index_pred = 1;  %�޸ĳ� 1 2 3   �ֱ��app res sig ��mat��
data_1 = xlsread([filepath,filename{index_pred},'.xlsx']);
save(['E:\Desktop\dianci\Python_code\mat\mat_python\' filename{index_pred} '.mat'],'data_1')

%% ����python sumԤ������ 5steps
filepath = 'E:\Desktop\dianci\Python_code\mat\mat_python\';
filename = {'sum_pred_5step'};
index_pred = 1;  %�޸ĳ� 1 2 3   �ֱ��app res sig ��mat��
data_1 = xlsread([filepath,filename{index_pred},'.xlsx']);
save(['E:\Desktop\dianci\Python_code\mat\mat_python\' filename{index_pred} '.mat'],'data_1')

%% ����python sumԤ������ 3step
filepath = 'E:\Desktop\dianci\Python_code\mat\mat_python\';
filename = {'sum_pred_3step'};
index_pred = 1;  %�޸ĳ� 1 2 3   
data_1 = xlsread([filepath,filename{index_pred},'.xlsx']);
save(['E:\Desktop\dianci\Python_code\mat\mat_python\' filename{index_pred} '.mat'],'data_1')

%% ����python sumԤ������ 1step
filepath = 'E:\Desktop\dianci\Python_code\mat\mat_python\';
filename = {'sum_pred_1step'};
index_pred = 1;  %�޸ĳ� 1 2 3   
data_1 = xlsread([filepath,filename{index_pred},'.xlsx']);
save(['E:\Desktop\dianci\Python_code\mat\mat_python\' filename{index_pred} '.mat'],'data_1')

%% ����python appԤ������
filepath = 'E:\Desktop\dianci\Python_code\mat\mat_python\';
filename = {'app_sarima_212_010_pred'};
index_pred = 1;  %�޸ĳ� 1 2 3   �ֱ��app res sig ��mat��
data_1 = xlsread([filepath,filename{index_pred},'.xlsx']);
save(['E:\Desktop\dianci\Python_code\mat\mat_python\' filename{index_pred} '.mat'],'data_1')

%% ����python resԤ������
filepath = 'E:\Desktop\dianci\Python_code\mat\mat_python\';
filename = {'res_arima_602_pred'};
index_pred = 1;  %�޸ĳ� 1 2 3   �ֱ��app res sig ��mat��
data_1 = xlsread([filepath,filename{index_pred},'.xlsx']);
save(['E:\Desktop\dianci\Python_code\mat\mat_python\' filename{index_pred} '.mat'],'data_1')

%% ����python lstmԤ������
filepath = 'E:\Desktop\dianci\Python_code\mat\mat_python\';
filename = {'lstm_onepoint'};
index_pred = 1;  %�޸ĳ� 1 2 3 
data_1 = xlsread([filepath,filename{index_pred},'.xlsx']);
save(['E:\Desktop\dianci\Python_code\mat\mat_python\' filename{index_pred} '.mat'],'data_1')

%% ����r����csv
filepath = 'E:\Desktop\dianci\Python_code\mat\xls_r\';
filename = {'app_diff1'};
index_r = 1;  %�޸ĳ� 1 2 3 
data_1 = csvread([filepath,filename{index_r},'.csv']);
save(['E:\Desktop\dianci\Python_code\mat\xls_r\' filename{index_r} '.mat'],'data_1')

%% ����6min������ֵ
filepath = 'E:\Desktop\dianci\sample_data\apartment\result\';
filename = {'20210106-20210110-rms.xls', '20210110-20210112-rms.xls', '20210112-20210114-rms.xls'};

data = [];
for file=filename
    d = xlsread([filepath,file{1}]);
    data = [data; d];
end

data_1 = data(:,6);  %rms_val��������
save('E:\Desktop\dianci\Python_code\mat\106to114.mat','data');
save('E:\Desktop\dianci\Python_code\mat\106to114_oneDim.mat','data_1')

%% ����15sԭʼ����
filepath = 'E:\Desktop\dianci\sample_data\apartment\result\';
filename = {'20210106-20210110-thin.xls', '20210110-20210112-thin.xls', '20210112-20210114-thin.xls', '20210114-20210116-thin.xls'};

data = [];
for file = filename
    d = xlsread([filepath,file{1}]);
    data = [data; d];
end

data_val = data(:, 6);
save('E:\Desktop\dianci\Python_code\mat\106to114_15s.mat','data');
save('E:\Desktop\dianci\Python_code\mat\106to114_oneDim_15s.mat','data_val')

%% ����spec csv�ļ���mat
filepath = 'E:\Desktop\dianci\sample_data\20210808\spectrum_csv1\';
%filename = {'8;SPECTRUM;08-Aug-2021 13_44_05'};

file_number = size(dir(filepath))  %·�����ļ�����
%����csv�ļ���mat
for i = 11565:file_number
    file=dir([filepath num2str(i) ';*']); 
    data_1 = xlsread([filepath,file.name]);
    save(['E:\Desktop\dianci\Python_code\mat\mat_python\spec_mat\' file.name(1:end-4) '.mat'],'data_1')
end