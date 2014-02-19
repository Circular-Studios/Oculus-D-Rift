
/*
* This module will be imported by all D wrapper modules in the package.
*/ 

module ovr.package_globals;


// Typedefs header code

// End Typedefs header code

// Converters header code
import std.string: toStringz;
import std.conv: to;
string CToDString(char* cstring) {
	return to!string(cstring);
}

// End converters header code
