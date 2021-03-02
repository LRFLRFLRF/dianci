# -*- coding: utf-8 -*-
import pandas as pd
import os

filename = 'F:\\Desktop\\dianci\\sample_data\\apartment\\20210112-20210114.xls'
r_filepath = filename.rsplit("\\", 1)


df = pd.read_excel(filename)#, index_col = 'frame_id'
#df.index.name = 'frame_id'

data = {'frame_id':[], 'month':[], 'day':[], 'hour':[], 'minute':[], 'second':[], 'val':[]}
df1 = pd.DataFrame(data)
'''
########err=2的数据填入拟合值
for row_index, row in df.iterrows():
    if row['err_frame'] == 2:
        #找到连续err的帧
        i = 0
        while 1:
            if df.loc[row_index + i, 'err_frame'] != 2:
                break
            i = i + 1

        ##计算拟合值
        val = 0
        if i <= 3:   #err连续错误数小于4，根据前五次，后五次算平均

            for j in range(5):
                val = val + df.loc[row_index - 1 - j, 'val'] + df.loc[row_index + i + j, 'val']

            val = val / 10
            #val = df.loc[row_index, 'val']
        else:
            for j in range(20):
                val = val + df.loc[row_index - 1 - j, 'val'] + df.loc[row_index + i + j, 'val']
            val = val / 40

        #插入值到dataframe
        for k in range(i):
            df.loc[row_index + 1 + k, 'val'] = val

#将修正过err的dataframe存至excel
#df.to_excel("F:\\Desktop\\dianci\\sample_data\\road\\20201223-2road\\result\\20201223time-chang-2road.xls")
'''
#########数据抽稀
#判断第一行是否是完整的连续两帧
if abs(df.loc[1, 'second'] - df.loc[0, 'second']) <= 1 or abs(df.loc[1, 'second'] + 60 - df.loc[0, 'second']) <= 1:
    print('起始是连续两帧')
else:
    print('不是连续两帧')
    os.system("pause")

x_size = 19   #代表取df前x_size+1个数 用于判断当前情况
y_size = int((x_size+1)/2)   #取df1前面y_size个数，用于判断  当前情况
df1_index = 0

for row_index, row in df.iterrows():

    val = []
    if row_index >= x_size and row_index % 2 == 1:   #在连续两帧的后一帧时才进行判断
        #print(df1.loc[0:df1_index - 1])
        for i in range(x_size + 1):
            val.append(df.loc[row_index - i, 'val'])
        print(val)

        #当前这连续两帧的值相差很小，则基本认定没有问题，取平均数作为真实值
        if abs(val[x_size] - val[x_size - 1]) < 0.1:
            df1.loc[df1_index] = df.loc[row_index]
            df1.loc[df1_index, 'val'] = (val[x_size] + val[x_size - 1])/2
            print(df1.loc[df1_index])
            df1_index = df1_index + 1

        #当值相差很大时，和前几次进行比较，挑选标准差最小的值作为真实值
        else:
            # 用连续两帧的前一帧进行标准差计算
            df1.loc[df1_index] = df.loc[row_index - 1]
            std0 = df1.loc[df1_index - y_size:df1_index,'val'].std()
            # 用连续两帧的后一帧进行标准差计算
            df1.loc[df1_index] = df.loc[row_index]
            std1 = df1.loc[df1_index - y_size:df1_index, 'val'].std()

            if std0 < std1:      #取标准差更小的作为真实值
                df1.loc[df1_index] = df.loc[row_index - 1]
            df1_index = df1_index + 1
            print(std1)

    elif row_index < x_size:
        #手动把起始的x_size/2长度的帧填到df1中
        if row_index % 2 == 0:
            df1.loc[df1_index] = df.loc[row_index]
            df1_index = df1_index + 1

df1.to_excel("F:\\Desktop\\dianci\\sample_data\\apartment\\result\\20210112-20210114-thin.xls")