import simd

protocol Material {
    func scatter(_  rayIn: Ray,
                 _ rec: HitRecord,
                 _ attenuation: inout color,
                 _ scattered: inout Ray) -> Bool
}

// Listing 44
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

// Listing 51
class Metal: Material {
    var albedo: color
    var fuzz: Double

    init(albedo: color, fuzz: Double) {
        self.albedo = albedo
        self.fuzz = fuzz < 1.0 ? fuzz : 1.0
    }

    // This method is called by the "rayColor" function (Image.swift)
    func scatter(_  rayIn: Ray,
                 _ rec: HitRecord,
                 _ attenuation: inout color,
                 _ scattered: inout Ray) -> Bool {
        let reflected = reflect(normalize(rayIn.direction),
                                n: rec.normal)
        scattered = Ray(origin: rec.p,
                        direction: reflected + fuzz*random_in_unit_sphere())
        attenuation = albedo
        return dot(scattered.direction, rec.normal) > 0
    }
}


