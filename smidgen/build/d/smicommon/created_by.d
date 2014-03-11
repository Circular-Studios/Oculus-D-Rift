

/**
* Make the D wrapper classes for C++ classes and enums.
*
* Authors: A Lynch, alynch4047@gmail.com
* Copyright: A Lynch, 2013
*/

module smicommon.created_by;

/**
* CreatedBy indicates whether the C++ wrapped object was initiated from D or C++
*/ 
enum CreatedBy {D, CPP};

/**
* OwnedBy indicates whether D or C++ is responsible for deleting the CPP object. If None
* then the object came through via a virtual call (e.g. is possibly on the stack) and
* we are not responsible for deleting it.
*/
enum OwnedBy {D, CPP, None};