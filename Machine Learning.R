#forecast for 1 decades
# Training set: 1980–2010
train <- window(energy_ts, start = 1980, end = 2010)

# Test set: 2011–2023
test  <- window(energy_ts, start = 2011, end = 2021)


# Example ARIMA models
model_1001_tr <- Arima(train, order = c(10,0,1))
model_900_tr  <- Arima(train, order = c(9,0,0))
model_111_tr  <- Arima(train, order = c(1,1,1))
model_auto_tr <- auto.arima(train)

h <- length(test)  # = 11
fc_1001 <- forecast(model_1001_tr, h = h)
fc_900  <- forecast(model_900_tr,  h = h)
fc_111  <- forecast(model_111_tr,  h = h)
fc_auto <- forecast(model_auto_tr, h = h)

#compare forecast accuracy
acc_1001 <-accuracy(fc_1001, test)
acc_900 <-accuracy(fc_900,  test)
acc_111 <-accuracy(fc_111,  test)
acc_auto <-accuracy(fc_auto, test)


#plot
windows()
library(gridExtra)

# Build individual plots
p1 <- autoplot(train) +
  autolayer(test, series = "Actual") +
  autolayer(fc_1001$mean, series = "ARIMA(10,0,1)") +
  ggtitle("ARIMA(10,0,1)")

p2 <- autoplot(train) +
  autolayer(test, series = "Actual") +
  autolayer(fc_900$mean, series = "ARIMA(9,0,0)") +
  ggtitle("ARIMA(9,0,0)")

p3 <- autoplot(train) +
  autolayer(test, series = "Actual") +
  autolayer(fc_111$mean, series = "ARIMA(1,1,1)") +
  ggtitle("ARIMA(1,1,1)")

p4 <- autoplot(train) +
  autolayer(test, series = "Actual") +
  autolayer(fc_auto$mean, series = "auto.arima") +
  ggtitle("Auto ARIMA")

# Arrange 2x2 grid
grid.arrange(p1, p2, p3, p4, ncol = 2)

#model_900 is best fitted among others

# Extract test-set accuracy (row 2) and add model names
results <- rbind(
  ARIMA_1001 = acc_1001[2, c("RMSE","MAE","MAPE","MASE")],
  ARIMA_900  = acc_900[2,  c("RMSE","MAE","MAPE","MASE")],
  ARIMA_111  = acc_111[2,  c("RMSE","MAE","MAPE","MASE")],
  ARIMA_auto = acc_auto[2,  c("RMSE","MAE","MAPE","MASE")]
)

results

# Refit best model ARIMA(9,0,0) on full dataset
final_model <- arima(energy_ts, order = c(9,0,0))

# Forecast for 10 years ahead (2024–2033)
final_fc <- forecast(final_model, h = 10)

# Plot forecast
windows()
autoplot(final_fc) +
  ggtitle("20-Year Forecast: Renewable Energy Consumption (ARIMA(9,0,0))") +
  xlab("Year") + ylab("Consumption")

