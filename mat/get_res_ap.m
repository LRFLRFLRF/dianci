function get_res_ap()
    %从小波GUI工具箱获得的结点construct波形  
    %生成对应的res波形和den波形的xls文件
    
    yuan_data_path = 'E:\Desktop\dianci\Python_code\mat\';  %106to114_oneDim 文件路径
    node_data_path = 'E:\Desktop\dianci\Python_code\mat\mat_xls_file\';    %node文件路径
    yuan_data_name = '106to114';
    node_data_name = 'wp_4_db8_rec';      %得到变量名字符串
    
    
    %加载原始波形
    dat = load([yuan_data_path, yuan_data_name, '.mat']);   
    fieldname = fieldnames(dat);   %获取字段名
    name = fieldname{1};
    data_yuan = getfield(dat, name);    %根据字段名读取数据

    %加载结点construct波形
    dat = load([node_data_path, node_data_name, '.mat']);      
    fieldname = fieldnames(dat);   %获取字段名
    name = fieldname{1};
    data_node = getfield(dat, name)';


    %写入excel
    write_date_den = [data_yuan(:,1:5) data_node];  %拼接原表格前五列时间数据
    xlswrite(['E:\Desktop\dianci\Python_code\mat\mat_xls_file\', node_data_name, '_DEN.xls'], write_date_den)    %写入指定结点的 construc波形

    res = data_yuan(:,6) - data_node; %计算残差
    write_date_res = [data_yuan(:,1:5) res];
    xlswrite(['E:\Desktop\dianci\Python_code\mat\mat_xls_file\', node_data_name, '_RES.xls'], write_date_res)    %写入指定结点的 残差波形
end

