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


file_sigDEN = pd.read_excel(r'E:\Desktop\dianci\Python_code\mat\mat_xls_file\wp_4_db8_rec_DEN.xls')  #读取小波分解
file_sigRES = pd.read_excel(r'E:\Desktop\dianci\Python_code\mat\mat_xls_file\wp_4_db8_rec_RES.xls')  #读取小波分解残差
file_sig = pd.read_excel(r'E:\Desktop\dianci\Python_code\mat\mat_xls_file\sig.xls')  #读取原序列

#######################SIGDEN##########################
##遍历excel建立datetime
sigDEN_indexname = {'sigDEN': [], 'datetime': []}
sigDEN_table = pd.DataFrame(sigDEN_indexname)
for row in range(file_sigDEN.shape[0]):
    # 创建datetime
    datetime_new = datetime.datetime(2021, file_sigDEN.iat[row, 1], file_sigDEN.iat[row, 2], file_sigDEN.iat[row, 3], file_sigDEN.iat[row, 4])
    sigDEN_table.loc[row, :] = [file_sigDEN.iat[row, 5], datetime_new]

sigDEN_table['datetime'] = pd.to_datetime(sigDEN_table['datetime'])
sigDEN_table.set_index('datetime', inplace=True)
#取要研究的时间段 重采样
sigDEN = sigDEN_table['sigDEN']['2021-1-7':'2021-1-13']
sigDEN_resample = sigDEN_table['sigDEN']['2021-1-7':'2021-1-13'].resample('12T').mean()  # 三十分钟重采样
#sigDEN_resample.to_excel(r'E:\Desktop\dianci\Python_code\mat\mat_python\app_7_13_12min.xlsx', sheet_name = 'data1')

#######################SIGRES##########################
##遍历excel建立datetime
sigRES_indexname = {'sigRES': [], 'datetime': []}
sigRES_table = pd.DataFrame(sigRES_indexname)
for row in range(file_sigRES.shape[0]):
    # 创建datetime
    datetime_new = datetime.datetime(2021, file_sigRES.iat[row, 1], file_sigRES.iat[row, 2], file_sigRES.iat[row, 3], file_sigRES.iat[row, 4])
    sigRES_table.loc[row, :] = [file_sigRES.iat[row, 5], datetime_new]
sigRES_table['datetime'] = pd.to_datetime(sigRES_table['datetime'])
sigRES_table.set_index('datetime', inplace=True)
#取要研究的时间段 重采样
sigRES = sigRES_table['sigRES']['2021-1-7':'2021-1-13']
sigRES_resample = sigRES_table['sigRES']['2021-1-7':'2021-1-13'].resample('12T').mean()  # 三十分钟重采样
#sigRES_resample.to_excel(r'E:\Desktop\dianci\Python_code\mat\mat_python\res_7_13_12min.xlsx', sheet_name = 'data1')

#######################SIG原序列##########################
##遍历excel建立datetime
sig_indexname = {'sig': [], 'datetime': []}
sig_table = pd.DataFrame(sig_indexname)
for row in range(file_sig.shape[0]):
    # 创建datetime
    datetime_new = datetime.datetime(2021, file_sig.iat[row, 1], file_sig.iat[row, 2], file_sig.iat[row, 3], file_sig.iat[row, 4])
    sig_table.loc[row, :] = [file_sig.iat[row, 5], datetime_new]
sig_table['datetime'] = pd.to_datetime(sig_table['datetime'])
sig_table.set_index('datetime', inplace=True)
#取要研究的时间段 重采样
sig = sig_table['sig']['2021-1-7':'2021-1-13']
sig_resample = sig_table['sig']['2021-1-7':'2021-1-13'].resample('12T').mean()  # 三十分钟重采样
#sig_resample.to_excel(r'E:\Desktop\dianci\Python_code\mat\mat_python\sig_7_13_12min.xlsx', sheet_name = 'data1')
print()


def SARIMA_DEN(df, order, seasonal_order):
    mod = SARIMAX(df, order=order,
                  seasonal_order=seasonal_order,
                  enforce_stationarity=False,
                  enforce_invertibility=False)
    results = mod.fit(maxiter=100)
    print('BIC:{}'.format(results.bic))
    print("模型中实际估计的自回归参数 :", results.arparams)
    print("模型中实际估算的移动平均参数 :", results.maparams)
#    print("模型中实际估算的季节性自回归参数 :", results.seasonalarparams)
#    print("模型中实际估算的季节性移动平均参数 :", results.seasonalmaparams)
    print("模型 MSE :", results.mse)
    print("模型 MAE :", results.mae)
    print(results.summary())
    return results


def forecast_DEN_dynamic(res, df_yuan, delt_t, step):  #delt_t 采样时间间隔   step 预测步数

    fore = res.get_forecast(steps=5)
    return fore


def cal_mod(true_j, pred_j, mod_name):
    ##计算小波分解模型mape
    mape_j = sum(np.abs((true_j-pred_j)/true_j))/len(true_j)*100
    print(mod_name + " MAPE_j ：", mape_j)

    ##计算MSE
    mse_j = sum((pred_j - true_j)**2)/len(true_j)
    print(mod_name + " MSE_j ：", mse_j)

    ##计算MAE
    mae_j = sum(np.abs(pred_j - true_j))/len(true_j)
    print(mod_name + " MAE_j ：", mae_j)

    return [mape_j, mse_j, mae_j]

def calculate_mod(true_j, pred_j, mod_name, slip_num):#每天分为几个时段
    if len(true_j) != len(pred_j):
        true_j = true_j[0:len(pred_j)]

    #整体计算
    cal_mod(true_j, pred_j, mod_name)

    #分时段计算
    delt_min = datetime.timedelta(minutes=24*60/slip_num) #每个时段长度【分钟】
    starttime = pred_j.index[0]
    cal_mape = []
    cal_mse = []
    cal_mae = []
    flag = 0
    while( True ):
        endtime = starttime + delt_min
        if endtime.__ge__(true_j.index[-1]):
            endtime = true_j.index[-1]
            flag = 1
        true_cut = true_j[starttime: endtime]
        pred_cut = pred_j[starttime: endtime]
        [mape, mse, mae] = cal_mod(true_cut, pred_cut, mod_name)
        cal_mape.append(mape)
        cal_mse.append(mse)
        cal_mae.append(mae)
        starttime = endtime
        if flag == 1:
            break
    #所有时段输出
    cal_mape = np.array(cal_mape).reshape(-1, 3)
    cal_mse = np.array(cal_mse).reshape(-1, 3)
    cal_mae = np.array(cal_mae).reshape(-1, 3)
    print(mod_name + '-所有分段mape：', cal_mape)
    print(mod_name + '-所有分段mse：', cal_mse)
    print(mod_name + '-所有分段mae：', cal_mae)

    #多天各时段平均
    cal_mape_mean = cal_mape.mean(axis=0)
    cal_mae_mean = cal_mae.mean(axis=0)
    cal_mse_mean = cal_mse.mean(axis=0)
    print(mod_name + '-多天分段平均mape：', cal_mape_mean)
    print(mod_name + '-多天分段平均mse：', cal_mse_mean)
    print(mod_name + '-多天分段平均mae：', cal_mae_mean)

def main():

    ##############################sigDEN#############################
    #训练sarima模型
    mod_DEN = SARIMA_DEN(sigDEN_resample,
                         order=(2, 1, 2),
                         seasonal_order=(0, 1, 0, 48*2.5))

    #动态预测
    den_pred_dy = forecast_DEN_dynamic(mod_DEN, sigDEN_resample, delt_t=12, step=10)  #delt_t 采样时间间隔   step 预测步数
    #计算精度
    true_j = sigDEN_resample['1/11/2021':'1/13/2021']
    pred_j = den_pred_dy['1/11/2021':'1/13/2021']
    calculate_mod(true_j, pred_j, '近似信号模型样本内预测', slip_num=3) #每天分为几个时段
    #den_pred_dy.to_excel(r'E:\Desktop\dianci\Python_code\mat\mat_python\app_sarima_212_010_pred.xlsx', sheet_name='data1')


if __name__ == '__main__':
    main()



