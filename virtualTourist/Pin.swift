//
//  Pin.swift
//  virtualTourist
//
//  Created by Warren Hansen on 10/22/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//

import Foundation
import CoreData
import MapKit


class Pin {
    var coordinate: CLLocationCoordinate2D
   // var latitude: CLLocationDegrees
   // var longitude: CLLocationDegrees
    init(coordinate: CLLocationCoordinate2D
        //, latitude: CLLocationDegrees, longitude:CLLocationDegrees
        )
    {
        self.coordinate = coordinate
//        self.latitude = latitude
//        self.longitude = longitude
    }

}

/*
 class Starship: FullyNamed {
 var prefix: String?
 var name: String
 init(name: String, prefix: String? = nil)
 {
 self.name = name
 self.prefix = prefix
 }
 var fullName: String {
 return (prefix != nil ? prefix! + " " : "") + name
 }
 }
 var ncc1701 = Starship(name: "Enterprise", prefix: "USS")
 // ncc1701.fullName is "USS Enterprise"
 */
//struct Pin {
//    var coordinate: CLLocationCoordinate2D
//}

// Pin: NSManagedObject, MKAnnotation {
//    var coordinate: CLLocationCoordinate2D {
//        return CLLocationCoordinate2DMake(latitude, longitude)
//    }
//    
//    convenience init(latitude: Double, longitude: Double, context: NSManagedObjectContext) {
//        if let ent = NSEntityDescription.entityForName("Pin", inManagedObjectContext: context) {
//            self.init(entity: ent, insertIntoManagedObjectContext: context)
//            self.latitude = latitude
//            self.longitude = longitude
//        } else {
//            fatalError("Unable to find Entity name!")
//        }
//    }
//}
