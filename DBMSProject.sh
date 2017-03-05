#!/bin/bash

#************************** database management ******************************** 
function createDB(){
 	printf "Enter Database Name: "
	read dbName
	mkdir $dbName
}

function renameDB(){
	printf "Enter Old Name: "
	read dbName
	printf "Enter New Name: "
	read dbNewName
	mv  $dbName $dbNewName
}

function removeDB(){
     printf "Enter Database Name: "
     read dbName
     rm -r $dbName
}

names='Create-Database Rename-Database Drop-Database Quit'
PS3='Enter Choice Number: '
select name in $names
do
     case $name in
          'Create-Database')
               createDB
               ;;
          'Rename-Database')
               renameDB
               ;;
          'Drop-Database')
               removeDB
               ;; 
          'Quit')
               break
               ;;
          *)
               echo "incorrect choice... plz, choose again"
               ;;
     esac
done
