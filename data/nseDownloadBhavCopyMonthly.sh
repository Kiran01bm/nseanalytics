#!/bin/bash

# Sample Invocation
# ./nseDownloadBhavCopyMonthly.sh DEC 2019 

day=1

# ex: DEC
month=$1

# ex: 2019
year=$2

while [ $day -le 31 ] 
do
  case "$day" in

  1)  day=01
      ;;
  2)  day=02
      ;;
  3)  day=03
      ;;
  4)  day=04
      ;;
  5)  day=05
      ;;
  6)  day=06
      ;;
  7)  day=07
      ;;
  8)  day=8
      ;;
  9)  day=9
      ;;
  *)  day=$day
      ;;
  esac

  echo $day $month $year  

  `curl -kLvvvv https://www.nseindia.com/content/historical/EQUITIES/$year/$month/cm"$day$month$year"bhav.csv.zip  > $dateVal.zip`

  if [ $day -eq 8 ]
  then
    `curl -kLvvvv https://www.nseindia.com/content/historical/EQUITIES/$year/$month/cm"08$month$year"bhav.csv.zip  > $dateVal.zip`
  elif [ $day -eq 9 ]
  then
    `curl -kLvvvv https://www.nseindia.com/content/historical/EQUITIES/$year/$month/cm"09$month$year"bhav.csv.zip  > $dateVal.zip`
  fi
  unzip $dateVal.zip

  rm $dateVal.zip
   
  day=$(( $day + 1 ))
done


echo "Removing 1st lines"

find . -name "*.csv";

find . -name "*.csv" -type f -exec sed -i '' -e "1d" {} \;
find . -name "*.csv" -type f -exec sed -i '' -e "s/,$//" {} \;

cat *.csv > consolidated.csv
