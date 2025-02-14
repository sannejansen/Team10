install.packages("haven") # import SPSS data
install.packages("dplyr") # data management
install.packages("ggplot2") # produce different types of plots
install.packages("cluster") # cluster analysis
install.packages("factoextra") # visualizes output of cluster analysis
install.packages("car") # for assessing significance of cluster differences (ANOVA)
install.packages("lubridate")
install.packages("reshape2")
install.packages("TSstudio")
install.packages("tidyverse")

library(haven)
library(dplyr)
library(ggplot2)
library(cluster)
library(factoextra)
library(car)
library(lubridate)
library(reshape2)
library(TSstudio)
library(tidyverse)


setwd("C:\\Users\\Gebruiker\\Documents\\Tilburg Uni\\Master\\Online Data collection and management\\Project") 

# Import the listings and calendar data
path_listings <-  "C:\\Users\\Gebruiker\\Documents\\Tilburg Uni\\Master\\Online Data collection and management\\Project\\listings_AMS.csv.gz"
path_calendar <-  "C:\\Users\\Gebruiker\\Documents\\Tilburg Uni\\Master\\Online Data collection and management\\Project\\calendar_AMS.csv.gz"

#File name for the dataset, to view and import it into R
AirBNB_AMS_listings <- read.csv(path_listings)
View(AirBNB_AMS_listings)

AirBNB_AMS_calendar <- read.csv(path_calendar)
View(AirBNB_AMS_calendar)

#Filter out the dollar sign before the prices
AirBNB_AMS_listings$price = as.numeric(gsub("\\$", "", AirBNB_AMS_listings$price))
View(AirBNB_AMS_listings)

#Filter out the NA and then calculate the mean price of the whole dataset
mean(AirBNB_AMS_listings$price, na.rm=TRUE)

#Filter out the NA for all columns
AirBNB_AMS_listings%>%
  filter(na.rm = TRUE)

na.omit(AirBNB_AMS_listings)

View(AirBNB_AMS_listings)

#See how many AirBNBs are rented per neighbourhood (the count)
AirBNB_AMS_listings %>%
  count(neighbourhood_cleansed)

#New dataset containing only the price and the neighbourhoods
Datasetnew1 <-  subset(AirBNB_AMS_listings, select = c ("neighbourhood_cleansed", "price"))
View (Datasetnew1)

Datasetnew1%>%
  filter(na.rm = TRUE)

#New dataset with average price per neighbourhood:
Datasetnew2 <- na.omit(Datasetnew1)

Datasetnew2_table <-  (Datasetnew2 %>%
                         group_by(neighbourhood_cleansed) %>%
                         summarise_at(vars(price), list(price = mean)))
#Average price:
print(Datasetnew2_table, n=Inf, na.rm=TRUE)

#To merge, make the column with the listings the same name for both datasets:
AirBNB_AMS_calendar_renamed <- AirBNB_AMS_calendar %>%
  rename(
    id = listing_id
  )
View(AirBNB_AMS_calendar_renamed)

#Put the neighbhourhood in the listings dataset
AirBNB_AMS_listings_with_id_and_neighbourhoods <- subset(AirBNB_AMS_listings, select = c(neighbourhood_cleansed, id))
View(AirBNB_AMS_listings_with_id_and_neighbourhoods)
                                             
AirBNB_Calendar_and_Listings <- merge(AirBNB_AMS_calendar_renamed, AirBNB_AMS_listings_with_id_and_neighbourhoods, by = "id", all.y = TRUE)
View(AirBNB_Calendar_and_Listings)

#Make a new dataset containing only the variables that are needed/the variables we want to look at: id, data, price, neighbourhood_cleansed
Neighbourhoods_price_date <- subset(AirBNB_Calendar_and_Listings, select = c(id, date, price, neighbourhood_cleansed))

View(Neighbourhoods_price_date)
#Filter out the dollar sign before the price in this new dataset
Neighbourhoods_price_date$price = as.numeric(gsub("\\$", "", Neighbourhoods_price_date$price))

View(Neighbourhoods_price_date)

#Filter out the first neighbourhood: Bijlmer-Centrum (Price_1BC)
Bijlmer_Centrum_complete <- subset(Neighbourhoods_price_date, neighbourhood_cleansed %in% c("Bijlmer-Centrum"))
Bijlmer_Centrum <-   na.omit(Bijlmer_Centrum_complete)

View(Bijlmer_Centrum)

#Then, make an average price per day for the 1st neighbourhood
Daily_mean_BC_average <-  (Bijlmer_Centrum %>%
                               group_by(date) %>%
                               summarise_at(vars(price), list(price = mean), na.rm = TRUE))

Daily_mean_BC_average <-  Daily_mean_BC_average %>%
  rename(Price_1BC = price)

#Filter out the second neighbourhood: Bijlmer-Oost (Price_2BO)
Bijlmer_Oost_complete <- subset(Neighbourhoods_price_date, neighbourhood_cleansed %in% c("Bijlmer-Oost"))
Bijlmer_Oost <-   na.omit(Bijlmer_Oost_complete)

View(Bijlmer_Oost)

#Then, make an average price per day for the 2nd neighbourhood
Daily_mean_BO_average <-  (Bijlmer_Oost %>%
                             group_by(date) %>%
                             summarise_at(vars(price), list(price = mean), na.rm = TRUE))

Daily_mean_BO_average <-  Daily_mean_BO_average %>%
  rename(Price_2BO = price)

View(Daily_mean_BO_average)
#Filter out the third neighbourhood: Bos en Lommer (Price_3BL)
Bijlmer_BL_complete <- subset(Neighbourhoods_price_date, neighbourhood_cleansed %in% c("Bos en Lommer"))
Bijlmer_Bos_Lommer <-   na.omit(Bijlmer_BL_complete)

View(Bijlmer_Bos_Lommer)

#Then, make an average price per day for the 3rd neighbourhood
Daily_mean_BL_average <-  (Bijlmer_Bos_Lommer %>%
                             group_by(date) %>%
                             summarise_at(vars(price), list(price = mean), na.rm = TRUE))

Daily_mean_BL_average <-  Daily_mean_BL_average %>%
  rename(Price_3BL = price)

View(Daily_mean_BL_average)

#Filter out the fourth neighbourhood: Buitenveldert-Zuidas (Price_4BZ)
Bijlmer_BZ_complete <- subset(Neighbourhoods_price_date, neighbourhood_cleansed %in% c("Buitenveldert - Zuidas"))
Bijlmer_Buiten_Zuid <-   na.omit(Bijlmer_BZ_complete)

View(Bijlmer_Buiten_Zuid)

#Then, make an average price per day for the 4th neighbourhood
Daily_mean_BZ_average <-  (Bijlmer_Buiten_Zuid %>%
                             group_by(date) %>%
                             summarise_at(vars(price), list(price = mean), na.rm = TRUE))

Daily_mean_BZ_average <-  Daily_mean_BZ_average %>%
  rename(Price_4BZ = price)

View(Daily_mean_BZ_average)

#Filter out the fifth neighbourhood: Centrum-Oost (Price_5CO)
Centrum_Oost_complete <- subset(Neighbourhoods_price_date, neighbourhood_cleansed %in% c("Centrum-Oost"))
Centrum_Oost <-   na.omit(Centrum_Oost_complete)

View(Centrum_Oost)

#Then, make an average price per day for the 5th neighbourhood
Daily_mean_CO_average <-  (Centrum_Oost %>%
                             group_by(date) %>%
                             summarise_at(vars(price), list(price = mean), na.rm = TRUE))

Daily_mean_CO_average <-  Daily_mean_CO_average %>%
  rename(Price_5CO = price)

View(Daily_mean_CO_average)

#Filter out the sixth neighbourhood: Centrum-West (Price_6CW)
Centrum_West_complete <- subset(Neighbourhoods_price_date, neighbourhood_cleansed %in% c("Centrum-West"))
Centrum_West <-   na.omit(Centrum_West_complete)

View(Centrum_West)

#Then, make an average price per day for the 6th neighbourhood
Daily_mean_CW_average <-  (Centrum_West %>%
                             group_by(date) %>%
                             summarise_at(vars(price), list(price = mean), na.rm = TRUE))
Daily_mean_CW_average <-  Daily_mean_CW_average %>%
  rename(Price_6CW = price)

View(Daily_mean_CW_average)

#Filter out the seventh neighbourhood: De Aker - Nieuw Sloten (Price_7DANS)
De_Aker_complete <- subset(Neighbourhoods_price_date, neighbourhood_cleansed %in% c("De Aker - Nieuw Sloten"))
De_Aker <-   na.omit(De_Aker_complete)
View(De_Aker)

#Then, make an average price per day for the 7th neighbourhood
Daily_mean_DANS_average <-  (De_Aker %>%
                             group_by(date) %>%
                             summarise_at(vars(price), list(price = mean), na.rm = TRUE))
Daily_mean_DANS_average <-  Daily_mean_DANS_average %>%
  rename(Price_7DANS = price)

View(Daily_mean_DANS_average)

#Filter out the eight neighbourhood: De Baarsjes - Oud-West (Price_8BOW)
De_Baarsjes_complete <- subset(Neighbourhoods_price_date, neighbourhood_cleansed %in% c("De Baarsjes - Oud-West"))
De_Baarsjes <-   na.omit(De_Baarsjes_complete)
View(De_Baarsjes)

#Then, make an average price per day for the 8th neighbourhood
Daily_mean_BOW_average <-  (De_Baarsjes %>%
                               group_by(date) %>%
                               summarise_at(vars(price), list(price = mean), na.rm = TRUE))
Daily_mean_BOW_average <-  Daily_mean_BOW_average %>%
  rename(Price_8BOW = price)

View(Daily_mean_BOW_average)

#Filter out the ninth neighbourhood: De Pijp - Rivierenbuurt )(Price_9DPRB)
De_Pijp_complete <- subset(Neighbourhoods_price_date, neighbourhood_cleansed %in% c("De Pijp - Rivierenbuurt"))
De_Pijp <-   na.omit(De_Pijp_complete)
View(De_Pijp)

#Then, make an average price per day for the 9th neighbourhood 
Daily_mean_DPRB_average <-  (De_Pijp %>%
                              group_by(date) %>%
                              summarise_at(vars(price), list(price = mean), na.rm = TRUE))
Daily_mean_DPRB_average <-  Daily_mean_DPRB_average %>%
  rename(Price_9DPRB = price)

View(Daily_mean_DPRB_average)

#Filter out the tenth neighbourhood: Gaasperdam - Driemond (Price_10GD)
Gaasperdam_complete <- subset(Neighbourhoods_price_date, neighbourhood_cleansed %in% c("Gaasperdam - Driemond"))
Gaasperdam <-   na.omit(Gaasperdam_complete)
View(Gaasperdam)

#Then, make an average price per day for the 10th neighbourhood
Daily_mean_GD_average <-  (Gaasperdam %>%
                               group_by(date) %>%
                               summarise_at(vars(price), list(price = mean), na.rm = TRUE))
Daily_mean_GD_average <-  Daily_mean_GD_average %>%
  rename(Price_10GD = price)

View(Daily_mean_GD_average)

#Filter out the eleventh neighbourhood: Geuzenveld - Slotermeer (Price_11GS)
Geuzenveld_complete <- subset(Neighbourhoods_price_date, neighbourhood_cleansed %in% c("Geuzenveld - Slotermeer"))
Geuzenveld <-   na.omit(Geuzenveld_complete)
View(Geuzenveld)

#Then, make an average price per day for the 11th neighbourhood
Daily_mean_GS_average <-  (Geuzenveld %>%
                             group_by(date) %>%
                             summarise_at(vars(price), list(price = mean), na.rm = TRUE))
Daily_mean_GS_average <-  Daily_mean_GS_average %>%
  rename(Price_11GS = price)

View(Daily_mean_GS_average)

#Filter out the twelfth neighbourhood: IJburg - Zeeburgereiland (Price_12IZ)
Ijburg_complete <- subset(Neighbourhoods_price_date, neighbourhood_cleansed %in% c("IJburg - Zeeburgereiland"))
Ijburg <-   na.omit(Ijburg_complete)
View(Ijburg)

#Then, make an average price per day for the 12th neighbourhood
Daily_mean_IZ_average <-  (Ijburg %>%
                             group_by(date) %>%
                             summarise_at(vars(price), list(price = mean), na.rm = TRUE))
Daily_mean_IZ_average <-  Daily_mean_IZ_average %>%
  rename(Price_12IZ = price)

View(Daily_mean_IZ_average)

#Filter out the thirteenth neighbourhood: Noord-Oost (Price_13NO)
Noord_Oost_complete <- subset(Neighbourhoods_price_date, neighbourhood_cleansed %in% c("Noord-Oost"))
Noord_Oost <-   na.omit(Noord_Oost_complete)
View(Noord_Oost)

#Then, make an average price per day for the 13th neighbourhood
Daily_mean_NO_average <-  (Noord_Oost %>%
                             group_by(date) %>%
                             summarise_at(vars(price), list(price = mean), na.rm = TRUE))
Daily_mean_NO_average <-  Daily_mean_NO_average %>%
  rename(Price_13NO = price)

View(Daily_mean_NO_average)

#Filter out the fourteenth neighbourhood: Noord-West (Price_14NW)
Noord_West_complete <- subset(Neighbourhoods_price_date, neighbourhood_cleansed %in% c("Noord-West"))
Noord_West <-   na.omit(Noord_West_complete)
View(Noord_West)

#Then, make an average price per day for the 14th neighbourhood
Daily_mean_NW_average <-  (Noord_West %>%
                             group_by(date) %>%
                             summarise_at(vars(price), list(price = mean), na.rm = TRUE))
Daily_mean_NW_average <-  Daily_mean_NW_average %>%
  rename(Price_14NW = price)

View(Daily_mean_NW_average)

#Filter out the 15th neighbourhood: Oostelijk Havengebied - Indische Buurt (Price_15OHIB)
Oostelijk_Havengebied_Indische_Buurt <- subset(Neighbourhoods_price_date, neighbourhood_cleansed %in% c("Oostelijk Havengebied - Indische Buurt"))
Oostenlijk_Havengebied_Indische_Buurt1 <-  na.omit(Oostelijk_Havengebied_Indische_Buurt)
View(Oostenlijk_Havengebied_Indische_Buurt1)

#Then, make an average price per day for the 15th neighbourhood
Daily_mean_OHIB_average <-  (Oostenlijk_Havengebied_Indische_Buurt1 %>%
                               group_by(date) %>%
                               summarise_at(vars(price), list(price = mean), na.rm = TRUE))
View(Daily_mean_OHIB_average)
Daily_mean_OHIB_average <- Daily_mean_OHIB_average %>%
  rename(Price_15OHIB = price)

#Filter out the sixteenth neighbourhood: Osdorp (Price_16OD)
Osdorp_complete <- subset(Neighbourhoods_price_date, neighbourhood_cleansed %in% c("Osdorp"))
Osdorp <-   na.omit(Osdorp_complete)
View(Osdorp)

#Then, make an average price per day for the 16th neighbourhood
Daily_mean_OD_average <-  (Osdorp %>%
                             group_by(date) %>%
                             summarise_at(vars(price), list(price = mean), na.rm = TRUE))
Daily_mean_OD_average <-  Daily_mean_OD_average %>%
  rename(Price_16OD = price)

View(Daily_mean_OD_average)

#Filter out the seventeenth neighbourhood: Oud-Noord (Price_17ON)
Oud_Noord_complete <- subset(Neighbourhoods_price_date, neighbourhood_cleansed %in% c("Oud-Noord"))
Oud_Noord <-   na.omit(Oud_Noord_complete)
View(Oud_Noord)

#Then, make an average price per day for the 17th neighbourhood
Daily_mean_ON_average <-  (Oud_Noord %>%
                             group_by(date) %>%
                             summarise_at(vars(price), list(price = mean), na.rm = TRUE))
Daily_mean_ON_average <-  Daily_mean_ON_average %>%
  rename(Price_17ON = price)

View(Daily_mean_ON_average)

#Filter out the eighteenth neighbourhood: Oud-Oost (Price_18OO)
Oud_Oost_complete <- subset(Neighbourhoods_price_date, neighbourhood_cleansed %in% c("Oud-Oost"))
Oud_Oost <-   na.omit(Oud_Oost_complete)
View(Oud_Oost)

#Then, make an average price per day for the 18th neighbourhood
Daily_mean_OO_average <-  (Oud_Oost %>%
                             group_by(date) %>%
                             summarise_at(vars(price), list(price = mean), na.rm = TRUE))
Daily_mean_OO_average <-  Daily_mean_OO_average %>%
  rename(Price_18OO = price)

View(Daily_mean_OO_average)

#Filter out the nineteenth neighbourhood: Slotervaart (Price_19SV)
Slotervaart_complete <- subset(Neighbourhoods_price_date, neighbourhood_cleansed %in% c("Slotervaart"))
Slotervaart <-   na.omit(Slotervaart_complete)
View(Slotervaart)

#Then, make an average price per day for the 19th neighbourhood
Daily_mean_SV_average <-  (Slotervaart %>%
                             group_by(date) %>%
                             summarise_at(vars(price), list(price = mean), na.rm = TRUE))
Daily_mean_SV_average <-  Daily_mean_SV_average %>%
  rename(Price_19SV = price)

View(Daily_mean_SV_average)

#Filter out the twentieth neighbourhood: Watergraafsmeer (Price_20WGM)
Watergraafsmeer_complete <- subset(Neighbourhoods_price_date, neighbourhood_cleansed %in% c("Watergraafsmeer"))
Watergraafsmeer <-   na.omit(Watergraafsmeer_complete)
View(Watergraafsmeer)

#Then, make an average price per day for the20th neighbourhood
Daily_mean_WGM_average <-  (Watergraafsmeer %>%
                             group_by(date) %>%
                             summarise_at(vars(price), list(price = mean), na.rm = TRUE))
Daily_mean_WGM_average <-  Daily_mean_WGM_average %>%
  rename(Price_20WGM = price)

View(Daily_mean_WGM_average)

#Filter out the twenty-first neighbourhood: Westerpark (Price_21WP)
Westerpark_complete <- subset(Neighbourhoods_price_date, neighbourhood_cleansed %in% c("Westerpark"))
Westerpark <-   na.omit(Westerpark_complete)
View(Westerpark)

#Then, make an average price per day for the 21st neighbourhood
Daily_mean_WP_average <-  (Westerpark %>%
                              group_by(date) %>%
                              summarise_at(vars(price), list(price = mean), na.rm = TRUE))
Daily_mean_WP_average <-  Daily_mean_WP_average %>%
  rename(Price_21WP = price)

View(Daily_mean_WP_average)

#Filter out the twenty-second neighbourhood: Zuid (Price_22ZUID)
Zuid_complete <- subset(Neighbourhoods_price_date, neighbourhood_cleansed %in% c("Zuid"))
Zuid <-   na.omit(Zuid_complete)
View(Zuid)

#Then, make an average price per day for the 22nd neighbourhood
Daily_mean_ZUID_average <-  (Zuid %>%
                             group_by(date) %>%
                             summarise_at(vars(price), list(price = mean), na.rm = TRUE))
Daily_mean_ZUID_average <-  Daily_mean_ZUID_average %>%
  rename(Price_22ZUID = price)

View(Daily_mean_ZUID_average)

#Dataset containing everything
All_Neighbourhoods_1_2 <- merge(Daily_mean_BC_average, Daily_mean_BO_average, by = "date", all.y = TRUE)
View(All_Neighbourhoods_1_2)

All_Neighbourhoods_3_4 <- merge(Daily_mean_BL_average, Daily_mean_BZ_average, by = "date", all.y = TRUE)
View(All_Neighbourhoods)

All_Neighbourhoods_1_4 <- merge(All_Neighbourhoods_1_2, All_Neighbourhoods_3_4, by = "date", all.y = TRUE)
View(All_Neighbourhoods_1_4)

All_Neighbourhoods_5_6 <- merge(Daily_mean_CO_average, Daily_mean_CW_average, by = "date", all.y = TRUE)
View(All_Neighbourhoods_5_6)

All_Neighbourhoods_7_8 <- merge(Daily_mean_DANS_average, Daily_mean_BOW_average, by = "date", all.y = TRUE)
View(All_Neighbourhoods_7_8)

All_Neighbourhoods_5_8 <- merge(All_Neighbourhoods_5_6, All_Neighbourhoods_7_8, by = "date", all.y = TRUE)
View(All_Neighbourhoods_5_8)

All_Neighbourhoods_1_8 <- merge(All_Neighbourhoods_1_4, All_Neighbourhoods_5_8, by = "date", all.y = TRUE)
View(All_Neighbourhoods_1_8)

All_Neighbourhoods_9_10 <- merge(Daily_mean_DPRB_average, Daily_mean_GD_average, by = "date", all.y = TRUE)
View(All_Neighbourhoods_9_10)

All_Neighbourhoods_11_12 <- merge(Daily_mean_GS_average, Daily_mean_IZ_average, by = "date", all.y = TRUE)
View(All_Neighbourhoods_11_12)

All_Neighbourhoods_9_12 <- merge(All_Neighbourhoods_9_10, All_Neighbourhoods_11_12, by = "date", all.y = TRUE)
View(All_Neighbourhoods_9_12)

All_Neighbourhoods_13_14 <- merge(Daily_mean_NO_average, Daily_mean_NW_average, by = "date", all.y = TRUE)
View(All_Neighbourhoods_13_14)

All_Neighbourhoods_15_16 <-  merge(Daily_mean_OHIB_average, Daily_mean_OD_average, by = "date", all.y = TRUE)
View(All_Neighbourhoods_15_16)

All_Neighbourhoods_13_16 <- merge(All_Neighbourhoods_13_14, All_Neighbourhoods_15_16, by = "date", all.y = TRUE)
View(All_Neighbourhoods_13_16)

All_Neighbourhoods_9_16 <- merge(All_Neighbourhoods_9_12, All_Neighbourhoods_13_16, by = "date", all.y = TRUE)
View(All_Neighbourhoods_9_16)

All_Neighbourhoods_1_16 <- merge(All_Neighbourhoods_1_8, All_Neighbourhoods_9_16, by = "date", all.y = TRUE)
View(All_Neighbourhoods_1_16)


All_Neighbourhoods_17_18 <- merge(Daily_mean_ON_average, Daily_mean_OO_average, by = "date", all.y = TRUE)
View(All_Neighbourhoods_17_18)

All_Neighbourhoods_19_20 <- merge(Daily_mean_SV_average, Daily_mean_WGM_average, by = "date", all.y = TRUE)
View(All_Neighbourhoods_19_20)

All_Neighbourhoods_21_22 <- merge(Daily_mean_WP_average, Daily_mean_ZUID_average, by = "date", all.y = TRUE)
View(All_Neighbourhoods_21_22)

All_Neighbourhoods_17_20 <- merge(All_Neighbourhoods_17_18, All_Neighbourhoods_19_20, by = "date", all.y = TRUE)
View(All_Neighbourhoods_17_20)

All_Neighbourhoods_17_22 <- merge(All_Neighbourhoods_17_20, All_Neighbourhoods_21_22, by = "date", all.y = TRUE)
View(All_Neighbourhoods_17_22)

All_Neighbourhoods <- merge(All_Neighbourhoods_1_16, All_Neighbourhoods_17_22, by = "date", all.y = TRUE)
View(All_Neighbourhoods)

#Make a new .csv file for the All_Neighbourhoods dataset

write.csv(All_Neighbourhoods, "C:\\Users\\Gebruiker\\Documents\\Tilburg Uni\\Master\\Online Data collection and management\\Project\\All_Neighbourhoods.csv.gz", row.names = FALSE)
write.csv(All_Neighbourhoods, "C:\\Users\\Gebruiker\\Documents\\Tilburg Uni\\Master\\Online Data collection and management\\Project\\All_Neighbourhoods.csv", row.names = FALSE)


#See an example plot of only one neighbourhood here
D1 <- Daily_mean_OHIB_average
D1$date <- as.Date(D1$date)
Date <- D1$date
Price <-  D1$Price_15OHIB
D1 <- D1[order(Date),]
D1

View(Daily_mean_OHIB_average)
#Plot for only OHIB
plot(Date,
     Price,
     main = "Oostenlijk Havengebied - Indische Buurt",
     type = "l",
     col = "pink", 
     lwd = "2",
     xaxt = "n")
axis(1,
     D1$date,
     format(D1$date, "%m"))
#See the data in a scatterplot here:
scatter.smooth(x=Date, y = Price, main = "OHB")

#plot for EVERYTHING
All_Neighbourhoods$date <- D1$date
Date <- All_Neighbourhoods$date
Price <- All_Neighbourhoods$Price_1BC
na.omit(All_Neighbourhoods)

All_Neighbourhoods$date <- D1$date

View(All_Neighbourhoods)
#See the whole graph with EVERYTHING plotted:
plot(Date,
     Price,
     type = "l",
     col = "1", 
     lwd = "2",
     ylim = c(100,247))
lines(All_Neighbourhoods$date, 
      All_Neighbourhoods$Price_2BO, 
      type = "l",
      lwd = "2",
      col = "2")
lines(All_Neighbourhoods$date, 
      All_Neighbourhoods$Price_3BL, 
      type = "l",
      lwd = "2",
      col = "3")
lines(All_Neighbourhoods$date, 
      All_Neighbourhoods$Price_4BZ, 
      type = "l",
      lwd = "2",
      col = "4")
lines(All_Neighbourhoods$date, 
      All_Neighbourhoods$Price_5CO, 
      type = "l",
      lwd = "2",
      col = "11")
lines(All_Neighbourhoods$date, 
      All_Neighbourhoods$Price_6CW, 
      type = "l",
      lwd = "2",
      col = "6")                   
lines(All_Neighbourhoods$date, 
      All_Neighbourhoods$Price_7DANS, 
      type = "l",
      lwd = "2",
      col = "7")
lines(All_Neighbourhoods$date, 
      All_Neighbourhoods$Price_8BOW, 
      type = "l",
      lwd = "2",
      col = "8")                              
lines(All_Neighbourhoods$date, 
      All_Neighbourhoods$Price_9DPRB, 
      type = "l",
      lwd = "2",
      col = "pink")
lines(All_Neighbourhoods$date, 
      All_Neighbourhoods$Price_10GD, 
      type = "l",
      lwd = "2",
      col = "10")
lines(All_Neighbourhoods$date, 
      All_Neighbourhoods$Price_11GS, 
      type = "l",
      lwd = "2",
      col = "5")
lines(All_Neighbourhoods$date, 
      All_Neighbourhoods$Price_12IZ, 
      type = "l",
      lwd = "2",
      col = "12")
lines(All_Neighbourhoods$date, 
      All_Neighbourhoods$Price_13NO, 
      type = "l",
      lwd = "2",
      col = "violetred3")                   
lines(All_Neighbourhoods$date, 
      All_Neighbourhoods$Price_14NW, 
      type = "l",
      lwd = "2",
      col = "14")
lines(All_Neighbourhoods$date, 
      All_Neighbourhoods$Price_15OHIB, 
      type = "l",
      lwd = "2",
      col = "lemonchiffon3")                                            
lines(All_Neighbourhoods$date, 
      All_Neighbourhoods$Price_16OD, 
      type = "l",
      lwd = "2",
      col = "16")                   
lines(All_Neighbourhoods$date, 
      All_Neighbourhoods$Price_17ON, 
      type = "l",
      lwd = "2",
      col = "17")
lines(All_Neighbourhoods$date, 
      All_Neighbourhoods$Price_18OO, 
      type = "l",
      lwd = "2",
      col = "18")                              
lines(All_Neighbourhoods$date, 
      All_Neighbourhoods$Price_19SV, 
      type = "l",
      lwd = "2",
      col = "19")
lines(All_Neighbourhoods$date, 
      All_Neighbourhoods$Price_20WGM, 
      type = "l",
      lwd = "2",
      col = "20")
lines(All_Neighbourhoods$date, 
      All_Neighbourhoods$Price_21WP, 
      type = "l",
      lwd = "2",
      col = "21")
lines(All_Neighbourhoods$date, 
      All_Neighbourhoods$Price_22ZUID,
      type = "l",
      lwd = "2",
      col = "violetred3")
legend(x = "topright",
       legend = c("BC", "BO", "BL","BZ", "CO", "CW","DANS", "BOW", "DPRB","GD", "GS", "IZ", "NO", "NW", "OHIB", "OD", "ON", "OO", "SV", "WGM", "WP", "ZUID"),
       lty = c(1,1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ,1, 1 ,1 ,1 , 1, 1, 1),
       col = c(1, 2, 3, 4, 11, 6, 7, 8, 'pink', 10, 5, 12, 'violetred3', 14, 'lemonchiffon3', 16, 17, 18, 19, 20, 21, 22),
       lwd = 2)

#Correlation matrix between all the neighbourhoods' prices
See_All_neighbourhoods_without_date <- All_Neighbourhoods[,2:23]
View(See_All_neighbourhoods_without_date)

cor(See_All_neighbourhoods_without_date)

summary(See_All_neighbourhoods_without_date)

#Average prices per day
See_All_neighbourhoods_without_date$Daily_price_means <- rowMeans(See_All_neighbourhoods_without_date)

View(See_All_neighbourhoods_without_date)

See_All_neighbourhoods_without_date_First_seven <- head(See_All_neighbourhoods_without_date, 7)
View(See_All_neighbourhoods_without_date_First_seven)

See_All_neighbourhoods_without_date_First_seven <- head(See_All_neighbourhoods_without_date, 7)
View(See_All_neighbourhoods_without_date_First_seven)

See_All_neighbourhoods_without_date_Last_seven <- tail(See_All_neighbourhoods_without_date, 7)
View(See_All_neighbourhoods_without_date_Last_seven)

colMeans(See_All_neighbourhoods_without_date_First_seven)
colMeans_See_All_neighbourhoods_without_date_First_seven <-  colMeans(See_All_neighbourhoods_without_date_First_seven)
View(colMeans_See_All_neighbourhoods_without_date_First_seven)

colMeans(See_All_neighbourhoods_without_date_Last_seven)
colMeans_See_All_neighbourhoods_without_date_Last_seven <-  colMeans(See_All_neighbourhoods_without_date_Last_seven)
View(colMeans_See_All_neighbourhoods_without_date_Last_seven)

Difference_colMeans <- print(colMeans_See_All_neighbourhoods_without_date_First_seven- colMeans_See_All_neighbourhoods_without_date_Last_seven )

Price_Change <- print(Difference_colMeans/colMeans_See_All_neighbourhoods_without_date_First_seven)

Price_Change_100 <- print(Price_Change * 100)

