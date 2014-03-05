%module ovr
%{
#include "Kernel/OVR_Types.h"
#include "Kernel/OVR_Allocator.h"
#include "Kernel/OVR_ContainerAllocator.h"
#include "Kernel/OVR_Array.h"
#include "Kernel/OVR_Alg.h"
#include "Kernel/OVR_UTF8Util.h"
#include "Kernel/OVR_Log.h"
#include "Kernel/OVR_Allocator.h"
#include "Kernel/OVR_System.h"
#include "Kernel/OVR_RefCount.h"
#include "Kernel/OVR_Std.h"
#include "Kernel/OVR_Math.h"
#include "Kernel/OVR_Atomic.h"
#include "Kernel/OVR_String.h"
#include "OVR_DeviceConstants.h"
#include "OVR_DeviceHandle.h"
#include "OVR_DeviceMessages.h"
#include "OVR_SensorFusion.h"
#include "OVR_Profile.h"
#include "OVR_HIDDeviceBase.h"
#include "OVR_Device.h"
#include "Util/Util_LatencyTest.h"
#include "Util/Util_Render_Stereo.h"
#include "OVR_JSON.h"
#include "OVR_DeviceImpl.h"

using namespace OVR;

Matrix4f Matrix4f::IdentityValue = Matrix4f();
%}

#define __stdcall
#define __cdecl

%import "Kernel/OVR_Types.h"
%import "Kernel/OVR_Alg.h"
%import "Kernel/OVR_UTF8Util.h"
%include "Kernel/OVR_Log.h"
%include "Kernel/OVR_Allocator.h"
%include "Kernel/OVR_System.h"
%import "Kernel/OVR_RefCount.h"
%import "Kernel/OVR_Std.h"
%include "Kernel/OVR_Math.h"
%include "Kernel/OVR_Atomic.h"
%include "Kernel/OVR_String.h"
%include "OVR_DeviceConstants.h"
%include "OVR_DeviceHandle.h"
%include "OVR_DeviceMessages.h"
%include "OVR_SensorFusion.h"
%include "OVR_Profile.h"
%include "OVR_HIDDeviceBase.h"
%include "OVR_Device.h"
%include "Util/Util_LatencyTest.h"
%include "Util/Util_Render_Stereo.h"
%include "OVR_JSON.h"
