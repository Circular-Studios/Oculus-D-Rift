module test.testovr;

import ovr;
import std.stdio;

void main()
{
	System.Init();

	SensorFusion pFusionResult = new SensorFusion;
	DeviceManager pManager = DeviceManager.Create();
	HMDDevice pHMD;
	SensorDevice pSensor;
	bool infoLoaded;
	HMDInfo info;

	// Need DeviceEnumerator
	// pHMD = pManager.EnumerateDevicesEx(
	//	new DeviceEnumerationArgs( HMDDevice.EnumDeviceType, true ) );

	if( pHMD )
	{
		infoLoaded = pHMD.GetDeviceInfo( info );
		pSensor = pHMD.GetSensor();
	}
	else
	{
		// Need DeviceEnumerator
		//pSensor = pManager.EnumerateDevicesEx( FUcking I don't know );
	}

	if( pSensor )
	{
		pFusionResult.AttachToSensor( pSensor );
	}

	writeln( "----- Oculus Console -----" );

	if( pHMD )
		writeln( " [x] HMD Found" );
	else
		writeln( " [ ] HMD Not Found" );
	
	if( pSensor )
		writeln( " [x] Sensor Found" );
	else
		writeln( " [ ] Sensor Not Found" );
	
	writeln( "--------------------------" );

	if( infoLoaded )
	{
		writeln( " DisplayDeviceName: ", info.DisplayDeviceName );
		writeln( " ProductName: ", info.ProductName );
		writeln( " Manufacturer: ", info.Manufacturer );
		writeln( " Version: ", info.Version );
		writeln( " HResolution: ", info.HResolution );
		writeln( " VResolution: ", info.VResolution );
		writeln( " HScreenSize: ", info.HScreenSize );
		writeln( " VScreenSize: ", info.VScreenSize );
		writeln( " VScreenCenter: ", info.VScreenCenter );
		writeln( " EyeToScreenDistance: ", info.EyeToScreenDistance );
		writeln( " LensSeparationDistance: ", info.LensSeparationDistance );
		writeln( " InterpupillaryDistance: ", info.InterpupillaryDistance );
		//writeln( " DistortionK[0]: ", info.DistortionK[ 0 ] );
		//writeln( " DistortionK[1]: ", info.DistortionK[ 1 ] );
		//writeln( " DistortionK[2]: ", info.DistortionK[ 2 ] );
		writeln( "--------------------------" );
	}

	while( pSensor )
	{
		SWIGTYPE_p_OVR__QuatT_float_t quaternion = pFusionResult.GetOrientation();
		
		float yaw, pitch, roll;
		quaternion.GetEulerAngles<Axis.Axis_Y, Axis.Axis_X, Axis.Axis_Z>( &yaw, &pitch, &roll );

		auto RadToDegree = ( float num ) => num * 180 / 3.14;

		writeln( " Yaw: ", RadToDegree( yaw ),
				", Pitch: ", RadToDegree( pitch ),
				", Roll: ", RadToDegree( roll ) );

		import core.thread, core.time;
		Thread.sleep( dur!"msecs"( 50 ) );
	}

	// SHUTDOWN
	pSensor.clear();
	pHMD.clear();
	pManager.clear();

	System.Destroy();
}
