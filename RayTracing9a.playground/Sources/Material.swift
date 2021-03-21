import simd

protocol Material {
    func scatter(_  rayIn: Ray,
                 _ rec: HitRecord,
                 _ attenuation: inout color,
                 _ scattered: inout Ray) -> Bool
}

// Listing 46
class Lambertian: Material {
    var albedo: color

    init(albedo: color) {
        self.albedo = albedo
    }

    func scatter(_  rayIn: Ray,
                 _ rec: HitRecord,
                 _ attenuation: inout color,
                 _ scattered: inout Ray) -> Bool {
        var scatterDirection = rec.normal + random_unit_vector()

        // Catch degenerate scatter direction
        if (scatterDirection.near_zero()) {
            scatterDirection = rec.normal
        }
        scattered = Ray(origin: rec.p,
                        direction: scatterDirection)
        attenuation = albedo
        return true
    }
}

// Listing 48
class Metal: Material {
    var albedo: color

    init(albedo: color) {
        self.albedo = albedo
    }

    // This method is called by the "rayColor" function (Image.swift)
    func scatter(_  rayIn: Ray,
                 _ rec: HitRecord,
                 _ attenuation: inout color,
                 _ scattered: inout Ray) -> Bool {
        // Use the built-in function
        let reflected = reflect(normalize(rayIn.direction),
                                n: rec.normal)
        scattered = Ray(origin: rec.p, direction: reflected)
        attenuation = albedo
        return dot(scattered.direction, rec.normal) > 0
    }
}


