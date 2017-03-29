#!/bin/sh
#
#    MIT License
#    Copyright (c) 2016-2017 Pierre-Yves Lapersonne (Twitter: @pylapp, Mail: pylapp(dot)pylapp(at)gmail(dot)com)
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
# Version.............: 7.0.0
# Since...............: 05/10/2016
# Description.........: Provides some features about this update/technical watch/... project: find some elements or build HTML files from CSV files to update another file
#
# Usage: sh tipsntools.sh {--help | --count | --md5 | --update | {--findAll | --findWeb | --findTools | --findDevices | --findSocs} yourRegexp}
# Usage: sh tipsntools.sh {-h | -c | -m | -u | {-a | -w | -t | -d | -s} yourRegexp}
#


# ############# #
# CONFIGURATION #
# ############# #

# Some configuration things
UTILS_DIR="utils"
CSV2README_SCRIPT="csvToReadme.sh"
CSV2HTMLDEVICES_SCRIPT="csvToHtml_devices.sh"
CSV2HTMLTOOLS_SCRIPT="csvToHtml_tools.sh"
CSV2HTMLSOCS_SCRIPT="csvToHtml_socs.sh"

# The folders and files about the libraries and tools
TOOLS_DIR="toolz"
CSV_TOOLS_FILE="$TOOLS_DIR/Tips-n-tools_Tools.csv"

# The folder and files about some publications, articles, blogs...
WEB_DIR="webz"
CSV_WEBS_FILE="$WEB_DIR/Tips-n-tools_WebLinks.csv"

# The folder and files about the devices (smartphones, phablets, tablets, wearables, smartwatches...)
DEVICE_DIR="devz"
CSV_DEVICES_FILE="$DEVICE_DIR/Tips-n-tools_Devices.csv"

# The folder and files about the SoC
SOC_DIR="socz"
CSV_SOC_FILE="$SOC_DIR/Tips-n-tools_SoC.csv"


# ######### #
# FUNCTIONS #
# ######### #

# \fn fUsageAndExit
# \brief Displays the usage and exits
fUsageAndExit(){
	echo "USAGE:"
	echo "sh tipsntools.sh {--help | --count | --md5 | --update | {--findAll | --findWeb | --findTools | --findDevices | --findSocs} yourRegexp}"
	echo "sh tipsntools.sh {-h | -c | -m | -u | {-a | -w | -t | -d | -s} yourRegexp}"
	echo "\t --help	....................: displays the help, i.e. this usage."
	echo "\t -h ........................: displays the help, i.e. this usage."
	echo "\t --count....................: count the number of items"
	echo "\t -c ........................: count the number of items"
	echo "\t --md5......................: compute the MD5 checksum"
	echo "\t -m ........................: compute the MD5 checksum"	
	echo "\t --update ..................: updates the defined result file with HTML files built thanks to CSV files and scripts in .utils/ folder"
	echo "\t -u ........................: updates the defined result file with HTML files built thanks to CSV files and scripts in .utils/ folder"
	echo "\t --findAll yourRegexp.......: finds in all the CSV source files the rows which contain elements matching yourRegexp"
	echo "\t -a yourRegexp..............: finds in all the CSV source files the rows which contain elements matching yourRegexp"
	echo "\t --findWeb yourRegexp.......: finds in the web links CSV source file the rows which contain elements matching yourRegexp"	
	echo "\t -w yourRegexp..............: finds in the web links CSV source file the rows which contain elements matching yourRegexp"	
	echo "\t --findTools yourRegexp.....: finds in the tools CSV source file the rows which contain elements matching yourRegexp"
	echo "\t -t yourRegexp..............: finds in the tools CSV source file the rows which contain elements matching yourRegexp"
	echo "\t --findDevices yourRegexp...: finds in the devices CSV source file the rows which contain elements matching yourRegexp"
	echo "\t -d yourRegexp..............: finds in the devices CSV source file the rows which contain elements matching yourRegexp"
	echo "\t --findSocs yourRegexp......: finds in the SoC CSV source file the rows which contain elements matching yourRegexp"
	echo "\t -s yourRegexp..............: finds in the devices CSV source file the rows which contain elements matching yourRegexp"	
	exit 0	
}

# \fn fUpdate
# \brief Updates the result file with HTML files built with CSV soruce files
fUpdate(){
	echo "******************************"
	echo "* Updating destination file..."
	echo "******************************"	
	cd $UTILS_DIR
	sh $CSV2README_SCRIPT
	cd ..
}

# \fn errBadCommand
# \brief Displays an error message saying there is a bad command
errBadCommand(){
	echo "ERROR: Bad command, see help to use the script."
}

# \fn errBadCommandAndExit
# \brief Displays an error message saying there is a bad command and exists
errBadCommandandExit(){
	errBadCommand
	exit 1
}

# \fn errBadDirectory
# \param directory - The missing/bad directory
# \brief Displays an error message saying there is a bad/unexisting directory and exits
errBadDirectory(){
	echo "ERROR: The directory '$1' does not exist."
	exit 1
}

# \fn errBadFile
# \param file - The missing/bad file
# \brief Displays an error message saying there is a bad/unexisting file and exits
errBadFile(){
	echo "ERROR: The file '$1' does not exist."
	exit 1
}

# \fn fFindInAllFiles
# \param regexp - The regex to use
# \brief Finds in CSV source files some items
fFindInAllFiles(){
	echo "****************************"
	echo "* Find in all files for '$1'..."
	echo "****************************"	
	regex=$1
	# The tools file
	fFindInCsvFile $CSV_TOOLS_FILE $regex
	# The web things file
	fFindInCsvFile $CSV_WEBS_FILE $regex
	# The devices file
	fFindInCsvFile $CSV_DEVICES_FILE $regex
	# The SoC file
	fFindInCsvFile $CSV_SOC_FILE $regex	
	echo "End of search."
}

# \fn fFindInCsvFile
# \param file - The file to use
# \param regex - The regex to use
# \brief Find a dedicated CSV file items wich match the regex
fFindInCsvFile(){
	echo "****************************"
	echo "* Find in '$1' for '$2'..."
	echo "****************************"	
	file=$1
	regex=$2
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

# \fn fMd5sum
# \brief Make an MD5 checksum for each file and display them in the standard ouput
fMd5sum(){
	echo "******************"
	echo "* MD5 checksums..."
	echo "******************"
	# Utils folder...
	echo "\\tMD5 checksum for .sh files:\\n`md5sum */*.sh`"
	# CSV files
	echo "\\tMD5 checksum for .csv files:\\n`md5sum */*.csv`"
	# HTML files
	echo "\\tMD5 checksum for .html files:\\n`md5sum */*.html`"
	# Main script, readme file and sheet file
	echo "\\tMD5 checksum for main files:\\n`md5sum *.*`"
}

# \fn fCountItems
# \brief Computes the number of items listed in each file
fCountItems(){
	TOOLS_DIR="toolz"
	CSV_TOOLS_FILE="$TOOLS_DIR/Tips-n-tools_Tools.csv"
	CSV_TOOLS_FILE_USELESS_ROWS=6
	HTML_TOOLS_FILE="$TOOLS_DIR/Tips-n-tools_Tools.html"
	WEB_DIR="webz"
	CSV_WEB_FILE="$WEB_DIR/Tips-n-tools_WebLinks.csv"
	CSV_WEB_FILE_USELESS_ROWS=6
	HTML_WEB_FILE="$WEB_DIR/Tips-n-tools_WebLinks.html"
	DEVICE_DIR="devz"
	CSV_DEVICE_FILE="$DEVICE_DIR/Tips-n-tools_Devices.csv"
	CSV_DEVICE_FILE_USELESS_ROWS=6
	HTML_DEVICE_FILE="$DEVICE_DIR/Tips-n-tools_Devices.html"
	SOC_DIR="socz"
	CSV_SOC_FILE="$SOC_DIR/Tips-n-tools_SoC.csv"
	CSV_SOC_FILE_USELESS_ROWS=6
	HTML_SOC_FILE="$SOC_DIR/Tips-n-tools_SoC.html"
	csvToolsRows=`cat $CSV_TOOLS_FILE | wc -l`
	csvWebRows=`cat $CSV_WEB_FILE | wc -l`
	csvDevicesRows=`cat $CSV_DEVICE_FILE | wc -l`
	csvSocsRows=`cat $CSV_SOC_FILE | wc -l`
	csvToolsRowsCleaned=$(($csvToolsRows - $CSV_TOOLS_FILE_USELESS_ROWS))
	csvWebRowsCleaned=$(($csvWebRows - $CSV_WEB_FILE_USELESS_ROWS))
	csvDevicesRowsCleaned=$(($csvDevicesRows - $CSV_DEVICE_FILE_USELESS_ROWS))
	csvSocsRowsCleaned=$(($csvSocsRows - $CSV_SOC_FILE_USELESS_ROWS))
	htmlToolsRowsNew=`cat $HTML_TOOLS_FILE | wc -l`
	htmlWebRowsNew=`cat $HTML_WEB_FILE | wc -l`
	htmlDevicesRowsNew=`cat $HTML_DEVICE_FILE | wc -l`
	htmlSocsRowsNew=`cat $HTML_SOC_FILE | wc -l`
	echo "Items as TOOLS..........: $csvToolsRowsCleaned items in $CSV_TOOLS_FILE"
	echo "Items as WEB THINGS.....: $csvWebRowsCleaned items in $CSV_WEB_FILE"
	echo "Items in DEVICES........: $csvDevicesRowsCleaned items in $CSV_DEVICE_FILE"
	echo "Items in SoC............: $csvSocsRowsCleaned items in $CSV_SOC_FILE"
}


# ######### #
# MAIN CODE #
# ######### #

# Check the args and display usage if needed
if [ "$#" -lt 1 -o "$#" -gt 2 ]; then
	fUsageAndExit
fi

# Check id the directories containing the data and the script exist
if [ ! -d "$UTILS_DIR" ]; then
	errBadDirectory $UTILS_DIR
fi

if [ ! -d "$TOOLS_DIR" ]; then
	errBadDirectory $TOOLS_DIR
fi

if [ ! -d "$WEB_DIR" ]; then
	errBadDirectory $WEB_DIR
fi

if [ ! -d "$DEVICE_DIR" ]; then
	errBadDirectory $DEVICE_DIR	
fi

if [ ! -d "$SOC_DIR" ]; then
	errBadDirectory $SOC_DIR	
fi

# Check if all the files to use exist
if [ ! -e "$CSV_TOOLS_FILE" ]; then
	errBadFile $CSV_TOOLS_FILE	
fi

if [ ! -e "$CSV_WEBS_FILE" ]; then
	errBadFile $CSV_WEBS_FILE	
fi

if [ ! -e "$CSV_DEVICES_FILE" ]; then
	errBadFile $CSV_DEVICES_FILE	
fi

if [ ! -e "$CSV_SOC_FILE" ]; then
	errBadFile $CSV_SOC_FILE	
fi

if [ ! -e "$UTILS_DIR/$CSV2README_SCRIPT" ]; then
	errBadFile "$UTILS_DIR/$CSV2README_SCRIPT"
fi

# Let's work !
if [ $1 ]; then
	# Update the README.md file?
	if [ "$1" = "--update" -o "$1" = "-u" ]; then
		if [ "$#" -ne 1 ]; then
			errBadCommand
			fUsageAndExit
		else		
			fUpdate
			fMd5sum	
		fi
	# Find some data in all files?
	elif [ "$1" = "--findAll" -o "$1" = "-a" ]; then
		if [ "$2" ]; then
			regexp="$2"
			fFindInAllFiles $regexp 
		else
			errBadCommand		
			fUsageAndExit
		fi
	# Find some data in web file?		
	elif [ "$1" = "--findWeb" -o "$1" = "-w" ]; then
		if [ "$2" ]; then
			regexp="$2"
			fFindInCsvFile $CSV_WEBS_FILE $regexp
		else
			errBadCommand		
			fUsageAndExit
		fi
	# Find some data in the tools file?
	elif [ "$1" = "--findTools" -o "$1" = "-t" ]; then
		if [ "$2" ]; then
			regexp="$2"				
			fFindInCsvFile $CSV_TOOLS_FILE $regexp
		else
			errBadCommand		
			fUsageAndExit
		fi		
	# Find some data in devices file?		
	elif [ "$1" = "--findDevices" -o "$1" = "-d" ]; then
		if [ "$2" ]; then
			regexp="$2"			
			fFindInCsvFile $CSV_DEVICES_FILE $regexp
		else
			errBadCommand		
			fUsageAndExit
		fi
	# Find some data in SoC file?		
	elif [ "$1" = "--findSocs" -o "$1" = "-s" ]; then
		if [ "$2" ]; then
			regexp="$2"			
			fFindInCsvFile $CSV_SOC_FILE $regexp
		else
			errBadCommand		
			fUsageAndExit
		fi							
	# Need some help?
	elif [ "$1" = "--help" -o "$1" = "-h" ]; then
		fUsageAndExit
	# Compute MD5 checksums
	elif [ "$1" = "--md5" -o "$1" = "-m" ]; then
		if [ "$#" -ne 1 ]; then
			errBadCommand		
			fUsageAndExit
		else
			fMd5sum		
		fi		
	# Compute the number of items in each file
	elif [ "$1" = "--count" -o "$1" = "-c" ]; then
		if [ "$#" -ne 1 ]; then
			errBadCommand		
			fUsageAndExit
		else
			fCountItems
		fi				
	# Stop jumping on your keyboard...	
	else
		errBadCommand	
		fUsageAndExit
	fi
else
	fUsageAndExit
fi

echo "✿✿✿✿ ʕ •ᴥ•ʔ/ ︻デ═一	tipsntools.sh	TERMINATED !"


