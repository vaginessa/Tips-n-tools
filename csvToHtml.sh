#!/bin/sh
#
# Process a file/an input (mainly in CSV format) to HTML with CSS
#
# Usage: cat myFileToProcess.csv | sh csvToHtml.sh > myOutputFile.html
#

# ###### #
# CONFIG #
# ###### #

CSV_SEPARATOR=';'

# Empty or useless rows
NUMBER_OF_LINES_TO_IGNORE=6


# ######### #
# MAIN CODE #
# ######### #

currentRowIndex=0;

# ***** Step 1: Prepare the header of the output

# Some CSS
echo "<style>
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

# The begin of the table
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

