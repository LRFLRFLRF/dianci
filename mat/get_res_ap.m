function get_res_ap()
    %��С��GUI�������õĽ��construct����  
    %���ɶ�Ӧ��res���κ�den���ε�xls�ļ�
    
    yuan_data_path = 'E:\Desktop\dianci\Python_code\mat\';  %106to114_oneDim �ļ�·��
    node_data_path = 'E:\Desktop\dianci\Python_code\mat\mat_xls_file\';    %node�ļ�·��
    yuan_data_name = '106to114';
    node_data_name = 'wp_4_db8_rec';      %�õ��������ַ���
    
    
    %����ԭʼ����
    dat = load([yuan_data_path, yuan_data_name, '.mat']);   
    fieldname = fieldnames(dat);   %��ȡ�ֶ���
    name = fieldname{1};
    data_yuan = getfield(dat, name);    %�����ֶ�����ȡ����

    %���ؽ��construct����
    dat = load([node_data_path, node_data_name, '.mat']);      
    fieldname = fieldnames(dat);   %��ȡ�ֶ���
    name = fieldname{1};
    data_node = getfield(dat, name)';


    %д��excel
    write_date_den = [data_yuan(:,1:5) data_node];  %ƴ��ԭ���ǰ����ʱ������
    xlswrite(['E:\Desktop\dianci\Python_code\mat\mat_xls_file\', node_data_name, '_DEN.xls'], write_date_den)    %д��ָ������ construc����

    res = data_yuan(:,6) - data_node; %����в�
    write_date_res = [data_yuan(:,1:5) res];
    xlswrite(['E:\Desktop\dianci\Python_code\mat\mat_xls_file\', node_data_name, '_RES.xls'], write_date_res)    %д��ָ������ �в��
end

