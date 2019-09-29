# Functions MDP - RL
# Author : Stamina Running
# Date : 27/08/19



# Input : indices of the selected sessions and the running sessions
# Output : draw the histogram of the pace
histPace <- function(indicesSessions, sessions) {
  pace <- c()
  for(i in 1:length(indicesSessions)){
    if(is.numeric(sessions[[indicesSessions[i]]]$pace)){
      pace <- rbind(pace,sessions[[indicesSessions[i]]]$pace)
    }
  }
  # length(as.vector(pace))
  hist(pace, breaks=100, col=1, xlim = c(100, 500))
}


# Input : the running sessions in sections, the clusters of each section, the number of clusters and the actions in the MDP
# Output : List of the transition matrix for each action
transitionMatrix <- function(sessions, clusters, nbClusters, actions) {
  nbSessions <- length(sessions)
  nbActions <- length(actions)
  
  # Initialisation of transition matrix
  tMatrix <- list()
  for (i in 1:nbActions) {
    tMatrix[[i]] <- matrix(0, nbClusters, nbClusters)
  } 
  
  for (i in 1:nbSessions) {
    troncons <- sessions[[i]]
    n <- dim(troncons)[1]
    cluster <- clusters[[i]]
    
    for(j in 1:(n-1)) {
      # Determining which action ?
      action <- which.min(abs(actions - troncons$speed[j]))
      tMatrix[[action]][cluster[j], cluster[j+1]] <- tMatrix[[action]][cluster[j], cluster[j+1]] + 1
    }
  }
  
  # Transform in probabilities
  for (i in 1:nbActions) {
    for (j in 1:nbClusters) {
      s <- sum(tMatrix[[i]][j,])
      if (s == 0) {
        tMatrix[[i]][j,] <- 0
      }
      else {
        tMatrix[[i]][j,] <- tMatrix[[i]][j,]/s
      }
    }
  }
  return(tMatrix)
}


# Input : the running sessions in sections, actions in the MDP, the number of clusters and the distance of each section
# Output : List of the transition matrix for each action
transitionMatrixForSessionOfXkm <- function(sessions, actions, nbCluster, sessionDistance) {
  nbSessions <- length(sessions)
  
  allSessions <- data.frame()
  allSessionsScaled <- data.frame()
  for (i in 1:nbSessions) {
    run <- sessions[[i]]
    runCleaned <- preProcessDataForSectionCSV(run)
    troncons <- sliceSession(runCleaned)
    troncons.norm <- sapply(troncons, scale)
    row.names(troncons.norm) <- row.names(troncons) 
    
    allSessions <- rbind(allSessions, cbind(session = rep(i, dim(troncons)[1]), troncons))
    allSessionsScaled <- rbind(allSessionsScaled, cbind(session = rep(i, dim(troncons)[1]), troncons.norm))
  }
  
  # Les courses de 10 km
  sizesSessions <- vector(mode = "numeric", length = nbSessions)
  for (i in 1:nbSessions) {
    sizesSessions[i] <- nrow(allSessions[allSessions$session == i, ])
  }
  # hist(sizesSessions, breaks = 28, col = 6)
  indicesXkm <- which(sizesSessions == sessionDistance)
  print(paste("Sessions of", sessionDistance, "km :"))
  print(indicesXkm)
  nbSessionsXkm <- length(indicesXkm)
  
  allXkmSessions <- data.frame()
  allXkmSessionsScaled <- data.frame()
  for (i in 1:nbSessionsXkm) {
    allXkmSessions <- rbind(allXkmSessions, allSessions[allSessions$session == indicesXkm[i], ])
    allXkmSessionsScaled <- rbind(allXkmSessionsScaled, allSessionsScaled[allSessionsScaled$session == indicesXkm[i], ])
  }
  
  # kmeans
  km <- kmeans(allXkmSessionsScaled[,-1], nbCluster)
  # The centers (unscale)
  centers <- km$centers
  meanAll <- sapply(allXkmSessions, mean)[-1]
  sdAll <- sapply(allXkmSessions, sd)[-1]
  for (i in 1:ncol(km$centers)) {
    centers[,i] <- centers[,i] * sdAll[i] + meanAll[i]
  }
  print(paste("kmeans - centers :"))
  print(centers)
  
  # for (i in 1:nbSessions10km) {
  #   plot(allXkmSessionsScaled[allXkmSessionsScaled$session == indicesXkm[i], ]$speed, main = paste("speed each section for session", indicesXkm[i]), type = "p", pch = 20, col = km$cluster[allXkmSessionsScaled$session == indicesXkm[i]], xlab = "troncon", ylab = "speed")
  # }
  
  clustersXkmSessions <- list()
  for (i in 1:nbSessionsXkm) {
    clustersXkmSessions[[i]]<- km$cluster[allXkmSessionsScaled$session == indicesXkm[i]]
  }
  
  # Pour fonction matrice de transition
  ## Les sessions de X km
  XKmSessions <- list()
  for (i in 1:nbSessionsXkm) {
    XKmSessions[[i]] <- allSessions[allSessions$session == indicesXkm[i], ]
  }
  
  P <- transitionMatrix(XKmSessions, clustersXkmSessions, nbCluster, actions)
  return(P)
}






