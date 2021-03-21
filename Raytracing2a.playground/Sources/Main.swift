import Cocoa
import simd

struct Pixel {
    var red: UInt8
    var green: UInt8
    var blue: UInt8
}

func cgImageFromRawBitmap(_ bitMapData: UnsafeRawPointer,
                          _ width: Int,
                          _ height: Int) -> CGImage? {
    let bitsPerComponent: Int = 8
    let bytesPerPixel = 3
    let colorSpace = NSColorSpaceName.deviceRGB
    let bir = NSBitmapImageRep(bitmapDataPlanes: nil,
                               pixelsWide: width,
                               pixelsHigh: height,
                               bitsPerSample: bitsPerComponent,
                               samplesPerPixel: bytesPerPixel,
                               hasAlpha: false,
                               isPlanar: false,
                               colorSpaceName: colorSpace,
                               bytesPerRow: width*bytesPerPixel,
                               bitsPerPixel: bitsPerComponent*bytesPerPixel)
    guard let bmImageRep = bir
    else {
        return nil
    }
    memcpy(bmImageRep.bitmapData,
           bitMapData,
           width*height*bytesPerPixel)
    return bmImageRep.cgImage
}

// Listing 2
public func generateCGImage() -> CGImage? {

    // Image
    let imageWidth = 256
    let imageHeight = 256

    // Allocate space for the bitmap; initialize and clear each pixel to black.
    let pixel = Pixel(red: 0, green: 0, blue: 0)
    var bitMap = [Pixel](repeating: pixel,
                         count: imageWidth * imageHeight)

    // Render
    // Instead of a double for-loop, 2 concurrent dispatch queues
    // are used to execute the 2 blocks of code in parallel.
    DispatchQueue.concurrentPerform(iterations: imageHeight) {
        row in
        DispatchQueue.concurrentPerform(iterations: imageWidth) {
            col in
            let r = Double(col)/Double(imageWidth-1)
            let g = Double(row)/Double(imageHeight-1)
            let b = 0.25
            let red = UInt8(255.999*r)
            let green = UInt8(255.999*g)
            let blue  = UInt8(255.999*b)
            let pixel = Pixel(red: red,
                              green: green,
                              blue: blue)
            // The pixels are written out in rows with pixels left to right.
            // The rows of pixels are written out from bottom to top.
            bitMap[imageWidth*(imageHeight-row-1) + col] = pixel
        }
    }
    return cgImageFromRawBitmap(bitMap, imageWidth, imageHeight)
}


