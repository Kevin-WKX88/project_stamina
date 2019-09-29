# Functions for k-means
# Author : Stamina Running
# Date : 12/08/2019

# Input : data to cluster and k number of clusters
# Output : The total within-cluster sum of square (WSS)
WSS_f <- function(data, k) {
  r <- kmeans(data, k)
  WSS <- sum(r$withinss)
  return(WSS)
}

# Input : df data to cluster and kMax the maximum number of cluster
# Output : The optimal number of clusters for k-means
bestK <- function(df, kMax) {
  WSS_k <- sapply(1:kMax, WSS_f, data = df)
  Ks <- 1:kMax
  
  # plot(Ks, WSS_k, col = 1, xlab = "number of clusters")
  
  a <- (WSS_k[kMax]-WSS_k[1])/(kMax-1)
  b <- -1
  c <- WSS_k[1]
  res <- vector(length = kMax-2)
  max <- 0
  for (k in 2:kMax-1) {
    distance <- abs(a*(k-1) + b*WSS_k[k] + c) / sqrt(a^2 + b^2)
    res[k-1] <- distance
  }
  # print(res)
  for (k in 2:kMax-1) {
    distance <- abs(a*(k-1) + b*WSS_k[k] + c) / sqrt(a^2 + b^2)
    if(distance<max)
    {
      return(k-1)
    }
    else
    {
      max <- distance
    }
  }
  return(0)
}