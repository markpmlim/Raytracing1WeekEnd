//: Playground - noun: a place where people can play

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

// Listing 9
func rayColor(_ ray: Ray) -> color {
    let unitDirection = normalize(ray.direction)
    // t is (0, 1) since unitDirection.y is (-1, 1)
    let t = 0.5*(unitDirection.y + 1.0)
    let color0 = color(1.0, 1.0, 1.0)       // white
    let color1 = color(0.5, 0.7, 1.0)       // bluish
    // Return a linear interpolation of the 2 colors.
    return (1.0-t)*color0 + t*color1
}

// Listing 9
public func generateCGImage() -> CGImage? {

    // Image
    let aspectRatio: Double = 16.0/9.0
    let imageWidth = 400
    let imageHeight = Int(Double(imageWidth)/aspectRatio)

    // Camera
    let viewPortHeight: Double = 2.0
    let viewPortWidth = aspectRatio * viewPortHeight
    let focalLength: Double = 1.0

    let origin = point3(0)
    let horizontal = vec3(viewPortWidth, 0.0, 0.0)
    let vertical = vec3(0.0, viewPortHeight, 0.0)
    let lowerLeftCorner = origin - horizontal/2 - vertical/2 - vec3(0, 0, focalLength)

    let pixel = Pixel(red: 0, green: 0, blue: 0)
    var bitMap = [Pixel](repeating: pixel,
                         count: imageWidth * imageHeight)

    DispatchQueue.concurrentPerform(iterations: imageHeight) {
        row in
        DispatchQueue.concurrentPerform(iterations: imageWidth) {
            col in
            let u = Double(col)/Double(imageWidth-1)
            let v = Double(row)/Double(imageHeight-1)
            // The direction of the ray is changing wrt to u and v.
            let ray = Ray(origin: origin,
                          direction: lowerLeftCorner + u*horizontal + v*vertical - origin)
            let pixelColor = rayColor(ray)
            // write out the color
            let red = UInt8(255.999*pixelColor.x)
            let green = UInt8(255.999*pixelColor.y)
            let blue = UInt8(255.999*pixelColor.z)
            let pixel = Pixel(red: red,
                              green: green,
                              blue: blue)
            bitMap[imageWidth*(imageHeight-row-1) + col] = pixel
        }
    }
    return cgImageFromRawBitmap(bitMap, imageWidth, imageHeight)
}
