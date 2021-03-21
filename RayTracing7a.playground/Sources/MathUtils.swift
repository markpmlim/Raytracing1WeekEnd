import Foundation
import simd

typealias point3 = double3
typealias color = double3
typealias vec3 = double3

// Utility Functions
// Listing 23 - the built-in Double.pi constant is used.
func degrees_to_radians(_ degrees: Double) -> Double {
    return degrees * .pi / 180.0
}

// Listing 25
// arc4random() returns a UInt32
func random_double() -> Double {
    // Returns a random real number in [0,1).
    return Double(arc4random())/Double(UINT32_MAX)
}

func random_double(_ min: Double, _ max: Double) -> Double {
    // Returns a random real number in [min,max).
    return (min + (max-min)*random_double())
}
