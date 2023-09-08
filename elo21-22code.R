kovo21_22_byset <- read.csv(file = "/Users/ryansung/Downloads/restructured_2122.csv")

library(dplyr)
library(elo)

kovo_elo4 <- kovo21_22_byset %>%
  select(TeamA, TeamB, ScoreA, ScoreB) %>%
  rename(TeamA = TeamA, TeamB = TeamB, ScoreA = ScoreA, ScoreB = ScoreB)


initial_elos3 <- c("KB손해보험" = 1463.549, "OK금융그룹" = 1476.434, "대한항공" = 1627.238, "삼성화재" = 1364.935, 
                   "우리카드" = 1604.082, "한국전력" = 1478.963, "현대캐피탈" = 1484.798, 
                   "GS칼텍스" = 1577.789, "IBK기업은행" = 1467.224, "KGC인삼공사" = 1502.496, "한국도로공사" = 1481.197,
                   "현대건설" = 1484.465, "흥국생명" = 1486.829, "페퍼저축은행" = 1500)

kovo_elo4 <- kovo_elo4 %>% 
  # Determining if Team.A won (1) or lost (0)
  mutate(Result = ifelse(ScoreA > ScoreB, '1', '0'))

kovo_elo_model4 <- elo.run(
  formula = Result ~ TeamA + TeamB,
  k = 17,
  initial.elos = initial_elos3,
  data = kovo_elo4
)



vnl_elo_ratings4 <- kovo_elo_model4 %>%
  as.data.frame() %>%
  mutate_if(is.numeric, round , digits = 2)

vnl_elo_ratings4

final.elos(kovo_elo_model4)

library(openxlsx)


write.csv(vnl_elo_ratings, file = "/Users/ryansung/Downloads/vnl_elo_ratings.csv")
write.csv(vnl_elo_ratings2, file = "/Users/ryansung/Downloads/vnl_elo_ratings2.csv" )
write.csv(vnl_elo_ratings3, file = "/Users/ryansung/Downloads/vnl_elo_ratings3.csv",)
write.csv(vnl_elo_ratings4, file = "/Users/ryansung/Downloads/vnl_elo_ratings4.csv")
write.csv(vnl_elo_ratings5, file = "/Users/ryansung/Downloads/vnl_elo_ratings5.csv")


