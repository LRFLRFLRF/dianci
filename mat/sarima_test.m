%% ��ȡ�����ź�����
node_data_path = 'E:\Desktop\dianci\Python_code\mat\mat_xls_file\';    %node�ļ�·��
node_data_name = 'wp_4_db8_rec';      %�õ��������ַ���
dat = load([node_data_path, node_data_name, '.mat']);      
fieldname = fieldnames(dat);   %��ȡ�ֶ���
name = fieldname{1};
sig_a = getfield(dat, name)';

%% arima




