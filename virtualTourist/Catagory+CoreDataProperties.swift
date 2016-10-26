//
//  Catagory+CoreDataProperties.swift
//  virtualTourist
//
//  Created by Warren Hansen on 10/26/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//

import Foundation
import CoreData


extension Catagory {

//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Catagory> {
//        return NSFetchRequest<Catagory>(entityName: "Catagory");
//    }

    @NSManaged public var catagoryName: String?

}
