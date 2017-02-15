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
# Version.............: 14.0.0
# Since...............: 21/06/2016
# Description.........: Process a file/an input (mainly in CSV format) to HTML with CSS if needed.
#			This file must contain several columns: Plateform, Name, Description, Keywords, URL
#
# Usage: sh csvToHtml_tools.sh --help
# Usage: cat myFileToProcess.csv | sh csvToHtml_tools.sh [ --fullHtml | --limitedHtml ] > myOutputFile.html
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
.subjectOther {
	background-color: #9e9e9e;
}
.subjectAndroid {
	background-color: #8bc34a;
}
.subjectDesign {
	background-color: #e91e63;
}
.subjectJavaScript {
	background-color: #ffeb3b;
}
.subjectJava {
	background-color: #ff9800;
}
.subjectKotlin {
	background-color: #3f51b5;
}
.subjectWeb {
	background-color: #795548;
}
.subjectSwift {
	background-color: #ff5722;
}
.subjectGo {
	background-color: #2196f3;
}
.subjectScala {
	background-color: #f44336;
}
.subjectGroovy {
	background-color: #bbdefb;
}
.subjectPython {
	background-color: #1565c0;
}
.subjectDevTool {
	background-color: #000000;
	color: #ffffff;
	border: 1px solid #ffffff; 
}
.subjectBots {
	background-color: #000000;
	color: #ff0000;
	border: 1px solid #ffffff; 
}
.subjectRust {
	background-color: #424242;
	color: #ffffff;
}
.subjectDart {
	background-color: #64ffda;
	color: #000000;
}
.name {
	text-align: center;
}
.url {
	color: #03a9f4;
}
.keywords {
	font-style: italic;
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
						echo "\t\t<td class=\"subjectAndroid\">" $cleanItem "</td>"	
					;;
					*Design*)
						echo "\t\t<td class=\"subjectDesign\">" $cleanItem "</td>"	
					;;
					*JavaScript*)
						echo "\t\t<td class=\"subjectJavaScript\">" $cleanItem "</td>"	
					;;
					*Java*)
						echo "\t\t<td class=\"subjectJava\">" $cleanItem "</td>"	
					;;
					*Kotlin*)
						echo "\t\t<td class=\"subjectKotlin\">" $cleanItem "</td>"	
					;;
					*Web*)
						echo "\t\t<td class=\"subjectWeb\">" $cleanItem "</td>"	
					;;
					*Swift*)
						echo "\t\t<td class=\"subjectSwift\">" $cleanItem "</td>"	
					;;
					*Go*)
						echo "\t\t<td class=\"subjectGo\">" $cleanItem "</td>"	
					;;
					*Scala*)
						echo "\t\t<td class=\"subjectScala\">" $cleanItem "</td>"	
					;;
					*Groovy*)
						echo "\t\t<td class=\"subjectGroovy\">" $cleanItem "</td>"	
					;;
					*Python*)
						echo "\t\t<td class=\"subjectPython\">" $cleanItem "</td>"	
					;;
					*DevTool*)
						echo "\t\t<td class=\"subjectDevTool\">" $cleanItem "</td>"
					;;
					*Bots*)
						echo "\t\t<td class=\"subjectBots\">" $cleanItem "</td>"
					;;	
					*Rust*)
						echo "\t\t<td class=\"subjectRust\">" $cleanItem "</td>"
					;;
					*Dart*)
						echo "\t\t<td class=\"subjectDart\">" $cleanItem "</td>"
					;;
					*)
						echo "\t\t<td class=\"subjectOther\">" $cleanItem "</td>"
					;;
				esac
				;;
			1)
				echo "\t\t<td class=\"name\">" $cleanItem "</td>"
				;;
			2)
				echo "\t\t<td class=\"description\">" $cleanItem "</td>"			
				;;
			3)
				echo "\t\t<td class=\"keywords\">" $cleanItem "</td>"			
				;;
			4)
				echo "\t\t<td class=\"url\">" $cleanItem "</td>"			
				;;
		esac
		fieldIndex=$(($fieldIndex + 1))
	done
	
	# ***** Step 5: Prepare the footer of the line
	echo "\t</tr>"
	
done

# ***** Step 6: Prepare the footer of the output
echo "</table>"

