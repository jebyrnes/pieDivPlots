####################
#
# pieDivPlotExample
# A demonstration of pieDivPlot
#
# by Jillian Dunic & Jarrett Byrnes
# Last Updated 10/16/2013
#
# Changelog
#
#
####################

#load the function
source("./pieDivPlot.R")

####Example of aggregated data from duffy_2003
library(plyr)
library(reshape2)
library(multifunc)
data(duffy_2003)


sp <- 18:23

#aggregate down
duffy_2003_melt <- melt(duffy_2003, c("treatment", "diversity", names(duffy_2003[sp])),
                   names(duffy_2003)[6:17])

duffy_2003_summary <- ddply(duffy_2003_melt, names(duffy_2003_melt)[1:9], summarise,
                       mean_value = mean(value), se_value = sd(value)/sqrt(length(value)))

#fix the NAs for no replicates
duffy_2003_summary$se_value[which(is.na(duffy_2003_summary$se_value))] <-0

#plot just sediment OM
pieDivPlot(diversity, mean_value, 3:8, se_value, 
           data=subset(duffy_2003_summary, duffy_2003_summary$variable=="sediment_OM"), ylab="sediment_OM",
           ylim=c(0,2))

#look at it all
par(ask=T)
for(avar in unique(duffy_2003_summary$variable)) {
  adf <- subset(duffy_2003_summary, duffy_2003_summary$variable==avar)
  ylim <- c(min(adf$mean_value-adf$se_value), max(adf$mean_value+adf$se_value))
  pieDivPlot(diversity, mean_value, 3:8, se_value, 
      data=adf, ylab=avar, xlab="", ylim=ylim)
}
par(mfrow=c(1,1), mar=c(5, 4, 4, 2)+0.1)
