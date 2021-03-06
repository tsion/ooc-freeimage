use freeimage
import io/File
import freeimage/[ImageFormat, IOHandler]

Bitmap: cover from FIBITMAP* {
    new: static func (width, height, bpp: Int) -> This {
        FreeImage_Allocate(width, height, bpp, 0, 0, 0)
    }

    new: static func ~fromPath (path: String) -> This {
        fif := ImageFormat unknown
        fif = FreeImage_GetFileType(path, 0)

        if (fif == ImageFormat unknown) {
            fif = FreeImage_GetFIFFromFilename(path)
        }

        if ((fif != ImageFormat unknown) && FreeImage_FIFSupportsReading(fif)) {
            bitmap := FreeImage_Load(fif, path, 0)
            return bitmap
        }

        return null
    }

    new: static func ~fromFile (file: File) -> This {
        This new(file path)
    }

    new: static func ~fromHandle (io: IOHandler*, handle: FStream) -> This {
        fif := ImageFormat unknown
        fif = FreeImage_GetFileTypeFromHandle(io, handle, 0)

        if ((fif != ImageFormat unknown) && FreeImage_FIFSupportsReading(fif)) {
            bitmap := FreeImage_LoadFromHandle(fif, io, handle, 0)
            return bitmap
        }

        return null
    }

    clone: extern(FreeImage_Clone) func -> This

    save: func (filename: String, format: ImageFormat) -> Bool {
        FreeImage_Save(format, this, filename, 0)
    }

    unload: extern(FreeImage_Unload) func

    width: Int {
        get: extern(FreeImage_GetWidth)
    }

    height: Int {
        get: extern(FreeImage_GetHeight)
    }

    bpp: Int {
        get: extern(FreeImage_GetBPP)
    }

    imageType: extern(FreeImage_GetImageType) func -> ImageType

    // Pixel access functions
    bits: extern(FreeImage_GetBits) func -> UInt8*

    scanline: extern(FreeImage_GetScanLine) func (Int) -> UInt8*

    getPixelIndex: func (x, y: UInt) -> UInt8 {
        index: UInt8
        FreeImage_GetPixelIndex(this, x, y, index&)
        return index
    }

    getPixelColor: func (x, y: UInt) -> RGBQuad {
        color := RGBQuad new()
        FreeImage_GetPixelColor(this, x, y, color)
        return color
    }

    setPixelIndex: func (x, y: UInt, index: UInt8) {
        FreeImage_SetPixelIndex(this, x, y, index&)
    }

    setPixelColor: func (x, y: UInt, color: RGBQuad) {
        FreeImage_SetPixelColor(this, x, y, color)
    }

    // Toolkit functions
    rescale: extern(FreeImage_Rescale) func (width, height: Int, filter: ImageFilter) -> This

    thumbnail: extern(FreeImage_MakeThumbnail) func (max: Int, convert: Bool) -> This

    thumbnail: func ~defaultConvert (max: Int) -> This {
        thumbnail(max, true)
    }
}

FreeImage_Allocate: extern func (Int, Int, Int, Int, Int, Int) -> Bitmap
FreeImage_Load: extern func (ImageFormat, String, Int) -> Bitmap
FreeImage_LoadFromHandle: extern func (ImageFormat, IOHandler*, FStream, Int) -> Bitmap
FreeImage_Save: extern func (ImageFormat, Bitmap, String, Int) -> Bool
FreeImage_GetFileType: extern func (String, Int) -> ImageFormat
FreeImage_GetFileTypeFromHandle: extern func (IOHandler*, FStream, Int) -> ImageFormat
FreeImage_GetFIFFromFilename: extern func (String) -> ImageFormat
FreeImage_FIFSupportsReading: extern func (ImageFormat) -> Bool
FreeImage_GetPixelIndex: extern func (Bitmap, UInt, UInt, UInt8*) -> Bool
FreeImage_GetPixelColor: extern func (Bitmap, UInt, UInt, RGBQuad*) -> Bool
FreeImage_SetPixelIndex: extern func (Bitmap, UInt, UInt, UInt8*) -> Bool
FreeImage_SetPixelColor: extern func (Bitmap, UInt, UInt, RGBQuad*) -> Bool

RGBQuadStruct: cover from RGBQUAD {
    red:      extern(rgbRed)      UInt8
    green:    extern(rgbGreen)    UInt8
    blue:     extern(rgbBlue)     UInt8
    reserved: extern(rgbReserved) UInt8
}

RGBQuad: cover from RGBQuadStruct* {
    new: static func (red, green, blue, reserved: UInt8) -> This {
        this := gc_malloc(RGBQuadStruct size) as This
        this@ red = red
        this@ green = green
        this@ blue = blue
        this@ reserved = reserved
        return this
    }

    new: static func ~withoutAlpha (red, green, blue: UInt8) -> This {
        This new(red, green, blue, 255)
    }

    new: static func ~blank -> This {
        This new(0, 0, 0, 0)
    }
}

ImageType: extern(FREE_IMAGE_TYPE) enum {
    unknown: extern(FIT_UNKNOWN)
    bitmap:  extern(FIT_BITMAP)
    uint16:  extern(FIT_UINT16)
    int16:   extern(FIT_INT16)
    uint32:  extern(FIT_UINT32)
    int32:   extern(FIT_INT32)
    float:   extern(FIT_FLOAT)
    double:  extern(FIT_DOUBLE)
    complex: extern(FIT_COMPLEX)
    rgb16:   extern(FIT_RGB16)
    rgba16:  extern(FIT_RGBA16)
    rgbf:    extern(FIT_RGBF)
    rgbaf:   extern(FIT_RGBAF)
}

ImageFilter: extern(FREE_IMAGE_FILTER) enum {
    box:        extern(FILTER_BOX)
    bicubic:    extern(FILTER_BICUBIC)
    bilinear:   extern(FILTER_BILINEAR)
    bspline:    extern(FILTER_BSPLINE)
    catmullrom: extern(FILTER_CATMULLROM)
    lanczos3:   extern(FILTER_LANCZOS3)
}
