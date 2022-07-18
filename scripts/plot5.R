## Generates plot5.png
## Assumes presence of exdata_data_NEI_data in the working directory of the R project

## Load data
NEI <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")

## Subset NEI data to only those in Baltimore City, fips 24510
bmore_data <- subset(NEI, fips == "24510")

## Get the factors that involve motor vehicles in EI.Sector of SCC and subset those SCC's
motor_facts <- grep("[Vv]ehicle", levels(SCC$EI.Sector), value = TRUE)
sub_scc <- subset(SCC, EI.Sector %in% motor_facts)$SCC

## Get NEI data that come from the motor vehicle SCC's 
sub_bmore <- subset(bmore_data, SCC %in% sub_scc)
sub_bmore <- transform(sub_bmore, year=factor(year))

## tapply to get data by year
bmore_motor_em_by_year <- tapply(sub_bmore$Emissions, sub_bmore$year, sum)

## Plot data
png(filename = "plots/plot5.png")
plot(names(bmore_motor_em_by_year), bmore_motor_em_by_year, type="b", pch=15, 
     main = expression("Motor Vehicle PM"[2.5]*" Emissions in Baltimore City from 1999-2008"),
     xlab = "Year", ylab = expression('PM'[2.5]*' Emissions (tons)'))
dev.off()
