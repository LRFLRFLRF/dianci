# -*- coding: utf-8 -*-
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import itertools
from statsmodels.tsa.statespace.sarimax import SARIMAX
import datetime
from statsmodels.tsa.stattools import adfuller, acf
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf

plt.style.use('fivethirtyeight')
plt.rcParams['figure.figsize'] = 28, 18
plt.rcParams['font.sans-serif'] = [u'SimHei']
plt.rcParams['axes.unicode_minus'] = False

file = pd.read_excel(r'F:\Desktop\dianci\sample_data\20201128-20201205-market\result\20201128-20201205time-chang-rms.xls')
rng = pd.date_range(start='11/28/2020 9:23:00', periods=1999, freq='6T')  #end='12/06/2018 17:11:00'
df1 = pd.Series(np.array(file['rms_val']), index=rng)

df2 = df1.resample('30T').mean()   #三十分钟重采样
df = df2['11/29/2020':'12/4/2020']

def plot_data(df):
    plt.figure(figsize=(20, 7))
    plt.plot(df)
    plt.title('原时间序列')
    plt.show()


def cal(dataframe):
    #暴力算aic
    p = d = q = range(0, 3)
    pdq = list(itertools.product(p, d, q))
    pdq_x_PDQs = [(x[0], x[1], x[2], 48) for x in list(itertools.product(p, d, q))]
    a=[]
    b=[]
    c=[]
    wf=pd.DataFrame()
    for param in pdq:
        for seasonal_param in pdq_x_PDQs:
            try:
                mod = SARIMAX(dataframe, order=param, seasonal_order=seasonal_param,
                              enforce_stationarity=False, enforce_invertibility=False)
                results = mod.fit()
                print('ARIMA{}x{} - AIC:{}'.format(param, seasonal_param, results.aic))
                a.append(param)
                b.append(seasonal_param)
                c.append(results.aic)
            except:
                continue
    wf['pdq']=a
    wf['pdq_x_PDQs']=b
    wf['aic']=c
    print(wf[wf['aic']==wf['aic'].min()])


def df_diff(dataframe, diff_num): #数列向后移动diff_num个位置做差分
    diff_df = dataframe.diff(diff_num)
    plt.figure(figsize=(20, 7))
    plt.plot(diff_df)
    plt.title('diff_df: 差分后移位置' + str(diff_num))
    plt.show()
    return diff_df.dropna(inplace=False)

def TestStationaryAdfuller(df, cutoff = 0.01):
    ts_test = adfuller(df, autolag='AIC')
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
    ax1 = fig.add_subplot(211)
    fig = plot_acf(df.iloc[49:], lags=50, ax=ax1)
    ax2 = fig.add_subplot(212)
    fig = plot_pacf(df.iloc[49:], lags=50, ax=ax2)
    plt.show()

def SARIMA(df):
    mod =  SARIMAX(df,order=(6, 1, 2),
                   seasonal_order=(1, 1, 1, 48),
                   enforce_stationarity=False,
                   enforce_invertibility=False)
    results = mod.fit()
    print(results.summary())
    return results

def mod_test(res):
    # 模型检验
    # 模型诊断
    res.plot_diagnostics(figsize=(15, 12))
    plt.show()
    # LB检验
    r, q, p = acf(res.resid.values.squeeze(), qstat=True)
    data = np.c_[range(1, 41), r[1:], q, p]
    table = pd.DataFrame(data, columns=['lag', "AC", "Q", "Prob(>Q)"])
    print(table.set_index('lag'))

def predict(res, df):
    pred = res.get_prediction(start=pd.to_datetime('2020-12-1'), dynamic=False)
    pred_ci = pred.conf_int()
    plt.figure(figsize=(20, 7))
    df.plot(color='blue')
    pred.predicted_mean.plot(color='red')
    plt.title('静态预测')
    plt.show()
    return pred

def predict_dynamic(res, df):
    pred_dynamic = res.get_prediction(start=pd.to_datetime('2020-12-1'), dynamic=True, full_results=True)
    pred_dynamic_ci = pred_dynamic.conf_int()
    plt.figure(figsize=(20, 7))
    df.plot(color='blue')
    pred_dynamic.predicted_mean.plot(color='red')
    plt.title('动态预测')
    plt.show()

def predict_future(res, df2, pre_len):
    forecast = res.get_forecast(steps=pre_len)
    forecast_ci = forecast.conf_int()
    plt.figure(figsize=(20, 7))
    df2.plot(color='blue')
    forecast.predicted_mean.plot(color='green')
    plt.title('未来预测')
    plt.show()


def main():
    #绘制原数据
    plot_data(df['11/29/2020':'12/5/2020'])

    #暴力求解aic 模型定阶
    #cal(df)

    #差分
    ddf = df_diff(df, 48)  #后移48 做差分  24h*2

    #ADF 单位根检验判断平稳性
    TestStationaryAdfuller(ddf)

    #画出差分后的PACF ACF
    #ACF_PACF(ddf)

    #训练sarima模型
    mod_res = SARIMA(df)

    #模型检测
    #mod_test(mod_res)

    #静态预测
    pred = predict(mod_res, df)

    #动态预测
    predict_dynamic(mod_res, df)

    #未来预测
    predict_future(mod_res, df, 48*1)

    #白噪声检验


if __name__ == '__main__':
    main()