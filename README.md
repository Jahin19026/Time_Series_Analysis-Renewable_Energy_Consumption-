# 🌱 Renewable Energy Consumption Forecasting (Time Series Analysis)

This project analyzes and forecasts renewable energy consumption using time series modeling techniques in R. The dataset spans multiple decades and explores stationarity, model fitting, residual diagnostics, and 20-year forecasting.

---

## 📌 Objective

To build and evaluate time series models (ARIMA) for forecasting future values of renewable energy consumption, and to identify the most suitable model based on accuracy metrics and diagnostics.

---

## 📁 Dataset

- File: `Dataset.xlsx`
- Variable: `Renewable.energy.consumption` (Yearly time series data)
- Cleaned using `na.omit()` to remove missing values.

---

## 🛠️ Methods and Workflow

### 🔹 Step 1: Data Preparation
- Load the data using `openxlsx`
- Remove missing values
- Convert to time series object with `ts()`
- Create a data frame for visualization

### 🔹 Step 2: Visualization
- Plot the time series using `ggplot2`
- Add line and points with proper labels

### 🔹 Step 3: Stationarity Tests
- Augmented Dickey-Fuller (ADF)
- Phillips-Perron (PP)
- KPSS (Level and Trend)
- DF-GLS via `urca::ur.ers()`

### 🔹 Step 4: Model Building
- `auto.arima()` for best-fit model
- Manual ARIMA models:
  - ARIMA(10,0,1)
  - ARIMA(0,1,0)
  - ARIMA(1,1,0)

### 🔹 Step 5: Model Evaluation
- Metrics from `summary()`: AIC, MASE, MAPE
- Residual diagnostics using:
  - `tsdisplay()`
  - Ljung-Box test (`Box.test()`)

### 🔹 Step 6: Forecasting
- Forecast for 2 years (short-term)
- Forecast for 20 years (long-term)
- Visualize forecasts with confidence intervals

---

## 📊 Model Performance Summary

| Model         | AIC     | MASE  | MAPE   | Residual Autocorrelation |
|---------------|---------|-------|--------|---------------------------|
| ARIMA(10,0,1) | 152.51  | 0.407 | 1.35   | ❌ None (Best Fit)        |
| ARIMA(0,1,0)  | 156.48  | 0.977 | 97.36  | ✅ Exists                 |
| ARIMA(1,1,0)  | 154.47  | 0.646 | 2.22   | ✅ Exists                 |

---

## 📦 R Packages Used

- `openxlsx` – for reading Excel data  
- `forecast` – for ARIMA modeling and forecasting  
- `tseries` – for ADF, PP, and KPSS tests  
- `urca` – for DF-GLS test  
- `ggplot2` – for data visualization  

---

## 🚀 How to Run

1. Open the R script in RStudio or R.
2. Make sure `Dataset.xlsx` is in your working directory.
3. Install required packages:
```r
install.packages(c("openxlsx", "forecast", "tseries", "urca", "ggplot2"))
