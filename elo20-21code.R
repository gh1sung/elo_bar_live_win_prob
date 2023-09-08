# Read csv
kovo20_21_byset <- read.csv(file = "/Users/ryansung/Downloads/restructured_2021.csv")

# Deploy libraries 
library(dplyr)
library(elo)

# Change names to be readable in function 
kovo_elo3 <- kovo20_21_byset %>%
  select(TeamA, TeamB, ScoreA, ScoreB) %>%
  rename(TeamA = TeamA, TeamB = TeamB, ScoreA = ScoreA, ScoreB = ScoreB)

# Add a Result column of 1 if A won and 0 if A lost 
kovo_elo3 <- kovo_elo3 %>% 
  # Determining if Team.A won (1) or lost (0)
  mutate(Result = ifelse(ScoreA > ScoreB, '1', '0'))

# Define a vector of initial Elo ratings for each team (from previous season)
initial_elos2 <- c("KB손해보험" = 1412.329, "OK금융그룹" = 1490.28, "대한항공" = 1650.347, "삼성화재" = 1438.477, 
                  "우리카드" = 1646.432, "한국전력" = 1338.953, "현대캐피탈" = 1523.181, 
                  "GS칼텍스" = 1550.911, "IBK기업은행" = 1415.797, "KGC인삼공사" = 1530.192, "한국도로공사" = 1363.439,
                  "현대건설" = 1580.082, "흥국생명" = 1559.579)

# Use the initial.elos argument in elo.run() to assign the initial Elo ratings (k = 30)
kovo_elo_model3 <- elo.run(
  formula = Result ~ TeamA + TeamB,
  k = 12,
  initial.elos = initial_elos2,
  data = kovo_elo3
)

# Add the calculated elo model onto data frame
vnl_elo_ratings3 <- kovo_elo_model3 %>%
  as.data.frame() %>%
  mutate_if(is.numeric, round , digits = 2)

# Final data frame
vnl_elo_ratings3

# Final Elo ratings
final.elos(kovo_elo_model3)

library(openxlsx)

write.xlsx(vnl_elo_ratings, file = "/Users/ryansung/Downloads/elo22_23_w21-22.xlsx", rowNames = FALSE)


elo.prob(1635.17, 1596.15)
