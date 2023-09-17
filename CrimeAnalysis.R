library(tidyverse)
library(jsonlite)
library(knitr)
library(kableExtra)
library(scales)
library(maps)
library(rgdal)
library(maptools)
library(ggthemes)
library(broom)
library(gridExtra)
library(lubridate)

crime_raw <- read_csv("Crimes_-_2001_to_Present.csv") 
crime <- crime_raw %>%
  mutate(`Primary Type` = ifelse(`Primary Type` == "CRIM SEXUAL ASSAULT", 
                                 "CRIMINAL SEXUAL ASSAULT", `Primary Type`))

##Identifying the Top Ten Crimes Types in the dataset
top_types <- crime %>% 
  count(`Primary Type`) %>%
  arrange(desc(n)) %>%
  head(10)

## Crime rates for the Top ten Crime Types in 2019 and 2020
crime_2019_2020 <- crime %>%
  filter(Year == 2019 | Year == 2020) %>%
  mutate(Year = factor(Year, levels=c("2019", "2020"))) %>%
  group_by(Year) %>%
  count(`Primary Type`) %>% 
  filter(`Primary Type` %in% top_types$`Primary Type`)

perc_decrease <- crime_2019_2020 %>%
  pivot_wider(names_from = Year, values_from = n) %>%
  mutate(percent_decrease = (`2020` - `2019`)/`2019`) 


## Plots Crime rates for top ten types for 2019 and 2020
ggplot(crime_2019_2020) +
  geom_bar(aes(x=reorder(`Primary Type`, n), y=n, fill=Year), 
           stat="identity", 
           position = "dodge") +
  labs(title="Top 10 Types of Crime in Chicago for 2019 and 2020",
       x="", y="Number of Crimes Reported",
       caption="Source: Chicago Data Portal") +
  coord_flip() + 
  scale_y_continuous(breaks = seq(0,65000, by=10000))+
  theme_bw() + 
  theme(legend.title = element_text(""),
        plot.title.position = "plot",
        plot.caption.position = "plot",
        plot.caption = element_text(hjust = 0),
        legend.position = c(0.7, 0.4),
        legend.box.background = element_rect(color = "black"))

ggsave("CrimeBarGraph.png")

###############################################################################
## Crime rate differences and numbers from previous years

## Finding all types of crime that increased from 2019 to 2020
crime_diff_inc <- crime %>%
  filter(Year >= 2010 & Year < 2021) %>%
  group_by(Year) %>%
  count(`Primary Type`) %>%
  pivot_wider(names_from = Year, values_from=n) %>%
  mutate(Difference = `2020` - `2019`) %>%
  filter(Difference > 0)

## Creating kable
## Saved by using the export tab in the viewer
##   because ggsave doesn't work on kables
crime_diff_inc %>%
  select(`Primary Type`,`2019`, `2020`) %>%
  mutate(`Percent Increase` = percent((`2020` - `2019`)/`2019`)) %>%
  arrange(desc(`Percent Increase`)) %>%
  kable(align = 'lrrr') %>%
  kable_styling(bootstrap_options="striped", full_width=TRUE)


## Pivoting the data to make the plot easier, 
## Profile plot 
crime_diff_tall <- crime_diff_inc %>%
  select(-Difference)%>%
  pivot_longer(-`Primary Type`, names_to="Year", values_to="Count") %>%
  group_by(`Year`)
  
ggplot(crime_diff_tall) +
  geom_line(aes(x=Year, y=Count, group=`Primary Type`)) +
  labs(x="", y="Number of Crimes Reported",
       title="Crime Trends from 2010 to 2020",
       caption="Source: Chicago Data Portal")+
  facet_grid(`Primary Type`~., scale = "free_y", 
             labeller = label_wrap_gen(width = 10)) +
  scale_y_continuous(minor_breaks = NULL)+
  theme_bw() +
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        legend.key.size = unit(0.5, "cm"),
        plot.caption = element_text(hjust = 0))
 
ggsave("CrimeChangeProfile.png", width = 6, height = 4)

################################################################################
## Arson and Homicide over Time in 2020

## Accessing the API to get the community area codes and names
comm_area_codes <- fromJSON("https://data.cityofchicago.org/resource/igwz-8jzy.json") %>%
  select(community, area_num_1) %>%
  mutate(area_num_1 = as.numeric(area_num_1))

crime_2020 <-crime %>%
  filter(Year == 2020,
         `Primary Type` == "ARSON" |`Primary Type` == "HOMICIDE") %>%
  select(Date, `Primary Type`) %>%
  mutate(Date = as.Date(Date, "%m/%d/%y")) %>%
  group_by(Date, `Primary Type`) %>%
  count() 

ggplot(crime_2020) +
  geom_line(aes(x=Date, y=n, group=`Primary Type`)) +
  facet_grid(`Primary Type`~., scales = "free_y") +
  labs(x="", y="Number of Reported Crimes", 
       title="Crime in Chicago during 2020") +
  scale_x_date(breaks = seq(min(crime_2020$Date), max(crime_2020$Date), by="2 weeks"),
               minor_break=NULL,
               labels = date_format("%b %d") )+
  theme_bw()+
  theme(axis.text.x = element_text(angle = -90))

ggsave("Chicago2020.png", width=6, height=3)



################################################################################
### Community Area Map

## Downloading shape files
chi_map <- readOGR("/Users/ginakrynski/Desktop/STA 404/SoloProj/Boundaries", 
                   "geo_export_e306118f-986b-4eaa-8ad6-1804ef0ed888")

ggplot(chi_map) +
  geom_path(aes(x=long, y=lat, group=group)) +
  coord_quickmap() + 
  theme_map()

## Adding the community area names to the crime data filtered for 
##    the year 2020, arson and homicide
communities <- crime %>%
  filter(Year == 2020,
         `Primary Type` == "ARSON" | `Primary Type` == "HOMICIDE" )%>%
  group_by(`Community Area`) %>%
  count(`Primary Type`)%>%
  rename(total_crime = n) %>%
  pivot_wider(names_from=`Primary Type`, values_from = total_crime)

com_crime <- comm_area_codes %>% 
  left_join(communities, by=c("area_num_1"="Community Area"))%>%
  mutate(ARSON = ifelse(is.na(ARSON),0, ARSON),
         HOMICIDE = ifelse(is.na(HOMICIDE),0,HOMICIDE))
  

## Joining all the map data together
temp_chi <- chi_map@data
temp_chi <- temp_chi %>%
  select(area_num_1) %>%
  mutate(id = (0:(nrow(temp_chi)-1)))

temp_chi <- temp_chi %>%
  mutate(id = as.character(id))

chi_map2 <- tidy(chi_map)
chi_map2 <- left_join(chi_map2, temp_chi, by="id")

com_crime <- com_crime %>%
  mutate(area_num_1 = as.character(area_num_1))

chi_crime_map <- left_join(chi_map2, com_crime)

chi_crime_arson <- chi_crime_map %>%
  select(-HOMICIDE)

chi_crime_homicide <- chi_crime_map %>%
  select(-ARSON)

## Final Map plots
ggplot(chi_crime_arson) + 
  geom_polygon(aes(x=long, y=lat, group=group, fill=ARSON)) + 
  geom_path(aes(x=long, y=lat, group=group), color="gray50") + 
  theme_map() + 
  coord_quickmap() +
  labs(title="2020 Arson Frequency in Chicago")+
  scale_fill_gradient(low="gray95", high="darkred",
                      name="Frequency") +
  theme(legend.position=c(-0.1,0.2))

ggsave("ArsonMap.png", width = 4, height = 4)

ggplot(chi_crime_homicide) + 
    geom_polygon(aes(x=long, y=lat, group=group, fill=HOMICIDE)) + 
    geom_path(aes(x=long, y=lat, group=group), color="gray50") + 
    theme_map() + 
    coord_quickmap() +
    labs(title="2020 Homicide Frequency in Chicago")+
    scale_fill_gradient(low="gray95", high="navy",
                        name="Frequency") +
    theme(legend.position=c(-0.1,0.2))


ggsave("HomicideMap.png", width = 4, height = 4)

  



