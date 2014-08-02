## Oculus-D-Rift

A D binding for the Oculus Rift. Note: This only works on Windows.

### Generating the Binding

Run this from the root directory (note you may need to replace `C:\D\dm\` with
your path to DMC):

```
htod libovr\Src\OVR_CAPI.h source\ovr.d -I"C:\D\dm\include"
```
