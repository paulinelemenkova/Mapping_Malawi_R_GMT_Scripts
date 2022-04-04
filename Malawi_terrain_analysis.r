# Topographic maps of Malawi and terrain analysis: slope, aspect, hillshade.
# set working directory to data folder
setwd("/Users/pauline/")

############################ -- LOAD PACKAGES -- ############
library(sp)
library(raster)
library(ncdf4)
library(RColorBrewer)
library(sf)
library(tmap)

############################# -- GET DATA -- ######################
# Calculate terrain characteristics
# Elevation data is needed to create a hillshade map. The raster package provides an easy access to the SRTM 90 m resolution elevation data with the getData() function. For example, it is possible to download the elevation data for the whole country of "" using the code below: download the elevation data for the whole country of Malawi
alt = getData("alt", country = "Malawi", path = tempdir())

############################# -- Calculate terrain characteristics: SLOPE AND ASPECT -- ######################
# Hillshade maps are created based on certain terrain characteristics - slope and aspect. Both of them can be calculated with the terrain function and the opt argument set to "slope" or "aspect".
# A hillshade map can be created using the tmap package. This package builds maps by stacking different data layers. In this case, the first layer is the hillshade object (hill), colored using different levels of gray.

slope = terrain(alt, opt = "slope")
plot(slope)
aspect = terrain(alt, opt = "aspect")
plot(aspect)
hill = hillShade(slope, aspect, angle = 40, direction = 270)
plot(hill)
plot(alt)

############################# -- SLOPE-- ######################
# tmaptools::palette_explorer()
tmap_mode("plot")
#data(World)
map1 <-
    tmap_style("watercolor") +
    tm_shape(slope, name = "Slope", title = "Slope") +
    tm_raster(
        title = "Slope (0\u00B0-90\u00B0)",
        palette = "-Set1",
        style = "quantile", n = 17,
        breaks = c(5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 60, 65, 70, 75, 80, 85, 90),
        legend.show = T,
        legend.hist = T,
        legend.hist.z=0,
        ) +
    tm_scale_bar(
        width = 0.25,
        text.size = 0.8,
        text.color = "black",
        color.dark = "black",
        color.light = "white",
        position=c("right", "bottom"),
        lwd = 1) +
    tm_compass(
        type = "radar", position=c("right", "top"), size = 8.0) +
    tm_layout(scale = .8,
        main.title = "Slope terrain map based on SRTM-90 DEM of Malawi. Mapping: R",
        main.title.position = "center",
        main.title.color = "black",
        main.title.size = 1.0,
        title = "Slope (0\u00B0-90\u00B0)",
        title.color = "black",
        title.size = 1.0,
        title.position = c("left", "top"),
        panel.labels = c("R packages: tmap, raster, sp, sf"),
        panel.label.color = "darkslateblue",
        panel.label.size = 1.0,
        legend.position = c("left","bottom"),
        legend.bg.color = "grey90",
        legend.bg.alpha = .2,
        legend.outside = FALSE,
        legend.width = 0.9,
        legend.height = .5,
        legend.hist.height = .2,
        legend.title.size = 0.9,
        legend.text.size = 0.8,
        legend.stack = "vertical",
        inner.margins = 0) +
    tm_graticules(
        ticks = TRUE,
        lines = TRUE,
        labels.rot = c(15, 15),
        col = "azure3", lwd = 1,
        labels.size = 1.0)
# plot map
map1
tmap_save(map1, "Malawi_Slope.jpg", dpi = 300, height = 10)

############################# -- ASPECT-- ######################
# tmaptools::palette_explorer()
tmap_mode("plot")
map2 <-
    tmap_style("watercolor") +
    tm_shape(aspect, name = "Slope", title = "Slope") +
    tm_raster(
        title = "Aspect",
        palette = "-Spectral",
        style = "quantile", n = 8,
        legend.show = T,
        legend.hist = T,
        legend.hist.z=0,
        ) +
    tm_scale_bar(
        width = 0.25,
        text.size = 0.9,
        text.color = "black",
        color.dark = "black",
        color.light = "white",
        position=c("left", "bottom"),
        lwd = 1) +
    tm_compass(
        type = "rose", position=c("right", "bottom"), size = 8.0) +
    tm_layout(scale = .8,
        main.title = "Aspect terrain map based on SRTM-90 DEM of Malawi. Mapping: R",
        main.title.position = "center",
        main.title.color = "black",
        main.title.size = 0.9,
        title = "Aspect \n(W-E-S-N)",
        title.color = "black",
        title.size = 1.0,
        title.position = c("left", "top"),
        panel.labels = c("R packages: tmap, raster, sp, sf"),
        panel.label.color = "darkslateblue",
        panel.label.size = 1.0,
        legend.position = c("right","top"),
        legend.bg.color = "grey90",
        legend.bg.alpha = .2,
        legend.stack = "vertical",
        legend.outside = F,
        legend.width = 0.7,
        legend.height = .4,
        legend.hist.height = .15,
        legend.hist.width = .2,
        legend.title.size = 0.9,
        legend.text.size = 0.9,
        inner.margins = 0) +
    tm_graticules(
        ticks = TRUE,
        lines = TRUE,
        labels.rot = c(15, 15),
        col = "azure3", lwd = 1,
        labels.size = 1.0)
# plot map
map2
tmap_save(map2, "Malawi_Aspect.jpg", dpi = 300, height = 10)

Twomaps <- tmap_arrange(map1, map2)
Twomaps
tmap_save(Twomaps, "Malawi_SlopeAspect.jpg", dpi = 300, height = 10, width = 12)

############################# -- HILLSHADE-- ######################
# tmaptools::palette_explorer()
tmap_mode("plot")
map3 <-
    tmap_style("cobalt") +
    tm_shape(hill, name = "Hillshade", title = "Hillshade",
        auto.palette.mapping = FALSE,) +
    tm_raster(
        title = "Histogram \n(data distribution)",
        palette = "cividis",
        style = "quantile", n = 10,
        legend.show = T,
        legend.hist = T,
        legend.hist.z=0,
        ) +
    tm_scale_bar(
        width = 0.25,
        text.size = 0.9,
        text.color = "black",
        color.dark = "black",
        color.light = "white",
        position=c("left", "bottom"),
        lwd = 1) +
    tm_compass(
        type = "8star", position=c("right", "bottom"), size = 7.0) +
    tm_layout(scale = .9,
        main.title = "Hillshade terrain analysis based on DEM of Malawi. Mapping: R",
        main.title.position = "center",
        main.title.color = "black",
        main.title.size = 1.0,
        title = "Hillshade (0\u00B0-90\u00B0)",
        title.color = "black",
        title.size = 1.0,
        title.position = c("left", "top"),
        panel.labels = c("R packages: tmap, raster, sp, sf"),
        panel.label.color = "darkslateblue",
        panel.label.size = 1.0,
        legend.position = c("right","top"),
        legend.bg.color = "grey90",
        legend.bg.alpha = .2,
        legend.frame = "gray50",
        legend.outside = FALSE,
        legend.width = .3,
        legend.height = .5,
        legend.hist.height = 0.15,
        legend.title.size = 1.1,
        legend.text.size = 0.9,
        inner.margins = 0) +
    tm_graticules(
        ticks = TRUE,
        lines = TRUE,
        col = "azure3",
        lwd = 1,
        labels.size = 1.0,
        labels.rot = c(15, 15),
        labels.col = "black")
# plot map
map3
tmap_save(map3, "Malawi_Hillshade.jpg", height = 10)

############################# -- ELEVATION-- ######################
# tmaptools::palette_explorer()
tmap_mode("plot")
map4 <-
    tmap_style("natural") +
    tm_shape(alt, name = "Elevation", title = "Elevation") +
    tm_raster(
        title = "Elevation (m asl)",
        #palette = "-BrBG",
        palette = terrain.colors(256),
        style = "quantile", n = 30,
        legend.show = T,
        legend.hist = T,
        legend.hist.z=0,
        ) +
    tm_scale_bar(
        width = 0.25,
        text.size = 0.9,
        text.color = "black",
        color.dark = "black",
        color.light = "white",
        position=c("left", "bottom"),
        lwd = 1) +
    tm_compass(
        type = "4star", position=c("right", "bottom"), size = 7.0) +
    tm_layout(scale = .8,
        main.title = "Elevation terrain analysis based on DEM of Malawi. Mapping: R",
        main.title.position = "center",
        main.title.color = "black",
        main.title.size = 1.0,
        title = "Elevation (m)",
        title.color = "black",
        title.size = 1.0,
        title.position = c("left", "top"),
        panel.labels = c("R packages: tmap, raster, sp, sf"),
        panel.label.color = "darkslateblue",
        panel.label.size = 1.0,
        legend.position = c("right","top"),
        legend.bg.color = "grey90",
        legend.bg.alpha = .2,
        legend.outside = FALSE,
        legend.width = .9,
        legend.height = .3,
        legend.hist.height = .2,
        legend.title.size = 0.9,
        legend.text.size = 0.6,
        legend.stack = "horizontal",
        inner.margins = 0) +
    tm_graticules(
        ticks = TRUE,
        lines = TRUE,
        labels.rot = c(15, 15),
        col = "azure3", lwd = 1,
        labels.size = 1.0)
# plot map
map4
tmap_save(map4, "Malawi_Elevation.jpg", dpi = 300, height = 10)

Twomaps <- tmap_arrange(map3, map4)
Twomaps
tmap_save(Twomaps, "Malawi_HillElev.jpg", dpi = 300, height = 10, width = 12.0)

############################# -- HISTOGRAMS-- ######################
hist(hill, maxpixels=100000, plot=TRUE)
hist(alt, maxpixels=100000, plot=TRUE)
hist(slope, maxpixels=100000, plot=TRUE)
hist(aspect, maxpixels=100000, plot=TRUE)
