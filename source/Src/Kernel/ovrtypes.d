module src.kernel.ovrtypes;

/************************************************************************************

PublicHeader:   OVR.h
Filename    :   OVR_Types.h
Content     :   Standard library defines and simple types
Created     :   September 19, 2012
Notes       : 

Copyright   :   Copyright 2013 Oculus VR, Inc. All Rights reserved.

Licensed under the Oculus VR SDK License Version 2.0 (the "License"); 
you may not use the Oculus VR SDK except in compliance with the License, 
which is provided at the time of installation or download, or which 
otherwise accompanies this software in either electronic or hard copy form.

You may obtain a copy of the License at

http://www.oculusvr.com/licenses/LICENSE-2.0 

Unless required by applicable law or agreed to in writing, the Oculus VR SDK 
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

************************************************************************************/


//-----------------------------------------------------------------------------------
// ****** Operating System
//
// Type definitions exist for the following operating systems: (OVR_OS_x)
//
//    WIN32    - Win32 (Windows 95/98/ME and Windows NT/2000/XP)
//    DARWIN   - Darwin OS (Mac OS X)
//    LINUX    - Linux
//    ANDROID  - Android
//    IPHONE   - iPhone

static if((defined(__APPLE__) && (defined(__GNUC__) ||     defined(__xlC__) || defined(__xlc__))) || defined(__MACOS__)) {
static if((defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) || defined(__IPHONE_OS_VERSION_MIN_REQUIRED))) {
// #    define OVR_OS_IPHONE
} else {
// #    define OVR_OS_DARWIN
// #    define OVR_OS_MAC
}
} else static if((defined(WIN64) || defined(_WIN64) || defined(__WIN64__))) {
// #  define OVR_OS_WIN32
} else static if((defined(WIN32) || defined(_WIN32) || defined(__WIN32__) || defined(__NT__))) {
// #  define OVR_OS_WIN32
} else static if(defined(__linux__) || defined(__linux)) {
// #  define OVR_OS_LINUX
} else {
// #  define OVR_OS_OTHER
}

static if(defined(ANDROID)) {
// #  define OVR_OS_ANDROID
}


//-----------------------------------------------------------------------------------
// ***** CPU Architecture
//
// The following CPUs are defined: (OVR_CPU_x)
//
//    X86        - x86 (IA-32)
//    X86_64     - x86_64 (amd64)
//    PPC        - PowerPC
//    PPC64      - PowerPC64
//    MIPS       - MIPS
//    OTHER      - CPU for which no special support is present or needed


static if(defined(__x86_64__) || defined(WIN64) || defined(_WIN64) || defined(__WIN64__)) {
// #  define OVR_CPU_X86_64
// #  define OVR_64BIT_POINTERS
} else static if(defined(__i386__) || defined(OVR_OS_WIN32)) {
// #  define OVR_CPU_X86
} else static if(defined(__powerpc64__)) {
// #  define OVR_CPU_PPC64
} else static if(defined(__ppc__)) {
// #  define OVR_CPU_PPC
} else static if(defined(__mips__) || defined(__MIPSEL__)) {
// #  define OVR_CPU_MIPS
} else static if(defined(__arm__)) {
// #  define OVR_CPU_ARM
} else {
// #  define OVR_CPU_OTHER
}

//-----------------------------------------------------------------------------------
// ***** Co-Processor Architecture
//
// The following co-processors are defined: (OVR_CPU_x)
//
//    SSE        - Available on all modern x86 processors.
//    Altivec    - Available on all modern ppc processors.
//    Neon       - Available on some armv7+ processors.

static if(defined(__SSE__) || defined(OVR_OS_WIN32)) {
// #  define  OVR_CPU_SSE
} // __SSE__

static if(defined( __ALTIVEC__ )) {
// #  define OVR_CPU_ALTIVEC
} // __ALTIVEC__

static if(defined(__ARM_NEON__)) {
// #  define OVR_CPU_ARM_NEON
} // __ARM_NEON__


//-----------------------------------------------------------------------------------
// ***** Compiler
//
//  The following compilers are defined: (OVR_CC_x)
//
//     MSVC     - Microsoft Visual C/C++
//     INTEL    - Intel C++ for Linux / Windows
//     GNU      - GNU C++
//     ARM      - ARM C/C++

static if(defined(__INTEL_COMPILER)) {
// Intel 4.0                    = 400
// Intel 5.0                    = 500
// Intel 6.0                    = 600
// Intel 8.0                    = 800
// Intel 9.0                    = 900
alias OVR_CC_INTEL       __INTEL_COMPILER;

} else static if(defined(_MSC_VER)) {
// MSVC 5.0                     = 1100
// MSVC 6.0                     = 1200
// MSVC 7.0 (VC2002)            = 1300
// MSVC 7.1 (VC2003)            = 1310
// MSVC 8.0 (VC2005)            = 1400
// MSVC 9.0 (VC2008)            = 1500
// MSVC 10.0 (VC2010)           = 1600
alias OVR_CC_MSVC        _MSC_VER;

} else static if(defined(__GNUC__)) {
// #  define OVR_CC_GNU

} else static if(defined(__CC_ARM)) {
// #  define OVR_CC_ARM

} else {
// #  error "Oculus does not support this Compiler"
}


//-----------------------------------------------------------------------------------
// ***** Compiler Warnings

// Disable MSVC warnings
static if(defined(OVR_CC_MSVC)) {
// #  pragma warning(disable : 4127)    // Inconsistent dll linkage
// #  pragma warning(disable : 4514)    // Unreferenced inline function has been removed
// #  pragma warning(disable : 4530)    // Exception handling
// #  pragma warning(disable : 4711)    // function 'x()' selected for automatic inline expansion
// #  pragma warning(disable : 4820)    // 'n' bytes padding added after data member 'item'
static if((OVR_CC_MSVC<1300)) {
// #    pragma warning(disable : 4710)  // Function not inlined
// #    pragma warning(disable : 4714)  // _force_inline not inlined
// #    pragma warning(disable : 4786)  // Debug variable name longer than 255 chars
} // (OVR_CC_MSVC<1300)
} // (OVR_CC_MSVC)



// *** Linux Unicode - must come before Standard Includes

static if(OVR_OS_LINUX) {
// Use glibc unicode functions on linux.
static if(!_GNU_SOURCE) {
// #    define _GNU_SOURCE
}
}

//-----------------------------------------------------------------------------------
// ***** Standard Includes
//
// #include    <stddef.h>
// #include    <limits.h>
// #include    <float.h>


// MSVC Based Memory Leak checking - for now
static if(defined(OVR_CC_MSVC) && defined(OVR_BUILD_DEBUG)) {
// #  define _CRTDBG_MAP_ALLOC
// #  include <stdlib.h>
// #  include <crtdbg.h>

// Uncomment this to help debug memory leaks under Visual Studio in OVR apps only.
// This shouldn't be defined in customer releases.
static if(!OVR_DEFINE_NEW) {
// #    define OVR_DEFINE_NEW new(__FILE__, __LINE__)
// #    define new OVR_DEFINE_NEW
}

}


//-----------------------------------------------------------------------------------
// ***** Type definitions for Common Systems

alias char            Char;

// Pointer-sized integer
alias size_t          UPInt;
alias ptrdiff_t       SPInt;


static if(defined(OVR_OS_WIN32)) {

alias char            SByte;  // 8 bit Integer (Byte)
alias ubyte   UByte;
alias short           SInt16; // 16 bit Integer (Word)
alias ushort  UInt16;
alias int            SInt32; // 32 bit Integer
alias uint   UInt32;
alias long         SInt64; // 64 bit Integer (QWord)
alias ulong UInt64;

 
} else static if(defined(OVR_OS_MAC) || defined(OVR_OS_IPHONE) || defined(OVR_CC_GNU)) {

//typedef int             SByte  __attribute__((__mode__ (__QI__)));
//typedef unsigned int    UByte  __attribute__((__mode__ (__QI__)));
//typedef int             SInt16 __attribute__((__mode__ (__HI__)));
//typedef unsigned int    UInt16 __attribute__((__mode__ (__HI__)));
//typedef int             SInt32 __attribute__((__mode__ (__SI__)));
//typedef unsigned int    UInt32 __attribute__((__mode__ (__SI__)));
//typedef int             SInt64 __attribute__((__mode__ (__DI__)));
//typedef unsigned int    UInt64 __attribute__((__mode__ (__DI__)));

} else {

// #include <sys/types.h>
alias int8_t          SByte;
alias uint8_t         UByte;
alias int16_t         SInt16;
alias uint16_t        UInt16;
alias int32_t         SInt32;
alias uint32_t        UInt32;
alias int64_t         SInt64;
alias uint64_t        UInt64;

}


// ***** BaseTypes Namespace

// BaseTypes namespace is explicitly declared to allow base types to be used
// by customers directly without other contents of OVR namespace.
//
// Its is expected that GFx samples will declare 'using namespace OVR::BaseTypes'
// to allow using these directly without polluting the target scope with other
// OVR declarations, such as Ptr<>, String or Mutex.
namespace BaseTypes
{
    using OVR.UPInt;
    using OVR.SPInt;
    using OVR.UByte;
    using OVR.SByte;
    using OVR.UInt16;
    using OVR.SInt16;
    using OVR.UInt32;
    using OVR.SInt32;
    using OVR.UInt64;
    using OVR.SInt64;
} // OVR::BaseTypes


//-----------------------------------------------------------------------------------
// ***** Macro Definitions
//
// We define the following:
//
//  OVR_BYTE_ORDER      - Defined to either OVR_LITTLE_ENDIAN or OVR_BIG_ENDIAN
//  OVR_FORCE_INLINE    - Forces inline expansion of function
//  OVR_ASM             - Assembly language prefix
//  OVR_STR             - Prefixes string with L"" if building unicode
// 
//  OVR_STDCALL         - Use stdcall calling convention (Pascal arg order)
//  OVR_CDECL           - Use cdecl calling convention (C argument order)
//  OVR_FASTCALL        - Use fastcall calling convention (registers)
//

// Byte order constants, OVR_BYTE_ORDER is defined to be one of these.
enum OVR_LITTLE_ENDIAN =       1;
enum OVR_BIG_ENDIAN =          2;


// Force inline substitute - goes before function declaration
static if(defined(OVR_CC_MSVC)) {
alias OVR_FORCE_INLINE  __forceinline;
} else static if(defined(OVR_CC_GNU)) {
//#  define OVR_FORCE_INLINE  __attribute__((always_inline)) inline
} else {
alias OVR_FORCE_INLINE  ;
}  // OVR_CC_MSVC


static if(defined(OVR_OS_WIN32)) {
    
    // ***** Win32

    // Byte order
    alias OVR_BYTE_ORDER    OVR_LITTLE_ENDIAN;

    // Calling convention - goes after function return type but before function name
    static if(__cplusplus_cli) {
    } else {
    alias OVR_FASTCALL      __fastcall;
    }


    // Assembly macros
    static if(defined(OVR_CC_MSVC)) {
    // #  define OVR_ASM           _asm
    } else {
    alias OVR_ASM           asm;
    } // (OVR_CC_MSVC)

    static if(UNICODE) {
//    #  define OVR_STR(str)      L##str
    } else {
     auto OVR_STR(  ARG1 )(ARG1 str) { return      str; }
    } // UNICODE

} else {
    
    // Assembly macros
    alias OVR_ASM                  __asm__;
     auto OVR_ASM_PROC(  ARG1 )(ARG1 procname) { return   OVR_ASM; }
    alias OVR_ASM_END              OVR_ASM;
    
    // Calling convention - goes after function return type but before function name
    // #define OVR_FASTCALL
    // #define OVR_STDCALL
    // #define OVR_CDECL

} // defined(OVR_OS_WIN32)



//-----------------------------------------------------------------------------------
// ***** OVR_DEBUG_BREAK, OVR_ASSERT
//
// If not in debug build, macros do nothing
static if(!OVR_BUILD_DEBUG) {

// #  define OVR_DEBUG_BREAK  ((void)0)
 void OVR_ASSERT(  ARG1 )(ARG1 p) {     (cast()0); }

} else {

// Microsoft Win32 specific debugging support
static if(defined(OVR_OS_WIN32)) {
static if(OVR_CPU_X86) {
static if(defined(__cplusplus_cli)) {
// #      define OVR_DEBUG_BREAK   do { __debugbreak(); } while(0)
} else static if(defined(OVR_CC_GNU)) {
// #      define OVR_DEBUG_BREAK   do { OVR_ASM("int $3\n\t"); } while(0)
} else {
// #      define OVR_DEBUG_BREAK   do { OVR_ASM int 3 } while (0)
}
} else {
// #    define OVR_DEBUG_BREAK     do { __debugbreak(); } while(0)
}
// Unix specific debugging support
} else static if(defined(OVR_CPU_X86) || defined(OVR_CPU_X86_64)) {
// #  define OVR_DEBUG_BREAK       do { OVR_ASM("int $3\n\t"); } while(0)
} else {
// #  define OVR_DEBUG_BREAK       do { *((int *) 0) = 1; } while(0)
}

// This will cause compiler breakpoint
 void OVR_ASSERT(  ARG1 )(ARG1 p) {            do { if (!p)  { OVR_DEBUG_BREAK; } } while(0); }

} // OVR_BUILD_DEBUG


// Compile-time assert; produces compiler error if condition is false
 void OVR_COMPILER_ASSERT(  ARG1 )(ARG1 x) {   { int zero = 0; switch(zero) {case 0: case x:{}} }{} }



//-----------------------------------------------------------------------------------
// ***** OVR_UNUSED - Unused Argument handling

// Macro to quiet compiler warnings about unused parameters/variables.
static if(defined(OVR_CC_GNU)) {
//#  define   OVR_UNUSED(a)   do {__typeof__ (&a) __attribute__ ((unused)) __tmp = &a; } while(0)
} else {
 auto OVR_UNUSED(  ARG1 )(ARG1 a) { return   a; }
}

 auto OVR_UNUSED1(  ARG1 )(ARG1 a1) { return OVR_UNUSED(a1); }
 void OVR_UNUSED2(  ARG1,  ARG2 )(ARG1 a1, ARG2 a2) {  OVR_UNUSED(a1); OVR_UNUSED(a2); }
 void OVR_UNUSED3(  ARG1,  ARG2,  ARG3 )(ARG1 a1, ARG2 a2, ARG3 a3) {  OVR_UNUSED2(a1,a2); OVR_UNUSED(a3); }
 void OVR_UNUSED4(  ARG1,  ARG2,  ARG3,  ARG4 )(ARG1 a1, ARG2 a2, ARG3 a3, ARG4 a4) {  OVR_UNUSED3(a1,a2,a3); OVR_UNUSED(a4); }
 void OVR_UNUSED5(  ARG1,  ARG2,  ARG3,  ARG4,  ARG5 )(ARG1 a1, ARG2 a2, ARG3 a3, ARG4 a4, ARG5 a5) {  OVR_UNUSED4(a1,a2,a3,a4); OVR_UNUSED(a5); }
 void OVR_UNUSED6(  ARG1,  ARG2,  ARG3,  ARG4,  ARG5,  ARG6 )(ARG1 a1, ARG2 a2, ARG3 a3, ARG4 a4, ARG5 a5, ARG6 a6) {  OVR_UNUSED4(a1,a2,a3,a4); OVR_UNUSED2(a5,a6); }
 void OVR_UNUSED7(  ARG1,  ARG2,  ARG3,  ARG4,  ARG5,  ARG6,  ARG7 )(ARG1 a1, ARG2 a2, ARG3 a3, ARG4 a4, ARG5 a5, ARG6 a6, ARG7 a7) {  OVR_UNUSED4(a1,a2,a3,a4); OVR_UNUSED3(a5,a6,a7); }
 void OVR_UNUSED8(  ARG1,  ARG2,  ARG3,  ARG4,  ARG5,  ARG6,  ARG7,  ARG8 )(ARG1 a1, ARG2 a2, ARG3 a3, ARG4 a4, ARG5 a5, ARG6 a6, ARG7 a7, ARG8 a8) {  OVR_UNUSED4(a1,a2,a3,a4); OVR_UNUSED4(a5,a6,a7,a8); }
 void OVR_UNUSED9(  ARG1,  ARG2,  ARG3,  ARG4,  ARG5,  ARG6,  ARG7,  ARG8,  ARG9 )(ARG1 a1, ARG2 a2, ARG3 a3, ARG4 a4, ARG5 a5, ARG6 a6, ARG7 a7, ARG8 a8, ARG9 a9) {  OVR_UNUSED4(a1,a2,a3,a4); OVR_UNUSED5(a5,a6,a7,a8,a9); }


//-----------------------------------------------------------------------------------
// ***** Configuration Macros

// SF Build type
static if(OVR_BUILD_DEBUG) {
enum OVR_BUILD_STRING = "Debug";
} else {
enum OVR_BUILD_STRING = "Release"
}


//// Enables SF Debugging information
//# define OVR_BUILD_DEBUG

// OVR_DEBUG_STATEMENT injects a statement only in debug builds.
// OVR_DEBUG_SELECT injects first argument in debug builds, second argument otherwise.
static if(OVR_BUILD_DEBUG) {
 auto OVR_DEBUG_STATEMENT(  ARG1 )(ARG1 s) { return   s; }
 auto OVR_DEBUG_SELECT(  ARG1,  ARG2 )(ARG1 d, ARG2 nd) { return  d; }
} else {
 void OVR_DEBUG_STATEMENT(  ARG1 )(ARG1 s) { {} }
 auto OVR_DEBUG_SELECT(  ARG1,  ARG2 )(ARG1 d, ARG2 nd) { return  nd; }
}


// #define OVR_ENABLE_THREADS
//
// Prevents OVR from defining new within
// type macros, so developers can override
// new using the #define new new(...) trick
// - used with OVR_DEFINE_NEW macro
//# define OVR_BUILD_DEFINE_NEW
//


  // OVR_Types_h
