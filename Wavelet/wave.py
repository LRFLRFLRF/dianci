# -*- coding: utf-8 -*-
import numpy as np
import math
import matplotlib.pyplot as plt
import pandas as pd
import datetime
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf
#from datetime import datetime

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

def cal(dataframe):
    # 暴力算bic
    p = q = range(0, 3)
    pdq = list(itertools.product(p, q))
    pdq_x_PDQs = [(x[0], 1, x[1], 48*2.5) for x in list(itertools.product(p, q))]
    a = []
    b = []
    c = []
    wf = pd.DataFrame()
    for param in pdq:
        for seasonal_param in pdq_x_PDQs:
            try:
                mod = SARIMAX(dataframe, order=(param[0], 0, param[1]), seasonal_order=seasonal_param,
                              enforce_stationarity=False, enforce_invertibility=False)
                results = mod.fit()
                print('ARIMA{}x{} - BIC:{}'.format(param, seasonal_param, results.bic))
                a.append(param)
                b.append(seasonal_param)
                c.append(results.bic)
            except:
                continue
    wf['pdq'] = a
    wf['pdq_x_PDQs'] = b
    wf['bic'] = c
    print(wf[wf['bic'] == wf['bic'].min()])

def cal_res(dataframe):
    # 暴力算bic
    p = d = q = range(0, 4)
    pdq = list(itertools.product(p, d, q))
    a = []
    b = []
    wf = pd.DataFrame()
    for param in pdq:
        try:
            mod = SARIMAX(dataframe, order=(param[0], param[1], param[2]),
                          enforce_stationarity=False, enforce_invertibility=False)
            results = mod.fit()
            print('ARIMA{} - BIC:{}'.format(param, results.bic))
            a.append(param)
            b.append(results.bic)
        except:
            continue
    wf['pdq'] = a
    wf['bic'] = b
    print(wf[wf['bic'] == wf['bic'].min()])

def TestStationaryAdfuller(df, cutoff = 0.01):
    ts_test = adfuller(df, autolag='BIC')
    ts_test_output = pd.Series(ts_test[0:4],
                               index=['Test Statistic', 'p-value', '#Lags Used', 'Number of Observations Used'])
    for key, value in ts_test[4].items():
        ts_test_output['Critical Value (%s)' % key] = value
    print(ts_test_output)

    if ts_test[1] <= cutoff:
        print(u"拒绝原假设，即数据没有单位根,序列是平稳的。")
    else:
        print(u"不能拒绝原假设，即数据存在单位根,数据是非平稳序列。")

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

##LBj检验残差是否为白噪声
    ljung_data = lb_test(results.resid['1/8/2021':], return_df=True)
    print(ljung_data)
    return results

def ARIMA_RES(df, order):
    mod =  SARIMAX(df, order=order,
                   enforce_stationarity=False,
                   enforce_invertibility=False)
    results = mod.fit(maxiter=100)
    print("模型中实际估计的自回归参数 :", results.arparams)
#    print("模型中实际估算的移动平均参数 :", results.maparams)
    print("模型 MSE :", results.mse)
    print("模型 MAE :", results.mae)
    print(results.summary())

    ##LBj检验残差是否为白噪声
    ljung_data = lb_test(results.resid['1/8/2021':], return_df=True)
    print(ljung_data)

    # 也可看一次差分后的ACF图观察随机性 ， 如果是纯随机的则只有o阶最大
    fig = plt.figure(figsize=(20, 7))
    ax1 = fig.add_subplot(211, facecolor='#FFFFFF')
    fig = plot_acf(df.iloc[49:], lags=100, ax=ax1, title='自相关函数图')
    ax2 = fig.add_subplot(212, facecolor='#FFFFFF')
    fig = plot_pacf(df.iloc[49:], lags=100, ax=ax2, title='偏自相关函数图')
    plt.show()


    return results

def plot_sum(pred, sig):
    plt.figure(figsize=(20, 7))
    plt.subplot(111, facecolor='#FFFFFF')
    sig.plot(color='black', linewidth=2.0, label='原始数据')
    pred.plot(color='red', marker='x', linewidth=1.0, label='预测结果')
    plt.title('小波分解重构+SARIMA/ARIMA混合模型预测')
    plt.legend(loc='upper left')
    plt.show()

def plot_sum_dynamic(pred, sig):
    plt.figure(figsize=(20, 7))
    sig.plot(color='blue', linewidth=2.0)
    pred.plot(color='red', marker='x', linewidth=1.0, label='dynamic forecast')
    plt.title('小波分解重构序列 + 原序列动态预测')
    plt.show()

def predict_RES_dynamic(res, df_yuan, delt_t, step):  #delt_t 采样时间间隔   step 预测步数
    time_delt = datetime.timedelta(minutes=delt_t*(step-1))    #预测时长
    starttime = pd.to_datetime('2021-1-8')
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

def predict_DEN_dynamic(res, df_yuan, delt_t, step):  #delt_t 采样时间间隔   step 预测步数
    time_delt = datetime.timedelta(minutes=delt_t*(step-1))    #预测时长
    starttime = pd.to_datetime('2021-1-8')
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

def sea_dec():

    ########################seasonal_decompose#######################
    ##seasonal_decompose方法 本质是移动平均法做分解 是经典方法
    DecomposeResult = seasonal_decompose(x=sig_resample,
                                         model='additive',
                                         period=48,
                                         two_sided=False)
    plt.figure(figsize=(20, 7))
    DecomposeResult.plot()
    plt.show()

    ##########seasonal#########
    mod_SEA = SARIMA_DEN(DecomposeResult.seasonal,
                         order=(2, 0, 1),
                         seasonal_order=(0, 1, 0, 48))
    #动态预测
    sea_pred_dy = predict_RES_dynamic(mod_SEA, DecomposeResult.seasonal, delt_t=12, step=1)

    ###########trend##########
    mod_TRE = ARIMA_RES(DecomposeResult.trend, order=(2, 0, 2))
    #动态预测
    tre_pred_dy = predict_RES_dynamic(mod_TRE, DecomposeResult.trend, delt_t=12, step=1)

    #############res##########
    #cal_res(DecomposeResult.resid)
    mod_RES = ARIMA_RES(DecomposeResult.resid,
                         order=(1, 1, 0))
    #静态预测
    res_pred_dy = predict_RES_dynamic(mod_RES, DecomposeResult.resid, delt_t=12, step=1)  # delt_t 采样时间间隔   step 预测步数
    ###############################sea+tre############################
    ####单步预测####
    sum_pred = sea_pred_dy + tre_pred_dy + res_pred_dy
    plot_sum(sum_pred, sig_resample)

    ###计算mape
    true_j = sig_resample['1/8/2021':'1/13/2021']
    pred_j = sum_pred['1/8/2021':'1/13/2021']
    mape_j = sum(np.abs((true_j-pred_j)/true_j))/len(true_j)*100
    print("模型总 MAPE_j ：", mape_j)

def STL():

    mod_STL = STLForecast(sig_resample['2021-1-7':'2021-1-13'], model=ARIMA,
                          model_kwargs=dict(order=(1, 1, 0)),
                          robust=True, period=48)
    DecomposeResult_STL = mod_STL.fit()
    #####静态预测
    pre_STL = DecomposeResult_STL.get_prediction(start=pd.to_datetime('2021-1-8'), dynamic=False)
    plt.figure(figsize=(20, 7))
    plt.title('STLForecast静态预测')
    pre_STL.predicted_mean.plot(color='red',
                             marker='x',
                             linewidth=1.0,
                             label='One-step-ahead forecast')
    sig_resample.plot(color='blue', linewidth=2.0)
    plt.show()

    #####动态预测
    forecast_STL = DecomposeResult_STL.forecast(48)
    plt.figure(figsize=(20, 7))
    plt.title('STLForecast动态预测')
    forecast_STL.plot(color='red')
    sig_resample.plot(color='blue', linewidth=2.0)
    plt.show()

    ###计算mape
    true_stl = sig_resample['1/8/2021':'1/13/2021']
    pred_stl = pre_STL.predicted_mean['1/8/2021':'1/13/2021']
    mape_j = sum(np.abs((true_stl - pred_stl) / true_stl)) / len(true_stl) * 100
    print("STL模型总 MAPE_j ：", mape_j)

def calculate_mod(true_j, pred_j, mod_name):
    if len(true_j) != len(pred_j):
        true_j = true_j[0:len(pred_j)]

    ##计算小波分解模型mape
    mape_j = sum(np.abs((true_j-pred_j)/true_j))/len(true_j)*100
    print(mod_name + " MAPE_j ：", mape_j)

    ##计算MSE
    mse_j = sum((pred_j - true_j)**2)/len(true_j)
    print(mod_name + " MSE_j ：", mse_j)

    ##计算MAE
    mae_j = sum(np.abs(pred_j - true_j))/len(true_j)
    print(mod_name + " MAE_j ：", mae_j)

def main():
    ########################seasonal_decompose方法  mape 6.05%  短期预测很好 长期不行
    #sea_dec()
    #########################STLForecast方法  mape6.48%
    #STL()

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
    ##bic暴力算阶
    #cal(sigDEN_resample['2021-1-7':'2021-1-10'])

    #训练sarima模型
    mod_DEN = SARIMA_DEN(sigDEN_resample,
                         order=(2, 0, 2),
                         seasonal_order=(0, 1, 0, 48*2.5))

    #动态预测
    den_pred_dy = predict_DEN_dynamic(mod_DEN, sigDEN_resample, delt_t=12, step=1)  #delt_t 采样时间间隔   step 预测步数
    #计算精度
    true_j = sigDEN_resample['1/8/2021':'1/13/2021']
    pred_j = den_pred_dy['1/8/2021':'1/13/2021']
    calculate_mod(true_j, pred_j, '近似信号模型样本内预测')



    ##############################sigRES#############################
    ##bic暴力算阶
    #cal_res(sigRES_resample)
    #ADF 单位根检验判断平稳性
    #TestStationaryAdfuller(sigRES_resample)
    #训练arima模型
    mod_RES = ARIMA_RES(sigRES_resample, order=(2, 0, 3))
    #动态预测
    res_pred_dy = predict_RES_dynamic(mod_RES, sigRES_resample, delt_t=12, step=5)  #delt_t 采样时间间隔   step 预测步数
    #计算精度
    true_j = sigRES_resample['1/8/2021':'1/13/2021']
    pred_j = res_pred_dy['1/8/2021':'1/13/2021']
    calculate_mod(true_j, pred_j, '残差信号模型样本内预测')



    ###############################DEN+RES############################
    ####单步预测####
    sum_pred = res_pred_dy + den_pred_dy
    plot_sum(sum_pred, sig_resample)

    true_j = sig_resample['1/8/2021':'1/13/2021']
    pred_j = sum_pred['1/8/2021':'1/13/2021']

    # 计算模型 mape  mae  mse
    calculate_mod(true_j, pred_j, '小波分解重构模型样本内预测')

    ####动态预测####
    #sum_pred_dynamic = res_pred_dy + den_pred_dy
    #plot_sum_dynamic(sum_pred_dynamic, sig_resample)

if __name__ == '__main__':
    main()



