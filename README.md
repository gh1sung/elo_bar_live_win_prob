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

*** Note that the amount that the winning team has gained in rating and the amount that the losing team has lost are equal. This is because Elo ratings are a zero-sum game, meaning that their NET total change are equal.***

# KOVO Example Run with R elo package
In codes elo18-19.R through elo22-23code.R are Elo rating runs of KOVO (Korean Volleyball Federation). 
After collecting data for win/loss records for KOVO, we accumulated each team within the federation to run their elo ratings. All 14 teams (7 men, 7 women) started with a rating of 1500. Their K constant (the acceleration of the rating at which it increases/decreases) was determined using machine learning techniques for highest accuracy. 

An example of the result is displayed in file vnl_elo_ratings5.csv. You can see that 
