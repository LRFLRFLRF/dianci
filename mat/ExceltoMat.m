%% 加载6min均方根值
filepath = 'E:\Desktop\dianci\sample_data\apartment\result\';
filename = {'20210106-20210110-rms.xls', '20210110-20210112-rms.xls', '20210112-20210114-rms.xls'};

data = [];
for file=filename
    d = xlsread([filepath,file{1}]);
    data = [data; d];
end

data_1 = data(:,6);  %rms_val单列数据
save('E:\Desktop\dianci\Python_code\mat\106to114.mat','data');
save('E:\Desktop\dianci\Python_code\mat\106to114_oneDim.mat','data_1')

%% 加载15s原始数据
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