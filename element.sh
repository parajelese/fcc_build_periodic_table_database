#!/bin/bash
#periodic table database testing
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
echo -e "\n~~Welcome to Periodic Table Database~~\n"
if [[ -z $1 ]]
then
#argument required
echo -e "\nPlease provide an element as an argument."
exit
else
#number validation
if [[ ! $1 =~ ^[0-9]+$ ]]
then
ELEMENT=$($PSQL "SELECT atomic_number,atomic_mass,melting_point_celsius,boiling_point_celsius,symbol,name,type FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE elements.name LIKE '$1%' ORDER BY atomic_number LIMIT 1")
else
ELEMENT=$($PSQL "SELECT atomic_number,atomic_mass,melting_point_celsius,boiling_point_celsius,symbol,name,type FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE elements.atomic_number=$1")
fi
if [[ -z $ELEMENT ]]
then
echo "I could not find that element in the database."
exit
else
echo $ELEMENT | while IFS="|" read ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS SYMBOL NAME TYPE
do
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
done
exit
fi
fi