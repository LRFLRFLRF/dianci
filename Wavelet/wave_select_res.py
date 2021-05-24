
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

file_sigres = pd.read_excel(r'E:\Desktop\dianci\Python_code\mat\mat_python\res_7_13_12min.xlsx')
sigres_indexname = {'sig_res': []}
sigres_table = pd.DataFrame(sigres_indexname)
for row in range(file_sigres.shape[0]):
    sigres_table.loc[row] = [file_sigres.iat[row, 0]]
res = sm.tsa.arma_order_select_ic(sigres_table['sig_res'], max_ar=10, max_ma=5, ic='aic')
print(res)