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

// Listing 11
func hitSphere(center: point3, radius: Double, ray r: Ray) -> Double {
    let oc = r.origin - center
    let a = dot(r.direction, r.direction)
    let b = 2.0 * dot(oc, r.direction)
    let c = dot(oc, oc) - radius*radius
    let discriminant = b*b - 4*a*c
    if discriminant < 0 {
        // The intersection point is behind the viewer.
        return -1.0
    }
    else {
        // We have an intersection point.
        // The ray has hit the sphere at the point of intersection.
        // We should take the smaller +ve value.
        return (-b - sqrt(discriminant)) / (2.0*a)
    }
}

func rayColor(_ ray: Ray) -> color {
    // centre of sphere is at the point (0, 0, -1) i.e. along the z-axis
    var t = hitSphere(center: point3(0,0,-1),
                      radius: 0.5,
                      ray: ray)
    if t > 0.0 {
        // The direction of the normal is the position vector of the hit point
        // minus the position vector of the center of the sphere.
        let normal = normalize(ray.at(t) - vec3(0,0,-1))
        // Each component of the unit normal value is [-1.0, 1.0]
        // Transform the normal into [0.0, 1.0]
        //return 0.5*color(normal.x+1, normal.y+1, normal.z+1)
        return 0.5*(normal + color(1.0))
    }
    // background
    let unitDirection = normalize(ray.direction)
    t = 0.5*(unitDirection.y + 1.0)
    return (1.0-t)*color(1.0, 1.0, 1.0) + t*color(0.5, 0.7, 1.0)
}


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

    // Render
    DispatchQueue.concurrentPerform(iterations: imageHeight) {
        row in
        DispatchQueue.concurrentPerform(iterations: imageWidth) {
            col in
            let u = Double(col)/Double(imageWidth-1)
            let v = Double(row)/Double(imageHeight-1)
            // The direction of the ray is changing wrt u and v
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
