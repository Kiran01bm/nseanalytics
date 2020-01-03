#/bin/bash

# Build/Compile
javac -cp "/usr/apps/nse/classes:/usr/apps/nse/dependency/*" -d /usr/apps/nse/classes /usr/apps/nse/src/*.java

# Run/Execute
java -cp "/usr/apps/nse/classes:/usr/apps/nse/dependency/*" com.kiran.nse.nseanalytics changeit 01-Dec-2019 31-Dec-2019
