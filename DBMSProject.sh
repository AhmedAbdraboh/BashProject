#!/bin/bash

#************************** Choose Command ******************************** 

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

printf "1- Create Database\n2- Rename Database \n3- Drop Database\n"
printf 'Enter Your Choice Number: '
read choice

case $choice in
     1)
           createDB
          ;;
     2)
          renameDB
          ;;
     3)
          removeDB
          ;; 
     *)
          echo "incorrect choice... plz, choose again"
          ;;
esac
