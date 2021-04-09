install.packages("mongolite")
library(mongolite)
connection <- mongo(collection = "truck_1",
                    db = "TruckData",
                    url = "mongodb://user:password@mongo:27017")

data <- connection$find()
