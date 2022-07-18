## Generates plot4.png
## Assumes presence of exdata_data_NEI_data in the working directory of the R project

## Load data
NEI <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")

## Need to find the factors that involve coal combustion in EI.Sector of SCC and subset those SCC's
coal_facts <- grep("[Cc]oal", levels(SCC$EI.Sector), value = TRUE)
sub_scc <- subset(SCC, EI.Sector %in% coal_facts)$SCC

## Subset data from NEI that specifically comes from these SCC's 
sub_nei <- subset(NEI, SCC %in% sub_scc)

## tapply across years to get yearly emissions 
coal_em_by_year <- tapply(sub_nei$Emissions, sub_nei$year, sum)


## Plot data
png(filename = "plots/plot4.png")
plot(names(coal_em_by_year), coal_em_by_year, type="b", pch=19, 
     main = expression("Coal-Related PM"[2.5]*" Emissions in the US from 1999-2008"),
     xlab = "Year", ylab = expression('PM'[2.5]*' Emissions (tons)'))
dev.off()