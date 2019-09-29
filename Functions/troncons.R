# Functions for sections
# Author : Stamina Running
# Date : 12/08/2019

# Input : data from a running session
# Output : data with NA column removed and cleaned
preProcessDataForSection <- function(session) {
  df <- session[, -c(1, 2, 3, 4, 5)]
  p <- dim(df)[2]
  
  na.colums <- c()
  for (k in 1:p) {
    if (sum(!is.na(df[, k])) == 0) {
      na.colums <- c(na.colums, k)
    }
  }
  df <- df[, -na.colums]
  df <- na.omit(df)
  return(df)
}

# Input : une session
# Output : une liste de troncons tous les kms avec les moyennes de chaque variable à chaque km
sliceSession <- function(data){
  n <- dim(data)[1]
  p <- dim(data)[2]
  dist <- data$distance
  k_max <- ceiling(dist[n]/1000)
  
  res <- matrix(nrow = k_max, ncol = p) 
  colnames(res) <- colnames(data)
  
  res[1, ] <- apply(data[1:length(dist[dist<1000]),], 2, mean)
  
  for(k in 1:k_max-1){
    a <- length(dist[dist<k*1000])
    b <- length(dist[dist<(k+1)*1000])
    res[k+1, ] <- apply(data[a:b,], 2, mean)
  }
  return(as.data.frame(res)) 
}

# Input : data from a running session
# Output : data with NA column removed and cleaned
preProcessDataForSectionCSV <- function(session) {
  session <- na.omit(session)
  df <- cbind(distance = session$distance*1000,
              heart_rate = session$heartrate,
              cadence_running = session$cadence,
              speed = session$pace,
              elevation = session$elevation
  )
  
  # p <- dim(df)[2]
  # na.colums <- c()
  # for (k in 1:p) {
  #   if (sum(!is.na(df[, k])) == 0) {
  #     na.colums <- c(na.colums, k)
  #   }
  # }
  # df <- df[, -na.colums]
  # df <- na.omit(df)
  return(data.frame(df))
}



