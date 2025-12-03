package main

/*
#include <stdlib.h>
*/
import "C"

import (
    "embed"
    "io/fs"
    "mime"
    "path/filepath"
    "strings"
    "unsafe"
)

//go:embed Assets/*
var embeddedAssets embed.FS

// Asset represents a single embedded asset
type Asset struct {
    Path     string
    MimeType string
    Data     []byte
    Size     int
}

// guessMimeType determines MIME type from file extension
func guessMimeType(path string) string {
    ext := filepath.Ext(path)
    if ext == "" {
        return "application/octet-stream"
    }

    mimeType := mime.TypeByExtension(ext)
    if mimeType == "" {
        return "application/octet-stream"
    }

    return mimeType
}

// GetEmbeddedAsset retrieves an asset by its relative path
// Path should NOT include "Assets/" prefix, e.g., "test.txt" not "Assets/test.txt"
//
//export GetEmbeddedAsset
func GetEmbeddedAsset(pathPtr *C.char) *C.char {
    if pathPtr == nil {
        return nil
    }

    path := C.GoString(pathPtr)

    // Clean the path - remove leading slash if present
    path = strings.TrimPrefix(path, "/")

    // Add Assets/ prefix for embed.FS
    fullPath := "Assets/" + path

    // Read the file from embedded FS
    data, err := embeddedAssets.ReadFile(fullPath)
    if err != nil {
        return nil
    }

    // Return the data as C string (will be freed by caller)
    // Note: This returns raw bytes, caller must know the length
    return C.CString(string(data))
}

// GetEmbeddedAssetWithInfo retrieves an asset with metadata
// Returns: mime_type|size|data
// The format is: "mime/type|12345|<binary data>"
//
//export GetEmbeddedAssetWithInfo
func GetEmbeddedAssetWithInfo(pathPtr *C.char) *C.char {
    if pathPtr == nil {
        return nil
    }

    path := C.GoString(pathPtr)
    path = strings.TrimPrefix(path, "/")
    fullPath := "Assets/" + path

    data, err := embeddedAssets.ReadFile(fullPath)
    if err != nil {
        return nil
    }

    mimeType := guessMimeType(path)

    // Format: mime|size|data
    result := mimeType + "|" + string(rune(len(data))) + "|" + string(data)

    return C.CString(result)
}

// GetEmbeddedAssetData retrieves just the raw data
//
//export GetEmbeddedAssetData
func GetEmbeddedAssetData(pathPtr *C.char, sizeOut *C.int) *C.char {
    if pathPtr == nil {
        return nil
    }

    path := C.GoString(pathPtr)
    path = strings.TrimPrefix(path, "/")
    fullPath := "Assets/" + path

    data, err := embeddedAssets.ReadFile(fullPath)
    if err != nil {
        if sizeOut != nil {
            *sizeOut = 0
        }
        return nil
    }

    if sizeOut != nil {
        *sizeOut = C.int(len(data))
    }

    // Allocate C memory that won't be garbage collected
    cData := C.CBytes(data)
    return (*C.char)(cData)
}

// GetEmbeddedAssetMimeType retrieves just the MIME type
//
//export GetEmbeddedAssetMimeType
func GetEmbeddedAssetMimeType(pathPtr *C.char) *C.char {
    if pathPtr == nil {
        return nil
    }

    path := C.GoString(pathPtr)
    path = strings.TrimPrefix(path, "/")
    fullPath := "Assets/" + path

    // Check if file exists
    _, err := embeddedAssets.ReadFile(fullPath)
    if err != nil {
        return nil
    }

    mimeType := guessMimeType(path)
    return C.CString(mimeType)
}

// GetEmbeddedAssetSize retrieves just the size
//
//export GetEmbeddedAssetSize
func GetEmbeddedAssetSize(pathPtr *C.char) C.int {
    if pathPtr == nil {
        return -1
    }

    path := C.GoString(pathPtr)
    path = strings.TrimPrefix(path, "/")
    fullPath := "Assets/" + path

    data, err := embeddedAssets.ReadFile(fullPath)
    if err != nil {
        return -1
    }

    return C.int(len(data))
}

// AssetExists checks if an asset exists in the embedded FS
//
//export AssetExists
func AssetExists(pathPtr *C.char) C.int {
    if pathPtr == nil {
        return 0
    }

    path := C.GoString(pathPtr)
    path = strings.TrimPrefix(path, "/")
    fullPath := "Assets/" + path

    _, err := embeddedAssets.ReadFile(fullPath)
    if err != nil {
        return 0
    }

    return 1
}

// ListEmbeddedAssets returns a newline-separated list of all embedded asset paths
// Paths are returned WITHOUT the "Assets/" prefix
//

//export ListEmbeddedAssets
func ListEmbeddedAssets() *C.char {
    var paths []string

    // Walk the embedded FS
    err := fs.WalkDir(embeddedAssets, "Assets", func(path string, d fs.DirEntry, err error) error {
        if err != nil {
            return err
        }

        if !d.IsDir() {
            // Remove "Assets/" prefix
            relativePath := strings.TrimPrefix(path, "Assets/")
            paths = append(paths, relativePath)
        }

        return nil
    })

    if err != nil {
        return nil
    }

    result := strings.Join(paths, "\n")
    return C.CString(result)
}

// FreeString frees a C string allocated by Go
//
//export FreeString
func FreeString(str *C.char) {
    if str != nil {
        C.free(unsafe.Pointer(str))
    }
}

// Must have main for buildmode=c-archive
func main() {}
