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


// Listing 53 - not used.
func refract(_ uv: vec3, _ n: vec3, _ etai_over_etat: Double) -> vec3 {
    let cos_theta = fmin(dot(-uv, n), 1.0)
    let r_out_perp =  etai_over_etat * (uv + cos_theta*n);
    let r_out_parallel = -sqrt(fabs(1.0 - length_squared(r_out_perp))) * n;
    return r_out_perp + r_out_parallel;
}

extension double3 {
    func near_zero() -> Bool {
        // Return true if the vector is close to zero in all dimensions.
        let s = 1e-8
        return (fabs(x) < s) && (fabs(y) < s) && (fabs(z) < s)
    }
}
