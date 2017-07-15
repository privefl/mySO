library(ggplot2)
ggplot(data.frame(x = 1:8, y = 0), aes(x, y)) +
  geom_tile(fill = rgb(0, 0, c(0.1, 0.25, 0.1, 0.05, 0.05, 0.15, 0.15, 0.15))) + 
  coord_fixed() + 
  theme_void()



#DATA
mylist = c(0.1, 0.25, 0.1, 0.05, 0.05, 0.15, 0.15, 0.15)

par(pty = "s") #square plot

#create empty plot
plot(1,1, type = "n", xlim = c(-2, length(mylist) + 2),
     ylim = c(-2, length(mylist) + 2),
     ann = FALSE, axes = FALSE, asp = 1)
L = length(mylist)

#draw polygons
sapply(L:1, function(i)
  polygon(x = c(L/2 - i, L/2 + i, L/2 + i, L/2 - i),
          y = c(L/2 - i, L/2 - i, L/2 + i, L/2 + i),
          col = rgb(red = 0, green = 0, blue = mylist[i])))

