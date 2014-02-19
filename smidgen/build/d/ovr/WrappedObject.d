/**
*
* Authors: A Lynch, alynch4047@gmail.com
* Copyright: A Lynch, 2013
* License: GPL v2
*/

module ovr.WrappedObject;

public import smicommon.WrappedObjectBase;
import smicommon.created_by: CreatedBy, OwnedBy;

import core.memory;

import std.stdio: writeln, stdout;
import std.conv;
import std.string;
import std.array;
import std.algorithm: filter, count;




/**
* Get the D object that wraps wrappedObj. If there is no such wrapper
* yet instantiated, then instantiate one and use it to wrap the wrappedObj.
*
* Params:
* 	ownedBy.None = If not ownedBy.None then register the wrapped object so that in future
*                         we will return the same D wrapper for the same CPP object. 
*                         If it is None then a new D wrapper will be created
*                         next time, for the same CPP object.
*                         CPP objects on the heap (i.e. as we find with parameters
*                         of virtual method calls) must not be registered because the
*                         the address of the object on the stack is often quickly reused
*                         in later virtual calls. It is not (I believe) an issue that temporary 
*                         variables on the C++ stack might in theory have two different D wrappers.
*                         This is because they must have been created by C++ and therefore
*                         they are not subclassed in D (i.e. have no extra state other than that
*						  in the C++ object itself). It is possible that the client tries to use the
*                         the D wrapper in e.g. an associate array as a key. The client should
*                         <b>not</b> do this for objects passed in during a virtual method
*                         override. We could consider making the D hash value a function of
*                         the CPP object address, but this has its own potential pitfalls.
*
*   ownedBy =             If OwnedBy.D then delete the CPP object when the D object
*                         is destroyed. If not, then do not delete the CPP object
*                         on destruction. This flag is <b>only relevant here when instantiating
*                         a new wrapper</b> and should be set to OwnedBy.D when:
*                             - The client code creates a new D wrapper that creates a
*                               new CPP object
*                             - A D object wraps an object that was returned by value from
*                               another CPP wrapped object. This is because when value types
*                               are returned we use the C++ copy constructor to make a copy
*                               and pass a pointer to the copy back to D. D is then
*                               responsible for deleting this C++ copy.
*                         The flag should be set to OwnedBy.CPP when:
*                             - The D object is wrapping an CPP object that was returned
*                               by reference from another wrapped CPP object.
*                             - The D object wraps a CPP object that was returned by pointer
*                               from another wrapped CPP object and that does not fall under
*                               the TransferThis scenario    
*/
T getWrappedObject(T)(void* wrappedObj, bool registerNewWrappers=false,
	 OwnedBy ownedBy=OwnedBy.D) {
	
	debug { writeln("Get wrapped obj start %s %s ".format(T.stringof, wrappedObj)); stdout.flush(); }

	if (hasWrapper(wrappedObj)) {
		Object o = getWrapper(wrappedObj);
		debug { writeln("Cast to %s".format(T.stringof)); stdout.flush();}
		T obj = cast(T) o;
		if (obj is null) {
			writeln("Error: Cast returned null object: We expected a " ~ T.stringof ~ 
				" and this object (at %s) has previously been wrapped as %s".format(wrappedObj, o));
		} else {
			debug { writeln("Found wrapped obj created by %s".format(obj.createdBy)); }
			return obj;
		}	
	} else {
		debug { writeln("Did not find wrapped object...");}
	}
	debug { writeln("Get actual class name for descendent of " ~ T.stringof); stdout.flush();}
	
	string actualClassName = getClassName(T.stringof, wrappedObj);
	debug { writeln("Actual class name is ", actualClassName);}
	
	T wrapper;
	
	if (actualClassName.length > 0) {
		
		switch (actualClassName) {

			default:
				static if (__traits(isAbstractClass, T)) {
					throw new Exception("Dont know how to create a " ~ actualClassName 
						 ~ " and " ~ T.stringof ~ " is abstract");
				} else {
					debug {writeln("Did not find wrappedObj - wanted " 
						~ actualClassName ~ " and creating creating new " ~ T.stringof); }
					wrapper = new T(wrappedObj, CreatedBy.CPP, ownedBy);
					break;
				}
		}
	}
	else {
		debug { writeln("Did not find wrappedObj and don't know actual class name - creating new " ~ T.stringof);}
		static if (__traits(isAbstractClass, T)) {
			throw new Exception("Cannot instantiate the abstract class " ~ T.stringof);
		}
		else {
			debug { writeln("get wrapped obj G " ~ T.stringof); stdout.flush();}
			wrapper = new T(wrappedObj, CreatedBy.CPP, ownedBy);
		}
	}
	debug { writeln("Got wrapped obj H %s wrapper %s wrapper %s %s".format(T.stringof, wrappedObj, wrapper, wrapper.toHash())); stdout.flush();}
	
//	if (ownedBy != OwnedBy.None) {
//		registerWrappedObj(wrapper, wrappedObj);
//	}
	return wrapper;
}
