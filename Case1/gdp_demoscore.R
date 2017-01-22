require(ggplot2)
require(tidyr)
require(dplyr)
require(magrittr)

demo <- read.csv("Data/democracy_score_year_long.csv")
gdp <- read.csv("Data/gdp.csv")

gdp <- gdp %>% 
  gather(X1800:X2015, key="year", value="gdp") %>% 
  filter(!is.na(gdp))
gdp$year <- gsub("X", "", gdp$year) %>% as.character() %>% as.integer()
names(gdp)[1] <- "country"

world_powers <- 
  c("United States", "Russia", "China", "Germany", "United Kingdom",
    "France", "Japan", "Israel", "Saudi Arabia", "South Korea",
    "Canada", "Iran", "Australia", "India", "Italy", "Pakistan",
    "Turkey", "Sweden", "Netherlands", "Spain", "Egypt", "Brazil",
    "Singapore", "Denmark", "Jordan")

dat <- full_join(demo, gdp, by=c("country" = "country", "year" = "year")) %>% 
       filter(country %in% world_powers)

write.csv(dat, "gdp_demoscore.csv")

