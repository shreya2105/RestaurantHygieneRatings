library(tidyverse)
#install.packages("rsconnect")
#rest_data <- read.csv("/Users/shreyaagarwal/Documents/Code/ShinyApps/RestaurantRatings/data/rest_data_filtered.csv")


# d1 <- read.csv("/Users/shreyaagarwal/Documents/Code/ShinyApps/RestaurantRatings/data/data_restaurants_20.csv") 
# d2 <- read.csv("/Users/shreyaagarwal/Documents/Code/ShinyApps/RestaurantRatings/data/data_restaurants_next_lot.csv") 
# d3 <- read.csv("/Users/shreyaagarwal/Documents/Code/ShinyApps/RestaurantRatings/data/data_restaurants_next_lot1.csv") 
# d4 <- read.csv("/Users/shreyaagarwal/Documents/Code/ShinyApps/RestaurantRatings/data/data_restaurants_next_lot2.csv") 
# 
# data <- rbind(d1,d2)
# data <- rbind(data,d3)
# data <- rbind(data,d4)
# 
# unique(data$type)
# 
# data1 <- data %>% filter (type !="Distributors/Transporters" & type !="Importers/Exporters"
#                                    & type !="Mobile caterer" & type !="Other catering premises"
#                                    & type !="Retailers - other" & type !="Caring Premises"
#                                    & type !="Retailers - supermarkets/hypermarkets" & type !="School/college/university"
#                                    &  type !="Hotel/bed & breakfast/guest house" & type !="Manufacturers/packers"
#                                    & type !="Farmers/growers")
# 
# data1 <- data1 %>% filter (!is.na(long))
# data2 <- data1 [!duplicated(data1[c("long","lat")]),]
# unique(data2$Ratings)
# 
# data2 <- data2 %>% filter (Ratings !="AwaitingInspection" & Ratings !="Exempt"
#                           & Ratings !="Pass" & Ratings !="Improvement Required"
#                           & Ratings !="Awaiting Inspection" & Ratings !="Pass and Eat Safe"
#                           & Ratings !="AwaitingPublication")
# 
# county <- read.csv("/Users/shreyaagarwal/Documents/Code/ShinyApps/RestaurantRatings/data_counties.csv")
# names(county)[3] <- "Authority"
# data2 <- left_join(data2, county, by = "Authority")  
# data2 <- data2 %>% select("name", "type", "address", "postcode", "long", "lat", "Ratings","Authority","RegionName")
# 
# dim(data2)
# summary(data2)
# 
# write.csv(data2, "/Users/shreyaagarwal/Documents/Code/ShinyApps/RestaurantRatings/data/data_f.csv")
rest_data <- read.csv("data_f.csv")
rest_data$name <- as.character(rest_data$name)
rest_data$address <- as.character(rest_data$address)

