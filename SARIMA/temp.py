# -*- coding: utf-8 -*-
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import itertools
from statsmodels.tsa.statespace.sarimax import SARIMAX, SARIMAXResults
import statsmodels.api as sm
from statsmodels.tsa.stattools import acf
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf
from statsmodels.tsa.stattools import adfuller as ADF
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

file_path = 'E:\\Desktop\\dianci\\sample_data\\apartment\\result\\'
file_list = ['20210106-20210110-rms', '20210110-20210112-rms', '20210112-20210114-rms', '20210114-20210116-rms']

# 拼接多个excel
df = pd.read_excel(file_path + file_list[0] + '.xls')
for file_name in file_list[1:]:
    df_file = pd.read_excel(file_path + file_name + '.xls')
    df = pd.concat([df, df_file])

df['datetime'] = pd.to_datetime(df['datetime'])
df.set_index('datetime', inplace=True)

df_yuan = df['rms_val']['1/7/2020':'1/13/2020']
df_rs1 = df['rms_val'].resample('12T').mean()  # 三十分钟重采样
df_rs = df_rs1['1/7/2020':'1/13/2020']

def plot_data(dataframe):
    plt.figure(figsize=(20, 7))
    plt.subplot(111, facecolor='#FFFFFF')
    dataframe.plot(color='black', linewidth=1.0)
   # plt.plot(dataframe, linewidth=1.0, color='black')
    plt.title('室内综合电场强度时间序列')
    plt.show()


def cal(dataframe):
    # 暴力算bic
    p = q = range(0, 3)
    pdq = list(itertools.product(p, q))
    pdq_x_PDQs = [(x[0], 1, x[1], 48) for x in list(itertools.product(p, q))]
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

def df_diff(dataframe, diff_num): #数列向后移动diff_num个位置做差分
    diff_df = dataframe.diff(diff_num)
    plt.figure(figsize=(20, 7))
    plt.plot(diff_df)
    plt.title('diff_df: 差分后移位置' + str(diff_num))
    plt.show()
    return diff_df.dropna(inplace=False)

def SARIMA(df):
    mod =  SARIMAX(df, order=(2, 0, 1),
                   seasonal_order=(0, 1, 1, 48*2.5),
                   enforce_stationarity=False,
                   enforce_invertibility=False)
    results = mod.fit(maxiter=100)
    print("模型中实际估计的自回归参数 :", results.arparams)
    print("模型中实际估算的移动平均参数 :", results.maparams)
 #   print("模型中实际估算的季节性自回归参数 :", results.seasonalarparams)
#    print("模型中实际估算的季节性移动平均参数 :", results.seasonalmaparams)
    print("模型 MSE :", results.mse)
    print("模型 MAE :", results.mae)
    print(results.summary())

    t = sm.stats.acorr_ljungbox(results.resid, return_df=True)
    plt.title('模型Ljung-Box检验')
    plt.plot(t['lb_pvalue'])
    plt.show()

    plt.title('模型残差')
    results.resid.plot()
    plt.show()

    return results

def predict(res, df):
    pred = res.get_prediction(start=pd.to_datetime('2020-1-8'), dynamic=False)
    pred_ci = pred.conf_int()
    plt.figure(figsize=(20, 7))
    plt.subplot(111, facecolor='#FFFFFF')
    df.plot(color='black', linewidth=2.0, label='原始数据')
    pred.predicted_mean.plot(color='red',
                             linewidth=1.0,
                             label='预测结果',
                             marker='x')
    plt.title('单一SARIMA方法预测-预测步数1')
    plt.legend(loc='upper left')
    plt.show()
    return pred.predicted_mean

def predict_dynamic(res, df):
    pred_dynamic = res.get_prediction(start=pd.to_datetime('2020-1-11'), end=pd.to_datetime('2020-1-12'), dynamic=True, full_results=True)
    pred_dynamic_ci = pred_dynamic.conf_int()
    plt.figure(figsize=(20, 7))
    df.plot(color='blue')
    pred_dynamic.predicted_mean.plot(color='red', linewidth=1.0)
    plt.title('动态预测')
    plt.show()
    return pred_dynamic.predicted_mean

def predict_future(res, df2, pre_len):
    forecast = res.get_forecast(steps=pre_len)
    forecast_ci = forecast.conf_int()
    plt.figure(figsize=(20, 7))
    df2.plot(color='blue')
    forecast.predicted_mean.plot(color='green', linewidth=1.0)
    plt.title('未来预测')
    plt.show()

def TestStationaryAdfuller(df, cutoff = 0.01):
    ts_test = ADF(df, autolag='BIC')
    ts_test_output = pd.Series(ts_test[0:4],
                               index=['Test Statistic', 'p-value', '#Lags Used', 'Number of Observations Used'])
    for key, value in ts_test[4].items():
        ts_test_output['Critical Value (%s)' % key] = value
    print(ts_test_output)

    if ts_test[1] <= cutoff:
        print(u"拒绝原假设，即数据没有单位根,序列是平稳的。")
    else:
        print(u"不能拒绝原假设，即数据存在单位根,数据是非平稳序列。")

def ACF_PACF(df):
    # 也可看一次差分后的ACF图观察随机性 ， 如果是纯随机的则只有o阶最大
    fig = plt.figure(figsize=(20, 7))
    ax1 = fig.add_subplot(211, facecolor='#FFFFFF')
    fig = plot_acf(df.iloc[49:], lags=100, ax=ax1, title='自相关函数图')
    ax2 = fig.add_subplot(212, facecolor='#FFFFFF')
    fig = plot_pacf(df.iloc[49:], lags=100, ax=ax2, title='偏自相关函数图')
    plt.show()


def main():
    #绘制原数据
    plot_data(df_yuan['1/7/2020':'1/13/2020'])

    #暴力求解aic 模型定阶
    #cal(df_rs)

    #差分
    #ddf = df_diff(df_rs, 1)  #后移48 做差分  24h*2

    #ADF 单位根检验判断平稳性
    #TestStationaryAdfuller(df_yuan)

    #画出差分后的PACF ACF
    #ACF_PACF(df_rs)

    #训练sarima模型
    mod_res = SARIMA(df_rs)

    #模型检测
    #mod_test(mod_res)

    #静态预测
    pred_j = predict(mod_res, df_rs)
    res_j = df_rs['1/7/2020':'1/13/2020'] - pred_j['1/7/2020':'1/13/2020']
    plot_data(res_j) #绘制残差
    true_j = df_rs['1/8/2020':'1/13/2020']
    pred_j = pred_j['1/8/2020':'1/13/2020']
    mape_j = sum(np.abs((true_j-pred_j)/true_j))/len(true_j)*100
    print("模型 MAPE_j ：", mape_j)

    #动态预测
    pred_d = predict_dynamic(mod_res, df_rs)
    true_d = df_rs['1/11/2020':'1/11/2020']
    pred_d = pred_d['1/11/2020':'1/11/2020']
    mape_d = sum(np.abs((true_d-pred_d)/true_d))/len(true_d)*100
    print("模型 MAPE_d ：", mape_d)
    mse_d = sum((true_d - pred_d) ** 2) / len(true_d)
    print("模型 MSE_d ：", mse_d)
    mae_d = sum(np.abs((true_d-pred_d)/true_d))
    print("模型 MAE_d ：", mae_d)


    #未来预测
    #predict_future(mod_res, df_rs, 48*1)

    #白噪声检验


if __name__ == '__main__':
    main()

