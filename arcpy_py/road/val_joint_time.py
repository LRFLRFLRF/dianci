#coding=gbk
import arcpy
import math
import pandas as pd
from datetime import datetime
import numpy as np

#��ȡExcel
hour_offset = 8  #GPS��������hour���˰�Сʱ
val_path = 'F:\\Desktop\\dianci\\sample_data\\road\\20201231-road\\20201231time-chang-road.xls'
df = pd.read_excel(val_path)
df_datetime_list = []
#��������datetime�������������ʱ��val����������GPS����
for index, row in df.iterrows():
    datetime_new = datetime(2020, int(row['month']), int(row['day']),
                            int(row['hour'] - hour_offset), int(row['minute']), int(row['second']))
    df_datetime_list.append([datetime_new, index])
print(df_datetime_list)

#���ػ�������
arcpy.env.outputCoordinateSystem = arcpy.SpatialReference("WGS 1984 UTM Zone 50N")
arcpy.env.workspace = "F:\Desktop\dianci\GIS_dianci\GIS_dianci.gdb"
arcpy.env.overwriteOutput = True
#����GPS����
fc = "F:/Desktop/dianci/GIS_dianci/GIS_dianci.gdb/c20201231_road"
row_cursor = arcpy.UpdateCursor(fc)
#�����Ա����val�ֶκ�frame_id�ֶ�
arcpy.DeleteField_management(fc, 'val')
arcpy.DeleteField_management(fc, 'frame_id')
arcpy.AddField_management(fc, 'val', 'FLOAT')
arcpy.AddField_management(fc, 'frame_id')
cur_last_time = []
i = 0
#����GPS��
for cursor in row_cursor:
    #���µ�һ��cur_last_timeΪ��һ�е�datetime
    if i == 0:
        cur_last_time.append(cursor.getValue('DateTime'))
        i = 1
    time = cursor.getValue('DateTime')

    #����ǰ�������ʱ���
    delta = (time - cur_last_time[0])
    delta1 = (cur_last_time[0] - time)
    print('����ʱ��' + str(delta.seconds))

    cur_last_time[0] = time  #�����ϴ�ֵΪ��ǰ
    #�ҵ�����������ͼƬ������a  a[0]Ϊdatetime  a[1]Ϊdf��index
    a = []
    for x in df_datetime_list:
        if (x[0] - time).seconds <= delta.seconds or (x[0] - time).seconds >= 86399 - delta.seconds + 1:
            a.append(x)
    print(a)

    #�ӷ���������ֵ��ȡ���ֵ
    val = []
    for y in a:
        val.append(df.loc[y[1], 'val'])
    if val:  #��ֹval list�ǿյ�  ��max�ᱨ��   ���Ϊ�������val=0  frame_id=0
        max_val = max(val) #���ֵ
        val_index = val.index(max(val))
        te = a[val_index][1]
        cursor.setValue('frame_id', int(df.loc[te, 'frame_id']))
    else:
        max_val = 0
        cursor.setValue('frame_id', int(0))

    #��val�ֶ�д�����ֵ  frame_id�ֶ�д�����ֵ����Ӧ��ͼƬid
    cursor.setValue('val', max_val)
    row_cursor.updateRow(cursor)

    print(time)



