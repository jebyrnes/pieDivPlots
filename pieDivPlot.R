####################
#
# pieDivPlot
# A function to plot diversity-function types of experiments such that diversity is
# on the x-axis, function on the y, and each point is a pie showing something about
# what species are in the treatment
#
# by Jillian Dunic & Jarrett Byrnes
# Last Updated 10/16/2013
#
# Changelog
#
# 10/16/2013: Fixed it so that quotes are not needed for variable names
#
####################

#for color
library(RColorBrewer)
library(plotrix)


# The Function - give it column names and numbers (the SpCols thing is a kludge)
# as well as a color set to work from
pieDivPlot <- function(DiversityColname, FnColname, SpCols, errColname=NULL, data,
                       radius=0.05, col=brewer.pal(length(SpCols), "Set2"), 
                       controlCol="grey", errLwd=1,
                       xlab=NA, ylab=NA, 
                       jitterAmount=NULL, ...){
  
  #Deal with the unquoted variable names
  arguments <- as.list(match.call()[-1])
  #print(arguments)
  
  Diversity <- data[[as.character(arguments$DiversityColname)]]
  if(!is.null(jitterAmount)) Diversity <- jitter(Diversity, amount=jitterAmount)
  Fn <- data[[as.character(arguments$FnColname)]]
  if(!is.null(arguments$errColname))  err <- data[[as.character(arguments$errColname)]]

  if(is.na(xlab[1])) xlab <- as.character(arguments$DiversityColname)
  if(is.na(ylab[1])) ylab <- as.character(arguments$FnColname)
  
  #first, make the basic plot on which everything else will occur
  plot(x=Diversity, y=Fn, ylab=ylab, xlab=xlab, ...)
  
  for(arow in 1:nrow(data)){
    sp <- as.numeric(data[arow, SpCols][which(data[arow,SpCols]==1)])
    
    #add error lines if they are to be had
    if(!is.null(arguments$errColname)) {
    lines(x=rep(Diversity[arow],2),
          y=c(Fn[arow] + err[arow], Fn[arow]-err[arow]),
          lwd=errLwd)
    }
    
    #yes, this string of if/else is ugly
    if(!is.na(sp[1]) & sum(sp)>1){
      floating.pie(xpos=Diversity[arow],
                 ypos=Fn[arow],
                 x=sp,
                 col=col[which(data[arow,SpCols]==1)],
                 radius=radius)
    
    }else{
      useCol <- col[which(data[arow,SpCols]==1)]
      
      if(is.na(sp[1])){ useCol<- controlCol}
      
      draw.circle(x = Diversity[arow], y = Fn[arow], radius =radius,
                  col = useCol)
      
  
   }
  }
  
}

