library(openxlsx)
library(tseries)
library(forecast)
library(ggplot2)

##load the data
data<- read.xlsx("Dataset.xlsx")
cleaned_data <- na.omit(data$Renewable.energy.consumption)

energy_ts <- ts(cleaned_data, start= c(1980), frequency = 1)

##create data frame
energy_df<- data.frame(
  Year= as.numeric(time(energy_ts)),
  energy= as.numeric(energy_ts)
)

##plot the time series data
windows()
ggplot(energy_df, aes(x=Year,y=energy))+
  geom_line(color="blue")+
  geom_point(color="red")+
  scale_x_continuous(breaks = seq(min(energy_df$Year), max(energy_df$Year), by=5))+
  labs(title = "Renewable Energy Time Series",
       x = "Year",
       y = "Renewable Energy") +
  theme_minimal()+
  theme(plot.title = element_text(hjust = 0.5))

##ADF,PP, KPSS, DF-GLS test to check stationarity
adf.test(energy_ts)
pp.test(energy_ts)

library(urca)
dfgls<- ur.ers(energy_ts)
summary(dfgls)

kpss.test(energy_ts, null = "Level")
kpss.test(energy_ts, null = "Trend")
##the series is stationary

model <- auto.arima(energy_ts)
summary(model)
##p=0,d=1,q=0

#missing value forecasting 
#forecast for 2 years(2022, 2023)
forecasted <- forecast(model, h = 2)
print(forecasted)
plot(forecasted, main = "Forecast of Renewable Energy Consumption (2022–2023)")

##forecasted values
forecasted$mean 


##identify p,q parameters
acf(energy_ts, main= "ACF of the Series")

pacf(energy_ts, main= "PACF of the Series")

##difference
diff1_energy_ts <- diff(energy_ts)
plot(diff1_energy_ts)


adf.test(diff1_energy_ts)
pp.test(diff1_energy_ts)
kpss.test(diff1_energy_ts, null = "Trend")
##the series is still stationary

acf(diff1_energy_ts, main= "ACF of Differenced Series")#q=1
pacf(diff1_energy_ts, main= "PACF of Differenced Series")#p=0


##ARIMA model
model_1001<- arima(energy_ts, order=c(10,0,1))
summary(model_1001)
##AIc=152.51, MASE= 0.407,MAPE=1.35

model_900<- arima(energy_ts, order=c(9,0,0))
summary(model_900)
##AIc=154.92, MASE= 0.44,MAPE=1.51


model_111<- arima(energy_ts, order=c(1,1,1))
summary(model_111)
##AIc=140.68, MASE= 0.46,MAPE= 1.67

model<- auto.arima(energy_ts)
summary(model)
#ARIMA(0,1,0), AIC=133.39, MASE= 0.428,MAPE= 1.59
# this model is better fitted than naive model


##diagnostic checking
windows()
tsdisplay(residuals(model_1001))
tsdisplay(residuals(model_900))
tsdisplay(residuals(model))#suggested
tsdisplay(residuals(model_111))

##box-jenkins test for auto-correlation
Box.test(residuals(model_1001), type = "Ljung-Box")
##there is no auto-correlation exists 
Box.test(residuals(model_900), type = "Ljung-Box")
##there is no auto-correlation exists 
Box.test(residuals(model),lag=1, type = "Ljung-Box")
##auto-correlation doesn't exist
Box.test(residuals(model_111),lag=1, type = "Ljung-Box")
##auto-correlation doesn't exist

#checking heteroscedasticity
###ARCH Test
library(FinTS)

ArchTest(residuals(model), lags = 1)#homoskedastic
ArchTest(residuals(model_1001), lags = 1)#homoskedastic
ArchTest(residuals(model_900), lags = 1)#homoskedastic
ArchTest(residuals(model_111), lags = 1)#homoskedastic

ArchTest(residuals(model)^2, lags = 1)#homoskedastic
ArchTest(residuals(model_1001)^2, lags = 1)#homoskedastic
ArchTest(residuals(model_900)^2, lags = 1)#homoskedastic
ArchTest(residuals(model_111)^2, lags = 1)#homoskedastic

###Normality Test
windows()
qqnorm(residuals(model)) #no heavy tailed
hist(residuals(model), breaks = 20)

qqnorm(residuals(model_1001))#no heavy tailed
hist(residuals(model_1001), breaks = 20)

qqnorm(residuals(model_900))#no heavy tailed
hist(residuals(model_900), breaks = 20)


qqnorm(residuals(model_111)) #no heavy tailed
hist(residuals(model_111), breaks = 20)

shapiro.test(residuals(model)) #not normal
shapiro.test(residuals(model_1001))#normal
shapiro.test(residuals(model_111))#not normal
shapiro.test(residuals(model_900))#normal

library(nortest)
ad.test(residuals(model))#not normal
ad.test(residuals(model_1001))#normal
ad.test(residuals(model_111))#not normal
ad.test(residuals(model_900))#normal

jarque.bera.test(residuals(model))#not normal
jarque.bera.test(residuals(model_1001))#not normal
jarque.bera.test(residuals(model_111))#not normal
jarque.bera.test(residuals(model_900))#not normal


# Find lambda for Box-Cox transformation
lambda <- BoxCox.lambda(energy_ts)
print(lambda)

# Apply Box-Cox transformation with lambda = 0.6996
energy_ts_trans <- BoxCox(energy_ts, lambda = 0.6995979)

#ARIMA on transformed data
model_bc <- auto.arima(energy_ts_trans)
summary(model_bc)
#AIC= 36.65, MASE=0.47  , MAPE= 1.26

model_1001_bc <- arima(energy_ts_trans, order = c(10,0,1))
summary(model_1001_bc)
#AIC= 52.38, MASE=0.404  , MAPE= 1.01

model_900_bc  <- arima(energy_ts_trans, order = c(9,0,0))
summary(model_900_bc)
#AIC= 54.68, MASE=0.44  , MAPE= 1.15

model_111_bc  <- arima(energy_ts_trans, order = c(1,1,1),method = 'ML') #ML= Machine Learning
summary(model_111_bc)
#AIC= 43.91, MASE= 0.485  , MAPE= 1.30


#check normality of transformed model

windows()
qqnorm(residuals(model_bc)) #no heavy tailed
hist(residuals(model_bc), breaks = 20)

qqnorm(residuals(model_1001_bc))#no heavy tailed
hist(residuals(model_1001_bc), breaks = 20)

qqnorm(residuals(model_900_bc))#no heavy tailed
hist(residuals(model_900_bc), breaks = 20)


qqnorm(residuals(model_111_bc)) #no heavy tailed
hist(residuals(model_111_bc), breaks = 20)

shapiro.test(residuals(model_bc)) #not normal
shapiro.test(residuals(model_1001_bc))#normal
shapiro.test(residuals(model_111_bc))#not normal
shapiro.test(residuals(model_900_bc))#normal

library(nortest)
ad.test(residuals(model_bc))#not normal
ad.test(residuals(model_1001_bc))#not normal
ad.test(residuals(model_111_bc))#not normal
ad.test(residuals(model_900_bc))#normal

jarque.bera.test(residuals(model_bc))#normal
jarque.bera.test(residuals(model_1001_bc))#not normal
jarque.bera.test(residuals(model_111_bc))#normal
jarque.bera.test(residuals(model_900_bc))#normal

#the residuals are not perfectly normal

##diagnostic checking with transformed model
windows()
tsdisplay(residuals(model_1001_bc))
tsdisplay(residuals(model_900_bc))
tsdisplay(residuals(model_bc))#suggested
tsdisplay(residuals(model_111_bc))

##box-jenkins test for auto-correlation
Box.test(residuals(model_1001_bc), type = "Ljung-Box")
##there is no auto-correlation exists 
Box.test(residuals(model_900_bc), type = "Ljung-Box")
##there is no auto-correlation exists 
Box.test(residuals(model_bc),lag=1, type = "Ljung-Box")
##auto-correlation doesn't exist
Box.test(residuals(model_111_bc),lag=1, type = "Ljung-Box")
##auto-correlation doesn't exist

#checking heteroscedasticity
###ARCH Test
library(FinTS)

ArchTest(residuals(model_bc), lags = 1)#homoskedastic
ArchTest(residuals(model_1001_bc), lags = 1)#homoskedastic
ArchTest(residuals(model_900_bc), lags = 1)#homoskedastic
ArchTest(residuals(model_111_bc), lags = 1)#homoskedastic

ArchTest(residuals(model_bc)^2, lags = 1)#homoskedastic
ArchTest(residuals(model_1001_bc)^2, lags = 1)#homoskedastic
ArchTest(residuals(model_900_bc)^2, lags = 1)#homoskedastic
ArchTest(residuals(model_111_bc)^2, lags = 1)#homoskedastic

#we will go forward with these models (model_1001,model_900,model_111, model_auto) for machine learning procedure
