import cv2
import os
import sys
import time
import schedule

def init_func(camera_id):
    cv2.namedWindow("Image")  # 创建窗口
    # 抓取摄像头视频图像
    cap = cv2.VideoCapture(camera_id)  # 创建内置摄像头变量
    path_now = os.getcwd()
    isExists=os.path.exists(path_now + '\\image_item\\')
    if not isExists:
        os.makedirs(path_now + '\\image_item\\')
    file_path = path_now + '\\image_item\\'
    print('图片保存位置：' + file_path)
    print('##############################')
    print()
    print()
    return cap, file_path

def timer_func(arg):
    global acq_time1
    global acq_id
    acq_id = 1
    schedule.every(acq_time1).seconds.do(timer_func_per, arg)


def timer_func_per(arg):
    global acq_time
    global frame_id
    global file_name
    global acq_cishu
    global acq_id
    if acq_id >= acq_cishu:
        #a = schedule.jobs
        schedule.cancel_job(schedule.jobs[1])
    acq_id = acq_id + 1
    localtime = time.strftime("%m-%d;%H-%M-%S", time.localtime())
    file = arg + str(frame_id) + ';' +file_name + ';' + localtime + '.jpg'
    cv2.imwrite(file, img)
    if os.path.isfile(file):
        print('save_ok!         file_name:    ' + str(frame_id) + ';' +file_name + ';' + localtime + '.jpg')
        frame_id = frame_id + 1
    else:
        print('file_no_saved  !!!')


file_name = 'image'
print('请输入采集间隔时间，单位秒')
acq_time = float(sys.stdin.readline())
print('请输入每次采集间隔时间，单位秒')
acq_time1 = float(sys.stdin.readline())
print('请输入每采集周期采集多少次')
acq_cishu = int(sys.stdin.readline())
print('请输入摄像头id -- 自带摄像头：0    usb摄像头：1')
camera_id = int(sys.stdin.readline())
cap, file_path = init_func(camera_id)
print('采集已开始！！        鼠标选中弹出的Image视频窗口，直接键入a或A，即可结束程序！！')
print()
print()
frame_id = 1
acq_id = 1
schedule.every(acq_time).seconds.do(timer_func, file_path)

schedule.every(acq_time1).seconds.do(timer_func_per, file_path)

while (cap.isOpened()):  # isOpened()  检测摄像头是否处于打开状态
    schedule.run_pending()
    ret, img = cap.read()  # 把摄像头获取的图像信息保存之img变量
    if ret == True:  # 如果摄像头读取图像成功
        cv2.imshow('Image', img)
        k = cv2.waitKey(100)
        if k == ord('a') or k == ord('A'):
            print('进程停止！！')
            cap.release()  # 关闭摄像头
            cv2.destroyAllWindows()
            time.sleep(2)
            break

os.popen('exit.exe')

