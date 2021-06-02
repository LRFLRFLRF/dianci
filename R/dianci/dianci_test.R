app_1<-ts(app_7_13_12min$sigDEN,frequency = 120)
app = app_1[1:840]
plot(app)


library(forecast)



app_diff = diff(app, 120)
tsdisplay(app_diff)


app_diff1 = diff(app_diff, 1)
tsdisplay(app_diff1)
acf <-acf(app_diff1,main=" ")

app_diff1_m <- as.matrix(app_diff1)
sampleT <- as.integer(nrow(app_diff1_m))
qnorm<-qnorm((1 + 0.95)/2)
qnorm
ci <- qnorm((1 + 0.95)/2)/sqrt(sampleT)
ci

pacf <-pacf(app_diff1,main=" ")

app_diff2 = diff(app_diff1, 1)
tsdisplay(app_diff2)




###自动选择
a = auto.arima(app_d, seasonal = T,trace = T,max.P = 8,max.q = 3,start.P = 0,start.q = 0)
a

a = auto.arima(app_diff1,d=0,seasonal = F,trace = T,max.p = 5,max.q = 5,start.p = 0,start.q = 0,stationary = T)
a

##拟合测试
fit_test <- arima(app_diff1, order=c(2,0,2))
summary(fit_test)



fit1 <- arima(app, order=c(2,1,2),seasonal=list(order = c(0,1,0), period = 120))

summary(fit1)
cancha = residuals(fit1)
plot(cancha)
cancha1 = cancha[150:480]
tsdisplay(cancha1) #显示残差


plot(forecast(fit1,h=120))

qqnorm(cancha1)
qqline(cancha1)

Box.test(cancha1,type="Ljung-Box")
Box.test(cancha,type="Ljung-Box")
Box.test(app,type="Ljung-Box")


library(tseries)
adf.test(app_diff1)


###############RES
res<-ts(res_7_13_12min$sigRES,frequency = 120)
plot(res)



b = auto.arima(res, seasonal = F,max.p = 20)
b


adf.test(res)

tsdisplay(res)
acf <-acf(res,main=" ")
pacf <-pacf(res,main=" ")


fit2 <- arima(res, order=c(5,0,2))
summary(fit2)
cancha_res = residuals(fit2)
plot(cancha_res)


plot(forecast(fit2,h=120))

qqnorm(cancha_res)
qqline(cancha_res)

Box.test(cancha_res,type="Ljung-Box")



##########################导出
write.table (app_diff1, file ="E:\\Desktop\\dianci\\Python_code\\mat\\xls_r\\app_diff1.csv", sep =",", row.names =FALSE)




