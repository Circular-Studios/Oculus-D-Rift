/**
*
* Authors: A Lynch, alynch4047@gmail.com
* Copyright: A Lynch, 2013
* License: GPL v2
*/

module smicommon.WrappedObjectBase;

import smicommon.created_by: CreatedBy, OwnedBy;

import core.memory;

import std.stdio: writeln, stdout;
import std.conv;
import std.string;
import std.array;
import std.algorithm: filter, count;

extern (C) char* getClassNameC(char* baseClassName, void* wrappedObject);

/**
* Get the specific CPP type for an object of the given base type
*/ 
string getClassName(string baseClassName, void* wrappedObj) {
	char* baseClassNameZ = cast(char*) baseClassName.toStringz();
	return to!string(getClassNameC(baseClassNameZ, wrappedObj));
}

static if (true) {
	// Check that the mapping of pointer to ulong is valid on this platform
	alias void* pvoid;
	static assert(ulong.sizeof == pvoid.sizeof);
}

// Object[void*]
/**
* The registry of wrapped objects.
* We use ulong here to avoid the garbage collector knowing that these are pointers.
* We also have to munge the points (using ~) to fool the GC.
*/
static ulong[ulong] wrappedObjectsToDWrapper;

/**
* Return the number of wrapped objects - only used in tests
*/ 
size_t getNumWrappedObjects() {
	return wrappedObjectsToDWrapper.values.filter!(a => a != 0).count;
}

ulong makeHiddenAddress(Object dObj) {
	void* address = cast(void*) dObj;
	return ~ (cast(ulong) address) ;
}

Object getObject(ulong hiddenAddress) {
	void* objPointer = cast(void*) (~hiddenAddress);
	return cast(Object) objPointer;
}

/**
* Maintain the lookup from CPP object to its D wrapper
*/ 
void registerWrappedObj(Object dObj, void* wrappedObj) {
	debug { 
		writeln("Register wrapped obj CPP %x D %s &D wrapper %x ".format(wrappedObj, dObj, cast(void*) dObj)); stdout.flush();
		foreach (key, ref val; wrappedObjectsToDWrapper) {
			if (val == cast(ulong) (cast(void*) dObj)) {
				throw new Exception("That D object already wraps CPP %x!".format(key));
			}
		}
	}

	wrappedObjectsToDWrapper[cast(ulong) wrappedObj] = makeHiddenAddress(dObj);
}

/**
* Get the D wrapper for the given CPP object address
*/
Object getWrapper(void* wrappedObj) {
//	debug { writeln("getWrapper for CPP %x".format(wrappedObj)); stdout.flush();}
	Object obj = getObject(wrappedObjectsToDWrapper[cast(ulong) wrappedObj]);
//	debug { writeln("wrapper is %s, %x".format(obj, cast(void*) obj)); stdout.flush();}
	return obj;
}

/**
* Return if there is a known D wrapper for this CPP object
*/ 
bool hasWrapper(void* wrappedObj) {
	bool res = ((cast(ulong) (cast(void*) wrappedObj)) in wrappedObjectsToDWrapper) != null;
	if (res) {
		if (wrappedObjectsToDWrapper[cast (ulong) wrappedObj] == 0) {
			wrappedObjectsToDWrapper.remove(cast(ulong) wrappedObj);
			res = false;
		}
	}	
	debug { writeln("Has wrapper %s".format(res)); stdout.flush();}
	return res;
}

/**
* Remove this wrappedObject and its wrapped from the wrapped object registry. 
* deregisterWrappedObj is called from the D destructor so we must be careful
* not to trigger a reentrant call to the GC. 
*/
void deregisterWrappedObj(void* wrappedObj) {
	if (WrappedObject.getSystemExiting) return;
	debug { writeln("remove wrappedobj from D registry");stdout.flush();}
	wrappedObjectsToDWrapper[cast(ulong) (cast(void*) wrappedObj)] = 0;
		// we can't remove it here if called from gc because removing from
		// an AA triggers a gc and gc is not reenterable
//		wrappedObjectsToDWrapper.remove(wrappedObj);
}
 
/**
* Objects that support this interface can access CPP functions that cast from
* a type to a multiply-inherited base type (which is coded as an interface in D)
*/ 
interface CastPointerProvider {
	void* getCastPointerForInterface(string interfaceName);
}

/**
* A base interface for wrapped objects that gives access to important state.
*/ 
interface HasWrappedObject: CastPointerProvider {
	@property void* wrappedObj();
	@property CreatedBy createdBy();
}

/**
* makeCastCall is used as a mixin for calling CPP casting functions from a CTFE template
* e.g. 
*       return castRectToCalculator(obj);
*
* and elsewhere:
*
*        extern "C" void* castRectToCalculator(Rect* rect); 
*/ 
string makeCastCall(string className, string interfaceName) {
	return "return cast%sTo%s(obj);".format(className, interfaceName);
}


class SmidgenException: Exception {
	this(string message) {
		super(message);
	}
}

/**
* The WrappedObject class is the base class for all D instances of wrapped objects.
*/
abstract class WrappedObject: HasWrappedObject {
	
	/**
	* Set this to true on system exit
	*/
	static protected bool systemExiting = false;
	
	/**
	* Pointer to the CPP wrapped object
	*/
	void* _wrappedObj;
	
	CreatedBy _createdBy;
	
	OwnedBy _ownedBy = OwnedBy.D;
	
	/**
	* When a CreatedBy.D CPP object is deleted by a CPP object then the CPPWrapper
	* destructor causes this flag to be set to false. No method should be callable
	* on the D object if this flag has been set to false, and the D destructor should not
	* attempt to delete the wrapped CPP object.
	*/ 
	bool CPPObjectValid = true;
	
	this() {}
	
	this(void* wrappedObj, CreatedBy createdBy, OwnedBy ownedBy) { 
		this._wrappedObj = wrappedObj;
		this._createdBy = createdBy;
		this._ownedBy = ownedBy;
	}
	
	~this() {
		debug { writeln("deregister wrapped obj from D destructor"); stdout.flush(); }
		if (ownedBy != OwnedBy.None) {
			deregisterWrappedObj(wrappedObj);
		}	
		if (! systemExiting) {
			deleteCPPObject();
		}	
	}
	
	static void setSystemExiting() {
		systemExiting = true;
	}
	
	static bool getSystemExiting() {
		return systemExiting;
	}	
	
	override hash_t toHash() { 
		if (_createdBy == CreatedBy.CPP) {
			return cast(hash_t) _wrappedObj;
		} else {
			return super.toHash();
		}
	}
	
	override bool opEquals(Object o) {
		if (o is this) {
			return true;
		}
		if (typeid(o) != typeid(this)) {
			return false;
		}
		WrappedObject other = cast(WrappedObject) o;
		if (_createdBy == CreatedBy.CPP) {
			// These objects are functioanlly equivalent
			if (_wrappedObj == other._wrappedObj) {
				return true;
			}
		}
		return true;
		
	}
	
	void deleteCPPObject() {
		throw new SmidgenException("Not implemented");
	}
	
	void* getCastPointerForInterface(string interfaceName) {
		throw new SmidgenException("Interface " ~ interfaceName ~
							" not implemented by " ~ to!string(this));
	}
	
	@property {
		void* wrappedObj() {
			return _wrappedObj;
		}
		
		void wrappedObj(void* obj) {
			_wrappedObj = obj;
		}
	}
	
	@property {
		CreatedBy createdBy() {
			return _createdBy;
		}
		
		void createdBy(CreatedBy obj) {
			_createdBy = obj;
		}
	}		
	
	@property {
		OwnedBy ownedBy() {
			return _ownedBy;
		}
		
		void ownedBy(OwnedBy obj) {
			_ownedBy = obj;
		}
	}		
	
	void checkCPPObjectIsValid() {		
		if (! CPPObjectValid) {
			throw new SmidgenException("The wrapped C++ object has been previously deleted.");
		}
	}	
	
	/**
	* This method is called when the CPPWrapper is deleted
	*/
	void cppObjectDeleted() {
		debug { writeln("deregister wrapped obj from CPP destructor", wrappedObj); stdout.flush();}
		CPPObjectValid = false;
		deregisterWrappedObj(wrappedObj);
	}
}