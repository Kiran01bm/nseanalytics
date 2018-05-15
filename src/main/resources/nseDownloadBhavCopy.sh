#!/bin/bash
currentDateTs=$(date -j -f "%Y-%m-%d" $1 "+%s")
endDateTs=$(date -j -f "%Y-%m-%d" $2 "+%s")
offset=86400

while [ "$currentDateTs" -le "$endDateTs" ]
do
  #date=$(date -j -f "%s" $currentDateTs "+%Y-%m-%d")
  dateVal=$(date -j -f "%s" $currentDateTs "+%d-%m-%Y")
  
  # Get day of the month
  day=`echo $dateVal | awk -F "-" '{print $1}'`
  
  # Get 3 alphabet month in upper case ex: JAN
  month=$(`echo date +"%b"` | awk '{print toupper($0)}')
  
  # echo $day $date
  `curl -kLvvvv https://www.nseindia.com/content/historical/EQUITIES/2018/$month/cm"$day$month"2018bhav.csv.zip  > $dateVal.zip`

  unzip $dateVal.zip

  rm $dateVal.zip

  currentDateTs=$(($currentDateTs+$offset))
done


echo "Removing 1st lines"

find . -name "*.csv";

find . -name "*.csv" -type f -exec sed -i '' -e "1d" {} \;
find . -name "*.csv" -type f -exec sed -i '' -e "s/,$//" {} \;
