//
//  Photos.swift
//  virtualTourist
//
//  Created by Warren Hansen on 10/26/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//  Photo object need to  images stored as Binary Type in thenentity with the “Allows External Storage” option active?

import Foundation
import CoreData
import UIKit


@objc(Photos)
class Photos: NSManagedObject {
    
    
    
    // MARK: - Init model
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(photoURL: String, pin: Pin, context: NSManagedObjectContext){
        
        let entity = NSEntityDescription.entity(forEntityName: "Photos", in: context)!
        super.init(entity: entity, insertInto: context)
        self.url = photoURL
        self.pin = pin
        print("init from Photos.swift\(url)")
        
    }
    
    //MARK: - Delete file when deleting a managed object
    override func prepareForDeletion(){
        super.prepareForDeletion()
        
        //        if filePath != nil{
        //            // Delete the associated image file when the Photos managed object is deleted.
        //            let fileName = (filePath! as NSString).lastPathComponent
        //
        //            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        //            let pathArray = [dirPath, fileName]
        //            let fileURL = NSURL.fileURL(withPathComponents: pathArray)!
        //
        //            do {
        //                try FileManager.default.removeItem(at: fileURL)
        //            } catch let error as NSError {
        //                print("Error from prepareForDeletion - \(error)")
        //            }
        //        } else { print("filepath is empty")}
    }
}
