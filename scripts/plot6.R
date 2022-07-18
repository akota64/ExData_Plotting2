## Generates plot6.png
## Assumes presence of exdata_data_NEI_data in the working directory of the R project

library(dplyr)
library(ggplot2)


bmore_fips <- "24510"
la_fips <- "06037"

## Load data
NEI <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")

## Subset NEI data to only those in Baltimore City or LA County
sub_nei <- subset(NEI, fips == bmore_fips | fips == la_fips)

## Get the factors that involve motor vehicles in EI.Sector of SCC and subset those SCC's
motor_facts <- grep("[Vv]ehicle", levels(SCC$EI.Sector), value = TRUE)
sub_scc <- subset(SCC, EI.Sector %in% motor_facts)$SCC

## Subset data from NEI that specifically comes from these SCC's 
motor_sub <- subset(sub_nei, SCC %in% sub_scc)
motor_sub <- transform(motor_sub, 
                       year=factor(year), 
                       fips=factor(fips, labels = c("Los Angeles County", "Baltimore City")))

## Summarize data over Baltimore City and LA County separately, and normalizing by
## computing the proportion change of emissions as compared to 1999 in each city
motor_summary <- motor_sub %>% 
    group_by(fips, year) %>% 
    summarize(total_emissions=sum(Emissions)) %>%
    mutate(emission_prop = total_emissions/first(total_emissions)) %>%
    mutate(year = as.numeric(as.character(year)), fips = as.character(fips)) %>%
    ungroup()

## Create plot with ggplot
png("plots/plot6.png")
g <- ggplot(motor_summary, aes(x = year, y = emission_prop))
g + geom_point(aes(color = fips)) + geom_line(aes(color = fips)) + 
    labs(x = "Year", y = expression('Change in PM'[2.5]*' Emissions (vs. 1999 PM'[2.5]*' Emissions)'), 
         color = "Area",
         title = expression("Comparing PM"[2.5]*" Emission Change between Baltimore City and LA County")) + 
    theme(plot.title = element_text(hjust = 0.2))
dev.off()
