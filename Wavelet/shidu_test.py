# -*- coding: utf-8 -*-
import numpy as np
import math
import matplotlib.pyplot as plt
import pandas as pd
import datetime
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf
#from datetime import datetime
import scipy.io as sio
from scipy import interpolate
from pandas import DataFrame,Series
import statsmodels.api as sm
import numpy as np
from statsmodels.tsa.statespace.sarimax import SARIMAX
from statsmodels.tsa.arima.model import ARIMA
from statsmodels.tsa.seasonal import seasonal_decompose
from statsmodels.tsa.forecasting.stl import STLForecast
import itertools
from statsmodels.tsa.stattools import adfuller, acf
from statsmodels.stats.diagnostic import acorr_ljungbox
from statsmodels.stats.diagnostic import acorr_ljungbox as lb_test

plt.style.use('fivethirtyeight')
plt.rcParams['figure.figsize'] = 28, 18
plt.rcParams['font.sans-serif'] = [u'SimHei']
plt.rcParams['axes.unicode_minus'] = False
plt.rcParams['figure.facecolor'] = '#FFFFFF'
plt.rcParams['lines.linewidth'] = 2.0
plt.rcParams['figure.edgecolor'] = 'black'
plt.rcParams['axes.grid'] = True
plt.rcParams['grid.linewidth'] = 0.5
plt.rcParams['grid.color'] = '#000000'
print(plt.rcParamsDefault)


file_sigDEN = pd.read_excel(r'E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\db7_4_DEN.xls')  #读取小波分解
file_sigRES = pd.read_excel(r'E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\db7_4_RES.xls')  #读取小波分解残差
file_sig = pd.read_excel(r'E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\cor.xls')  #读取原序列


#######################SIGDEN##########################
##遍历excel建立datetime
sigDEN_indexname = {'sigDEN': [], 'datetime': []}
sigDEN_table = pd.DataFrame(sigDEN_indexname)
for row in range(file_sigDEN.shape[0]):
    # 创建datetime
    datetime_new = datetime.datetime(2020, file_sigDEN.iat[row, 1], file_sigDEN.iat[row, 2], file_sigDEN.iat[row, 3], file_sigDEN.iat[row, 4])
    sigDEN_table.loc[row, :] = [file_sigDEN.iat[row, 5], datetime_new]

sigDEN_table['datetime'] = pd.to_datetime(sigDEN_table['datetime'])
sigDEN_table.set_index('datetime', inplace=True)
#取要研究的时间段 重采样
sigDEN = sigDEN_table['sigDEN']['2020-12-1':'2020-12-5']
sigDEN_resample = sigDEN_table['sigDEN']['2020-12-1':'2020-12-5'].resample('12T').mean()  # 三十分钟重采样
#sigDEN_resample.to_excel(r'E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\app_7_13_12min.xlsx', sheet_name = 'data1')

#######################SIGRES##########################
##遍历excel建立datetime
sigRES_indexname = {'sigRES': [], 'datetime': []}
sigRES_table = pd.DataFrame(sigRES_indexname)
for row in range(file_sigRES.shape[0]):
    # 创建datetime
    datetime_new = datetime.datetime(2020, file_sigRES.iat[row, 1], file_sigRES.iat[row, 2], file_sigRES.iat[row, 3], file_sigRES.iat[row, 4])
    sigRES_table.loc[row, :] = [file_sigRES.iat[row, 5], datetime_new]
sigRES_table['datetime'] = pd.to_datetime(sigRES_table['datetime'])
sigRES_table.set_index('datetime', inplace=True)
#取要研究的时间段 重采样
sigRES = sigRES_table['sigRES']['2020-12-1':'2020-12-5']
sigRES_resample = sigRES_table['sigRES']['2020-12-1':'2020-12-5'].resample('12T').mean()  # 三十分钟重采样
#sigRES_resample.to_excel(r'E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\res_7_13_12min.xlsx', sheet_name = 'data1')

#######################SIG原序列##########################
##遍历excel建立datetime
sig_indexname = {'sig': [], 'datetime': []}
sig_table = pd.DataFrame(sig_indexname)
for row in range(file_sig.shape[0]):
    # 创建datetime
    datetime_new = datetime.datetime(2020, file_sig.iat[row, 1], file_sig.iat[row, 2], file_sig.iat[row, 3], file_sig.iat[row, 4])
    sig_table.loc[row, :] = [file_sig.iat[row, 5], datetime_new]
sig_table['datetime'] = pd.to_datetime(sig_table['datetime'])
sig_table.set_index('datetime', inplace=True)
#取要研究的时间段 重采样
sig = sig_table['sig']['2020-12-1':'2020-12-5']
sig_resample = sig_table['sig']['2020-12-1':'2020-12-5'].resample('12T').mean()  # 三十分钟重采样
#sig_resample.to_excel(r'E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\cor_resample.xlsx', sheet_name = 'data1')

print()
def SARIMA_DEN(df, order, seasonal_order):
    mod = SARIMAX(df, order=order,
                  seasonal_order=seasonal_order,
                  enforce_stationarity=False,
                  enforce_invertibility=False)
    results = mod.fit(maxiter=100)
    print('BIC:{}'.format(results.bic))
    return results

def predict_DEN_dynamic(res, df_yuan, delt_t, step):  #delt_t 采样时间间隔   step 预测步数
    time_delt = datetime.timedelta(minutes=delt_t*(step-1))    #预测时长
    starttime = pd.to_datetime('2020-12-4')
    df = pd.Series()   #新建空表放预测值
    while(starttime.__lt__( df_yuan.index[-1] - time_delt )):
        endtime = starttime + time_delt
        pred_dynamic = res.get_prediction(start=starttime,
                                          end=endtime,
                                          dynamic=True,
                                          full_results=True)
        starttime = endtime + datetime.timedelta(minutes=delt_t)
        df = pd.concat([df, pred_dynamic.predicted_mean])

    plt.figure(figsize=(20, 7))
    plt.subplot(111, facecolor='#FFFFFF')
    df_yuan.plot(color='black', linewidth=2.0, label='原始数据')
    df.plot(color='red',
            marker='x',
            linewidth=1.0,
            label='预测结果')
    plt.title('近似信号多步预测-预测步数' + str(step))
    plt.legend(loc='upper left')
    plt.show()
    return df

def ARIMA_RES(df, order):
    mod =  SARIMAX(df, order=order,
                   enforce_stationarity=False,
                   enforce_invertibility=False)
    results = mod.fit(maxiter=100)
    return results

def predict_RES_dynamic(res, df_yuan, delt_t, step):  #delt_t 采样时间间隔   step 预测步数
    time_delt = datetime.timedelta(minutes=delt_t*(step-1))    #预测时长
    starttime = pd.to_datetime('2020-12-4')
    df = pd.Series()   #新建空表放预测值
    while(starttime.__lt__( df_yuan.index[-1] - time_delt )):
        endtime = starttime + time_delt
        pred_dynamic = res.get_prediction(start=starttime,
                                          end=endtime,
                                          dynamic=True,
                                          full_results=True)
        starttime = endtime + datetime.timedelta(minutes=delt_t)
        df = pd.concat([df, pred_dynamic.predicted_mean])

    plt.figure(figsize=(20, 7))
    plt.subplot(111, facecolor='#FFFFFF')
    df_yuan.plot(color='black', linewidth=2.0, label='原始数据')
    df.plot(color='red',
            marker='x',
            linewidth=1.0,
            label='预测结果')
    plt.title('残差信号多步预测-预测步数' + str(step))
    plt.legend(loc='upper left')
    plt.show()
    return df

def plot_sum(pred, sig):
    plt.figure(figsize=(20, 7))
    plt.subplot(111, facecolor='#FFFFFF')
    sig.plot(color='black', linewidth=2.0, label='原始数据')
    pred.plot(color='red', marker='x', linewidth=1.0, label='预测结果') #
    plt.title('小波分解重构+SARIMA/ARIMA混合模型预测')
    plt.legend(loc='upper left')
    plt.show()

def main():
    #绘制原时间序列
    plt.figure(figsize=(20, 7))
    plt.subplot(111, facecolor='#FFFFFF')
    #plt.plot(sig_resample,color='black', linewidth=2.0)
    sig_resample.plot(color='black', linewidth=2.0)
    plt.title('降采样后室内电场强度')
    plt.show()


    # 绘制小波分解后时间序列
    plt.figure(figsize=(20, 7))
    plt.subplot(211, facecolor='#FFFFFF')
    sigDEN_resample.plot(color='black', linewidth=2.0,)
    plt.title('4层小波分解近似信号')
    plt.subplot(212, facecolor='#FFFFFF')
    sigRES_resample.plot(color='black', linewidth=2.0)
    plt.title('4层小波分解后所剩残差信号')
    plt.show()

    ##############################sigDEN#############################
    #训练sarima模型
    mod_DEN = SARIMA_DEN(sigDEN_resample,
                         order=(2, 1, 2),
                         seasonal_order=(0, 1, 0, 48*2.5))
    #动态预测
    den_pred_dy = predict_DEN_dynamic(mod_DEN, sigDEN_resample, delt_t=12, step=3)  #delt_t 采样时间间隔   step 预测步数

    #den_pred_dy.to_excel(r'E:\Desktop\dianci\Python_code\mat\mat_python\app_sarima_212_010_pred_1step.xlsx', sheet_name='data1')


    ##############################sigRES#############################
    #训练arima模型
    mod_RES = ARIMA_RES(sigRES_resample, order=(6, 0, 2))
    #动态预测
    res_pred_dy = predict_RES_dynamic(mod_RES, sigRES_resample, delt_t=12, step=3)  #delt_t 采样时间间隔   step 预测步数

    #res_pred_dy.to_excel(r'E:\Desktop\dianci\Python_code\mat\mat_python\res_arima_602_pred_1step.xlsx', sheet_name='data1')


    ###############################DEN+RES############################
    sum_pred = res_pred_dy + den_pred_dy

    # 保存3步预测结果
    #sum_pred.to_excel(r'E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\pred_3step.xlsx', sheet_name='data1')
    # 保存5步预测结果
    #sum_pred.to_excel(r'E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\pred_5step.xlsx', sheet_name='data1')
    # 保存10步预测结果
    #sum_pred.to_excel(r'E:\Desktop\dianci\sample_data\20201128-20201205-market\result\test\pred_10step.xlsx', sheet_name='data1')
    plot_sum(sum_pred, sig_resample)


if __name__ == '__main__':
    main()
