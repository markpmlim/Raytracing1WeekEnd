import Cocoa
import simd

struct Pixel {
    var red: UInt8
    var green: UInt8
    var blue: UInt8
}

// Invert the image
public func cgImageFromRawBitmap(_ bitMapData: UnsafeRawPointer,
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

// Listing 10
func hitSphere(_ center: point3, radius: Double, ray r: Ray) -> Bool {
    // Compute the vector from center to origin
    let oc = r.origin - center
    let a = dot(r.direction, r.direction)
    let b = 2.0 * dot(oc, r.direction)
    let c = dot(oc, oc) - radius * radius
    let discriminant = b * b - 4 * a * c
    return discriminant > 0
}

// The sphere is at -1.0 along the z-axis
func rayColor(_ ray: Ray) -> color {
    if hitSphere(point3(0.0, 0.0, -1.0),
                 radius: 0.5,
                 ray: ray) {
        return color(1.0, 0.0, 0.0)     // red
    }
    // Background colour
    let unitDirection = normalize(ray.direction)
    let t = 0.5*(unitDirection.y + 1.0)
    return (1.0-t)*color(1.0, 1.0, 1.0) + t*color(0.5, 0.7, 1.0)
}


public func generateCGImage() -> CGImage? {
    let aspectRatio: Double = 16.0/9.0
    let imageWidth = 400
    let imageHeight = Int(Double(imageWidth)/aspectRatio)
    
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
            // The direction of the ray is changing.
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
