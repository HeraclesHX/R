#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Using R to get the map chart #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

#demostrate the ggmap package

install.packages("ggmap")

require(ggplot2)
require(ggmap)
require(maps)

murder = subset(crime, offense == "murder")
head(murder)
qmplot(lon, lat, data = murder, colour = I("red"), size = I(3), darken = .3)

geocode("white house")
set.seed(500)
x = jitter(56, 0.4)
df = round(data.frame(x = jitter(rep(-95.36, 50), amount = 0.3),
                      y = jitter(rep(29.76, 50), amount = 0.3)
                      ), digits = 2)

map = get_googlemap("houston", markers = df,
                    path = df, scale = 2)

ggmap(map, extent = "device")

qmap("baylor university", zoom = 14, source = "stamen")


