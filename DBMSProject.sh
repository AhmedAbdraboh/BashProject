#!/bin/bash

#************************** Choose Command ******************************** 

function createDB(){
 	printf "Enter Database Name: "
	read dbName
	mkdir $dbName
}

function removeDB(){
	printf "Enter Database Name: "
	read dbName
	rm -r $dbName
}

function renameDB(){
	printf "Enter Old Name: "
	read dbName
	printf "Enter New Name: "
	read dbNewName
	mv  $dbName $dbNewName
}

printf "1- Create Database\n2- Rename Database \n3- Drop Database\n"
printf 'Enter Your Choice Number: '
read choice

case $choice in
     1)
           createDB
          ;;
     2)
          removeDB
          ;;
     3)
          renameDB
          ;; 
     *)
          echo "incorrect choice... plz, choose again"
          ;;
esac
