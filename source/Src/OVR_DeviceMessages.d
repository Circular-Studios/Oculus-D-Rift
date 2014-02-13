module Src.OVR_DeviceMessages;

/************************************************************************************

PublicHeader:   OVR.h
Filename    :   OVR_DeviceMessages.h
Content     :   Definition of messages generated by devices
Created     :   February 5, 2013
Authors     :   Lee Cooper

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

*************************************************************************************/


import OVR_DeviceConstants;
import OVR_DeviceHandle;

import Kernel.OVR_Math;
import Kernel.OVR_Array;
import Kernel.OVR_Color;

namespace OVR {


//#define OVR_MESSAGETYPE(devName, msgIndex)   ((Device_##devName << 8) | msgIndex)

// MessageType identifies the structure of the Message class; based on the message,
// casting can be used to obtain the exact value.
enum MessageType
{
    // Used for unassigned message types.
    Message_None            = 0,

    // Device Manager Messages
    Message_DeviceAdded             = OVR_MESSAGETYPE(Manager, 0),  // A new device is detected by manager.
    Message_DeviceRemoved           = OVR_MESSAGETYPE(Manager, 1),  // Existing device has been plugged/unplugged.
    // Sensor Messages
    Message_BodyFrame               = OVR_MESSAGETYPE(Sensor, 0),   // Emitted by sensor at regular intervals.
    // Latency Tester Messages
    Message_LatencyTestSamples          = OVR_MESSAGETYPE(LatencyTester, 0),
    Message_LatencyTestColorDetected    = OVR_MESSAGETYPE(LatencyTester, 1),
    Message_LatencyTestStarted          = OVR_MESSAGETYPE(LatencyTester, 2),
    Message_LatencyTestButton           = OVR_MESSAGETYPE(LatencyTester, 3),

};

//-------------------------------------------------------------------------------------
// Base class for all messages.
class Message
{
public:
    this(MessageType type = OVR.MessageType.Message_None,
            DeviceBase* pdev = 0)
    { Type = (type); pDevice = (pdev); }

    MessageType Type;    // What kind of message this is.
    DeviceBase* pDevice; // Device that emitted the message.
};


// Sensor BodyFrame notification.
// Sensor uses Right-Handed coordinate system to return results, with the following
// axis definitions:
//  - Y Up positive
//  - X Right Positive
//  - Z Back Positive
// Rotations a counter-clockwise (CCW) while looking in the negative direction
// of the axis. This means they are interpreted as follows:
//  - Roll is rotation around Z, counter-clockwise (tilting left) in XY plane.
//  - Yaw is rotation around Y, positive for turning left.
//  - Pitch is rotation around X, positive for pitching up.

class MessageBodyFrame : public Message
{
public:
    this(DeviceBase* dev)
    { super(OVR.MessageType.Message_BodyFrame, dev); Temperature = (0.0f); TimeDelta = (0.0f);
    }

    Vector3f Acceleration;   // Acceleration in m/s^2.
    Vector3f RotationRate;   // Angular velocity in rad/s^2.
    Vector3f MagneticField;  // Magnetic field strength in Gauss.
    float    Temperature;    // Temperature reading on sensor surface, in degrees Celsius.
    float    TimeDelta;      // Time passed since last Body Frame, in seconds.
};

// Sent when we receive a device status changes (e.g.:
// Message_DeviceAdded, Message_DeviceRemoved).
class MessageDeviceStatus : public Message
{
public:
	this(MessageType type, DeviceBase* dev, ref const DeviceHandle  hdev) { super(type, dev); Handle = (hdev); }

	DeviceHandle Handle;
};

//-------------------------------------------------------------------------------------
// ***** Latency Tester

// Sent when we receive Latency Tester samples.
class MessageLatencyTestSamples : public Message
{
public:
    this(DeviceBase* dev)
    { super(OVR.MessageType.Message_LatencyTestSamples, dev);
    }

    Array!(Color)     Samples;
};

// Sent when a Latency Tester 'color detected' event occurs.
class MessageLatencyTestColorDetected : public Message
{
public:
    this(DeviceBase* dev)
    { super(OVR.MessageType.Message_LatencyTestColorDetected, dev);
    }

    UInt16      Elapsed;
    Color       DetectedValue;
    Color       TargetValue;
};

// Sent when a Latency Tester 'change color' event occurs.
class MessageLatencyTestStarted : public Message
{
public:
    this(DeviceBase* dev)
    { super(OVR.MessageType.Message_LatencyTestStarted, dev);
    }

    Color    TargetValue;
};

// Sent when a Latency Tester 'button' event occurs.
class MessageLatencyTestButton : public Message
{
public:
    this(DeviceBase* dev)
    { super(OVR.MessageType.Message_LatencyTestButton, dev);
    }

};


} // namespace OVR
