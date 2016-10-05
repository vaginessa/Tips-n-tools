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
# Version.............: 2.0.0
# Since...............: 05/10/2016
# Description.........: Provides some features about this update/technical watch/... project: find some eleemnts or build HTML files from CSV files to update another file
#
# Usage: sh tipsntools.sh {--help | --update | --find yourRegexp}
#


# ############# #
# CONFIGURATION #
# ############# #

# Some configuration things
UTILS_FOLDER="utils"
CSV2README_SCRIPT="csvToReadme.sh"

# The folders and files about the libraries and tools
TOOLS_DIR="toolz"
CSV_TOOLS_FILE="$TOOLS_DIR/Tips-n-tools_Tools.csv"

# The folder and files about some publications, articles, blogs...
WEB_DIR="webz"
CSV_WEBS_FILE="$WEB_DIR/Tips-n-tools_WebLinks.csv"

# The folder and files about the devices (smartphones, phablets, tablets, wearables, smartwatches...)
DEVICE_DIR="devz"
CSV_DEVICES_FILE="$DEVICE_DIR/Tips-n-tools_Devices.csv"


# ######### #
# FUNCTIONS #
# ######### #

# \fn usageAndExit
# \brief Displays the usage and exits
usageAndExit(){
	echo "USAGE: sh tipsntools.sh {--help | --update | --find yourRegexp}"
	echo "\t --help             : displays the help, i.e. this usage."
	echo "\t --update           : updates the defined result file with HTML files built thanks to CSV files and scripts in .utils/ folder"
	echo "\t --find yourRegexp  : finds in all the CSV source files the rows wich contain elements matching yourRegexp"
	exit 0	
}

# \fn update
# \brief Updates the result file with HTML files built with CSV soruce files
update(){
	echo "Update the result file..."
	cd $UTILS_FOLDER
	sh $CSV2README_SCRIPT
	cd ..
}

# \fn findInFiles
# \param regexp - The regex to use
# \brief Finds in CSV source files some items
findInFiles(){

	echo "Finds in CSV files the items which match $1..."
	regex=$1
	
	# The tools file
	findInCsvFile $CSV_TOOLS_FILE $regex
	
	# The web things file
	findInCsvFile $CSV_WEBS_FILE $regex
	
	# The devices file
	findInCsvFile $CSV_DEVICES_FILE $regex
	
	echo "End of search."
}

# \fn findInFile
# \param file - The file to use
# \param regex - The regex to use
# \brief Find a dedicated CSV file items wich match the regex
findInCsvFile(){
	file=$1
	regex=$2
	echo "-----> Finding '$regex' in $file..."
	cat $file | while read -r line; do
		case "$line" in
			*$regex*)
				echo $line | sed 's/;/\n/g' | while read -r item; do
					if [ "$item" = "" ]; then
						echo "\t <null>"
					else
						echo "\t" $item
					fi
				done
				echo "\n"
			;;
			*)
			;;
		esac
	done
}


# ######### #
# MAIN CODE #
# ######### #

# Check the args and display usage if needed
if [ "$#" -lt 1 -o "$#" -gt 2 ]; then
	usageAndExit
fi

# Check id the directories containing the data and the script exist
if [ ! -d "$UTILS_FOLDER" ]; then
	echo "ERROR: Directory '$UTILS_FOLDER' does not exists. Exit now."
	exit 1
fi

if [ ! -d "$TOOLS_DIR" ]; then
	echo "ERROR: Directory '$TOOLS_DIR' does not exists. Exit now."
	exit 1
fi

if [ ! -d "$WEB_DIR" ]; then
	echo "ERROR: Directory '$WEB_DIR' does not exists. Exit now."
	exit 1
fi

if [ ! -d "$DEVICE_DIR" ]; then
	echo "ERROR: Directory '$DEVICE_DIR' does not exists. Exit now."
	exit 1
fi

# Check if all the files to use exist
if [ ! -e "$CSV_TOOLS_FILE" ]; then
	echo "ERROR: The file '$CSV_TOOLS_FILE' does not exist. Exit now."
	exit 1;
fi

if [ ! -e "$CSV_WEBS_FILE" ]; then
	echo "ERROR: The file '$CSV_WEBS_FILE' does not exist. Exit now."
	exit 1;
fi

if [ ! -e "$CSV_DEVICES_FILE" ]; then
	echo "ERROR: The file '$CSV_DEVICES_FILE' does not exist. Exit now."
	exit 1;
fi

if [ ! -e "$UTILS_FOLDER/$CSV2README_SCRIPT" ]; then
	echo "ERROR: The script '$UTILS_FOLDER/$CSV2README_SCRIPT' does not exist. Exit now."
	exit 1;
fi

# Let's work !
if [ $1 ]; then
	# Update the README.md file?
	if [ "$1" = "--update" ]; then
		if [ "$#" -ne 1 ]; then
			usageAndExit
		else
			update	
		fi
	# Find some data?
	elif [ "$1" = "--find" ]; then
		if [ "$2" ]; then
			regexp="$2"
			findInFiles $regexp 
		else
			usageAndExit
		fi
	# Need some help?
	elif [ "$1" = "--help" ]; then
		usageAndExit
	# Stop jumping on your keaboard...	
	else
		usageAndExit
	fi
else
	usageAndExit
fi

echo "\n\n✿✿✿✿ ʕ •ᴥ•ʔ/ ︻デ═一	tipsntools.sh	TERMINATED !"


