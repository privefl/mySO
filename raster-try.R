library(magick)

tiger <- image_read('http://jeroen.github.io/images/tiger.svg')
image_info(tiger)
plot(tiger)
tiger_raster <- as.raster(tiger)
plot(tiger_raster)

sort(table(tiger_raster), decreasing = TRUE)


tmp <- col2rgb(tiger_raster)
tmp2 <- rgb2hsv(tmp)

color_safe <- function(x) {
  (x[1, ] * 36 + x[2, ] * 6 + x[3, ]) * 6 / 256
}
tmp3 <- color_safe(tmp2)
plot(tmp3)

scale <- 3 / 256
tmp4 <- (floor(tmp * scale) / scale)
storage.mode(tmp4) <- "raw"
tmp4[, 1:3]
tiger_raster2 <- tiger_raster
tiger_raster2[] <- apply(tmp4, 2, function(x) paste0("#", paste(x, collapse = "")))
plot(tiger_raster)
plot(t(tiger_raster2))
