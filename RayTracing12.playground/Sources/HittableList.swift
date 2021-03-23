//
//  HittableList.swift
//  
//
//  Created by Mark Lim Pak Mun on 16/03/2021.
//

import Foundation

class HittableList: Hittable {
    var list: [Hittable]
    
    init(_ list: [Hittable]) {
        self.list = list
    }
    
    // On return, the instance of HitRecord will be valid if true.
    func isHitBy(_ r: Ray,
                 min tmin: Double, max tmax: Double,
                 _ rec: inout HitRecord) -> Bool {
        
        // Instantiate a (zeroed) hit record
        var tempRec = HitRecord()
        var hitAnything = false
        var closestSoFar = tmax
        for item in list {
            if item.isHitBy(r, min: tmin, max: closestSoFar, &tempRec) {
                hitAnything = true
                closestSoFar = tempRec.t
                rec = tempRec
            }
        }
        return hitAnything
    }
}
