
# allanimals <- read.csv("https://www.dropbox.com/s/0o6w29lz8yzryau/allanimals.csv?raw=1", 
#                        stringsAsFactors = FALSE)

# Here's an example animal
ExampleAnimal <- 5497370



allanimals_ID <- unique(c(allanimals$ID, allanimals$InfectingAnimal_ID))

infected <- rep(NA_integer_, length(allanimals_ID))

infected[match(allanimals$ID, allanimals_ID)] <-
  match(allanimals$InfectingAnimal_ID, allanimals_ID)

path <- rep(NA_integer_, length(allanimals_ID))

get_path <- function(animal) {
  curOne <- match(animal, allanimals_ID)
  i <- 1
  while (!is.na(nextOne <- infected[curOne])) {
    path[i] <- curOne
    i <- i + 1
    curOne <- nextOne
  }
  
  path[seq_len(i - 1)]
}

get_chain <- function(animal) {
  allanimals[get_path(animal), ]
}

ptm <- proc.time()
get_chain(ExampleAnimal)
proc.time() - ptm

# check it out
chain


sel.set <- allanimals %>% 
  filter(HexRow < 4 & Year == 130) %>% 
  pull("ID")





#### Memoize

system.time(
  test <- lapply(sel.set, get_path)
)


system.time(
  sel.set.match <- match(sel.set, allanimals_ID)
)

get_path_rec <- function(animal.match) {
  `if`(is.na(nextOne <- infected[animal.match]), 
       NULL, 
       c(animal.match, get_path_rec(nextOne)))
}

system.time(
  test2 <- lapply(sel.set.match, get_path_rec)
)
all.equal(test2, test)

get_path_rec_memo <- memoise::memoize(get_path_rec)
memoise::forget(get_path_rec_memo)

system.time(
  test3 <- lapply(sel.set.match, get_path_rec_memo)
)
all.equal(test3, test)
