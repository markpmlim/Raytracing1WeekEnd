import Foundation
import simd

typealias point3 = double3
typealias color = double3
typealias vec3 = double3

// Utility Functions
// Listing 23
func degrees_to_radians(_ degrees: Double) -> Double {
    return degrees * .pi / 180.0
}
