#!/bin/sh
#
# Parses the CSV files (previously generated from the ODS file) to HTML files,
# and concatenate them to the README.md file
#
# Usage: sh csvToReadme.sh
#

# ###### #
# CONFIG #
# ###### #

README_FILE="README.md"

CSV_LIB_FILE="Tips-n-tools_Libraries.csv"
CSV_LIB_FILE_USELESS_ROWS=6
HTML_LIB_FILE="Tips-n-tools_Libraries.html"

CSV_WEB_FILE="Tips-n-tools_WebLinks.csv"
CSV_WEB_FILE_USELESS_ROWS=6
HTML_WEB_FILE="Tips-n-tools_WebLinks.html"

README_HEADER="# Tips'n'tools";


# ######### #
# MAIN CODE #
# ######### #

# Check the args
if [ "$#" -ne 0 ]; then
	echo "Usage: sh csvToReadme.sh"
	exit 0	
fi

# Update the README_FILE file
echo "Write begin of readme file..."
echo $README_HEADER > $README_FILE

echo "Write HTML file from CSV about libraries..."
cat $CSV_LIB_FILE | sh csvToHtml.sh --limitedHtml > $HTML_LIB_FILE

echo "Write HTML file from CSV file about web links..."
cat $CSV_WEB_FILE | sh csvToHtml.sh --limitedHtml > $HTML_WEB_FILE

echo "Write README.md with HTML files' contents"
echo "\n\n" >> $README_FILE
echo "__" $CSV_LIB_FILE "__" >> $README_FILE
cat $HTML_LIB_FILE >> $README_FILE
echo "\n\n" >> $README_FILE
echo "__" $CSV_WEB_FILE "__" >> $README_FILE
cat $HTML_WEB_FILE >> $README_FILE

# Some stats about the number of fields
csvLibsRows=`cat $CSV_LIB_FILE | wc -l`
csvWebRows=`cat $CSV_WEB_FILE | wc -l`
csvLibsRowsCleaned=$(($csvLibsRows - $CSV_LIB_FILE_USELESS_ROWS))
csvWebRowsCleaned=$(($csvWebRows - $CSV_WEB_FILE_USELESS_ROWS))

echo "Now we have $csvLibsRowsCleaned items in $CSV_LIB_FILE"
echo "Now we have $csvWebRowsCleaned items in $CSV_WEB_FILE"

# Finish!
echo "Terminated ! ~=[,,_,,]:3"

