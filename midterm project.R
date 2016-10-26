library(dplyr)
library(reshape2)
library(tidyr)
library(ggplot2)
library(magrittr)

#import the data from a csv file
og <- read.csv("oil.csv",header=TRUE,stringsAsFactors = FALSE)

#make the demographic information into one table
demo <- og[c(1,5,6,7,8)]

#make the oil and gas production information into one table
ogproduction <-select(og, -(Rural_Urban_Continuum_Code_2013:Metro_Micro_Noncore_2013))

#melt the oil and gas columns.
#one column for year, one column for oil amount, one column for gas amount
oil1<- gather(ogproduction,"year","oil", oil2000:oil2011)
og1<- gather(oil1,"year","gas",gas2000:gas2011)

#delete a repeated year column
og1[10] <- NULL

#delete the oil words from the values
og1$year[og1$year == "oil2000"] <- "2000"
og1$year[og1$year == "oil2001"] <- "2001"
og1$year[og1$year == "oil2002"] <- "2002"
og1$year[og1$year == "oil2003"] <- "2003"
og1$year[og1$year == "oil2004"] <- "2004"
og1$year[og1$year == "oil2005"] <- "2005"
og1$year[og1$year == "oil2006"] <- "2006"
og1$year[og1$year == "oil2007"] <- "2007"
og1$year[og1$year == "oil2008"] <- "2008"
og1$year[og1$year == "oil2009"] <- "2009"
og1$year[og1$year == "oil2010"] <- "2010"
og1$year[og1$year == "oil2011"] <- "2011"


#delete one column in the demo table, which contains the repeated informatino from another table
demo$Metro_Nonmetro_2013 <- NULL

#make some graphs
#make a table of the total oil amount per state
tempog <- data.frame( og1$FIPS, og1$Stabr, og1$oil)
colnames(tempog) <- c("FIPS", "State", "Oil")
oil_by_state <- summarise(group_by(tempog, State), sum(as.numeric(Oil)))
colnames(oil_by_state)[2] <- "total_oil"

#make a scatterplot for the total oil amount of different states
options(scipen=5)
ggplot(oil_by_state,aes(total_oil))+geom_histogram(bins = 5)
#count the number of state for different oil amount
ggplot(oil_by_state,aes(x=as.numeric(oil_by_state$State),y=total_oil))+geom_point()

