library(dplyr)

dfile <- "household_power_consumption.txt"

##Verify if file exists in the working directory. If not - downolqd file and unzip it
if(!file.exists(dfile)){
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(url, "household_power_consumption.zip")
  unzip("household_power_consumption.zip")
}
##Preparer data  
  
  #Read data from file
  data <- read.csv(dfile, sep = ";", stringsAsFactors=FALSE)

  #Transform varialbe Date to date format
  data$Date <- as.Date(data$Date, format = "%d/%m/%Y") 
  
  #Make dplyr object
  data_tbl <- tbl_df(data) 
  
  #Choose necessary data (rows)
  sdata <- filter(data_tbl, Date == "2007-02-01" | Date == "2007-02-02")
  
  #Transform variables
  sdata$Time                  <- strptime(paste(sdata$Date, sdata$Time), format = "%Y-%m-%d %H:%M:%S")
  sdata$Global_active_power   <- as.numeric(sdata$Global_active_power)
  sdata$Global_reactive_power <- as.numeric(sdata$Global_reactive_power)
  sdata$Voltage               <- as.numeric(sdata$Voltage)
  sdata$Global_intensity      <- as.numeric(sdata$Global_intensity)
  sdata$Sub_metering_1        <- as.numeric(sdata$Sub_metering_1)
  sdata$Sub_metering_2        <- as.numeric(sdata$Sub_metering_2)
  
##Making plot   
  png(file = "figure/plot2.png", width = 480, height = 480)
  par(bg="transparent")
  
  #Set local time for English (for non English OS)
  Sys.setlocale("LC_TIME", "English")
  
  with(sdata, plot(Time, Global_active_power, type = "l",
                   xlab = "", ylab = "Global active power"))
  dev.off()