#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

NUMBER=$(( $RANDOM % 1000 + 1 ))
echo $NUMBER

echo Enter your username:

read USERNAME

USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME';")


if [[ -z $USER_ID ]]
then 

  echo Welcome, $USERNAME! It looks like this is your first time here.
  $($PSQL "INSERT INTO users(username, games_played, best_game) VALUES ('$USERNAME', 0, 0);")
  BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username='$USERNAME';")

else

  GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE user_id=$USER_ID;")
  BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE user_id=$USER_ID;")

  echo Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.
fi

TRIES=1
echo Guess the secret number between 1 and 1000:

read USER_NUMBER

while (( USER_NUMBER != NUMBER ))
do
  if [[ ! $USER_NUMBER =~ ^[0-9]+$ ]]
  then
    echo That is not an integer, guess again:
    read USER_NUMBER
  else
    if (( USER_NUMBER < NUMBER ))
    then 
      echo "It's higher than that, guess again:"
      (( TRIES++ ))
      read USER_NUMBER
    else
      echo "It's lower than that, guess again:"
      (( TRIES++ ))
      read USER_NUMBER
    fi
  fi  
done

if [[ $BEST_GAME == 0 ]]
then 
  $($PSQL "UPDATE users SET games_played=1 WHERE username='$USERNAME';")
  $($PSQL "UPDATE users SET best_game=$TRIES WHERE username='$USERNAME';")
else
  (( GAMES_PLAYED++ ))
  if [[ $TRIES < $BEST_GAME ]]
  then
    $($PSQL "UPDATE users SET games_played=$GAMES_PLAYED WHERE username='$USERNAME';")
    $($PSQL "UPDATE users SET best_game=$TRIES WHERE username='$USERNAME';")
  else
    $($PSQL "UPDATE users SET games_played=$GAMES_PLAYED WHERE username='$USERNAME';")
  fi
fi  

echo You guessed it in $TRIES tries. The secret number was $NUMBER. Nice job!



