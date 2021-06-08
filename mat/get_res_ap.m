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
    
    data_yuan = data_yuan(23:end,:);    % 把1月6号的数据删除掉！！！！！！！！！！！否则对不齐
    
    %加载结点construct波形
    dat = load([node_data_path, node_data_name, '.mat']);      
    fieldname = fieldnames(dat);   %获取字段名
    name = fieldname{1};
    data_node = getfield(dat, name)';
    

    %% 写入excel
    write_date_den = [data_yuan(:,1:5) data_node];  %拼接原表格前五列时间数据
    xlswrite(['E:\Desktop\dianci\Python_code\mat\mat_xls_file\', node_data_name, '_DEN.xls'], write_date_den)    %写入指定结点的 construc波形

    res = data_yuan(:,6) - data_node; %计算残差
    write_date_res = [data_yuan(:,1:5) res];
    xlswrite(['E:\Desktop\dianci\Python_code\mat\mat_xls_file\', node_data_name, '_RES.xls'], write_date_res)    %写入指定结点的 残差波形

%% 绘图
figure('color','w');
plot(data_yuan(:,6) , 'color', 'black', 'LineWidth', 1.0);
hold on;
plot(data_node , 'color', 'red', 'LineWidth', 1.5);
%title('原始电场强度信号与近似信号','FontSize',18);
h = legend('The raw signal','The approximate signal','Location', 'northwest');
set(h, 'FontSize', 15);
ylim([0.15,1]);
xlim([0,7*240]);
xlabel('Time[Day]','fontsize',20);
ylabel('E[V/m]','fontsize',20);
set(gca,'XTick',1:240:240*7,'fontsize',20);
set(gca,'XTicklabel',{'1','2','3','4','5','6','7','8'})
set(gca, 'XGrid', 'on');% 显示网格
set(gca, 'YGrid', 'on');% 显示网格
end

