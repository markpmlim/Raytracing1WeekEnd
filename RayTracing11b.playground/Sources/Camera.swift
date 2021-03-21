import Foundation
import simd

// The rectangular view port has coordinates:
// (-1.78,-1,0), (1.78,-1,0), (1.78,1,0), (-1.78,1,0)
// Listing 64
class Camera {
    var origin: point3
    var horizontal: vec3
    var vertical: vec3
    var lowerLeftCorner: point3

    init(_ lookFrom: point3,
         _ lookAt: point3,
         _ vUp: vec3,
         _ vfov: Double,            // vertical field-of-view in degrees
         _ aspectRatio: Double) {
        let theta = degrees_to_radians(vfov)
        let h: Double = tan(theta/2)
        let viewPortHeight: Double = 2.0 * h
        let viewPortWidth = aspectRatio * viewPortHeight

        let w = normalize(lookFrom - lookAt)
        let u = normalize(cross(vUp, w))
        let v = cross(w, u)

        origin = lookFrom
        horizontal = viewPortWidth * u
        vertical = viewPortHeight * v
        lowerLeftCorner = origin - horizontal/2 - vertical/2 - w
   }

    // Projects a ray from the camera's location towards the direction computed using
    // the horizotal & vertical offset from the lower left corner of rectangular view port.
    func getRay(_ uv: double2) -> Ray {
        return Ray(origin: origin,
                   direction: lowerLeftCorner + uv.x * horizontal + uv.y * vertical - origin)
    }
}
