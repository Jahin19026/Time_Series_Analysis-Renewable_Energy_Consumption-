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

#forecast for 2 years
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

acf(diff1_energy_ts, main= "ACF of Differenced Series")
pacf(diff1_energy_ts, main= "PACF of Differenced Series")

model_1001<- arima(energy_ts, order=c(10,0,1))
summary(model_1001)
##AIc=152.51, MASE= 0.407,MAPE=1.35

model_010<- arima(diff1_energy_ts, order=c(0,1,0))
summary(model_010)
##AIc=156.48, MASE= 0.977,MAPE=97.36

model_110<- arima(energy_ts, order=c(1,1,0))
summary(model_110)
##AIc=154.47, MASE= 0.646,MAPE= 2.22


##diagnostic checking(normality check)
tsdisplay(residuals(model_1001))
tsdisplay(residuals(model_010))#suggested
tsdisplay(residuals(model_110))

##box-jenkins test
Box.test(residuals(model_1001),lag=1, type = "Ljung-Box")
##there is no auto-correlation exists 
Box.test(residuals(model_010),lag=1, type = "Ljung-Box")
##auto-correlation exists
Box.test(residuals(model_110),lag=1, type = "Ljung-Box")
##auto-correlation exists

#forecast for 2 decades
forecasted_1001 = forecast(model_1001, h=20)
plot(forecasted_1001)

forecasted_010 = forecast(model_010, h=20)
plot(forecasted_010)

forecasted_110 = forecast(model_110, h=20)
plot(forecasted_110)

