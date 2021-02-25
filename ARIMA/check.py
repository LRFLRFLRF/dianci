# -*- coding: utf-8 -*-
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import datetime
plt.rcParams['font.sans-serif'] = [u'SimHei']
plt.rcParams['axes.unicode_minus'] = False

file = pd.read_excel(r'F:\Desktop\dianci\sample_data\20201128-20201205-market\result\20201128-20201205time-chang-rms.xls')
rng = pd.date_range(start='11/28/2020 9:23:00', periods=1999, freq='6T')  #end='12/06/2018 17:11:00'
df1 = pd.Series(np.array(file['rms_val']), index=rng)

df2 = df1.resample('30T').mean()
df = df2['11/30/2020':'12/4/2020']  #取周一到周五

#画出时序图
plt.figure(figsize=(20, 7))
plt.title('field_val')
df.plot()


#画自相关图和偏自相关图
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf
from statsmodels.tsa.stattools import adfuller as ADF
'''
plt.figure(figsize=(20, 7))
plot_acf(df)
plt.figure(figsize=(20, 7))
plot_pacf(df)
plt.show()
'''


'''
#周期分量
import statsmodels.api as sm
from pylab import rcParams
rcParams['figure.figsize'] = 11, 9
decomposition = sm.tsa.seasonal_decompose(df.values, model='additive', period=24)
fig = decomposition.plot()
'''

'''
#通过滑动平均得到平稳序列
rol_mean = df.rolling(window=6).mean()
rol_mean.dropna(inplace=True)
#画出滑动平均后的图
plt.figure(figsize=(20, 7))
plt.title('field_val rolling')
rol_mean.plot()
'''

#做一次差分
df_role_mean_diff1 = df.diff(1)
df_role_mean_diff1.dropna(inplace=True)


#ADF平稳性检验
adf_data=ADF(df_role_mean_diff1, regresults=True)
print(adf_data)
#(-4.279980099504444, 0.00048104041862999164, 12, 95, {'1%': -3.5011373281819504, '5%': -2.8924800524857854, '10%': -2.5832749307479226}, -547.8972436791398)
#p值比三个数都小  序列平稳



#对一次差分信号做白噪声检验，白噪声检验也成为纯随机性检验。   如果数据是纯随机性数据，那在进行数据分析就没有意义了
from statsmodels.stats.diagnostic import acorr_ljungbox
ljung_data = acorr_ljungbox(df_role_mean_diff1, return_df=True)
print(ljung_data)

#也可看一次差分后的ACF图观察随机性 ， 如果是纯随机的则只有o阶最大
plt.figure(figsize=(20, 7))
plot_acf(df_role_mean_diff1, lags=100)
plt.title('diff1 ACF')
plt.show()


#用BIC选出p,q值
import statsmodels.tsa.stattools as st
#order = st.arma_order_select_ic(df_role_mean_diff1, max_ar=10, max_ma=10, ic=['aic', 'bic'])
#print(order)


#训练模型
from statsmodels.tsa.arima_model import ARMA, ARIMA
from statsmodels.tsa.statespace.sarimax import SARIMAX
model = SARIMAX(df, seasonal_order=(9, 1, 9, 48))  #根据aic此处选择9,3阶模型  #df_role_mean_diff1
result_arma = model.fit(disp=1, maxiter=50)   #disp>0 输出训练参数  #, method='css'
print(result_arma.summary())

#用训练数据检测模型效果
predict_ts = result_arma.predict()


#预测
forecast = result_arma.forecast(100)
#df_forecast = pd.Series(forecast, index=pd.period_range('12/5/2020', periods=24, freq='60T'))
plt.figure(figsize=(20, 7))
df.plot(color='blue')
predict_ts.plot(color='red')
forecast.plot(color='green')
df2['12/5/2020': '12/5/2020'].plot(color='blue')
plt.show()


#残差ljungbox检验
#绘制残差图
residual = predict_ts['11/30/2020 03:00:00': '12/5/2020'] - df['11/30/2020 03:00:00': '12/5/2020']
plt.figure(figsize=(20, 7))
residual.plot(color='blue')
plt.title('residual')
plt.show()

plt.figure(figsize=(20, 7))
ljung_data1 = acorr_ljungbox(residual, return_df=True, boxpierce=True)
print(ljung_data1)



plt.figure(figsize=(20, 7))
plot_acf(residual, lags=100)
plt.title('residual ACF')
plt.show()
