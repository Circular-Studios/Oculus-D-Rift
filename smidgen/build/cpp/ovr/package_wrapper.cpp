#include <instance_tracker.h>

// Headers for converters

#include <string>
using namespace std;
// Converter functions
int convertPPCharToInt(char** toConvert) {
	return 0;
 }

char** convertIntToPPChar(int toConvert) {
	return (char**) 0;
}

char* convertCStringToPChar(string toConvert) {
			return (char*) toConvert.c_str();
   		 }

string convertPCharToCString(char* toConvert) {
			return *(new string(toConvert));
		}

char* convertPCharToPChar(char* toConvert) {
			return toConvert;
   		 }

char* convertPCharToPCharArgument(char* toConvert) {
			return toConvert;
   		 }

