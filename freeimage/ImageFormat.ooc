use freeimage
import structs/ArrayList, text/StringTokenizer

ImageFormat: cover from FREE_IMAGE_FORMAT {
    toString: extern(FreeImage_GetFormatFromFIF) func -> String

    extensionListString: extern(FreeImage_GetFIFExtensionList) func -> String

    extensionList: func -> ArrayList<String> {
        extensionListString() split(',') toArrayList()
    }
}

// FREE_IMAGE_FORMAT
FIF_UNKNOWN, FIF_BMP, FIF_ICO, FIF_JPEG, FIF_JNG, FIF_KOALA, FIF_LBM,
FIF_IFF, FIF_MNG, FIF_PBM, FIF_PBMRAW, FIF_PCD, FIF_PCX, FIF_PGM,
FIF_PGMRAW, FIF_PNG, FIF_PPM, FIF_PPMRAW, FIF_RAS, FIF_TARGA,
FIF_TIFF, FIF_WBMP, FIF_PSD, FIF_CUT, FIF_XBM, FIF_XPM, FIF_DDS,
FIF_GIF, FIF_HDR, FIF_FAXG3, FIF_SGI, FIF_EXR, FIF_J2K, FIF_JP2,
FIF_PFM, FIF_PICT, FIF_RAW : extern const ImageFormat
