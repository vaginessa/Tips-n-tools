#!/bin/sh
#
# Process a file/an input (mainly in CSV format) to HTML with CSS if needed
#
# Usage: cat myFileToProcess.csv | sh csvToHtml.sh > myOutputFile.html
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
table, th, td {
	border: 1px solid black;
	border-collapse: collapse;
	padding: 10px;
}
th {
	background-color: #fafafa;
}
.pfOther {
	background-color: #795548;
}
.pfAndroid {
	background-color: #8bc34a;
}
.pfDesign {
	background-color: #2196f3;
}
.pfJavaScript {
	background-color: #ffeb3b;
}
.pfJava {
	background-color: #ff5722;
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
	echo "Usage: sh csvToHtml.sh [ --fullHtml | --limitedHtml | --help ]"
	exit 0	
fi

if [ $1 ]; then
	if [ "$1" = "--fullHtml" ]; then
		IS_HTML_LIMITED=false		
	elif [ "$1" = "--limitedHtml" ]; then
		IS_HTML_LIMITED=true;
	elif [ "$1" = "--help" ]; then
		echo "Usage: sh csvToHtml.sh [ --fullHtml | --limitedHtml | --help]"
		exit 0		
	else
		echo "Usage: sh csvToHtml.sh [ --fullHtml | --limitedHtml | --help]"
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
					*Design*)
						echo "\t\t<td class=\"pfDesign\">" $cleanItem "</td>"	
					;;
					*Java*)
						echo "\t\t<td class=\"pfJava\">" $cleanItem "</td>"	
					;;
					*JS*)
						echo "\t\t<td class=\"pfJavaScript\">" $cleanItem "</td>"	
					;;
					*)
						echo "\t\t<td class=\"pfOther\">" $cleanItem "</td>"
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

