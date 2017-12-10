# Rock-Paper-Scissors-Arcade-Machine

A Rock-Paper-Scissors Arcade Machine is a simple game as suggested from its title. 

The overall blueprint of a machine is described as follows.

	•	(Output) A left screen and a right screen that quickly repeat through a 
	
	natural number 0 and 20 inclusively.
	
	•	(Output) The main screen, located between left and right screens, 
	
	alternates through graphic illustrations of rock, paper, and scissor. 
	
	Also displays a number of successive wins.
	
	•	(Input) Five buttons: “left”, “right”, “rock”, “paper”, and “scissor”.
	
The game initiates by inserting a coin. The left and right screens starts the repetition 

until the “left” and “right” button are pushed. Let’s denote x and y as the values halted in 

left and right screens respectively. If x > y, the potential credit is x-y (subtraction) and if x < y,

the potential credit is y – x (subtraction). At the case when x = y, the player loses the game. When 

the potential credit is set, the main screen presents the alternations as mentioned above. The 

repetition continuous until one of the buttons, “rock”, “paper”, and “scissor”, is pressed. With a 

valid input, the machine evaluates the winner of the game. The player must win three games successively 

in order to acquire the potential credit. The number of winning streak is shown in the main screen.

The program uses DE1_SoC circuit. The .sof file can be imported by the hardware and be played.

