1# Check if renv package is available and initialize it if needed
if (!require("renv")) {
  install.packages("renv", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
} else {
  renv::init() # Initialize renv
}

# Check and install plumber package
if (!require("plumber")) {
  install.packages("plumber", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
} else {
  library(plumber)
}

# Load the Plumber API file
api <- plumber::plumb("Plumber.R")

# Run the API on a specific host and port
api$run(host = "127.0.0.1", port = 5022)

