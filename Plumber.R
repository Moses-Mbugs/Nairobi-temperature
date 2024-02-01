if (!requireNamespace("plumber", quietly = TRUE)) {
  install.packages("plumber")
}
if (!requireNamespace("plumber", quietly = TRUE)) {
  install.packages("plumber")
}
if (!requireNamespace("jsonlite", quietly = TRUE)) {
  install.packages("jsonlite")


# Load necessary libraries
library(plumber)
library(MASS)  # 

# Load the LDA model
avacado_price_prediction_dateset_model_lda <- readRDS("./model/saved_avacado_price_prediction_dateset_model_lda.rds")

# Create a Plumber router
pr <- plumb()

# Define the endpoint for prediction
pr$register(
  "/predict",
  post = function(req, res) {
    # Convert the JSON input to a data frame
    input_data <- as.data.frame(fromJSON(req$postBody))
    
    # Make predictions using the LDA model
    predictions <- predict(avocado_price_prediction_dateset_model_lda, newdata = input_data)
    
    # Return the predictions as JSON
    res$setHeader("Content-Type", "application/json")
    return(list(predictions = as.numeric(predictions$class)))
  }
)

# Run the Plumber API on a specified port (e.g., 8000)
pr$run(port = 8000)

