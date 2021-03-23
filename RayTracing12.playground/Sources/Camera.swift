import Foundation
import simd

// The rectangular view port has coordinates:
// (-1.78,-1,0), (1.78,-1,0), (1.78,1,0), (-1.78,1,0)
// Listing 68
class Camera {
    private var origin: point3
    private var horizontal: vec3
    private var vertical: vec3
    private var lowerLeftCorner: point3
    private var lensRadius: Double
    private var u: vec3
    private var v: vec3
    private var w: vec3

    init(_ lookFrom: point3,
         _ lookAt: point3,
         _ vUp: vec3,
         _ vfov: Double,            // vertical field-of-view in degrees
         _ aspectRatio: Double,
         _ aperture: Double,
         _ focusDist: Double) {
        let theta = degrees_to_radians(vfov)
        let h: Double = tan(theta/2)
        let viewPortHeight: Double = 2.0 * h
        let viewPortWidth = aspectRatio * viewPortHeight

        w = normalize(lookFrom - lookAt)
        u = normalize(cross(vUp, w))
        v = cross(w, u)

        origin = lookFrom
        horizontal = focusDist * viewPortWidth * u
        vertical = focusDist * viewPortHeight * v
        lowerLeftCorner = origin - horizontal/2 - vertical/2 - focusDist*w

        lensRadius = aperture/2
    }

    // Projects a ray from the camera's location towards the direction computed using
    // the horizotal & vertical offset from the lower left corner of rectangular view port.
    func getRay(_ st: double2) -> Ray {
        let rd = lensRadius * random_in_unit_disk()
        let offset = u * rd.x + v * rd.y

        return Ray(origin: origin+offset,
                   direction: lowerLeftCorner + st.x * horizontal + st.y * vertical - origin - offset)
    }
}
