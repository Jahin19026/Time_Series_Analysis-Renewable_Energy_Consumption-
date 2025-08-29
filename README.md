### Renewable Energy Consumption Forecasting (Time Series Analysis + Machine Learning)
## 📌 Project Overview

This project applies time series forecasting techniques to predict renewable energy consumption (1980–2023) using ARIMA models. The goal is to evaluate different ARIMA specifications, perform model diagnostics, and generate reliable forecasts for the next one decades.

## 📂 Dataset

Source: Dataset.xlsx

Variable: Renewable.energy.consumption (annual frequency, 1980–2023)

Cleaned with na.omit() to handle missing values

Converted into a time series object with ts()

## ⚙️ Methods & Workflow

Exploratory Data Analysis

Time series plotting with ggplot2

Stationarity checks: ADF, PP, KPSS, DF-GLS

Model Building

Candidate ARIMA models:

ARIMA(10,0,1)

ARIMA(9,0,0)

ARIMA(1,1,1)

auto.arima() suggested ARIMA(0,1,0)

Diagnostic Checking

Residual analysis (ACF, PACF, Ljung–Box test)

Heteroskedasticity: ARCH test

Normality: Shapiro–Wilk, Anderson–Darling, Jarque–Bera

Transformation

Applied Box–Cox transformation (λ ≈ 0.70) to improve residual distribution.

Forecasting & Validation

Train set: 1980–2010

Test set: 2011–2021

Out-of-sample forecasts for 11 years

Accuracy compared using RMSE, MAE, MAPE, MASE

Visualization

Forecast plots for each model

Arranged in 2×2 grids with gridExtra

<img width="1366" height="729" alt="image" src="https://github.com/user-attachments/assets/c70a7b08-b4a2-43eb-a93f-c9a3889e0711" />

## 📊 Results

Best model (test accuracy): ARIMA(9,0,0)

Performance metrics (2011–2021 test set):

Lowest RMSE and MAPE among tested models

Final model will be used to generate 10-year forecasts (2024–2033)

<img width="1366" height="726" alt="image" src="https://github.com/user-attachments/assets/db5a5347-c963-4dd7-9c5b-0a5f6dddb537" />

## 🚀 How to Run

Clone this repository

git clone https://github.com/Jahin19026/Time_Series_Analysis-Renewable_Energy_Consumption.git

cd Time_Series_Analysis-Renewable_Energy_Consumption


Install required R packages:

install.packages(c("openxlsx","tseries","forecast","ggplot2",
                   "urca","FinTS","nortest","gridExtra"))


Open Renewable energy.R in RStudio

Run the script to reproduce results and plots

## 📌 Future Work

Explore Ensemble Forecasting (averaging ARIMA + ETS + ML models)

Test exogenous variables (ARIMAX) for improved accuracy

Deploy as an interactive Shiny app for visualization
