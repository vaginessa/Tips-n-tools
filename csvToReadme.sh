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
CSV_LIB_FILES="Tips-n-tools_Libraries.csv"
HTML_LIB_FILES="Tips-n-tools_Libraries.html"
CSV_WEB_FILES="Tips-n-tools_WebLinks.csv"
HTML_WEB_FILES="Tips-n-tools_WebLinks.html"

README_HEADER="# Tips'n'tools";

# ######### #
# MAIN CODE #
# ######### #

if [ "$#" -ne 0 ]; then
	echo "Usage: sh csvToReadme.sh"
	exit 0	
fi

echo "Write begin of readme file..."
echo $README_HEADER > $README_FILE

echo "Write HTML file from CSV about libraries..."
cat $CSV_LIB_FILES | sh csvToHtml.sh --limitedHtml > $HTML_LIB_FILES

echo "Write HTML file from CSV file about web links..."
cat $CSV_WEB_FILES | sh csvToHtml.sh --limitedHtml > $HTML_WEB_FILES

echo "Write README.md with HTML files' contents"
echo "\n\n" >> $README_FILE
echo "__" $CSV_LIB_FILES "__" >> $README_FILE
cat $HTML_LIB_FILES >> $README_FILE
echo "\n\n" >> $README_FILE
echo "__" $CSV_WEB_FILES "__" >> $README_FILE
cat $HTML_WEB_FILES >> $README_FILE

echo "Terminated ! ~=[,,_,,]:3"
