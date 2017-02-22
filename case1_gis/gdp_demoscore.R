require(ggplot2)
require(tidyr)
require(dplyr)
require(magrittr)

demo <- read.csv("Data/democracy_score_year_long.csv")
gdp <- read.csv("Data/gdp.csv")
le <- read.csv("Data/life_expectancy.csv")

world_powers <- 
  c("United States", "Russia", "China", "Germany", "United Kingdom",
    "France", "Japan", "Israel", "Saudi Arabia", "South Korea",
    "Canada", "Iran", "Australia", "India", "Italy", "Pakistan",
    "Turkey", "Sweden", "Netherlands", "Spain", "Egypt", "Brazil",
    "Singapore", "Denmark", "Jordan")

# correct gdp colnames and year labels 
gdp <- gdp %>% 
  gather(X1800:X2015, key="year", value="gdp") %>% 
  filter(!is.na(gdp))
gdp$year <- gsub("X", "", gdp$year) %>% as.character() %>% as.integer()
names(gdp)[1] <- "country"

# ditto for life expectancy
names(le)[1] <- "country"
le <- le %>% 
  gather(X1800:X2016, key="year", value="life_expectancy") %>% 
  filter(!is.na(life_expectancy))
le$year <- gsub("X", "", le$year) %>% as.integer()

# join data demo, gdp, and life expectancy
dat <- full_join(demo, gdp, by=c("country" = "country", "year" = "year")) %>% 
       full_join(le, by=c("country" = "country", "year" = "year")) %>% 
       filter(country %in% world_powers) %>% 
       select(-X)

# check observation counts
table(dat$country)

write.csv(dat, "gdp_demoscore_le.csv", row.names = F)

