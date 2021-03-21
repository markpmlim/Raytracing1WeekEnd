import Foundation
import simd

typealias color = double3
typealias vec3 = double3
typealias point3 = double3

// Listing 25
// arc4random() returns a UInt32
func random_double() -> Double {
    // Returns a random real number in [0,1).
    return Double(arc4random())/Double(UINT32_MAX)
}

func random_double(_ min: Double, _ max: Double) -> Double {
    // Returns a random real number in [min,max).
    return (min + (max-min)*random_double())
    //return min + Double(arc4random()) / (Double(UINT32_MAX) * (max - min))
}

func random() -> vec3 {
    return vec3(random_double(),
                random_double(),
                random_double())
}

func random(_ min: Double, _ max: Double) -> vec3 {
    return vec3(random_double(min, max),
                random_double(min, max),
                random_double(min, max))
}

/*
// Pick a random point in a unit sphere
// drand48() returns a real number in [0, 1]
func random_in_unit_sphere() -> vec3 {
    var p = vec3(0)
    repeat {
        p = 2.0 * vec3(drand48(),
                       drand48(),
                       drand48()) - vec3(1, 1, 1)
    } while dot(p, p) >= 1.0
    return p
}
 */

// Listing 32.
func random_in_unit_sphere() -> vec3 {
    while true {
        let p = random(-1.0, 1.0)
        if dot(p, p) >= 1.0 {
            continue
        }
        return p
    }
}

// Listing 37
func random_unit_vector() -> vec3 {
    return normalize(random_in_unit_sphere())
}

// Listing 39
func random_in_hemisphere(normal: vec3) -> vec3 {
    let in_unit_sphere = random_in_unit_sphere()
    if dot(in_unit_sphere, normal) > 0.0 {
        return in_unit_sphere
    }
    else {
        return -in_unit_sphere
    }
}

extension double3 {
    func near_zero() -> Bool {
        // Return true if the vector is close to zero in all dimensions.
        let s = 1e-8
        return (fabs(x) < s) && (fabs(y) < s) && (fabs(z) < s)
    }
}
