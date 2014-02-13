module Src.Kernel.OVR_Color;

/************************************************************************************

PublicHeader:   OVR.h
Filename    :   OVR_Color.h
Content     :   Contains color struct.
Created     :   February 7, 2013
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

import OVR_Types;

namespace OVR {

struct Color
{
    UByte R,G,B,A;

    static Color opCall() {}

    // Constructs color by channel. Alpha is set to 0xFF (fully visible)
    // if not specified.
    this(ubyte r,ubyte g,ubyte b, ubyte a = 0xFF) { R = (r); G = (g); B = (b); A = (a); }

    // 0xAARRGGBB - Common HTML color Hex layout
    this(uint c) { R = (cast(ubyte)(c>>16)); G = (cast(ubyte)(c>>8));
        B = (cast(ubyte)c); A = (cast(ubyte)(c>>24)); }

    bool operator==(ref const Color  b) const
    {
        return R == b.R && G == b.G && B == b.B && A == b.A;
    }

    void  GetRGBA(float *r, float *g, float *b, float * a) const
    {
        *r = R / 255.0f;
        *g = G / 255.0f;
        *b = B / 255.0f;
        *a = A / 255.0f;
    }
};

}

