import Foundation
import simd

class Sphere: Hittable  {
    var center: point3 = point3(0)
    var radius: Double = 0

    init(center: point3, radius: Double) {
        self.center = center
        self.radius = radius
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
            if temp < tmax && temp > tmin {
                rec.t = temp
                rec.p = r.at(rec.t)
                let outwardNormal = (rec.p - center) / radius
                rec.setFaceNormal(r, outwardNormal)
                return true
            }

            // Take the larger +ve value.
            temp = (-b + sqrt(discriminant)) / a
            if temp < tmax && temp > tmin {
                // We have an intersection point.
                rec.t = temp
                rec.p = r.at(rec.t)
                let outwardNormal = (rec.p - center) / radius
                rec.setFaceNormal(r, outwardNormal)
                return true
            }
            return false
        }
        // The intersection point is behind the viewer.
        return false
   }
}

