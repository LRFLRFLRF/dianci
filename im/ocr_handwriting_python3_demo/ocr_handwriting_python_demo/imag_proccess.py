import os
from im.ocr_handwriting_python3_demo.ocr_handwriting_python_demo.ocr import get_content
import cv2
import json
import numpy as np
import pandas as pd
import shutil
filePath = 'F:\\Desktop\\dianci\\sample_data\\apartment\\20210112-20210114\\'
#获取文件夹下所有文件
files = os.listdir(filePath)
r_filepath = filePath.rsplit("\\", 2)
errfilepath = r_filepath[0] + '\\err\\' + r_filepath[1] + '-err\\'
abnorm_filepath = r_filepath[0] + '\\abnormal\\' + r_filepath[1] + '-abnormal\\'

isExists=os.path.exists(errfilepath)
if not isExists:
    os.makedirs(errfilepath)
else:
    print(errfilepath + ' 目录已存在')

isExists=os.path.exists(abnorm_filepath)
if not isExists:
    os.makedirs(abnorm_filepath)
else:
    print(abnorm_filepath + ' 目录已存在')


#遍历文件 读取文件名
file_name = []
for file in files:
    te = file.split('.')
    str = te[0].split(';')
    frame_id = int(str[0])
    file_name.append([frame_id, str[1:], file])

new_list = sorted(file_name, key = (lambda x: [x[0], x[1], x[2]]))  #按照frame_id 进行帧排序
print(new_list)


wname = 'img'
a = 0
rows = []
last_frame = {'minute': 0, 'second': 0, 'val': float(0), 'filename': ''}
for file in new_list:

    #if a == 138:
        #break
    #a = a + 1

    err = 0
    img = cv2.imread(filePath + file[2])
    cropped = img[40:200, 20:260]  #剪裁img
    cv2.imwrite('cut.jpg', cropped)
    #显示切割后图片
    cut = cv2.imread('cut.jpg')
    cv2.imshow('cropped_image', cut)
    k = cv2.waitKey(10)
    print(file[0])

    #中断程序保存
    if k == ord('a') or k == ord('A'):
        print('进程停止！！')
        cv2.destroyAllWindows()
        break

    #ocr识别场强值
    try:
        content = get_content('cut.jpg')
        user_dic = json.loads(content)
        val = user_dic['data']['block'][0]['line'][0]['word'][0]['content']
        #时间解析
        [month, day] = file[1][1].split('-')
        [hour, minute, second] = file[1][2].split('-')


        if int(file[0]) == 1:
            last_frame['minute'] = int(minute)
            last_frame['second'] = int(second)
            last_frame['val'] = float(val)
            last_frame['filename'] = file[2]

        if (last_frame['second']+2 >= int(second) and last_frame['minute'] == int(minute)) or (int(second) < 2 and last_frame['second'] > 60-2):
            if last_frame['val'] - float(val) > 0.1:
                #异常帧：
                print(last_frame['val'], float(val))
                print(file[0], '帧异常')
                err = 1
                #将两张异常帧复制到异常帧目录下
                shutil.copy(filePath + file[2], abnorm_filepath + file[2])#当前帧
                shutil.copy(filePath + last_frame['filename'], abnorm_filepath + last_frame['filename'])#上一帧

        rows.append(np.array([int(file[0]), int(month), int(day), int(hour), int(minute), int(second), float(val), int(err)]))

        #更新last_frame
        last_frame['minute'] = int(minute)
        last_frame['second'] = int(second)
        last_frame['val'] = float(val)
        last_frame['filename'] = file[2]

    except ConnectionError:
        continue
    except Exception as m:
        print(m)
        #将错误图片复制到err路径下
        print(file[2] + '错误')
        [month, day] = file[1][1].split('-')
        [hour, minute, second] = file[1][2].split('-')
        rows.append(np.array([int(file[0]), int(month), int(day), int(hour), int(minute), int(second), float(0), int(2)]))
        shutil.copy(filePath + file[2], errfilepath + file[2])
        continue
    else:
        print(val)
        print('\n')


dataframe = pd.DataFrame(rows, columns=['frame_id', 'month', 'day', 'hour', 'minute', 'second', 'val', 'err_frame'])
dataframe.to_excel(r_filepath[0] + '\\' + r_filepath[1] + '.xls', index=False)








