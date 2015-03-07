#Exploratory lines to fetch only rows with 2006
expl_lines <- readLines("household_power_consumption.txt", 
                        n = 70000)
expl_lines_1 <- grepl("1/2/2007", expl_lines)
expl_lines_2 <- grepl("3/2/2007", expl_lines)
Skip <- which(expl_lines_1 == T)[1] #First occurence of feb/1/2007
n_rows <- which(expl_lines_2 == T)[1] - 1 #last occurence of feb/2/2007

#Simply read a couple of rows to fetch column names
col_Names <- read.table("household_power_consumption.txt", header = T,
                    nrows = 10, sep = ";")
col_Names <- names(col_Names)

#Read the dataset with only the dates we want... skip all the 2006 dates
#and stop at the last feb/2/2007 observation
dataset <- read.table("household_power_consumption.txt",  
                      skip = Skip - 1, nrows = n_rows - Skip + 1, sep = ";", 
                      na.strings = "?", stringsAsFactors = F)
names(dataset) <- col_Names 
date_temp <- paste(dataset$Date, dataset$Time, sep = " ")
dataset$Date <- strptime(date_temp, format = "%d/%m/%Y %H:%M:%S")
#Above we changed the date column to contain dates and time observations
dataset <- dataset[,-2] #collapse the Time variable
png(filename = "plot1.png", width = 480, height = 480)
hist(dataset$Global_active_power, xlab = "Global Active Power (killowatts)"
     , main = "Global Active Power", col = "red")
dev.off()
