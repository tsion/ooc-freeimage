use freeimage
include freeimage/Version
include stdio

main: func {
        printf("FreeImage %i.%i.%i\n", FreeImage MajorVersion, FreeImage MinorVersion, FreeImage ReleaseSerial)
}