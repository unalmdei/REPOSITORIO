library(agroforestry)
library(raster)
library(sf)
library(sp)
library(gstat)
# Para graficar
library(rgdal)
library(ggplot2)
library(tidyverse)
library(dplyr)
library(reshape2)
library(RColorBrewer)
#-------------------------

data("Isabelita")
a<-Isabelita[,1]
b<-is.na(a)
isabel<-Isabelita[!b,]
coordinates(isabel)<-~este+norte
class(isabel)

# creando shapefile type polygon
P<-list(x=c(402296.1, 407512.8, 407544.2, 405014.2, 404669.2, 404282.4, 404021.1, 403602.9, 402285.7, 402296.1),
        y=c(8764777, 8764787, 8758054, 8758033, 8763167, 8763407, 8763355, 8763198, 8763031, 8764777))
#P<-locator(9)
#P$x[10]<-P$x[1]
#P$y[10]<-P$y[1]
pol = st_sfc(st_polygon(list(cbind(P$x,P$y))))
plot(pol)
h<-st_sf(r=16,pol)
plot(h)

e<-extent(isabel)
grd<-expand.grid(x=seq(from=e[1],to=e[2],by=10), y=seq(from=e[3],to=e[4],by=10))
coordinates(grd)<- ~x + y
gridded(grd)<- TRUE
crs(grd)<-crs(shapefile)
nuevo<-idw(altura ~ 1, isabel,grd)
nuevo<-raster(nuevo)
plot(nuevo)
nuevo1<-raster::mask(nuevo,h)
plot(nuevo1)
image(nuevo1)
#---------------------
points(isabel,pch=20)
Q<-st_read("isabel.shp")
plot(Q)

