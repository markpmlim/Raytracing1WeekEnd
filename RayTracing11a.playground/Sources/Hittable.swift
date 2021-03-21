import Foundation
import simd

// Listing 42
class HitRecord {
    var p: point3 = point3(0)
    var normal: vec3 = vec3(0)
    var t: Double = 0
    var frontFace: Bool = false
    var material: Material = Lambertian(albedo: color(0))

    func setFaceNormal(_ ray: Ray, _ outwardNormal: vec3 ) {
        frontFace = dot(ray.direction, outwardNormal) < 0
        normal = frontFace ? outwardNormal : -outwardNormal
    }
}

// A class must implement this function to conform to the Hittable protocol
protocol Hittable {
    func isHitBy(_ r: Ray,
                 min tmin: Double, max tmax: Double,
                 _ rec: inout HitRecord) -> Bool
}
