
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

%Include ovr/ovr_mod.sip

