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

#************************** Tables management ********************************
function showTables(){
  ls -p | grep -v /
}
function createTable(){
  printf "Enter Table Name: "
  read tableName
  touch $tableName
}
# function updateTable(){

# }
# function deleteTable(){

# }
function dropTable(){
  printf "Enter Table Name: "
  read tableName
  rm $tableName
}

#************************** Select management ********************************
function selectAll(){
  printf "Enter Table Name: "
  read tableName
  awk -F: '{if(NR>1 && NR<16) print $0}' $tableName
}

function selectSpecificCol(){
  printf "Enter Table Name: "
  read tableName
  printf "Enter Column Number: "
  read colNum
  awk '{ print $$colNum }' $tableName
}

function selectWithCond(){
  printf "Enter Table Name: "
  read tableName
  printf "Enter Column Number: "
  read colNum
  awk '$2 == "shimaa" {print $$colNum }' $tableName
}
function getFieldNumber(){
  columnName=$1
  tableNameToLook=$2

  columnNumber=$(awk -v var=${columnName} 'BEGIN{FS=":";}{if(NR==1){
                for(i=1;i<=NF;i++){
                  if($i~ var)
                    print i
                }
              }
            }' $tableNameToLook)
  echo $columnNumber


}
#************************** Menue management ********************************
names='Create-Database Rename-Database Drop-Database Use-Database Show-Databases Quit'
PS3='Enter option Number: '
namesTables='Create-Table Show-Tables Select-from-Table Update-Table Delete-from-Table Drop-Table Quit';
selectTables='Select-All-Columns Select-specific-Columns Select-with-Condition Aggregate-Function Quit'
getFieldNumber email text123

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
                      select selectTable in $selectTables
                      do
                        case $selectTable in
                          'Select-All-Columns')
                            selectAll
                            ;;
                          'Select-specific-Columns')
                            selectSpecificCol
                            ;;
                          'Select-with-Condition')
                            selectWithCond
                            ;;
                          'Aggregate-Function')
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
                    'Update-Table')

                      ;;
                    'Delete-from-Table')

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
