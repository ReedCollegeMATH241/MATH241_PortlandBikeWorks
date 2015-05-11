library(RJSONIO)
library(dplyr)
library(ggplot2)
library(rgdal)
library(ggmap)

#laod in data
PDX <- fromJSON("trips.json")
accidents <- fromJSON("portland_accidents.json")

##ride data
# Extract information for first ride
orig.coordinates <- PDX[["features"]][[1]]$geometry$coordinates %>% unlist() %>% matrix(ncol=2, byrow=TRUE)
coordinates <- data.frame(
  lat = orig.coordinates[, 1],
  long = orig.coordinates[, 2],
  activity_type = PDX[["features"]][[1]]$properties["activity_type"],
  rating = PDX[["features"]][[1]]$properties["rating"],
  group = 1
)

# Create master data.frame
master.coordinates <- coordinates

# Append information for 2nd thru last ride
for(i in 2:length(PDX[["features"]])){
  orig.coordinates <- PDX[["features"]][[i]]$geometry$coordinates %>% unlist() %>% matrix(ncol=2, byrow=TRUE)
  coordinates <- data.frame(
    lat = orig.coordinates[, 1],
    long = orig.coordinates[, 2],
    activity_type = PDX[["features"]][[i]]$properties["activity_type"],
    rating = PDX[["features"]][[i]]$properties["rating"],
    group = i
  )
  master.coordinates <- bind_rows(master.coordinates, coordinates)
  
  if(PDX[["features"]][[i]]$geometry$type != "LineString")
    print(i)
}

##accident data
# Extract information for first accident
accidents.first<- accidents$accidents[[1]] %>% unlist() %>% matrix(ncol=1, byrow=TRUE)
#hack style
accidata1 <- data.frame(
  lat = accidents.first[ 6,],
  long = accidents.first[ 7,],
  street1 = accidents.first[ 1,],
  street2 = accidents.first[ 2,],
  no.accidents = accidents.first[ 4,],
  year = accidents.first[ 5,],
  crashID = accidents.first[ 8,],
  group = 1
)

# Create master data.frame
master.accidents <- accidata1

# Append information for 2nd thru last ride
for(i in 2:length(accidents[["accidents"]])){
  accidents.all<- accidents$accidents[[i]] %>% unlist() %>% matrix(ncol=1, byrow=TRUE)
  accidata <- data.frame(
    lat = accidents.all[ 6,],
    long = accidents.all[ 7,],
    street1 = accidents.all[ 1,],
    street2 = accidents.all[ 2,],
    no.accidents = accidents.all[ 4,],
    year = accidents.all[ 5,],
    crashID = accidents.all[ 8,],
    group = i
  )
  master.accidents <- bind_rows(master.accidents, accidata)
  
}

master.accidents$lat <- as.numeric(master.accidents$lat)
master.accidents$long <- as.numeric(master.accidents$long)

####MAPPING
#basemap
PDX.shapefile <- readOGR(dsn=".", layer="tract2010", verbose=FALSE) %>%
  spTransform(CRS("+proj=longlat +ellps=WGS84")) %>%
  subset(COUNTY=="051")

PDX.data <- PDX.shapefile@data %>% tbl_df()
PDX.map <- fortify(PDX.shapefile, region="FIPS") %>% tbl_df()

base.plot <-
  ggplot(PDX.map, aes(x=long, y=lat, group=group)) +
  geom_polygon(fill="white") +
  geom_path(col="black", size=0.5) +
  coord_map() +
  theme_bw()

#we can also use road center lines to map RIDE data
streets.shapefile <- readOGR(dsn=".", layer="streets", verbose=FALSE) %>%
  spTransform(CRS("+proj=longlat +ellps=WGS84")) %>%
  subset(COUNTY=="051")

streets.data <- streets.shapefile@data %>% tbl_df()
streets.map <- fortify(streets.shapefile, region="FIPS") %>% tbl_df()

base.plot.streets <-
  ggplot(streets.map, aes(x=long, y=lat, group=group)) +
  geom_polygon(fill="white") +
  geom_path(col="grey", size=0.5) +
  coord_map() +
  theme_bw() +
  scale_x_continuous(limits=c(-122.7, -122.6)) +
  scale_y_continuous(limits=c(45.475, 45.55)) +
  xlab("Longitude") + ylab("Latitude") + 
  ggtitle("PDX Streets")
base.plot.streets

#and we can add in a great data set from 2010 that has PDX bike infrastructure
bikeroad.shapefile <- readOGR(dsn=".", layer="Bicycle_Network_pdx", verbose=FALSE) %>%
  spTransform(CRS("+proj=longlat +ellps=WGS84"))

bikeroad.data <- bikeroad.shapefile@data %>% tbl_df()
bikeroad.map <- fortify(bikeroad.shapefile, region="FIPS") %>% tbl_df()
bikeroad.map <- rename(bikeroad.map, OBJECTID = id) %>%
  as.numeric(bikeroad.map$OBJECTID)
facility_rating <- left_join(bikeroad.map, bikeroad.data, by = "OBJECTID")

base.plot.bikeroad <-
  ggplot(facility_rating, aes(x=long, y=lat)) + 
  geom_path(alpha=1, aes(group=OBJECTID, col=FACILITY), lineend = "butt", size=1) +
  scale_x_continuous(limits=c(-122.7, -122.6)) +
  scale_y_continuous(limits=c(45.475, 45.55)) +
  theme(panel.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  coord_map() +
  xlab("Longitude") + ylab("Latitude") + 
  ggtitle("PDX Street Type") +
  labs(color = "Ride Rating")
base.plot.bikeroad
#MTRAIL = Multi-Use Trail;LANE = Bike Lane; BLVD = Bike Boulevard; SCONN = Signed Connection

base.plot.bikeroad + 
  geom_point(data=master.accidents, aes(x=long, y=lat), alpha=0.3, col="red", size= 3.25) +
  coord_map()

#we explore the ride data
#map at large
ggplot(master.coordinates, aes(x=long, y=lat, group=group)) + geom_path(alpha=0.5) +
  scale_x_continuous(limits=c(-123, -122.5)) +
  scale_y_continuous(limits=c(45.4, 45.6)) +
  coord_map() +
  xlab("Longitude") + ylab("Latitude") + 
  ggtitle("PDX Street Type") +
  labs(color = "Ride Rating")

#map focusing on Portland Urban area
ggplot(master.coordinates, aes(x=long, y=lat, group=group)) + geom_path(alpha=0.5) +
  scale_x_continuous(limits=c(-122.7, -122.6)) +
  scale_y_continuous(limits=c(45.475, 45.55)) +
  theme(panel.background = element_blank(),
       panel.grid.major = element_blank(),
       panel.grid.minor = element_blank()) +
  coord_map() +
  xlab("Longitude") + ylab("Latitude") + 
  ggtitle("All RIDE Data")

#there is also data on accident hot spots in the same city
base.plot +
  geom_point(data=master.accidents, aes(x=long, y=lat), alpha = 0.4, col="red", size= 3.25) +
  scale_x_continuous(limits=c(-122.7, -122.6)) +
  scale_y_continuous(limits=c(45.475, 45.55)) +
  xlab("Longitude") + ylab("Latitude") + 
  ggtitle("PDX Bike Accident Data (2010 - 2014)")

#we parse apart the RIDE dataset by rating
ggplot(master.coordinates, aes(x=long, y=lat, group=group)) + 
  geom_path(alpha=0.3, aes(col=rating), lineend = "butt") +
  scale_color_gradient2(low = "yellow", mid = "green", high = "red") +
  scale_x_continuous(limits=c(-122.7, -122.6)) +
  scale_y_continuous(limits=c(45.475, 45.55)) +
  coord_map() +
  xlab("Longitude") + ylab("Latitude") + 
  ggtitle("RIDE Data for PDX by Rating")  +
  labs(color = "Ride Rating")

#we adjust color 
ggplot(master.coordinates, aes(x=long, y=lat, group=group)) +
  geom_path(alpha=0.4, aes(col=rating), lineend = "butt") +
  scale_color_gradient2(low = "yellow", mid = "green", high = "red", midpoint=1) +
  theme(panel.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  scale_x_continuous(limits=c(-122.7, -122.6)) +
  scale_y_continuous(limits=c(45.475, 45.55)) +
  coord_map()

#see if a new background helps
ggplot(master.coordinates, aes(x=long, y=lat, group=group)) +
  geom_path(alpha=0.3, aes(col=rating), lineend = "butt") +
  scale_color_gradient2(low = "yellow", mid = "green", high = "red", midpoint=1) +
  theme(panel.background = element_rect(fill = 'grey30'),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  scale_x_continuous(limits=c(-122.7, -122.6)) +
  scale_y_continuous(limits=c(45.475, 45.55)) +
  coord_map()

#we add the accident data in
ggplot(master.coordinates, aes(x=long, y=lat, group=group)) +
  geom_point(data=master.accidents, aes(x=long, y=lat), alpha = 0.3, col="red", size= 6) +
  geom_path(alpha=0.3, aes(col=rating), lineend = "butt") +
  scale_color_gradient2(low = "yellow", mid = "green", high = "red", midpoint=1) +
  theme(panel.background = element_rect(fill = 'grey30'),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  scale_x_continuous(limits=c(-122.7, -122.6)) +
  scale_y_continuous(limits=c(45.475, 45.55)) +
  coord_map()

ggplot(master.coordinates, aes(x=long, y=lat, group=group)) +
  geom_path(alpha=0.4, aes(col=rating), lineend = "butt") +
  geom_point(data=master.accidents, aes(x=long, y=lat), alpha = 0.3, col="red", size= 3.25) +
  scale_color_gradient2(low = "yellow", mid = "green", high = "red", midpoint=1) +
  theme(panel.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  scale_x_continuous(limits=c(-122.7, -122.6)) +
  scale_y_continuous(limits=c(45.475, 45.55)) +
  coord_map()

#I used this map to get a better sense of where the popular routes ("whtvr", in green, which plots the sites where a RIDE biker transited more than once) were
#overlapped with accidents (master.accidents, red). It is a difficult comparison, as the RIDE data and accident data come from different ride information - that is, 
# the accidents depicted here did not necessarily happen to RIDE users. That said, both data sets showed increased ridership or number of accidents on major roads. 
whtvr <- group_by(master.coordinates, lat, long) %>% summarise(count=n()) %>% filter(count>1) %>% arrange(count)
base.plot +
  geom_point(data=whtvr, aes(x=long, y=lat, group=count), alpha = 0.4, col="green", size= 4.5) +
  geom_point(data=master.accidents, aes(x=long, y=lat), alpha = 0.4, col="red", size= 4.5) +
  scale_x_continuous(limits=c(-122.7, -122.6)) +
  scale_y_continuous(limits=c(45.475, 45.55))


#lets take a closer look at some neighborhoods:
#note: we use coord_cartesian to maintain a high level of detail at the neighborhood scale
#industrial
base.plot +
  geom_point(data=master.accidents, aes(x=long, y=lat), alpha = 0.4, col="red", size= 4.5) +
  geom_path(data = master.coordinates, alpha=0.3, aes(col=rating), lineend = "butt") +
  coord_cartesian(xlim=c(-122.67, -122.65), ylim=c(45.50, 45.52)) +
  scale_color_gradient2(low = "yellow", mid = "green", high = "red", midpoint=1) +
  theme(panel.background = element_rect(fill = 'grey30'),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())

#downtown
base.plot +
  geom_point(data=master.accidents, aes(x=long, y=lat), alpha = 0.4, col="red", size= 4.5) +
  geom_path(data = master.coordinates, alpha=0.3, aes(col=rating), lineend = "butt") +
  coord_cartesian(xlim=c(-122.70, -122.67), ylim=c(45.51, 45.53)) +
  scale_color_gradient2(low = "yellow", mid = "green", high = "red", midpoint=1) +
  theme(panel.background = element_rect(fill = 'grey30'),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())

#and we can add google map data, but it looks awful
#google.map <-
#  get_map(location = "Portland, OR", maptype = "roadmap", zoom = "auto", color = "bw", messaging = FALSE, force = ifelse(source == "google", TRUE, TRUE))
#ggmap(google.map) +
#  geom_point(data=master.accidents, aes(x=long, y=lat), alpha=0.5, col="red", size= 4.5) +
#  geom_path(data=master.coordinates, alpha=0.3, aes(x=long, y=lat, group=group, col=rating), lineend = "butt") +
#  scale_x_continuous(limits=c(-122.7, -122.6)) +
#  scale_y_continuous(limits=c(45.475, 45.55)) +
#  coord_map() +
#  xlab("longitude") + ylab("latitude")



