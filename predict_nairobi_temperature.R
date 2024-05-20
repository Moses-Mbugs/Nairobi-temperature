#Moses Mbugua
#2024
# predict_nairobi_temperature.R


#Load Necessary Libraries
if (!require("readr")) install.packages("readr", dependencies = TRUE)
if (!require("dplyr")) install.packages("dplyr", dependencies = TRUE)
if (!require("lubridate")) install.packages("lubridate", dependencies = TRUE)
if (!require("caret")) install.packages("caret", dependencies = TRUE)

library(readr)
library(dplyr)
library(lubridate)
library(caret)

#Load the Data
Nairobi_temp <- read_csv("D:/school work/sem 2/BI 2/Nairobi-temperature/data/Nairobi_temp.csv")

#Preprocess the Data
columns_to_remove <- c("Region", "Country", "State", "City", "AvgTemperature")
Nairobi_temp <- Nairobi_temp[, !names(Nairobi_temp) %in% columns_to_remove]
Nairobi_temp <- Nairobi_temp[Nairobi_temp$`Degree Celsius` != -72.8, ]

# Feature Engineering
Nairobi_temp$Date <- as.Date(paste(Nairobi_temp$Year, Nairobi_temp$Month, Nairobi_temp$Day, sep = "-"))
Nairobi_temp$DayOfYear <- yday(Nairobi_temp$Date)
Nairobi_temp <- Nairobi_temp %>% select(Date, DayOfYear, `Degree Celsius`)
Nairobi_temp <- na.omit(Nairobi_temp)

Nairobi_temp <- Nairobi_temp %>%
  arrange(Date) %>%
  mutate(Lag1 = lag(`Degree Celsius`, 1),
         Lag2 = lag(`Degree Celsius`, 2),
         Lag3 = lag(`Degree Celsius`, 3))

Nairobi_temp <- na.omit(Nairobi_temp)

# Split the Data
set.seed(123)
trainIndex <- createDataPartition(Nairobi_temp$`Degree Celsius`, p = 0.8, list = FALSE)
trainData <- Nairobi_temp[trainIndex, ]
testData <- Nairobi_temp[-trainIndex, ]

# Model Training
model <- lm(`Degree Celsius` ~ DayOfYear + Lag1 + Lag2 + Lag3, data = trainData)
summary(model)

#Model Evaluation
predictions <- predict(model, testData)
MAE <- mean(abs(predictions - testData$`Degree Celsius`))
RMSE <- sqrt(mean((predictions - testData$`Degree Celsius`)^2))

cat("Mean Absolute Error: ", MAE, "\n")
cat("Root Mean Squared Error: ", RMSE, "\n")

#Make Predictions
future_dates <- data.frame(
  Date = seq(max(Nairobi_temp$Date) + 1, by = "day", length.out = 30),
  DayOfYear = yday(seq(max(Nairobi_temp$Date) + 1, by = "day", length.out = 30))
)

future_dates$Lag1 <- tail(Nairobi_temp$`Degree Celsius`, 1)
future_dates$Lag2 <- tail(Nairobi_temp$Lag1, 1)
future_dates$Lag3 <- tail(Nairobi_temp$Lag2, 1)

future_dates$PredictedTemp <- predict(model, newdata = future_dates)

View(future_dates)
