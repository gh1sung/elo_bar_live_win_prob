# Elo+Bar Win Prediction Model
This model is a combination of Elo Ratings and BAR (box score above replacement player) that can predict live volleyball games with an accuracy range of 60~70%

# Elo Ratings
Elo ratings were originally created by prof. Arpad Elo. His ratings system was originally created for rating chess players in a mathematically logical method. This chess rating system prevailed around people and was later developed further for predicting games in baseball, basketball, football, and etc. This rating provides solid mathematical foundation to such an obscure and subjective ideology of rating a particular team or individual; however, it also has it's downsides. For example, if there are changes made in a team (during an offseason, let's say), then it will take a very long time for that change to be reflected into the team's rating. In any case, Elo Rating is a good starting point for having a mathematical system that objectifies a subjective idea. 

# Formula
The Elo rating is calculated using the following formula:

$$R_n = R_o + K \cdot (S - E)$$

Where:
- \(R_n\) is the new Elo rating.
- \(R_o\) is the old Elo rating.
- \(K\) is the weight of the match (usually a constant, like 32).
- \(S\) is the actual outcome of the match (1 for a win, 0.5 for a draw, 0 for a loss).
- \(E\) is the expected outcome of the match, calculated as:

$$E = \frac{1}{{1 + 10^{((R_o - R_e)/400)}}}$$

- \(R_e\) is the opponent's Elo rating.

