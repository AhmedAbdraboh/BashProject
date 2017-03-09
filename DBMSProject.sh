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

#************************** Tables management ********************************
function showTables(){
  ls -p | grep -v /
}
function dropTable(){
  printf "Enter Table Name: "
  read tableName
  rm $tableName
}
function createTable(){
  declare -a names
  declare -a types
  declare flag=1
  declare PrimaryCol
  # declare columnNumber
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


    if [ $flag == 1 ]; then
      printf "Make column as Primary Key[y/n] "
      read isPrimary
      if [[ $isPrimary == 'y' ]]; then
        declare flag=0
        columnNumberOfPrimaryKey=$i
      fi
    fi

  done
  touch $tableName
  echo -n ${names[$columnNumberOfPrimaryKey]}-${types[$columnNumberOfPrimaryKey]}:>>$tableName
  for (( i = 0; i < $numberOfColumns; i++ )); do
    if [[ i -ne columnNumberOfPrimaryKey ]]; then
      if [[ i -eq numberOfColumns-1 ]]; then
        echo ${names[$i]}-${types[$i]}>>$tableName
      else
        echo -n ${names[$i]}-${types[$i]}:>>$tableName
      fi
    fi
  done
}
function insertIntoTable(){
  declare -a values
  printf "Enter Table Name: "
  read tableName

  numberOfColumnsss=$(awk -F: '{if(NR==1)print NF}' $tableName)

  for (( i = 1; i <= $numberOfColumnsss; i++ ));
  do
    fieldName=$(awk -F: -v var=${i} '{if(NR==1)print $var}' $tableName)
    dataTypeOfField=$(echo $fieldName | cut -d'-' -f2)
    while true
    do
      printf "Enter Value of $fieldName  "
      read values[$i-1]

      while true
      do
        if [[ $i == 1 ]]; then
          isValidPK=$(isValidPrimaryKey $values $tableName)
          if [[ $isValidPK == 'error' ]]; then
            printf "Invalid data, Enter again"
          fi
        fi
      done

      resultCheckDataType=$(checkDataType $dataTypeOfField ${values[$i-1]})
      if [[ $resultCheckDataType == 'success' ]]; then
        break
      else
        echo "Error Input Enter correct Data Type"
      fi
    done
  done

  for (( i = 0; i < $numberOfColumnsss; i++ ));
  do
    if [[ i -eq numberOfColumns-1 ]]; then
      echo ${values[$i]}>>$tableName
    else
      echo -n ${values[$i]}:>>$tableName
    fi
  done
}
function updateTable(){
  printf "Enter Table To update: "
  read tableName
  printf "Enter identifier: "
  read identifier
  printf "Enter value of identifier: "
  read identifierValue
  printf "Enter column to change: "
  read columnToChange
  printf "Enter new value: "
  read newValue 

  columnNumberOfIdentifier=$(getFieldNumber $identifier $tableName)
  columnNumberOfChange=$(getFieldNumber $columnToChange $tableName)

  oldValue=$(awk -F: '{if($'$columnNumberOfIdentifier'=='$identifierValue')print $'$columnNumberOfChange'}' $tableName)
  sed -i 's/'$oldValue'/'$newValue'/' $tableName

}
function deleteTable(){
  printf "Enter Name of table to delete from: "
  read tableName
  printf "Enter identifier: "
  read identifier
  printf "Enter identifierValue: "
  read identifierValue
  columnNumberOfIdentifier=$(getFieldNumber $identifier $tableName)
  echo $columnNumberOfIdentifier
  rowNumber=$(awk -F':' '{if($'$columnNumberOfIdentifier' == "'$identifierValue'") print NR }' $tableName)
  echo $rowNumber
  sed -i ''$rowNumber'd' $tableName
}
#************************** Select management ********************************
function selectAll(){
  printf "Enter Table Name: "
  read tableName

  awk -F':'  '{if(NR>1) print $0 }' $tableName

}

function selectSpecificCol(){
  printf "Enter Table Name: "
  read tableName
  printf "Enter Column Name: "
  read colName

  columnNumber=$(getFieldNumber $colName $tableName)
  awk -F':' '{if(NR>1) print $'$columnNumber'}' $tableName

}


function selectWithCond(){
  printf "Enter Table Name: "
  read tableName
  printf "Enter Column Name: "
  read colName

  columnNumber=$(getFieldNumber $colName $tableName)
  printf "Enter field to select data: "
  read condition
  awk -F':' '{if($'$columnNumber'== "'$condition'") print $0 }' $tableName
}

function sumCol(){
  printf "Enter Table Name: "
  read tableName
  printf "Enter Column Name: "
  read colName

  columnNumber=$(getFieldNumber $colName $tableName)
  awk -F':' '{if(NR>2) sum+=$'$columnNumber'; } END{print "sum=",sum}' $tableName
}

function countRows(){
  printf "Enter Table Name:  "
  read tableName
  awk '{if(NR>2) count++} END {print "count= ",count}' $tableName
}

function averageCol(){
  printf "Enter Table Name: "
  read tableName
  printf "Enter Column Name: "
  read colName

  columnNumber=$(getFieldNumber $colName $tableName)
  awk -F':' '{sum+=$'$columnNumber'; if(NR>2) count++} END{print "average=",sum/count}' $tableName
}

#*********************************************************************************
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

function checkDataType(){
  dataType=$1
  # echo $dataType
  value=$2
  # echo $value
  re='^[0-9]+$'
  reString='^[a-zA-Z]+$'
  # echo "inside fun"
  if [[ $dataType == 'int' ]]; then
    # echo "inside int check"
    if ! [[ $value =~ $re ]]; then
      echo "error"
      exit
    else
      echo "success"
      exit
    fi
  fi
  if [[ $dataType == 'string' ]]; then
    # echo "inside string check"

    if ! [[ $value =~ $reString ]]; then
      echo "error"
      exit
    else
      echo "success"
      exit
    fi
  fi
  # echo "error"
}

isValidPrimaryKey()
{
  primaryValue=$1
  tableName=$2

  while read line
  do
    result=$( echo $line | cut -d ':' -f1 );
    if [[ $result == $primaryValue ]]; then
      echo "error"
      exit
    fi
  done <$tableName
}

#************************** Menue management ********************************
names='Create-Database Rename-Database Drop-Database Use-Database Show-Databases Quit'
PS3='Enter option Number: '
namesTables='Create-Table Show-Tables Select-from-Table Update-Table Delete-from-Table Drop-Table Insert-Into-Table Back';
selectTables='Select-All-Columns Select-specific-Columns Select-with-Condition Sum Count Average Back'


function selectMenu()
{
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
        'Sum')
          sumCol
          ;;
        'Count')
          countRows
          ;;
        'Average')
          averageCol
          ;;
        'Back')
          cd ../
          clear
          useFun
          break
          ;;
        *)
          echo "incorrect choice... plz, choose again"
          ;;
      esac
    done
}

function useFun()
{
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
          clear
          selectMenu
          ;;
        'Update-Table')
          updateTable
          ;;
        'Delete-from-Table')
          Delete-from-Table
          ;;
        'Drop-Table')
          dropTable
          ;;
        'Insert-Into-Table')
          insertIntoTable
          ;;
        'Back')
          cd ../
          clear
          mainMenu
          break
          ;;
        *)
          echo "incorrect choice... plz, choose again"
          ;;
      esac
    done
}

function mainMenu()
{
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
        clear
        useFun
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
}

mainMenu