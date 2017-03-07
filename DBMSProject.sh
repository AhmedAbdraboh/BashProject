#!/bin/bash
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
function showDB() {
  ls -d */;
}
function useDB(){
  printf "Enter Database Name: "
  read dbName
  cd $dbName
}
function showTables(){
  ls -p | grep -v /
}
function createTable(){
  declare -a names
  declare -a types
  choices='integer string'
  printf "Enter Table Name: "
  read tableName
  printf "Enter Number of Columns: "
  read numberOfColumns
  for (( i = 0; i < $numberOfColumns; i++ ));
  do
    echo "Enter Name of Column Number $i: "
    read nameOfColumn
    names[$i]=$nameOfColumn
    while true
    do
      printf "Enter Type of Column int or string $i: "
      read Type1
      if [ $Type1 == "int" ] || [ $Type1 == 'string' ]; then
        types[$i]=$Type1
        break
      else
        echo 'wrong input'
      fi
    done
  done
  touch $tableName

  for (( i = 0; i < $numberOfColumns; i++ )); do
    if [[ i -eq numberOfColumns-1 ]]; then
      echo -n ${names[$i]}-${types[$i]}>>$tableName
    else
      echo -n ${names[$i]}-${types[$i]}:>>$tableName
    fi
  done
}
# function selectFromTable(){
#
# }
# function updateTable(){
#
# }
# function deleteTable(){
#
# }
# function dropTable(){
#
# }

#************************** database management ********************************

names='Create-Database Rename-Database Drop-Database Use-Database Show-Databases Quit'
PS3='Enter Choice Number: '
namesTables='Create-Table Show-Tables Select-from-Table Update-Table Delete-from-Table Drop-Table Quit';
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
          'Use-Database')
                useDB
                select nameTable in $namesTables
                do
                  case $nameTable in
                    'Create-Table')
                      createTable
                      ;;
                    'Show-Tables')
                      showTables
                      ;;
                    'Select-from-Table')
                      selectFromTable
                      ;;
                    'Update-Table')
                      updateTable
                      ;;
                    'Delete-from-Table')
                      deleteTable
                      ;;
                    'Drop-Table')
                      dropTable
                      ;;
                    'Quit')
                      cd ../
                      break
                      ;;
                  *)
                       echo "incorrect choice... plz, choose again"
                     ;;
                  esac
                done
              ;;
          'Show-Databases')
               showDB
               ;;
          'Quit')
               break
               ;;
          *)
               echo "incorrect choice... plz, choose again"
               ;;
     esac
done
