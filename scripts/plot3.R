## Generates plot2.png
## Assumes presence of exdata_data_NEI_data in the working directory of the R project

library(dplyr)
library(ggplot2)

## Load data
NEI <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")

## Subset NEI data to only those in Baltimore City, fips 24510
bmore_data <- subset(NEI, fips == "24510")

## Formatting the type identifier nicer for display (lowercase instead of uppercase)
bmore_data$type <- tolower(bmore_data$type)

## Group and summarize by type and run same analysis as before
bmore_sum <- bmore_data %>% group_by(type, year) %>% summarize(total_emissions=sum(Emissions))

## Create plot with ggplot
png("plots/plot3.png")
g <- ggplot(bmore_sum, aes(year,total_emissions))
g + geom_line(aes(color = type)) + 
    labs(x = "Year", y = expression('PM'[2.5]*' Emissions (tons)'), color = "Type",
         title = expression("PM"[2.5]*" Emissions in Baltimore City from 1999-2008 by Type"))
dev.off()
