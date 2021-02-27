function get_res_ap()
    %��С��GUI�������õĽ��construct����  
    %���ɶ�Ӧ��res���κ�den���ε�xls�ļ�
    
    yuan_data_name = '106to114_oneDim';
    node_data_name = 'wp_4_0_rec';      %�õ��������ַ���
    
    
    %����ԭʼ����
    dat = load([yuan_data_name, '.mat']);   
    fieldname = fieldnames(dat);   %��ȡ�ֶ���
    name = fieldname{1};
    data_yuan = getfield(dat, name);    %�����ֶ�����ȡ����

    %���ؽ��construct����
    dat = load([node_data_name, '.mat']);      
    fieldname = fieldnames(dat);   %��ȡ�ֶ���
    name = fieldname{1};
    data_node = getfield(dat, name)';


    %д��excel
    xlswrite(['E:\Desktop\dianci\Python_code\mat\', node_data_name, '_DEN.xls'], data_node)    %д��ָ������ construc����

    res = data_yuan - data_node;
    xlswrite(['E:\Desktop\dianci\Python_code\mat\', node_data_name, '_RES.xls'], res)    %д��ָ������ �в��
end

