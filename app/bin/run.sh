#/bin/bash

# Build/Compile
javac -cp "/usr/apps/nse/classes:/usr/apps/nse/dependency/*" -d /usr/apps/nse/classes /usr/apps/nse/src/*.java

# Run/Execute
java -cp "/usr/apps/nse/classes:/usr/apps/nse/dependency/*" com.kiran.nse.nseanalytics changeit $STARTDATE $ENDDATE
