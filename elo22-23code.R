kovo22_23_byset <- read.csv(file = "/Users/ryansung/Downloads/restructured_2223.csv")

library(dplyr)
library(elo)

kovo_elo5 <- kovo22_23_byset %>%
  select(TeamA, TeamB, ScoreA, ScoreB) %>%
  rename(TeamA = TeamA, TeamB = TeamB, ScoreA = ScoreA, ScoreB = ScoreB)


initial_elos4 <- c("KB손해보험" = 1502.312, "OK금융그룹" = 1431.919, "대한항공" = 1594.046, "삼성화재" = 1442.913, 
                   "우리카드" = 1555.889, "한국전력" = 1545.19, "현대캐피탈" = 1427.729, 
                   "GS칼텍스" = 1625.218, "IBK기업은행" = 1491.162, "KGC인삼공사" = 1426.694, "한국도로공사" = 1628.489,
                   "현대건설" = 1637.624, "흥국생명" = 1398.627, "페퍼저축은행" = 1292.186)

kovo_elo5 <- kovo_elo5 %>% 
  # Determining if Team.A won (1) or lost (0)
  mutate(Result = ifelse(ScoreA > ScoreB, '1', '0'))

kovo_elo_model5 <- elo.run(
  formula = Result ~ TeamA + TeamB,
  k = 17,
  initial.elos = initial_elos4,
  data = kovo_elo5
)



vnl_elo_ratings5 <- kovo_elo_model5 %>%
  as.data.frame() %>%
  mutate_if(is.numeric, round , digits = 2)

vnl_elo_ratings5

final.elos(kovo_elo_model5)


elo.prob(1500, 1400)


library(openxlsx)

write.xlsx(vnl_elo_ratings, file = "/Users/ryansung/Downloads/elo21_22_final.xlsx", rowNames = FALSE)
write.xlsx(kovo_elo, file = "/Users/ryansung/Downloads/kovo22_23_set.xlsx", rowNames = FALSE)

