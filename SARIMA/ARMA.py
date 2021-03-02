# -*- coding: utf-8 -*-
from statsmodels.tsa.arima_model import ARMA, ARIMA
#from datetime import datetime
from itertools import product
import pandas as pd
import matplotlib.pyplot as plt
filename = 'F:\\Desktop\\1.xlsx'
df = pd.read_excel(filename)

#test_filename = 'F:\\Desktop\\dianci\\sample_data\\temp\\20201129time-chang.xlsx'
#test_df =  pd.read_excel(test_filename)


ps = range(0, 5)
qs = range(0, 5)

parameters = product(ps, qs)
parameters_list = list(parameters)

best_aic = float('inf')
best_bic = float('inf')
results_aic = []
results_bic = []
train = df['val']


global best_model_aic
global best_model_bic

for param in parameters_list:
    try:
        model = ARIMA(train[:], order=(param[0], 0, param[1])).fit()
    except ValueError:
        print("参数错误：", param)
        continue
    aic = model.aic
    bic = model.bic
    if aic < best_aic:
        best_model_aic = model
        best_aic = model.aic
        best_param_aic = param

    if bic < best_bic:
        best_model_bic = model
        best_bic = model.bic
        best_param_bic = param
    results_aic.append([param, model.aic])
    results_bic.append([param, model.bic])

results_table_aic = pd.DataFrame(results_aic)
results_table_bic = pd.DataFrame(results_bic)
results_table_aic.columns = ['parameters', 'aic']
results_table_bic.columns = ['parameters', 'bic']

#results_table.to_excel('F:\\Desktop\\dianci\\sample_data\\temp\\20201128time-chang-model.xls')
print("aic最优模型", best_model_aic.summary())

print("bic最优模型", best_model_bic.summary())


import statsmodels.tsa.stattools as st
order = st.arma_order_select_ic(train, max_ar=4, max_ma=4, ic=['aic', 'bic'])
print(order)

data = {'val':[], 'predict':[]}

'''
new = pd.DataFrame()
predicts  = best_model.predict(start=3708, end=5707)
new['val'] = train[-2000:]
new['predict'] = predicts
new.to_excel('F:\\Desktop\\dianci\\sample_data\\temp\\20201128time-chang-predict.xls')
plt.figure(figsize=(20, 7))
new.plot()
'''