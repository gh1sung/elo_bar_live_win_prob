# Read csv
kovo19_20_byset <- read.csv(file = "/Users/ryansung/Downloads/restructured_1920.csv")

# Deploy libraries 
library(dplyr)
library(elo)

# Change names to be readable in function 
kovo_elo2 <- kovo19_20_byset %>%
  select(TeamA, TeamB, ScoreA, ScoreB) %>%
  rename(TeamA = TeamA, TeamB = TeamB, ScoreA = ScoreA, ScoreB = ScoreB)

# Add a Result column of 1 if A won and 0 if A lost 
kovo_elo2 <- kovo_elo2 %>% 
  # Determining if Team.A won (1) or lost (0)
  mutate(Result = ifelse(ScoreA > ScoreB, '1', '0'))

# Define a vector of initial Elo ratings for each team (from previous season)
initial_elos <- c("KB손해보험" = 1519.086, "OK저축은행" = 1483.953, "대한항공" = 1583.655, "삼성화재" = 1549.197, 
                  "우리카드" = 1480.57, "한국전력" = 1352.326, "현대캐피탈" = 1531.212, 
                  "GS칼텍스" = 1504.309, "IBK기업은행" = 1488.056, "KGC인삼공사" = 1339.729, "한국도로공사" = 1592.073,
                  "현대건설" = 1471.84, "흥국생명" = 1603.992)

# Use the initial.elos argument in elo.run() to assign the initial Elo ratings (k = 30)
kovo_elo_model2 <- elo.run(
  formula = Result ~ TeamA + TeamB,
  k = 23,
  initial.elos = initial_elos,
  data = kovo_elo2
)

# Add the calculated elo model onto data frame
vnl_elo_ratings2 <- kovo_elo_model2 %>%
  as.data.frame() %>%
  mutate_if(is.numeric, round , digits = 2)

# Final data frame
vnl_elo_ratings2

# Final Elo ratings
final.elos(kovo_elo_model2)

library(openxlsx)

write.xlsx(vnl_elo_ratings, file = "/Users/ryansung/Downloads/elo22_23_w21-22.xlsx", rowNames = FALSE)



