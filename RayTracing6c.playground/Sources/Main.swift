//: Playground - noun: a place where people can play

import Cocoa
import simd


struct Pixel {
    var red: UInt8
    var green: UInt8
    var blue: UInt8
}

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


func rayColor(_ ray: Ray, _ world: HittableList) -> color {
    // Init a (zeroed) HitRecord object.
    var rec = HitRecord()
    if world.isHitBy(ray,
                     min: 0.0, max: Double.greatestFiniteMagnitude,
                     &rec) {
        let normal = rec.normal
        // [-1.0, 1.0] -> [0.0, 1.0]
        return 0.5 * (normal + color(1.0))
    }

    // Return a background color
    let unitDirection = normalize(ray.direction)
    let t = 0.5*(unitDirection.y + 1)
    return (1.0-t)*color(1.0, 1.0, 1.0) + t*color(0.5, 0.7, 1.0)
}

// Listing 24
public func generateCGImage() -> CGImage? {
    // Image
    let aspectRatio: Double = 16.0/9.0
    let imageWidth = 400
    let imageHeight = Int(Double(imageWidth)/aspectRatio)
    
    // World
    // List of objects in the scene.
    var objects = [Hittable]()
    // Small (multi-colored) sphere
    var object = Sphere(center: point3(0, 0, -1), radius: 0.5)
    objects.append(object)
    // Larger green sphere (ground)
    object = Sphere(center: point3(0, -100.5, -1), radius: 100)
    objects.append(object)

    let world = HittableList(objects)
    
    // Camera
    let viewPortHeight: Double = 2.0
    let viewPortWidth = aspectRatio * viewPortHeight
    let focalLength: Double = 1.0
    
    let origin = point3(0,0,0)
    let horizontal = vec3(viewPortWidth, 0.0, 0.0)
    let vertical = vec3(0.0, viewPortHeight, 0.0)
    let lowerLeftCorner = origin - horizontal/2 - vertical/2 - vec3(0, 0, focalLength)

    // Initialise an array of Pixels.
    let pixel = Pixel(red: 0, green: 0, blue: 0)
    var bitMap = [Pixel](repeating: pixel,
                         count: imageWidth * imageHeight)

    DispatchQueue.concurrentPerform(iterations: imageHeight) {
        row in
        DispatchQueue.concurrentPerform(iterations: imageWidth) {
            col in
            let u = Double(col)/Double(imageWidth-1)
            let v = Double(row)/Double(imageHeight-1)
            // The ray's direction is changing with u and v
            let ray = Ray(origin: origin,
                          direction: lowerLeftCorner + u*horizontal + v*vertical)
            let pixelColor = rayColor(ray, world)
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
