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
# Version.............: 6.0.0
# Since...............: 18/08/2016
# Description.........: Process a file/an input (mainly in CSV format) to HTML with CSS if needed
#			This file must contain several columns: OS, Constructor, Name, Screen size, Sreen type, Screen reoslution, SoC, GPU, Sensors, Batery, Storage, RAM, Camera, Dimensions, Weight, IP, USB Type, SD Card, SIM
#
# Usage: sh csvToHtml_devices.sh --help
# Usage: cat myFileToProcess.csv | sh csvToHtml_devices.sh [ --fullHtml | --limitedHtml ] > myOutputFile.html
#


# ###### #
# CONFIG #
# ###### #

# HTML output for Readme.md Github's file or not ?
IS_HTML_LIMITED=false

# CSV separator...
CSV_SEPARATOR=';'

# Empty or useless rows
NUMBER_OF_LINES_TO_IGNORE=6

# Some CSS
CSS_STYLE="<style>
body {
	font-family: 'Roboto', sans-serif;
}
table, td, .header {
	border: 1px solid black;
	border-collapse: collapse;
	padding: 10px;
}
.header {
	background-color: #fafafa;
}
.pfOther {
	background-color: #9e9e9e;
}
.pfAndroid {
	background-color: #8bc34a;
}
.pfCyanogen {
	background-color: #00bcd4;
}
.pfOxygenOS {
	background-color: #009688;
}
.pfIOS {
	background-color: #f44336;
}
.pfWindows {
	background-color: #3f51b5;
}
.pfFirefoxOS {
	background-color: #ff9800;
}
.pfUbuntuTouch {
	background-color: #ffeb3b;
}
.pfTizen {
	background-color: #2196f3;
}
.pfFuschia {
	background-color: #e91e63;
}
.os, .constructor, .name, .screensize, .screentype, .screenresolution, .soc, .gpu, .sensors, .battery, .storage, .ram, .camera, .dimensions, .weight, .ip, .usbtype, .sdcard, .sim {
	text-align: center;
}
.url {
	color: #03a9f4;
}
</style>
"

# ######### #
# MAIN CODE #
# ######### #

# Check args: if --fullHtml option, use CSS ; if --limitedHTML option, do not use CSS ; if --help, display usage ; otherwise display usage
if [ "$#" -ne 1 ]; then
	echo "USAGE: cat myFileToProcess.csv | sh csvToHtml_tools.sh [ --fullHtml | --limitedHtml | --help ]"
	exit 0	
fi

if [ $1 ]; then
	if [ "$1" = "--fullHtml" ]; then
		IS_HTML_LIMITED=false		
	elif [ "$1" = "--limitedHtml" ]; then
		IS_HTML_LIMITED=true;
	elif [ "$1" = "--help" ]; then
		echo "USAGE: cat myFileToProcess.csv | sh csvToHtml_tools.sh [ --fullHtml | --limitedHtml | --help]"
		exit 0		
	else
		echo "USAGE: cat myFileToProcess.csv | sh csvToHtml_tools.sh [ --fullHtml | --limitedHtml | --help]"
		exit 0
	fi
fi

currentRowIndex=0;

# ***** Step 0 : Some CSS
if  ! $IS_HTML_LIMITED ; then
	echo $CSS_STYLE
fi


# ***** Step 1: Prepare the header of the output
echo "<table>"
	
# Proces each line of the input	
while read -r line; do

	# ***** Step 2: Ignore the useless rows
	if [ $currentRowIndex -lt $NUMBER_OF_LINES_TO_IGNORE ]
	then
		# Get the line of the document where the headers of the columns are
		if [ $currentRowIndex -eq $(($NUMBER_OF_LINES_TO_IGNORE - 1)) ]; then
			echo "\t<tr>"
			echo $line | sed 's/;/\n/g' | while read -r item; do
				echo "\t\t<td class=\"header\">" $item "</td>"
			done
			echo "\t</tr>"	
		fi
		currentRowIndex=$(($currentRowIndex + 1))
		continue
	fi
	
	# ***** Step 3: Prepare the header of the line
	echo "\t<tr>"
	
	# ***** Step 4: Split the line and replace ; by \n, and delete useless "
	fieldIndex=0;
	echo $line | sed 's/;/\n/g' | while read -r item; do
		cleanItem=`echo $item | sed 's/\"//g'`
		# Add an good CSS class
		case "$fieldIndex" in
			0)
				case "$cleanItem" in
					*Android*)
						echo "\t\t<td class=\"pfAndroid\">" $cleanItem "</td>"	
					;;
					*Cyanogen*)
						echo "\t\t<td class=\"pfCyanogen\">" $cleanItem "</td>"	
					;;
					*OxygenOS*)
						echo "\t\t<td class=\"pfOxygenOS\">" $cleanItem "</td>"	
					;;
					*iOS*)
						echo "\t\t<td class=\"pfIOS\">" $cleanItem "</td>"	
					;;
					*Windows*)
						echo "\t\t<td class=\"pfWindows\">" $cleanItem "</td>"	
					;;
					*FirefoxOS*)
						echo "\t\t<td class=\"pfFirefoxOS\">" $cleanItem "</td>"	
					;;
					*UbuntuTouch*)
						echo "\t\t<td class=\"pfUbuntuTouch\">" $cleanItem "</td>"	
					;;
					*Tizen*)
						echo "\t\t<td class=\"pfTizen\">" $cleanItem "</td>"	
					;;						
					*)
						echo "\t\t<td class=\"pfOther\">" $cleanItem "</td>"
					;;
				esac
				;;
			1)
				echo "\t\t<td class=\"constructor\">" $cleanItem "</td>"
				;;
			2)
				echo "\t\t<td class=\"name\">" $cleanItem "</td>"			
				;;
			3)
				echo "\t\t<td class=\"screensize\">" $cleanItem "</td>"			
				;;
			4)
				echo "\t\t<td class=\"screentype\">" $cleanItem "</td>"			
				;;
			5)
				echo "\t\t<td class=\"screenresolution\">" $cleanItem "</td>"			
				;;
			6)
				echo "\t\t<td class=\"soc\">" $cleanItem "</td>"			
				;;			
			7)
				echo "\t\t<td class=\"gpu\">" $cleanItem "</td>"			
				;;
			8)
				echo "\t\t<td class=\"sensors\">" $cleanItem "</td>"			
				;;
			9)
				echo "\t\t<td class=\"battery\">" $cleanItem "</td>"			
				;;
			10)
				echo "\t\t<td class=\"storage\">" $cleanItem "</td>"			
				;;
			11)
				echo "\t\t<td class=\"ram\">" $cleanItem "</td>"			
				;;												
			12)
				echo "\t\t<td class=\"camera\">" $cleanItem "</td>"			
				;;
			13)
				echo "\t\t<td class=\"dimensions\">" $cleanItem "</td>"			
				;;					
			14)
				echo "\t\t<td class=\"usbtype\">" $cleanItem "</td>"			
				;;				
			15)
				echo "\t\t<td class=\"weight\">" $cleanItem "</td>"			
				;;
			16)
				echo "\t\t<td class=\"ip\">" $cleanItem "</td>"			
				;;
			17)
				echo "\t\t<td class=\"sdcard\">" $cleanItem "</td>"			
				;;
			18)
				echo "\t\t<td class=\"sim\">" $cleanItem "</td>"			
				;;																	
		esac
		fieldIndex=$(($fieldIndex + 1))
	done
	
	# ***** Step 5: Prepare the footer of the line
	echo "\t</tr>"
	
done

# ***** Step 6: Prepare the footer of the output
echo "</table>"

