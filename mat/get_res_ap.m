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
    
    data_yuan = data_yuan(23:end,:);    % ��1��6�ŵ�����ɾ������������������������������Բ���
    
    %���ؽ��construct����
    dat = load([node_data_path, node_data_name, '.mat']);      
    fieldname = fieldnames(dat);   %��ȡ�ֶ���
    name = fieldname{1};
    data_node = getfield(dat, name)';
    

    %% д��excel
    write_date_den = [data_yuan(:,1:5) data_node];  %ƴ��ԭ���ǰ����ʱ������
    xlswrite(['E:\Desktop\dianci\Python_code\mat\mat_xls_file\', node_data_name, '_DEN.xls'], write_date_den)    %д��ָ������ construc����

    res = data_yuan(:,6) - data_node; %����в�
    write_date_res = [data_yuan(:,1:5) res];
    xlswrite(['E:\Desktop\dianci\Python_code\mat\mat_xls_file\', node_data_name, '_RES.xls'], write_date_res)    %д��ָ������ �в��

%% ��ͼ
figure('color','w');
plot(data_yuan(:,6) , 'color', 'black', 'LineWidth', 1.0);
hold on;
plot(data_node , 'color', 'red', 'LineWidth', 1.5);
%title('ԭʼ�糡ǿ���ź�������ź�','FontSize',18);
h = legend('The raw signal','The approximate signal','Location', 'northwest');
set(h, 'FontSize', 15);
ylim([0.15,1]);
xlim([0,7*240]);
xlabel('Time[Day]','fontsize',20);
ylabel('E[V/m]','fontsize',20);
set(gca,'XTick',1:240:240*7,'fontsize',20);
set(gca,'XTicklabel',{'1','2','3','4','5','6','7','8'})
set(gca, 'XGrid', 'on');% ��ʾ����
set(gca, 'YGrid', 'on');% ��ʾ����
end

