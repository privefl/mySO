N <- 2e3  # 2e6
M <- 10   # 2e4

pixels.latlon=cbind(runif(N,min=-180, max=-120), runif(N, min=50, max=85))
grwl.latlon=cbind(runif(M,min=-180, max=-120), runif(M, min=50, max=85))
#calculate the distance matrix
library(geosphere)
dist.matrix = distm(pixels.latlon, grwl.latlon, fun=distHaversine)
#Pick out the indices of the minimum distance
rnum=apply(dist.matrix, 1, which.min)

rnum
dist.matrix


x <- pixels.latlon[1, ]
y <- grwl.latlon[1, ]
d <- dist.matrix[1, 1]
x - y
d


# geosphere:::.pointsToMatrix
p1 <- pixels.latlon[1, ] * pi/180
p2 <- grwl.latlon[1, ] * pi/180

dLatLon_div2 <- (p2 - p1) / 2
a <- sin(dLatLon_div2[2]) ** 2 + cos(p1[2]) * cos(p2[2]) * sin(dLatLon_div2[1]) ** 2
dist <- 2 * atan2(sqrt(a), sqrt(1 - a)) * 6378137
dist
d


curve(atan2(sqrt(x), sqrt(1 - x)) * 2 / pi, from = 0, to = 1)

curve(atan(x) * 2 / pi, from = 0, to = 1)
curve(x * 2 / pi, from = 0, to = 1, col = "red", add = TRUE)
curve(x * (1 - x^2/3) * 2 / pi, from = 0, to = 1, col = "red", add = TRUE)

# distHaversine
## Multiply by toRad <- pi/180

r <- 6378137
p = cbind(p1[1], p1[2], p2[1], p2[2], as.vector(r))
dLat <- p[, 4] - p[, 2]
dLon <- p[, 3] - p[, 1]
a <- sin(dLat/2) * sin(dLat/2) + cos(p[, 2]) * cos(p[, 4]) *
  sin(dLon/2) * sin(dLon/2)
a <- pmin(a, 1)
dist <- 2 * atan2(sqrt(a), sqrt(1 - a)) * p[, 5]
return(as.vector(dist))
