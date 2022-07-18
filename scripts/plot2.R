## Generates plot2.png
## Assumes presence of exdata_data_NEI_data in the working directory of the R project

## Load data
NEI <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")

## Subset NEI data to only those in Baltimore City, fips 24510
bmore_data <- subset(NEI, fips == "24510")
    
## Convert year in Baltimore City data to factor variable, to find total sum across years
bmore_data$year <- as.factor(bmore_data$year)

## Find total sum of emissions by year, and store in a new df
em_by_year <- tapply(bmore_data$Emissions, bmore_data$year, sum)


## Plot data
png(filename = "plots/plot2.png")
plot(names(em_by_year), em_by_year, type="b", pch=17, 
     main = expression("PM"[2.5]*" Emissions in Baltimore City from 1999-2008"),
     xlab = "Year", ylab = expression('PM'[2.5]*' Emissions (tons)'))
dev.off()