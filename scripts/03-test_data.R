#### Preamble ####
# Purpose: Check the data
# Author: Elizabeth Luong
# Date: 21 September 2024
# Contact: elizabethh.luong@mail.utoronto.ca
# Pre-requisites: Need to have simulated data
# Any other information needed? None.


#### Workspace setup ####
library(tidyverse)


#### Test data ####
data_simulate <- read_csv("data/raw_data/simulated_tsss_data.csv")


# Test for negative values in numerical columns
negative_values_test <- data_simulate %>% 
  summarise(
    negative_funding_capacity = min(funding_capacity) < 0,
    negative_actual_capacity = min(actual_capacity) < 0,
    negativee_occupancy = min(occupancy) < 0
  )

negative_values_test

# Test for occupancy exceeding actual capacity 
# Occupancy should never be greater than the actual capacity
occupancy_vs_capacity_test <- all(data_simulate$occupancy <= data_simulate$actual_capacity)
occupancy_vs_capacity_test
# TRUE if the test passes, FAIL if there is an issue

# Test for missing values in key columns
# There should not be any missing values in the critical columns
missing_values_test <- data_simulate %>%
  summarise(
    missing_service_date = any(is.na(service_date)),
    missing_overnight_service_type = any(is.na(overnight_service_type)),
    missing_capacity_type = any(is.na(capacity_type)),
    missing_funding_capacity = any(is.na(funding_capacity)),
    missing_actual_capacity = any(is.na(actual_capacity)),
    missing_occupancy = any(is.na(occupancy)),
    missing_location = any(is.na(location))
  )

missing_values_test

# Test for occupancy rate calculations
# Ensure that the calculated occupancy rate is a valid percentage 
data_simulate <- data_simulate %>% 
  mutate(occupancy_rate = occupancy / actual_capacity * 100)

valid_occupancy_rate_test <- all(data_simulate$occupancy_rate >= 0 & data_simulate$occupancy_rate <= 100)
valid_occupancy_rate_test
# TRUE if all occupancy rates are valid, FALSE if there is an issue

summary(data_simulate)

# Check the results of the tests
list(
  negative_values_test = negative_values_test,
  occupancy_vs_capacity_test = occupancy_vs_capacity_test,
  missing_values_test = missing_values_test,
  valid_occupancy_rate_test = valid_occupancy_rate_test
)
