#!/bin/sh
#
#    MIT License
#    Copyright (c) 2016  Pierre-Yves Lapersonne (Twitter: @pylapp, Mail: pylapp(dot)pylapp(at)gmail(dot)com)
#    Permission is hereby granted, free of charge, to any person obtaining a copy
#    of this software and associated documentation files (the "Software"), to deal
#    in the Software without restriction, including without limitation the rights
#    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#    copies of the Software, and to permit persons to whom the Software is
#    furnished to do so, subject to the following conditions:
#    The above copyright notice and this permission notice shall be included in all
#    copies or substantial portions of the Software.
#    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#    SOFTWARE.
#
#
# Author..............: pylapp
# Version.............: 9.0.0
# Since...............: 21/06/2016
# Description.........: Parses the CSV files (previously generated from the ODS file) to HTML files, and concatenate them to the README.md file
#
# Usage: sh csvToReadme.sh
#


# ############# #
# CONFIGURATION #
# ############# #

# The file to update with the HTML content (displayed in the Github repo)
README_FILE="../README.md"

# Some configuration things
UTILS_FOLDER=".";
CSV2HTML_TOOLS_SCRIPT="csvToHtml_tools.sh"
CSV2HTML_TOOLS_OPTIONS=" --limitedHtml"
CSV2HTML_DEVICES_SCRIPT="csvToHtml_devices.sh"
CSV2HTML_DEVICES_OPTIONS=" --limitedHtml"

# The folders and files about the libraries and tools
TOOLS_DIR="../toolz"
CSV_TOOLS_FILE="$TOOLS_DIR/Tips-n-tools_Tools.csv"
CSV_TOOLS_FILE_USELESS_ROWS=6
HTML_TOOLS_FILE="$TOOLS_DIR/Tips-n-tools_Tools.html"

# The folder and files about some publications, articles, blogs...
WEB_DIR="../webz"
CSV_WEB_FILE="$WEB_DIR/Tips-n-tools_WebLinks.csv"
CSV_WEB_FILE_USELESS_ROWS=6
HTML_WEB_FILE="$WEB_DIR/Tips-n-tools_WebLinks.html"

# The folder and files about the devices (smartphones, phablets, tablets, wearables, smartwatches...)
DEVICE_DIR="../devz"
CSV_DEVICE_FILE="$DEVICE_DIR/Tips-n-tools_Devices.csv"
CSV_DEVICE_FILE_USELESS_ROWS=6
HTML_DEVICE_FILE="$DEVICE_DIR/Tips-n-tools_Devices.html"

# Misc.
README_HEADER="# Tips'n'tools \n"
README_HEADER="$README_HEADER Note: Run\n\`\`\`shell\n\tsh tipsntools.sh --help \n\`\`\`\n  to get some help about the commands\n\n"
README_HEADER="$README_HEADER Note: Run\n\`\`\`shell\n\tsh tipsntools.sh {--findAll | --findWeb | --findDevices | --findTools} aRegex \n\`\`\`\n to make some search in files with a regular expression \n\n"
README_HEADER="$README_HEADER Note: Run\n\`\`\`shell\n\tsh tipsntools.sh --update  \n\`\`\`\n  to update the .html and README.md files with the value of the .csv files\n\n"


# ######### #
# MAIN CODE #
# ######### #

# Check the args and display usage if needed
if [ "$#" -ne 0 ]; then
	echo "USAGE: sh csvToReadme.sh"
	exit 0	
fi

# Create directories if needed
if [ ! -d "$TOOLS_DIR" ]; then
	echo "Create directory '$TOOLS_DIR' for libraries, tools and frameworks things..."
	mkdir $TOOLS_DIR
else
	echo "NOTE: Directory '$TOOLS_DIR' already created"
fi

if [ ! -d "$WEB_DIR" ]; then
	echo "Create directory '$WEB_DIR' for web things..."
	mkdir $WEB_DIR
else
	echo "NOTE: Directory '$WEB_DIR' already created"
fi

if [ ! -d "$DEVICE_DIR" ]; then
	echo "Create directory '$DEVICE_DIR' for devices things..."
	mkdir $DEVICE_DIR
else
	echo "NOTE: Directory '$DEVICE_DIR' already created"
fi

# Check if all the CSV files to use exist
if [ ! -e "$CSV_TOOLS_FILE" ]; then
	echo "ERROR: The file '$CSV_TOOLS_FILE' does not exist. Impossible to parse it to HTML. Exit now."
	exit 1;
fi

if [ ! -e "$CSV_WEB_FILE" ]; then
	echo "ERROR: The file '$CSV_WEB_FILE' does not exist. Impossible to parse it to HTML. Exit now."
	exit 1;
fi

if [ ! -e "$CSV_DEVICE_FILE" ]; then
	echo "ERROR: The file '$CSV_DEVICE_FILE' does not exist. Impossible to parse it to HTML. Exit now."
	exit 1;
fi

# Update the README_FILE file
echo "Write head of README file..."
echo $README_HEADER > $README_FILE

# Get some stats to compare with new stats later
if [ -e $HTML_TOOLS_FILE ]; then
	htmlToolsRowsOld=`cat $HTML_TOOLS_FILE | wc -l`
else
	htmlToolsRowsOld=0
fi

if [ -e $HTML_WEB_FILE ]; then
	htmlWebRowsOld=`cat $HTML_WEB_FILE | wc -l`
else
	htmlWebRowsOld=0
fi

if [ -e $HTML_DEVICE_FILE ]; then
	htmlDevicesRowsOld=`cat $HTML_DEVICE_FILE | wc -l`
else
	htmlDevicesRowsOld=0
fi


# Update .html and README.md files
echo "Write HTML file from CSV file about libraries, frameworks and tools..."
cat $CSV_TOOLS_FILE | sh $UTILS_FOLDER/$CSV2HTML_TOOLS_SCRIPT $CSV2HTML_TOOLS_OPTIONS > $HTML_TOOLS_FILE

echo "Write HTML file from CSV file about web links..."
cat $CSV_WEB_FILE | sh $UTILS_FOLDER/$CSV2HTML_TOOLS_SCRIPT $CSV2HTML_TOOLS_OPTIONS > $HTML_WEB_FILE

echo "Write HTML file from CSV file about devices..."
cat $CSV_DEVICE_FILE | sh $UTILS_FOLDER/$CSV2HTML_DEVICES_SCRIPT $CSV2HTML_DEVICES_OPTIONS > $HTML_DEVICE_FILE

echo "Write README.md with HTML files' contents..."
echo "\n\n" >> $README_FILE
echo "## ✿✿✿✿ ʕ •ᴥ•ʔ/ ︻デ═一 Some useful and neat libraries, frameworks and tools" >> $README_FILE
cat $HTML_TOOLS_FILE >> $README_FILE
echo "\n\n" >> $README_FILE
echo "## ✿✿✿✿ ʕ •ᴥ•ʔ/ ︻デ═一 Some interesting web pages, blogs and publications" >> $README_FILE
cat $HTML_WEB_FILE >> $README_FILE
echo "\n\n" >> $README_FILE
echo "## ✿✿✿✿ ʕ •ᴥ•ʔ/ ︻デ═一 Some famous devices' technical characteristics" >> $README_FILE
cat $HTML_DEVICE_FILE >> $README_FILE

# Some stats about the number of fields
csvToolsRows=`cat $CSV_TOOLS_FILE | wc -l`
csvWebRows=`cat $CSV_WEB_FILE | wc -l`
csvDevicesRows=`cat $CSV_DEVICE_FILE | wc -l`
csvToolsRowsCleaned=$(($csvToolsRows - $CSV_TOOLS_FILE_USELESS_ROWS))
csvWebRowsCleaned=$(($csvWebRows - $CSV_WEB_FILE_USELESS_ROWS))
csvDevicesRowsCleaned=$(($csvDevicesRows - $CSV_DEVICE_FILE_USELESS_ROWS))
htmlToolsRowsNew=`cat $HTML_TOOLS_FILE | wc -l`
htmlWebRowsNew=`cat $HTML_WEB_FILE | wc -l`
htmlDeviceRowsNew=`cat $HTML_DEVICE_FILE | wc -l`

# Some outputs
echo "Now we have $csvToolsRowsCleaned items in $CSV_TOOLS_FILE (evolution: $htmlToolsRowsOld -> $htmlToolsRowsNew)."
echo "Now we have $csvWebRowsCleaned items in $CSV_WEB_FILE (evolution: $htmlWebRowsOld -> $htmlWebRowsNew)."
echo "Now we have $csvDevicesRowsCleaned items in $CSV_DEVICE_FILE (evolution: $htmlDevicesRowsOld -> $htmlDeviceRowsNew)."

if [ $htmlToolsRowsNew -lt $htmlToolsRowsOld ]; then
	echo "WARNING: The new file $HTML_TOOLS_FILE has now a smaller size than its previous version."
elif [ $htmlToolsRowsNew -eq $htmlToolsRowsOld ]; then
	echo "NOTE: The new file $HTML_TOOLS_FILE has the same size as its previous version."
fi

if [ $htmlWebRowsNew -lt $htmlWebRowsOld ]; then
	echo "WARNING: The new file $HTML_WEB_FILE has now a smaller size than its previous version."
elif [ $htmlWebRowsNew -eq $htmlWebRowsOld ]; then
	echo "NOTE: The new file $HTML_WEB_FILE has the same size as its previous version."
fi

if [ $htmlDeviceRowsNew -lt $htmlDevicesRowsOld ]; then
	echo "WARNING: The new file $HTML_DEVICE_FILE has now a smaller size than its previous version."
elif [ $htmlDeviceRowsNew -eq $htmlDevicesRowsOld ]; then
	echo "NOTE: The new file $HTML_DEVICE_FILE has the same size as its previous version."
fi

# Finish!
echo "✿✿✿✿ ʕ •ᴥ•ʔ/ ︻デ═一	csvToReadme.sh	TERMINATED !"

