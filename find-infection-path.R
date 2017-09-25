library(tidyverse)

# make some data
allanimals <- data.frame(
  AnimalID = c("a1", "a2", "a3", "a4", "a5", "a6", "a7", "a8",
               "b1", "b2", "b3", "b4", "b5", 
               "c1", "c2", "c3", "c4", 
               "d1", "d2",
               "e1", "e2", "e3", "e4", "e5", "e6", 
               "f1", "f2", "f3", "f4", "f5", "f6", "f7"),
  InfectingAnimal = c("x", "a1", "a2", "a3", "a4", "a5", "a6", "a7", "a2", 
                      "b1", "b2", "b3", "b4", "b3", "c1", "c2", "c3", "c3",
                      "d1", "b1",  "e1", "e2", "e3", "e4", "e5", "e1", "f1",
                      "f2", "f3", "f4", "f5", "f6"), 
  habitat = c(1L, 2L, 1L, 2L, 2L, 1L, 3L, 2L, 4L, 5L, 6L, 1L, 2L, 3L, 2L, 3L, 
              2L, 1L, 1L, 2L, 5L, 4L, 1L, 1L, 1L, 1L, 4L, 5L, 4L, 5L, 4L, 3L),
  stringsAsFactors = FALSE
)


## My answer
allanimals_ID <- unique(c(allanimals$AnimalID, allanimals$InfectingAnimal))

infected <- rep(NA_integer_, length(allanimals_ID))
infected[match(allanimals$AnimalID, allanimals_ID)] <-
  match(allanimals$InfectingAnimal, allanimals_ID)

infected <- match(allanimals$InfectingAnimal, allanimals_ID)

Focal.Animal <- "d2"
path <- rep(NA_integer_, length(allanimals_ID))
curOne <- match(Focal.Animal, allanimals_ID)
i <- 1
while (!is.na(nextOne <- infected[curOne])) {
  path[i] <- curOne
  i <- i + 1
  curOne <- nextOne
}

all.equal(allanimals[path[seq_len(i - 1)], ], Chain, check.attributes = FALSE)




## OP's answer

show(allanimals)

# check it out
head(allanimals)

# Start with animal I'm interested in - say, d2
Focal.Animal <- "d2"

# Make a 1-row data.frame with d2's information
Focal.Animal <- allanimals %>% 
  filter(AnimalID == Focal.Animal)

# This is the animal we start with
Focal.Animal

# Make a new data.frame to store our results of the while loop in
Chain <- Focal.Animal

# make a condition to help while loop
InfectingAnimalInTable <- TRUE

# time it 
ptm <- proc.time()

# Run loop until you find an animal that isn't in the table, then stop
while (InfectingAnimalInTable) {
  # Who is the next infecting animal?
  NextAnimal <- Chain %>% 
    slice(n()) %>% 
    select(InfectingAnimal) %>% 
    unlist()
  
  NextRow <- allanimals %>% 
    filter(AnimalID == NextAnimal)
  
  
  # If there is an infecting animal in the table, 
  if (nrow(NextRow) > 0) {
    # Add this to the Chain table
    Chain[(nrow(Chain)+1), ] <- NextRow
    #Otherwise, if there is no infecting animal in the  table, 
    # define the Infecting animal follows, this will stop the loop.
  } else {InfectingAnimalInTable <- FALSE}
}

proc.time() - ptm

# did it work? Check out the Chain data.frame
Chain
