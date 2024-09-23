#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(ggplot2)

#### Read data ####
analysis_data <- read_csv("data/analysis_data/cleaned_tsss_data.csv")

### Model data ####

# Bar graph: Total occupied beds by neighborhood
ggplot(neighborhood_summary, aes(x = NEIGHBORHOOD, y = total_occupied_beds)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  theme_minimal() +
  labs(
    title = "Total Occupied Beds by Neighborhood",
    x = "Neighborhood",
    y = "Total Occupied Beds"
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels for readability

# Bar graph: Total available beds by neighborhood
ggplot(neighborhood_summary, aes(x = NEIGHBORHOOD, y = total_available_beds)) +
  geom_bar(stat = "identity", fill = "lightgreen") +
  theme_minimal() +
  labs(
    title = "Total Available Beds by Neighborhood",
    x = "Neighborhood",
    y = "Total Available Beds"
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Bar graph: Total user count by neighborhood
ggplot(neighborhood_summary, aes(x = NEIGHBORHOOD, y = total_user_count)) +
  geom_bar(stat = "identity", fill = "lightcoral") +
  theme_minimal() +
  labs(
    title = "Total User Count by Neighborhood",
    x = "Neighborhood",
    y = "Total User Count"
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Create a summary table of shelter data by neighborhood
neighborhood_summary <- data_clean %>%
  group_by(NEIGHBORHOOD) %>%
  summarize(
    total_occupied_beds = sum(OCCUPIED_BEDS, na.rm = TRUE),
    total_available_beds = sum(CAPACITY_ACTUAL_BED, na.rm = TRUE),
    total_user_count = sum(SERVICE_USER_COUNT, na.rm = TRUE)
  )

# Print the summary table
print(neighborhood_summary)

# Scatter plot with line of best fit: Available beds vs. User count
ggplot(data_clean, aes(x = CAPACITY_ACTUAL_BED, y = SERVICE_USER_COUNT)) +
  geom_point(color = "blue") +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  theme_minimal() +
  labs(
    title = "Relationship Between Available Beds and User Count",
    x = "Available Beds",
    y = "User Count"
  )

## Calculate the occupancy rate for each neighborhood
neighborhood_summary <- neighborhood_summary %>%
  mutate(occupancy_rate = (total_occupied_beds / total_available_beds) * 100)

# View the updated neighborhood summary with occupancy rate
print(neighborhood_summary)

# Bar graph: Occupancy rate by neighborhood
ggplot(neighborhood_summary, aes(x = NEIGHBORHOOD, y = occupancy_rate)) +
  geom_bar(stat = "identity", fill = "purple") +
  theme_minimal() +
  labs(
    title = "Occupancy Rate by Neighborhood",
    x = "Neighborhood",
    y = "Occupancy Rate (%)"
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Calculate capacity-to-demand ratio
neighborhood_summary <- neighborhood_summary %>%
  mutate(capacity_demand_ratio = total_available_beds / total_user_count)

# View the updated summary with capacity-to-demand ratio
print(neighborhood_summary)

# Bar graph: Capacity-to-demand ratio by neighborhood
ggplot(neighborhood_summary, aes(x = NEIGHBORHOOD, y = capacity_demand_ratio)) +
  geom_bar(stat = "identity", fill = "orange") +
  theme_minimal() +
  labs(
    title = "Capacity-to-Demand Ratio by Neighborhood",
    x = "Neighborhood",
    y = "Capacity-to-Demand Ratio"
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
