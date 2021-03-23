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
    func scatter(_ rayIn: Ray,
                 _ rec: HitRecord,
                 _ attenuation: inout color,
                 _ scattered: inout Ray) -> Bool {
        // use the built-in function
        let reflected = reflect(normalize(rayIn.direction),
                                n: rec.normal)
        scattered = Ray(origin: rec.p,
                        direction: reflected + fuzz*random_in_unit_sphere())
        attenuation = albedo
        return dot(scattered.direction, rec.normal) > 0
    }
}


// Listing 60
class Dielectric: Material {
    var refractiveIndex: Double = 0      // Refractive Index

    init(_ ir: Double) {
        self.refractiveIndex = ir
    }

    // This method is called by the "rayColor" function (Image.swift)
    func scatter(_ rayIn: Ray,
                 _ rec: HitRecord,
                 _ attenuation: inout color,
                 _ scattered: inout Ray) -> Bool {
        attenuation = color(1.0, 1.0, 1.0)
        let refractiveRatio = rec.frontFace ? (1.0/refractiveIndex) : refractiveIndex

        let unitDirection = normalize(rayIn.direction)
        let cos_theta = fmin(dot(-unitDirection, rec.normal), 1.0)
        let sin_theta = sqrt(1.0 - cos_theta*cos_theta)

        let cannotRefract = refractiveRatio * sin_theta > 1.0
        var direction = vec3(0)

        if cannotRefract || reflectance(cos_theta, refractiveRatio) > random_double() {
            // use the built-in function
            direction = reflect(unitDirection, n: rec.normal)
        }
        else {
            // use the built-in function
            direction = refract(unitDirection, n: rec.normal, eta: refractiveRatio)
            //direction = refract(unitDirection, rec.normal, refractiveRatio)
        }

        scattered = Ray(origin: rec.p,
                        direction: direction)
        return true
    }

    private func reflectance(_ cosine: Double, _ refIndex: Double) -> Double {
        // Use Schlick's approximation for reflectance
        var r0 = (1 - refIndex)/(1 + refIndex)
        r0 = r0 * r0
        return r0 + (1-r0)*pow((1 - cosine), 5)
    }
}

