## Generates plot1.png
## Assumes presence of exdata_data_NEI_data in the working directory of the R project

## Load data
NEI <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")


## Convert year in NEI to factor variable, to find total sum across years
NEI$year <- as.factor(NEI$year)

## Find total sum of emissions by year, and store in a new df
em_by_year <- tapply(NEI$Emissions, NEI$year, sum)


## Plot data
png(filename = "plots/plot1.png")
plot(names(em_by_year), em_by_year, type="b", pch=17, 
     main = expression("PM"[2.5]*" Emissions in the US from 1999-2008"),
     xlab = "Year", ylab = expression('PM'[2.5]*' Emissions (tons)'))
dev.off()
