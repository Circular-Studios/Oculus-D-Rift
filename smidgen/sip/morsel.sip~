
// Top level sip file that declares all the modules

%Include morsel_linux_x86_64.conf

%Converter ppchar.converter

%ConvertersDHeaderCode
import std.string: toStringz;
import std.conv: to;
string CToDString(char* cstring) {
	return to!string(cstring);
}
%End

%GetClassNameCCode
#include <shape.h>

extern "C" const char* getClassNameC(char* baseClassName, void* wrappedObject) {
	Base* obj = (Base*) wrappedObject;
	switch (obj->getClassId()) {
		case 1:
			return "Shape";
        case 2:
        	return "Rect";
        case 3:
        	return "Point";  
        case 4:
        	return "Polygon";    
        case 5:
        	return "Widget";
        case 6:
        	return "RectWidget";    
        case 7:
            return "Point.Place";           	       	           	      	      	
        default:
            return "MorselUnknownClass";
     }
}
%End

%Include morselcore/morselcore_mod.sip
%Include morselwidget/morselwidget_mod.sip
