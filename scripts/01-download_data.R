#### Preamble ####
# Purpose: Downloads and saves the data from Open Data Toronto
# Author: Elizabeth Luong
# Date: 21 September 2024
# Contact: elizabethh.luong@mail.utoronto.ca


#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)

# get package
package <- show_package("21c83b32-d5a8-4106-a54f-010dbe49f6f2")
package

# get all resources for this package
resources <- list_package_resources("21c83b32-d5a8-4106-a54f-010dbe49f6f2")

# identify datastore resources; by default, Toronto Open Data sets datastore resource format to CSV for non-geospatial and GeoJSON for geospatial resources
datastore_resources <- filter(resources, tolower(format) %in% c('csv', 'geojson'))

# load the first datastore resource as a sample
data <- filter(datastore_resources, row_number()==1) %>% get_resource()
data

#### Save data ####
write_csv(data, "data/raw_data/unedited_tsss_data.csv")
