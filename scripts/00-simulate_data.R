# Purpose: Simulates data
# Author: Elizabeth Luong
# Date: 21 September 2024
# Contact: elizabethh.luong@mail.utoronto.ca


#### Workspace setup ####
library(tidyverse)


#### Simulate data ####
set.seed(123)

# Define the start and end date
start_date <- as.Date("2018-01-01")
end_date <- as.Date("2023-12-31")

# Set the number of random dates for each record
number_of_records <- 1000

dates <- as.Date(
  runif(
    n = number_of_records,
    min = as.numeric(start_date),
    max = as.numeric(end_date)
  ),
  origin = "1970-01-01"
)

# stimulate Overnight Service Type
overnight_service_type <- sample(
  c("Shelter", "Hotel Program", "Family Program", "Crisis Services"),
  size = number_of_records, replace = TRUE
)

#Stimulate Capacity based on Overnight Service Type
capacity_type <-ifelse(overnight_service_type %in% c("Shelter", "Crisis Services"),
                       "Bed-based", "Room-based")

#Stimulate Funding Capacity: Different ranges for Bed-based vs. Room-based
funding_capacity <- ifelse(capacity_type == "Bed-based",
                           sample(50:200, size = number_of_records, replace = TRUE),
                           sample(10:50, size = number_of_records, replace = TRUE))

# Stimulate Actual Capacity as percentage of Funding Capacity (85%)
actual_capacity <- round(funding_capacity * runif(number_of_records, 0.85, 1.0))

# Stimulate Occupancy
occupancy <- round(actual_capacity * runif(number_of_records, 0.75, 1.0))

# Stimulate Location 
location <- sample(
  c("Downtown", "North York", "Scarborough", "Etobicoke"),
  size = number_of_records, replace = TRUE
)

data_simulate <- tibble(
  service_date = dates,
  overnight_service_type = overnight_service_type,
  capacity_type = capacity_type,
  funding_capacity = funding_capacity,
  actual_capacity = actual_capacity,
  occupancy = occupancy,
  location = location
)


#### Write csv
write_csv(data_simulate, file = "data/raw_data/simulated_tsss_data.csv")


