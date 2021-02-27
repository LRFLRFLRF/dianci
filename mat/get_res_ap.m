function get_res_ap()
    %从小波GUI工具箱获得的结点construct波形  
    %生成对应的res波形和den波形的xls文件
    
    yuan_data_name = '106to114_oneDim';
    node_data_name = 'wp_4_0_rec';      %得到变量名字符串
    
    
    %加载原始波形
    dat = load([yuan_data_name, '.mat']);   
    fieldname = fieldnames(dat);   %获取字段名
    name = fieldname{1};
    data_yuan = getfield(dat, name);    %根据字段名读取数据

    %加载结点construct波形
    dat = load([node_data_name, '.mat']);      
    fieldname = fieldnames(dat);   %获取字段名
    name = fieldname{1};
    data_node = getfield(dat, name)';


    %写入excel
    xlswrite(['E:\Desktop\dianci\Python_code\mat\', node_data_name, '_DEN.xls'], data_node)    %写入指定结点的 construc波形

    res = data_yuan - data_node;
    xlswrite(['E:\Desktop\dianci\Python_code\mat\', node_data_name, '_RES.xls'], res)    %写入指定结点的 残差波形
end

