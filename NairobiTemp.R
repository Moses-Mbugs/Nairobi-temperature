# Moses Mbugua
# 2024

if (!is.element("languageserver", installed.packages()[, 1])) {
  install.packages("languageserver", dependencies = TRUE)
}
require("languageserver")

install.packages("moments")
install.packages("plotly")

library(readr)
Nairobi_temp <- read_csv("data/Nairobi_temp.csv")
View(Nairobi_temp)

# the dataset has both degrees and Fahrenheit step one is to impute that column
# Another thing to do is to get rid of the region, country, state and city as 
# the we will predict for Nairobi.

columns_to_remove <- c("Region", "Country", "State", "City", "AvgTemperature")

# Subset the data to exclude the specified columns
Nairobi_temp_subset <- Nairobi_temp[, !names(Nairobi_temp) %in% columns_to_remove]

#we will reduce the degree celsius to 1dp
Nairobi_temp_subset$`Degree Celsius` <- round(Nairobi_temp_subset$`Degree Celsius`, 1)

# Display the modified dataset
cat("\nModified Dataset (Columns Removed and Rounded):\n")
View(Nairobi_temp_subset)
     
#in this stage we still have negative vaules on the temperature which is inaccurate
# hence we need to remove them
Nairobi_temp_subset <- Nairobi_temp_subset[Nairobi_temp_subset$`Degree Celsius` != -72.8, ]
cat("\nModified Dataset (removed invalid degrees):\n")
View(Nairobi_temp_subset)

#plotting

# Install and load ggplot2 package if not installed
# install.packages("ggplot2")
library(ggplot2)

# Plot time series of rounded temperature values
#daily
ggplot(Nairobi_temp_subset, aes(x = as.Date(paste(Year, Month, Day, sep = "-")), y = `Degree Celsius`)) +
  geom_line() +
  labs(title = "Temperature Time Series", x = "Day", y = "Degree Celsius") +
  theme_minimal()

#Monthly
ggplot(Nairobi_temp_subset, aes(x = factor(Year), y = `Degree Celsius`)) +
  geom_boxplot(fill = "skyblue", color = "blue") +
  labs(title = "Temperature Distribution Across Months", x = "Month", y = "Degree Celsius") +
  theme_minimal()

#Annually
ggplot(Nairobi_temp_subset, aes(x = factor(Month), y = `Degree Celsius`)) +
  geom_boxplot(fill = "brown", color = "green") +
  labs(title = "Temperature Distribution Across Months", x = "Year", y = "Degree Celsius") +
  theme_minimal()
