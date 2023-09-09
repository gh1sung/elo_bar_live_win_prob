# Elo+Bar Win Prediction Model for Volleyball
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

# Example Calculation
Let's calculate the new Elo ratings after a match between two players:

Player A (rating \(R_A\)): 1500
Player B (rating \(R_B\)): 1400
K value (constant): 30

Outcome:
- Player A wins the match (S = 1 for Player A, S = 0 for Player B)

Expected outcome (\(E_A\) for Player A):
$$E_A = \frac{1}{{1 + 10^{((R_B - R_A)/400)}}}$$
$$E_A = \frac{1}{{1 + 10^{((1400 - 1500)/400)}}}$$
$$E_A ≈ 0.64$$

Change in Player A's rating (\(ΔR_A\)):
$$ΔR_A = K \cdot (S - E_A)$$
$$ΔR_A = 30 \cdot (1 - 0.64)$$
$$ΔR_A ≈ 10.8$$

New rating for Player A (\(R_A\)):
$$R_A = R_A + ΔR_A$$
$$R_A = 1500 + 10.8$$
$$R_A = 1510.8$$

For Player B:
Expected outcome (\(E_B\) for Player B):
$$E_B = \frac{1}{{1 + 10^{((R_A - R_B)/400)}}}$$
$$E_B = \frac{1}{{1 + 10^{((1500 - 1400)/400)}}}$$
$$E_B ≈ 0.36$$

Change in Player B's rating (\(ΔR_B\)):
$$ΔR_B = K \cdot (S - E_B)$$
$$ΔR_B = 30 \cdot (0 - 0.36)$$
$$ΔR_B ≈ -10.8$$

New rating for Player B (\(R_B\)):
$$R_B = R_B + ΔR_B$$
$$R_B = 1400 - 10.8$$
$$R_B ≈ 1389.2$$

So, after the match:
- Player A's new rating is approximately 1510.8
- Player B's new rating is approximately 1389.2

*** Note that the amount that the winning team has gained in rating and the amount that the losing team has lost are equal. This is because Elo ratings are a zero-sum game, meaning that their NET total change are equal. ***

# KOVO Example Run with R elo package
In codes elo18-19.R through elo22-23code.R are Elo rating runs of KOVO (Korean Volleyball Federation). 
After collecting data for win/loss records for KOVO, we accumulated each team within the federation to run their elo ratings. All 14 teams (7 men, 7 women) started with a rating of 1500. Their K constant (the acceleration of the rating at which it increases/decreases) was determined using machine learning techniques for highest accuracy. 

An example of the result is displayed in file vnl_elo_ratings5.csv. You can see that Team A starts with a rating of about 1600 and Team B starts with a rating of about 1496. This is because the initial ratings of 1500 for every team has been accumulated and carried over from the previous years. Hence, the final elo rating from the 18-19 season rolls over to the start of the next season (19-20) and so on. The final elo ratings of the five years of win and loss data can be seen on elo_amalgamation.xslx. 

*** Note that all data for the win and loss of games are data by each set of a volleyball game. If wins.A = 1, then that means team.A won in the first set of that game. p.A is the probability of team.A winning (which is expected set score, maximum set score is 1 and minimum is 0, hence any number in between is that team's probability of earning that set score). Adding onto from the previous section, update.A and update.B are equal because of the zero-sum game.***

# Accuracy of Pure Elo
While Elo ratings provide a solid mathematical foundation to probability predictions and a valid rating system (it is especially very easy to code the R package), it comes with its flaws.

Here are notable flaws:

1. If there are changes made in a team during an offseason or in-season, then it will take a long time for the change to be reflected onto the ratings. This is because the ratings are gradually increasing/decreasing PURELY and ONLY via wins and losses of sets. For example, if Lebron was traded to the Detroit Pistons, the Pistons' rating would not be immediately increased, rather gradually over time.

2. The rating does not reflect the game in a true way. Yes, the wins and losses is in the end what matters, but the elo rating does not count into play of close games, or an upset. Yes, it does give more credit to the "weaker" team if they win a "stronger" team, but it still only encapsulates the conclusion of the game: win or loss. 

3. It is unclear of where to start as initial ratings. Did all teams start with an equal amount of strength of their roster? How far do we have to go back? While KOVO was fairly recently started (the latest season being 2005), if this were to be an NBA team's elo ratings, for instance, how far do we go back? To the 1950s when the Philadelphia 76ers were called the Syracuse Nationals?

Therefore, it was necessary to have an accuracy of the elo ratings. In the very last code of the elo_finale.ipynb are accuracy results. Getting every result of every set from every team starting from 2018 to 2023, the final accuracy was about 57%. If p.A was above 0.5 (which means that the elo ratings are predicting team A to win) and wins.A = 1, then that was considered an accurate prediction. If p.A was below 0.5 (which means that the elo ratings are predicting team A would lose) and wins.A = 0, then that was also considered an accurate predictions. Adding both cases and diving over the total number of predictions, the accuracy was 57%.

*** Note that this accuracy is not as precise as we want it to be. This is because it would be predicting some of the earlier games when all the teams have the same initial rating of 1500, which is an inaccurate fallacy as the teams won't be of all same levels at the start of the 2018 season. From this we can know that as the elo ratings accumulate, they would be more accurate. Also, five years of data is not enough to determine a team's rating. Lack of data was also a problem ***

# What now? 
Now, there are some things to determine. Is 57% a good enough accuracy? Do we want the model to be predicting whether a team will win or lose just with a 57% accuracy? Even if you randomly choose any team, that will be prediction accuracy of 50%. Just 7% above the base accuracy? It is not worth it. Therefore, it was necessary to find more metrics to add or complement the elo rating for a higher accuracy. 

# Enter BAR (Box score Above Replacement Player) 
FiveThirtyEight has an amazing metric for the NBA that they have been developing for years of trial and error. It is called the RAPTOR. This metric takes account of two major components that are blended together to rate players: a “box” (as in “box score”) component, which uses individual statistics (including statistics derived from player tracking and play-by-play data), and an “on-off” component, which evaluates a team’s performance when the player and various combinations of his teammates are on or off the floor. They account 75% of this and the rest with elo ratings. 

More details:
[FiveThirtyEight NBA Predictions Methodology](https://fivethirtyeight.com/methodology/how-our-nba-predictions-work/)

With volleyball, and especially in Korea (KOVO), the market is very small. Small markets lead to small audience, small audience leads to less money circulating, less money circulating means brittle data base. Even if there is a market, it might only be just enough to maintain the current data base bank. The current private data bank gives access to basic box data and maybe some heat maps along with wins/losses. With this in mind, it was challenging to redesign something similar to that of FiveThirtyEight's RAPTOR metric, but the elo rating was already solidly established. All that was needed at this stage was something that is theoretically more logically sound. Even if by adding another metric and blending it with Elo meant that the accuracy falls, if it is the more logical solution, which it is, then it was worth a shot. 

There was need of an individual metric that can be defined by itself, merges with the elo rating, and provides logical "information" about each individual player. If the metric does so, then changes made within the team will be reflected immediately, even by sets (starting and benches subbing in and out). 

In baseball, there is a metric known as WAR: wins above replacement player. This metric  














