module test.testovr;

import ovr;
import std.stdio;

void main()
{
    ovr_Initialize();
    ovrHmd hmd = ovrHmd_Create( 0 );

    if( hmd )
    {
        // Get more details about the HMD.
        writeln( " DisplayDeviceName: ", hmd.DisplayDeviceName );
        writeln( " ProductName: ", hmd.ProductName );
        writeln( " Manufacturer: ", hmd.Manufacturer );
        writeln( " HResolution: ", hmd.Resolution.w );
        writeln( " VResolution: ", hmd.Resolution.h );
        writeln( "--------------------------" );

        while( true )
        {
            // Start the sensor which provides the Rift’s pose and motion.
            ovrHmd_ConfigureTracking( hmd, ovrTrackingCap_Orientation |
                                           ovrTrackingCap_MagYawCorrection |
                                           ovrTrackingCap_Position, 0 );

            // Query the HMD for the current tracking state.
            ovrTrackingState ts = ovrHmd_GetTrackingState( hmd, ovr_GetTimeInSeconds() );

            if( ts.StatusFlags & ( ovrStatus_OrientationTracked | ovrStatus_PositionTracked ) )
            {
                auto orientation = ts.HeadPose.ThePose.Orientation;
                writefln( "Orientation: %s,%s,%s,%s", orientation.x, orientation.y, orientation.w, orientation.z );
            }
        }
    }
    else
    {
        writeln( "No HMD connected." );
    }

    // SHUTDOWN
    ovrHmd_Destroy( hmd );
    ovr_Shutdown();
}
