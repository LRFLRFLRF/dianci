
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


##################
# file_sigDEN = pd.read_excel(r'E:\Desktop\dianci\Python_code\mat\mat_xls_file\wp_4_db8_rec_DEN.xls')  #读取小波分解
# sigDEN_indexname = {'sigDEN': [], 'datetime': []}
# sigDEN_table = pd.DataFrame(sigDEN_indexname)
# for row in range(file_sigDEN.shape[0]):
#     # 创建datetime
#     datetime_new = datetime.datetime(2021, file_sigDEN.iat[row, 1], file_sigDEN.iat[row, 2], file_sigDEN.iat[row, 3], file_sigDEN.iat[row, 4])
#     sigDEN_table.loc[row, :] = [file_sigDEN.iat[row, 5], datetime_new]
# sigDEN_table['datetime'] = pd.to_datetime(sigDEN_table['datetime'])
# sigDEN_table.set_index('datetime', inplace=True)
# #取要研究的时间段 重采样
# sigDEN = sigDEN_table['sigDEN']['2021-1-7':'2021-1-13']
# sigDEN_resample = sigDEN_table['sigDEN']['2021-1-7':'2021-1-13'].resample('12T').mean()  # 三十分钟重采样

##########################
file_sigdiff = pd.read_excel(r'E:\Desktop\dianci\Python_code\mat\xls_r\app_diff1.xlsx')
sigdiff_indexname = {'sig_diff': []}
sigdiff_table = pd.DataFrame(sigdiff_indexname)
for row in range(file_sigdiff.shape[0]):
    sigdiff_table.loc[row] = [file_sigdiff.iat[row, 0]]
# res = sm.tsa.arma_order_select_ic(sigdiff_table['sig_diff'], max_ar=3, max_ma=3, ic='aic')
# print(res)



p = q = range(0, 3)
# Generate all different combinations of p, q and q triplets
pq = list(itertools.product(p, q))
# Generate all different combinations of seasonal p, q and q triplets
P = Q = range(0, 2)
PQ = list(itertools.product(P, Q))
seasonal_pdq = [(x[0], 1, x[1], 120) for x in PQ]
print('Examples of parameter combinations for Seasonal ARIMA...')
# print('SARIMAX: {} x {}'.format(pq[1], seasonal_pdq[1]))
# print('SARIMAX: {} x {}'.format(pq[1], seasonal_pdq[2]))
# print('SARIMAX: {} x {}'.format(pq[2], seasonal_pdq[3]))
# print('SARIMAX: {} x {}'.format(pq[2], seasonal_pdq[4]))

aic_result = []
for param in pq:
    for param_seasonal in seasonal_pdq:
        try:
            print("SARIMA:",param,param_seasonal)
            mod = sm.tsa.statespace.SARIMAX(sigdiff_table['sig_diff'],
                                            order=(param[0], 1, param[1]),
                                            seasonal_order=param_seasonal,
                                            enforce_stationarity=False,
                                            enforce_invertibility=False)

            results = mod.fit()

            print('ARIMA{}x{}120 - AIC:{}'.format(param, param_seasonal, results.aic))
            aic_result.append([param, param_seasonal, results.aic])
        except:
            continue

print(aic_result)




