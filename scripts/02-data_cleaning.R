#### Preamble ####
# Purpose: Cleans the raw Toronto Shelter data into an analysis dataset
# Author: Elizabeth Luong
# Date: 21 September 2024
# Contact: elizabethh.luong@mail.utoronto.ca

#### Workspace setup ####
library(tidyverse)
library(tidygeocoder)  
library(dplyr)         
library(readr)    

#### Clean data ####
raw_data <- read_csv("data/raw_data/unedited_tsss_data.csv")

# Check structure of the dataset
head(data)
str(data)

# Check for missing values
colSums(is.na(data))

# Remove duplicates 
data_clean <- data %>% distinct()

# Convert date columns to Data type
data_clean <- data_clean %>% 
  mutate(across(contains("date"), as.Date, format = "%Y-%m-%d"))

# Convert categorical variables to factors
data_clean <- data_clean %>% 
  mutate(across(where(is.character), as.factor))

# Select location 
data_clean <- data_clean %>%
  filter(LOCATION_CITY == "Toronto")

# Ensure data is in string format 
data_clean$LOCATION_ADDRESS <- as.character(data_clean$LOCATION_ADDRESS)


# Geocoding the address field to get lat and lon values
data_clean <- data_clean %>%
  geocode(LOCATION_ADDRESS, method = 'osm', full_results = TRUE)

head(data_clean %>% select(LOCATION_ADDRESS, lat, long))

# Reverse geocode the latitude and longitude to get detailed location information, including the neighborhood
data_clean <- data_clean %>%
  reverse_geocode(lat = lat, long = long, method = 'osm', full_results = TRUE)

# View the columns to see the neighborhood information provided by OpenStreetMap
head(data_clean %>% select(LOCATION_ADDRESS, lat, long, address, suburb, city, state))

# Extract the relevant neighborhood or suburb information
data_clean <- data_clean %>%
  mutate(NEIGHBORHOOD = coalesce(suburb, neighbourhood, city))  # Use suburb or neighborhood if available, fallback to city

# View the cleaned dataset with the neighborhood information
head(data_clean %>% select(LOCATION_ADDRESS, lat, long, NEIGHBORHOOD))

# Check the structure of the OCCUPIED_BEDS column
str(data_clean$OCCUPIED_BEDS)

# If it's a factor, convert it to numeric
# Convert factors to characters, then to numeric
data_clean$OCCUPIED_BEDS <- as.numeric(as.character(data_clean$OCCUPIED_BEDS))
data_clean$CAPACITY_ACTUAL_BED <- as.numeric(as.character(data_clean$CAPACITY_ACTUAL_BED))
data_clean$SERVICE_USER_COUNT <- as.numeric(as.character(data_clean$SERVICE_USER_COUNT))

# Group by NEIGHBORHOOD and summarize key metrics (like occupied beds, available beds, user count)
neighborhood_summary <- data_clean %>%
  group_by(NEIGHBORHOOD) %>%
  summarize(
    total_shelters = n(),
    total_occupied_beds = sum(OCCUPIED_BEDS, na.rm = TRUE),
    total_available_beds = sum(CAPACITY_ACTUAL_BED, na.rm = TRUE),
    total_user_count = sum(SERVICE_USER_COUNT, na.rm = TRUE)
  )

# View the summary by neighborhood
print(neighborhood_summary)

# Inspect the cleaned data
head(data_clean)
str(data_clean)

#### Save data ####
write_csv(data_clean, "data/analysis_data/cleaned_tsss_data.csv")
write_csv(neighborhood_summary, "data/shelter_neighborhood_summary.csv")


