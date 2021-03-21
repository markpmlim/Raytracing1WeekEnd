import Foundation
import simd

// Listing 27
// The rectangular view port has coordinates:
// (-1.78,-1,0), (1.78,-1,0), (1.78,1,0), (-1.78,1,0)
// Listing 27
class Camera {
    var origin: point3
    var horizontal: vec3
    var vertical: vec3
    var lowerLeftCorner: point3

    init() {
        let aspectRatio: Double = 16.0/9.0
        let viewPortHeight: Double = 2.0
        let viewPortWidth = aspectRatio * viewPortHeight
        let focalLength: Double = 1.0

        origin = point3(0.0, 0.0, 0.0)
        horizontal = vec3(viewPortWidth, 0.0, 0.0)
        vertical = vec3(0.0, viewPortHeight, 0.0)
        lowerLeftCorner = origin - horizontal/2 - vertical/2 - vec3(0, 0, focalLength)
   }

    // Projects a ray from the camera's location towards the direction computed using
    // the horizotal & vertical offset from the lower left corner of rectangular view port.
    func getRay(_ uv: double2) -> Ray {
        return Ray(origin: origin,
                   direction: lowerLeftCorner + uv.x * horizontal + uv.y * vertical - origin)
    }
}
