import Foundation
import simd

class Ray {
    var origin: point3      // position of camera/eye
    var direction: vec3     // direction of vector from origin to surface (not normalized)
    
    init(origin: point3, direction: vec3) {
        self.origin = origin
        self.direction = direction
    }
    
    func at(_ t: Double) -> point3 {
        return origin + t * direction
    }
}
