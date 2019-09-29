# enlève les 2 derniers caractères d'un élément
remove2 <- function(x){
  return(substr(x, 1, nchar(toString(x))-2))
}

# enlève les 3 derniers caractères d'un élément
# return char
remove3 <- function(x){
  return(substr(x, 1, nchar(toString(x))-3))
}

## DISTANCE,HR,CADENCE
# enlève les 3 derniers caractères d'une colonne
cleanUnites3 <- function(distance){
  if(class(distance) != 'numeric'){
    return(as.numeric(gsub(',','.',sapply(distance,remove3))))
  }
  return(distance)
}

# enlève les 2 derniers caractères d'une colonne
## ELEVATION
cleanUnites2 <- function(elevation){
  if(class(elevation) != 'numeric'){
    return(as.numeric(gsub(',','.',sapply(elevation,remove2))))
  }
  return(elevation)
}

# convertit la colonne en numeric et le temps en secondes uniquement
## PACE
paceToSec <- function(time){
  if(class(time) != 'numeric'){
    time <- as.numeric(gsub(":",".",sapply(time,remove3)))
    min <- round(time)
    return(min*60+(time-min)*100)
  }
  return(time)
}


# TIME
timeToSec <- function(x){
  if(class(x) != 'numeric'){
    x <- toString(x)
    if(nchar(x)<=3){
      x <- substr(x, 1, nchar(x)-1)
      return(as.numeric(x))
    }
    else{
      x <- gsub(":",".",x)
      if(nchar(x)<=5){
        x <- as.numeric(x)
        return(round(x)*60+(x-round(x))*100)
      }
      else{
        x <- as.numeric(substr(x,0,nchar(x)-6))*3600 + as.numeric(substr(x,nchar(x)-4,nchar(x)-3))*60 + as.numeric(substr(x,nchar(x)-1,nchar(x)))*100
        return(x)
      }
    }
  }
  else{
    return(x)
  }
}

# vecteur des lignes où il y a au moins un NA
NAline <- function(df){
  c <- c()
  for(i in 1:dim(df)[1]){
    if(sum(is.na(df[i,]))!=0){
      c <- c(c,i)
    }
  }
  return(c)
}

# input : dataframe par scraping Strava
# return : dataframe numeric sans unités
cleanAll <- function(dd){
  dd$distance <- cleanUnites3(dd$distance)
  dd$heartrate <- cleanUnites3(dd$heartrate)
  dd$cadence <- cleanUnites3(dd$cadence)
  dd$elevation <- cleanUnites2(dd$elevation)
  dd$pace <- paceToSec(dd$pace)
  #dd$time <- sapply(dd$time,timeToSec)
  
  # na <- NAline(dd)
  # if(length(na)==0){
  #   return(dd)
  # }
  # else{
  #   for(i in na){
  #     for(j in 1:6){
  #       if(is.na(dd[i,j])){
  # 
  #         ind <- i-1
  #         precedent <- dd[ind,j]
  #         while(is.na(precedent)){
  #           ind <- ind - 1
  #           precedent<-dd[ind,j]
  #         }
  # 
  #         ind <- i+1
  #         suivant <- dd[ind,j]
  #         while(is.na(suivant)){
  #           ind <- ind + 1
  #           suivant<-dd[ind,j]
  #         }
  # 
  #         dd[i,j]<-round((dd[precedent,j] + dd[suivant,j])/2)
  #       }
  #     }
  #   }
  # }
  return(dd)
}


# à partir d'un dossier, prend toutes les courses (tous les csv)
# et les clean
getAllrunclean <- function(path){
  filePaths <- list.files(paste0(path),full.names = TRUE)
  
  for(i in 1:length(filePaths)){
    if(substr(filePaths[i],nchar(filePaths[i])-2,nchar(filePaths[i])) == "csv"){
      dftemp <- cleanAll(read.csv(paste0(filePaths[i])))
      dftemp <- na.omit(dftemp)
      write.csv(dftemp,paste0(filePaths[i]))
    }
  }
}

# return liste avec chaque course (csv) d'un dossier
getRuns <- function(path){
  l <- list()
  fp <- list.files(paste0(path),full.names = TRUE)
  for(k in 1:length(fp)){
    if(substr(fp[k],nchar(fp[k])-2,nchar(fp[k])) == "csv"){
      dftemp <- read.csv(paste0(fp[k]))
      na <- NAline(dftemp)
      if(!is.null(na)){
        print(paste(k,"eme fichier,lignes:",NAline(dftemp)))
        dftemp <- na.omit(dftemp)
      }
      
      l[[k]] <- dftemp[,-1]
    }
  }
  return(l)
}

dfgetRuns <- function(path){
  l <- data.frame()
  fp <- list.files(paste0(path),full.names = TRUE)
  for(k in 1:length(fp)){
    if(substr(fp[k],nchar(fp[k])-2,nchar(fp[k])) == "csv"){
      dftemp <- read.csv(paste0(fp[k]))
      na <- NAline(dftemp)
      if(!is.null(na)){
        print(paste(k,"eme fichier,lignes:",NAline(dftemp)))
        dftemp <- na.omit(dftemp)
      }
      
      l <- rbind(l,dftemp[,-1])
    }
  }
  return(l)
}
