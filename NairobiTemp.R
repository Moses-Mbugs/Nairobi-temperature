# Moses Mbugua
# 2024

if (!is.element("languageserver", installed.packages()[, 1])) {
  install.packages("languageserver", dependencies = TRUE)
}
require("languageserver")

install.packages("moments")
install.packages("plotly")

# Load data
data <- read.csv("Nairobi_temp.csv")

