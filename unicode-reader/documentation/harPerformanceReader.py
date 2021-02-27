# harPerformanceReader
#
# This imports a .har file (network capture), extracts the request URL and performance data
# (total times), and saves them to the system clipboard.
#
# Use
#	python ./harPerformanceReader.py .har [-quiet]
#
# Output:
#	[URL]\t[Time in milliseconds]\n
#
# Options:
#	-quiet   Prints times but not URLs
#
# Adam Leone
# 22 Feb 2021


import pyperclip
import sys
from pathlib import Path
import re


def validHARFile():

	if len(sys.argv) < 2:
		return False

	p = Path(sys.argv[1])
	return p.is_file()


def openHARFile():
	try:
		harFile = open(sys.argv[1], errors="ignore")
	except Exception as e:
		print ("Could not open .har file!")
		exit()

	return harFile


def getEventsList(harFile):

	harContents = harFile.read()

	eventRegEx = re.compile(r'''\"request\":{\"method\":\"GET\",\"url\":\"(.*?)\",\"httpVersion\"
			.*?
			\"timings\":{.*?,\"send\":(.*?),\"wait\":(.*?),\"receive\":(.*?)}
			''', re.VERBOSE)
	
	eventMatches = eventRegEx.findall(harContents)

	if (not eventMatches):
		print ("No matches")
		exit()

	else:
		return eventMatches


def formatResults(events):

	verbose = True;

	if (len(sys.argv) > 2 and sys.argv[2] == "-quiet"):
		verbose = False

	output = ""

	for e in events:

		if verbose:
			output += e[0] + "\t"

		totalTime = float(e[1]) + float(e[2]) + float(e[3])
		output += str(totalTime) + "\n"

	return output


def main ():

	if not validHARFile():
		print ("Invalid .har file!  Correct the path and .har filename.")
		exit()	 

	harFile = openHARFile();
	events = getEventsList(harFile)
	output = formatResults (events)

	pyperclip.copy(output)
	print ("Matches copied to clipboard")


# Start program from main method
if __name__ == "__main__":
	main()
