
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

// Listing 49
func rayColor(_ ray: Ray, _ world: HittableList, _ depth: Int) -> color {
    // We need to instantiate a (zeroed) HitRecord.
    var rec = HitRecord()

    // If we've exceeded the ray bounce limit, no more light is gathered.
    if depth < 0 {
        return color(0,0,0)
    }

    // Fixing Shadow Acne
    if world.isHitBy(ray, min: 0.001, max: Double.infinity, &rec) {
        var scattered = ray
        var attenuation = color(0)
        if rec.material.scatter(ray, rec, &attenuation, &scattered) {
            return attenuation * rayColor(scattered, world, depth-1)
        }
        else {
            return color(0)
        }
    }
    else {
        // background
        let unitDirection = normalize(ray.direction)
        let t = 0.5*(unitDirection.y + 1.0)
        return (1.0-t)*color(1.0, 1.0, 1.0) + t*color(0.5, 0.7, 1.0)
    }
}

// Listing 50
public func generateCGImage() -> CGImage? {

    // Image
    let aspectRatio: Double = 16.0/9.0
    let imageWidth = 400
    let imageHeight = Int(Double(imageWidth)/aspectRatio)
    let samples_per_pixel = 100;
    let max_depth = 50

    // World

    let materialGround = Lambertian(albedo: color(0.8, 0.8, 0.0))
    let materialCenter = Lambertian(albedo: color(0.7, 0.3, 0.3))
    let materialLeft = Metal(albedo: color(0.8, 0.8, 0.8))
    let materialRight = Metal(albedo: color(0.8, 0.6, 0.2))
 
    var objects = [Hittable]()
    var object = Sphere(center: point3(0.0, -100.5, -1.0), radius: 100,
                        material: materialGround)
    objects.append(object)
    object = Sphere(center: point3(0.0, 0.0, -1.0), radius: 0.5,
                    material: materialCenter)
    objects.append(object)
    object = Sphere(center: point3(-1.0, 0.0, -1.0), radius: 0.5,
                    material: materialLeft)
    objects.append(object)
    object = Sphere(center: point3(1.0, 0.0, -1.0), radius: 0.5,
                    material: materialRight)
    objects.append(object)
    let world = HittableList(objects)

    // Camera

    let cam = Camera()

    let pixel = Pixel(red: 0, green: 0, blue: 0)
    var bitMap = [Pixel](repeating: pixel,
                         count: imageWidth * imageHeight)

    // Render

    DispatchQueue.concurrentPerform(iterations: imageHeight) {
        row in
        DispatchQueue.concurrentPerform(iterations: imageWidth) {
            col in
            var pixelColor = color(0)
            DispatchQueue.concurrentPerform(iterations: samples_per_pixel) {
                dummy in
                let u = (Double(col) + random_double()) / Double(imageWidth-1)
                let v = (Double(row) + random_double()) / Double(imageHeight-1)
                let ray = cam.getRay(double2(u,v))
                pixelColor += rayColor(ray, world, max_depth)
            }
            // Divide the color by the number of samples ...
            pixelColor /= Double(samples_per_pixel)
            //  ... and gamma-correct for gamma=2.0
            pixelColor = color(sqrt(pixelColor.x), sqrt(pixelColor.y), sqrt(pixelColor.z))
            pixelColor = clamp(pixelColor, min: 0.0, max: 0.999)
            let red = UInt8(256*pixelColor.x)
            let green = UInt8(256*pixelColor.y)
            let blue = UInt8(256*pixelColor.z)
            let pixel = Pixel(red: red,
                              green: green,
                              blue: blue)
            bitMap[imageWidth*(imageHeight-row-1) + col] = pixel
        }
    }
    return cgImageFromRawBitmap(bitMap, imageWidth, imageHeight)
}
