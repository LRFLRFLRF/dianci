# -*- coding: utf-8 -*-
import pandas as pd
import os
import math
from datetime import datetime
#新建DataFrame
df1_index = 0
data = {'frame_id': [], 'month': [], 'day': [], 'hour': [], 'minute': [], 'second': [], 'val': []}
df1 = pd.DataFrame(data)

#加载数据
filepath = 'F:\\Desktop\\dianci\\sample_data\\apartment\\result\\'
df = []
file_list = ["20201128time-chang-thin", "20201129time-chang-thin", "20201130time-chang-thin",
             "20201201time-chang-thin", "20201202time-chang-thin", "20201203time-chang-thin",
             "20201204time-chang-thin", "20201205time-chang-thin"]
'''
###拼接多天数据至一张表
for file in file_list:
    #加载所有excel
    df.append(pd.read_excel(filepath + file + '.xls'))

#拼接数据
for dataframe in df:
    for row in range(dataframe.shape[0]):
        df1.loc[df1_index] = dataframe.loc[row]
        df1_index = df1_index + 1

#df1.sort_values(by=['frame_id'])
df1.to_excel(filepath + "20201128-20201205time-chang" + '-joint.xls')  #生成拼接表
'''
#####取6min均方根####
#加载joint后的数据
filename_joint = filepath + "20210112-20210114-thin" + '.xls'
jo_df = pd.read_excel(filename_joint)

#新建方均根的df表
rms_data = {'month': [], 'day': [], 'hour': [], 'minute': [], 'rms_val': [], 'datetime': []}
rms_df = pd.DataFrame(rms_data)
rms_index = 0

row_data = jo_df.loc[0, :].to_dict()
data_list = []
minute_record = row_data['minute']  #初值设置
#遍历数据表
for row in range(jo_df.shape[0]):

    if (jo_df.loc[row, 'minute'] != row_data['minute']):
        continue

    #查询同一分钟内的所有帧
    a = jo_df.loc[(jo_df['month'] == row_data['month']) & (jo_df['day'] == row_data['day'])
                  & (jo_df['hour'] == row_data['hour']) & (jo_df['minute'] == row_data['minute'])]
    data_list.append(a)

    print(a)

    #将数据表拼接成6min一段，并进行均方根计算
    if (a.loc[row, 'minute'] - minute_record == 6-1) or (a.loc[row, 'minute'] - minute_record == -54-1):
        minute_record = a.loc[row, 'minute'] + 1  #更新新的时间刻度值

        #求均方根
        sum_all = 0
        for d in data_list:
            temp = map(lambda x: float(x)**2, d['val'].to_list())
            sum_all = sum_all + sum(temp)

        #6min钟内帧总数
        rms_num = sum(map(lambda y: y.shape[0], data_list))
        rms = math.sqrt(float(sum_all / rms_num))
        print(rms)
        if rms>1:
            print(rms)

        # dt [2021, month, day, hour, minute]
        dt = [2021, data_list[0].iat[0, 2], data_list[0].iat[0, 3], data_list[0].iat[0, 4], data_list[0].iat[0, 5]]

        #创建datetime
        datetime_new = datetime(dt[0], dt[1], dt[2], dt[3], dt[4])

        #写入rms_pd
        #rms_df.loc[rms_index, :] = [row_data['month'], row_data['day'], row_data['hour'], data_list[0].iat[0, 5], float(rms)]
        rms_df.loc[rms_index, :] = [dt[1], dt[2], dt[3], dt[4], float(rms), str(datetime_new)]
        rms_index = rms_index + 1

        #清空data_list
        data_list.clear()

    #更新下一组
    del row_data
    if a.tail(1).index.values[0] + 1 >= jo_df.shape[0]:
        break
    row_data = jo_df.iloc[a.tail(1).index.values[0] + 1, :].to_dict()
    del a

rms_df.to_excel(filepath + "20210112-20210114" + '-rms.xls')

