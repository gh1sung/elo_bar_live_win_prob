# Read csv
kovo18_19_byset <- read.csv(file = "/Users/ryansung/Downloads/restructured_1819.csv")

# Deploy libraries 
library(dplyr)
library(elo)

# Change names to be readable in function 
kovo_elo <- kovo18_19_byset %>%
  select(TeamA, TeamB, ScoreA, ScoreB) %>%
  rename(TeamA = TeamA, TeamB = TeamB, ScoreA = ScoreA, ScoreB = ScoreB)

# Add a Result column of 1 if A won and 0 if A lost 
kovo_elo <- kovo_elo %>% 
  # Determining if Team.A won (1) or lost (0)
  mutate(Result = ifelse(ScoreA > ScoreB, '1', '0'))

# Use the initial.elos argument in elo.run() to assign the initial Elo ratings (k = 30)
kovo_elo_model <- elo.run(
  formula = Result ~ TeamA + TeamB,
  k = 22,
  initial.elos = 1500,
  data = kovo_elo
)

# Add the calculated elo model onto data frame
vnl_elo_ratings <- kovo_elo_model %>%
  as.data.frame() %>%
  mutate_if(is.numeric, round , digits = 2)

# Final data frame
vnl_elo_ratings

# Final Elo ratings
final.elos(kovo_elo_model)

############
library(openxlsx)

write.xlsx(vnl_elo_ratings, file = "/Users/ryansung/Downloads/elo22_23_w21-22.xlsx", rowNames = FALSE)



