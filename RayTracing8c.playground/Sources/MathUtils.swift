import Foundation
import simd

typealias point3 = double3
typealias color = double3
typealias vec3 = double3

// Listing 26
// arc4random() returns a UInt32
func random_double() -> Double {
    // Returns a random real number in [0,1).
    return Double(arc4random())/Double(UINT32_MAX)
}

func random_double(_ min: Double, _ max: Double) -> Double {
    // Returns a random real number in [min,max).
    return (min + (max-min)*random_double())
}

// Listing 31
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

// Listing 32
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
