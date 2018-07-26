## loads packages for R
list <- c("shiny","cummeRbund","tidyverse","RSQLite")
invisible(lapply(list, library, character.only = TRUE))
