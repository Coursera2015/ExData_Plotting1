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

  png(file = "figure/plot4.png", width = 480, height = 480)

  #Set local time for English (for non English OS)
  Sys.setlocale("LC_TIME", "English") 
  par(mfcol = c(2, 2), bg = "transparent")
  
  #Plot 1
  plot(sdata$Time, sdata$Global_active_power, type = "l",
                   xlab = "", ylab = "Global active power")
  
  #Plot 2
  plot(sdata$Time, sdata$Sub_metering_1, type = "l",
       xlab = "", ylab = "Energy sub metering")
  lines(sdata$Time, sdata$Sub_metering_2, type = "l", col = "red")
  lines(sdata$Time, sdata$Sub_metering_3, type = "l", col = "blue")
  legend("topright", lwd = 1, col = c("black", "red", "blue"),
         legend = c("Sub metering 1", "Sub metering 2", "Sub metering 3"))
  
  #Plot 3
  
  plot(sdata$Time, sdata$Voltage, type = "l",
       xlab = "", ylab = "Voltage",
       ylim = c(234, 246))
  
  #Plot 4
  plot(sdata$Time, sdata$Global_reactive_power, type = "l",
       xlab = "", ylab = "Global reactive power",
       ylim = c(0, 0.57))
  
  #dev.copy(png, "plot4.png", width = 480, height = 480)
  dev.off()

  par(mfcol = c(1, 1)) #Recover default plot parameters
