import Foundation
import simd

// Listing 19
class Sphere: Hittable  {
    var center: point3
    var radius: Double

    init(center: point3, radius: Double) {
        self.center = center
        self.radius = radius
    }

    // A hit only counts when tmin < t < tmax; so in the
    // event of a hit, the function returns true and the
    // returned instance of HitRecord is valid.
    func isHitBy(_ r: Ray,
                 min tmin: Double, max tmax: Double,
                 _ rec: inout HitRecord) -> Bool {
        let oc = r.origin - center
        let a = length_squared(r.direction)
        let half_b = dot(oc, r.direction)
        let c = length_squared(oc) - radius * radius

        let discriminant = half_b*half_b - a*c
        if discriminant < 0 {
            // The intersection point is behind the viewer.
            return false
        }
        // We have an intersection point.
        // The ray has hit the sphere at the point of intersection.
        // Take the smaller +ve value.
        let sqrtd = sqrt(discriminant)
        var root = (-half_b - sqrtd) / a
        if root < tmin || tmax < root {
            root = (-half_b + sqrtd) / a
            if root < tmin || tmax < root {
                return false
            }
        }

        rec.t = root
        rec.p = r.at(rec.t)
        let outwardNormal = (rec.p - center) / radius
        rec.setFaceNormal(r, outwardNormal)

        return true
   }
}

