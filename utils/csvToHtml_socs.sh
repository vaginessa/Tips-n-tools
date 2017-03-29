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
# Version.............: 3.0.0
# Since...............: 28/11/2016
# Description.........: Process a file/an input (mainly in CSV format) to HTML with CSS if needed
#			This file must contain several columns: Target, Constructor, Name, Gravure, Modem, Peak download speed, Peak upload speed, Bluetooth, NFC, USB, Camera support max., Video capture max., Video playback max., Display max., CPU, CPU cores number, CPU clock speed max., CPU architecture, GPU, GPU API support
#
# Usage: sh csvToHtml_socs.sh --help
# Usage: cat myFileToProcess.csv | sh csvToHtml_socs.sh [ --fullHtml | --limitedHtml ] > myOutputFile.html
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
.targetSmartphone {
	background-color: #000000;
	color: #ffffff;
}
.targetSmartphoneTablet {
	background-color: #4caf50;
	color: #ffffff;
}
.targetIphone {
	background-color: #9e9e9e;
	color: #ffffff;
}
.targetOther {
	background-color: #eeeeee;
	color: #000000
}
.constructorQualcomm {
	background-color: #f44336;
	color: #ffffff;
}
.constructorSamsung {
	background-color: #3f51b5;
	color: #ffffff;
}
.constructorApple {
	background-color: #ffeb3b;
	color: #000000;
}
.constructorMediaTek {
	background-color: #00bcd4;
	color: #ffffff;
}
.constructorHuawei {
	background-color: #d50000;
	color: #ffffff;
}
.constructorXiaomi {
	background-color: #ff9800;
	color: #000000;
}
.constructorOther {
	background-color: #eeeeee;
	color: #000000
}
.target, .constructor, .name, .gravure, .modem, .pds, .pus, .bluetoothn .nfc, .usb, .csm, .vcm, .vpm, .dm, .cpu, .cpucn, .cpua, .gpu, .gpuas  {
	text-align: center;
}
</style>
"

# ######### #
# MAIN CODE #
# ######### #

# Check args: if --fullHtml option, use CSS ; if --limitedHTML option, do not use CSS ; if --help, display usage ; otherwise display usage
if [ "$#" -ne 1 ]; then
	echo "USAGE: cat myFileToProcess.csv | sh csvToHtml_socs.sh [ --fullHtml | --limitedHtml | --help ]"
	exit 0	
fi

if [ $1 ]; then
	if [ "$1" = "--fullHtml" ]; then
		IS_HTML_LIMITED=false		
	elif [ "$1" = "--limitedHtml" ]; then
		IS_HTML_LIMITED=true;
	elif [ "$1" = "--help" ]; then
		echo "USAGE: cat myFileToProcess.csv | sh csvToHtml_socs.sh [ --fullHtml | --limitedHtml | --help]"
		exit 0		
	else
		echo "USAGE: cat myFileToProcess.csv | sh csvToHtml_socs.sh [ --fullHtml | --limitedHtml | --help]"
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
		# Add a good CSS class
		case "$fieldIndex" in
			0)
				case "$cleanItem" in
					*tablet*)
						echo "\t\t<td class=\"targetSmartphoneTablet\">" $cleanItem "</td>"	
					;;
					*smartphone*)
						echo "\t\t<td class=\"targetSmartphone\">" $cleanItem "</td>"	
					;;
					*iPhone*)
						echo "\t\t<td class=\"targetIphone\">" $cleanItem "</td>"	
					;;
					*)
						echo "\t\t<td class=\"targetOther\">" $cleanItem "</td>"	
					;;					
				esac
				;;
			1)
				case "$cleanItem" in
					*Qualcomm*)
						echo "\t\t<td class=\"constructorQualcomm\">" $cleanItem "</td>"	
					;;
					*Samsung*)
						echo "\t\t<td class=\"constructorSamsung\">" $cleanItem "</td>"	
					;;
					*Apple*)
						echo "\t\t<td class=\"constructorApple\">" $cleanItem "</td>"	
					;;
					*MediaTek*)
						echo "\t\t<td class=\"constructorMediaTek\">" $cleanItem "</td>"	
					;;
					*Huawei*)
						echo "\t\t<td class=\"constructorHuawei\">" $cleanItem "</td>"	
					;;
					*Xiaomi*)
						echo "\t\t<td class=\"constructorXiaomi\">" $cleanItem "</td>"	
					;;	
					*)
						echo "\t\t<td class=\"constructorOther\">" $cleanItem "</td>"
					;;
				esac
				;;
			2)
				echo "\t\t<td class=\"name\">" $cleanItem "</td>"
				;;
			3)
				echo "\t\t<td class=\"gravure\">" $cleanItem "</td>"
				;;
			4)
				echo "\t\t<td class=\"modem\">" $cleanItem "</td>"			
				;;
			5)
				echo "\t\t<td class=\"pds\">" $cleanItem "</td>"			
				;;
			6)
				echo "\t\t<td class=\"pus\">" $cleanItem "</td>"			
				;;
			7)
				echo "\t\t<td class=\"bluetooth\">" $cleanItem "</td>"			
				;;
			8)
				echo "\t\t<td class=\"nfc\">" $cleanItem "</td>"			
				;;			
			9)
				echo "\t\t<td class=\"usb\">" $cleanItem "</td>"			
				;;
			10)
				echo "\t\t<td class=\"csm\">" $cleanItem "</td>"			
				;;
			11)
				echo "\t\t<td class=\"vcm\">" $cleanItem "</td>"			
				;;
			12)
				echo "\t\t<td class=\"vpm\">" $cleanItem "</td>"			
				;;
			13)
				echo "\t\t<td class=\"dm\">" $cleanItem "</td>"			
				;;												
			14)
				echo "\t\t<td class=\"cpu\">" $cleanItem "</td>"			
				;;
			15)
				echo "\t\t<td class=\"cpucn\">" $cleanItem "</td>"			
				;;					
			16)
				echo "\t\t<td class=\"cpucsm\">" $cleanItem "</td>"			
				;;				
			17)
				echo "\t\t<td class=\"cpua\">" $cleanItem "</td>"			
				;;
			18)
				echo "\t\t<td class=\"gpu\">" $cleanItem "</td>"			
				;;	
			19)
				echo "\t\t<td class=\"gpuas\">" $cleanItem "</td>"			
				;;															
		esac
		fieldIndex=$(($fieldIndex + 1))
	done
	
	# ***** Step 5: Prepare the footer of the line
	echo "\t</tr>"
	
done

# ***** Step 6: Prepare the footer of the output
echo "</table>"

