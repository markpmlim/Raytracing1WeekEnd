import Foundation
import simd

// Listing 43
class Sphere: Hittable  {
    var center: point3
    var radius: Double
    var material: Material

    // Declare a convenience initializer.
    init(center: point3, radius: Double, material: Material) {
        self.center = center
        self.radius = radius
        self.material = material
    }

    func isHitBy(_ r: Ray,
                 min tmin: Double, max tmax: Double,
                 _ rec: inout HitRecord) -> Bool {
        let oc = r.origin - center
        let a = length_squared(r.direction)
        let b = dot(oc, r.direction)
        let c = length_squared(oc) - radius * radius
        let discriminant = b * b - a * c
        if discriminant > 0 {
            // We have an intersection point.
            // The ray has hit the sphere at the point of intersection.
            // Take the smaller +ve value.
            var temp = (-b - sqrt(discriminant)) / a
            if temp < tmin {
                // Take the larger +ve value.
                temp = (-b + sqrt(discriminant) ) / a
            }
            if temp < tmax && temp > tmin {
                // We have an intersection point.
                rec.t = temp
                rec.p = r.at(rec.t)
                let outwardNormal = (rec.p - center) / radius
                rec.setFaceNormal(r, outwardNormal)
                rec.material = material         // added
                return true
            }
            //return false
        }
        // The intersection point is behind the viewer.
        return false
   }
}

