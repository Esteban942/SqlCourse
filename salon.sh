#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t -c"

MAIN_MENU(){
SERVICES=$($PSQL "SELECT * FROM services;")

echo "$SERVICES" | while read SERVICE_ID BAR NAME
do 
  echo $SERVICE_ID")" $NAME
done 
}

MAX=$($PSQL "SELECT MAX(service_id) FROM services;")

MAIN_MENU 

echo Ingresa un id de servicio

read SERVICE_ID_SELECTED

while (( 1 > $SERVICE_ID_SELECTED || $SERVICE_ID_SELECTED > $MAX ))
do  
  MAIN_MENU 

  echo Ingresa un id de servicio

  read SERVICE_ID_SELECTED
done


echo Ingresa un phone number
read CUSTOMER_PHONE

CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")

if [[ -z $CUSTOMER_NAME ]]
then
  echo ingresa tu nombre
  read CUSTOMER_NAME
  echo $($PSQL "INSERT INTO customers(phone,name) VALUES ('$CUSTOMER_PHONE','$CUSTOMER_NAME');")
fi

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")

echo Ingresa un horario para el servicio
read SERVICE_TIME

echo $($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES ('$CUSTOMER_ID','$SERVICE_ID_SELECTED', '$SERVICE_TIME');")

SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED';")

echo I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME.








