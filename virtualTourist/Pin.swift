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

@objc(Pin)
class Pin: NSManagedObject {
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // In Swift, superclass initializers are not available to subclasses, so it is necessary to include this initializer and call the superclass' implementation of it.
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(lat: Double, long: Double, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "Pin", in: context)!
        super.init(entity: entity, insertInto: context)
        
        self.latitude = lat
        self.longitude = long
        self.pageNumber = 0
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
        
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
