library(trackeR)
rm(list = ls())
#Set data of one run in a data frame
run0 <- readTCX(file = 'activity_3585598364.TCX', timezone = 'GMT')
str(run0)
## turn into trackeRdata object
units0 <- generate_units()
Run0 <- trackeRdata(run0, sport = 'running', units = units0)

## turn into trackeRdata object
run1<- readTCX(file = 'activity_2025637452.tcx', timezone = 'GMT')
#Set data of one run in a data frame
Run1 <- trackeRdata(run1, sport = 'running', units = units0)
# read_container(filepath, type = "tcx", timezone = "GMT") : does readTCX and trackeRdata

RunAll <- read_directory('.', timezone = "GMT", sport = "running")

#load intrackeRdata
RunRecord <- read_container( 'activity_3607400913.tcx', type = "tcx", timezone = "GMT", sport = 'running')

#load in a dataframe
runRecord <- readTCX( 'activity_3607400913.tcx', type = "tcx", timezone = "GMT", sport = 'running')

# plot the path on the map
plotRoute(RunRecord)

InfoSessions <- summary(RunAll, session = 1:6)
print(InfoSessions)

plot(RunAll, group = c("total", "moving"),what = c("avgSpeed", "distance", "duration", "avgHeartRate"))

# Test
plot(RunAll, session = 1:3, what = c("pace", "heart_rate", "speed"))
plot(RunAll, session = 5, what = c("speed"))

# Test kmeans 
run1.clean <- run1[, -c(1, 9, 10, 11)]
run1.norm <- sapply(run1.clean, scale)
row.names(run1.norm) <- row.names(run1.clean) 

km <- kmeans(run1.norm, 3)
km$cluster
km$size

plot(Run1, what = c("heart_rate", "speed"))

summary(run1.clean[km$cluster == 1, "speed"])
summary(run1.clean[km$cluster == 2, "speed"])
summary(run1.clean[km$cluster == 3, "speed"])




