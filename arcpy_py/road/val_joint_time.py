#coding=gbk
import arcpy
import math
import pandas as pd
from datetime import datetime
import numpy as np

#读取Excel
hour_offset = 8  #GPS航点数据hour慢了八小时
val_path = 'F:\\Desktop\\dianci\\sample_data\\road\\20201231-road\\20201231time-chang-road.xls'
df = pd.read_excel(val_path)
df_datetime_list = []
#遍历计算datetime，方便后续根据时间差将val归类至附近GPS航点
for index, row in df.iterrows():
    datetime_new = datetime(2020, int(row['month']), int(row['day']),
                            int(row['hour'] - hour_offset), int(row['minute']), int(row['second']))
    df_datetime_list.append([datetime_new, index])
print(df_datetime_list)

#加载环境配置
arcpy.env.outputCoordinateSystem = arcpy.SpatialReference("WGS 1984 UTM Zone 50N")
arcpy.env.workspace = "F:\Desktop\dianci\GIS_dianci\GIS_dianci.gdb"
arcpy.env.overwriteOutput = True
#加载GPS数据
fc = "F:/Desktop/dianci/GIS_dianci/GIS_dianci.gdb/c20201231_road"
row_cursor = arcpy.UpdateCursor(fc)
#向属性表添加val字段和frame_id字段
arcpy.DeleteField_management(fc, 'val')
arcpy.DeleteField_management(fc, 'frame_id')
arcpy.AddField_management(fc, 'val', 'FLOAT')
arcpy.AddField_management(fc, 'frame_id')
cur_last_time = []
i = 0
#遍历GPS点
for cursor in row_cursor:
    #更新第一个cur_last_time为第一行的datetime
    if i == 0:
        cur_last_time.append(cursor.getValue('DateTime'))
        i = 1
    time = cursor.getValue('DateTime')

    #计算前后两点间时间差
    delta = (time - cur_last_time[0])
    delta1 = (cur_last_time[0] - time)
    print('两点时间差：' + str(delta.seconds))

    cur_last_time[0] = time  #更新上次值为当前
    #找到符合条件的图片，存入a  a[0]为datetime  a[1]为df的index
    a = []
    for x in df_datetime_list:
        if (x[0] - time).seconds <= delta.seconds or (x[0] - time).seconds >= 86399 - delta.seconds + 1:
            a.append(x)
    print(a)

    #从符合条件的值中取最大值
    val = []
    for y in a:
        val.append(df.loc[y[1], 'val'])
    if val:  #防止val list是空的  用max会报错   如果为空则输出val=0  frame_id=0
        max_val = max(val) #最大值
        val_index = val.index(max(val))
        te = a[val_index][1]
        cursor.setValue('frame_id', int(df.loc[te, 'frame_id']))
    else:
        max_val = 0
        cursor.setValue('frame_id', int(0))

    #向val字段写入最大值  frame_id字段写入最大值所对应的图片id
    cursor.setValue('val', max_val)
    row_cursor.updateRow(cursor)

    print(time)



