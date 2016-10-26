//
//  MapViewController.swift
//  virtualTourist
//
//  Created by Warren Hansen on 10/22/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//
//  Store pins on core data
//  Reload pins on relaunch

//  Save Map Location on relaunch
//  Delete pins

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    var pins = [Pin]()
    var selectedPin: Pin? = nil
    
    // Flag for editing mode
    var editingPins = false
    
    // Core Data
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    // MARK: Retrieve Stored Pins
    func fetchAllPins() -> [Pin] {
        
        // Create the fetch request
        let fetchRequest = NSFetchRequest<Pin>(entityName: "Pin")
        
        // Execute the fetch request
        do {
            return try sharedContext.fetch(fetchRequest)
        } catch {
            print("error in fetch")
            return [Pin]()
        }
    }
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let latitude: CLLocationDegrees = 34.052235
        
        let longitude: CLLocationDegrees = -118.243683
        
        let latDelta: CLLocationDegrees = 0.05  // bigger = wider view
        
        let lonDelta: CLLocationDegrees = 0.05
        
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
        
        // add user annotation
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.longPress(getstureRecognizer:)))
        
        uilpgr.minimumPressDuration = 1

        mapView.addGestureRecognizer(uilpgr)
        // Set the map view delegate
        mapView.delegate = self
//deleteLabel.isHidden = true
        
        addSavedPinsToMap()
        
    }

//    // When the edit button is clicked, show the 'Done' button and flag the editingPins to true
//    @IBAction func editClicked(_ sender: UIBarButtonItem) {
//        
//        if editingPins == false {
//            editingPins = true
//            deleteLabel.isHidden = false
//            navigationItem.rightBarButtonItem?.title = "Done"
//            
//        }
//            
//        else if editingPins {
//            navigationItem.rightBarButtonItem?.title = "Edit"
//            editingPins = false
//            deleteLabel.isHidden = true
//        }
//        
//    }
    
    // Find all the saved pins and show it on the mapView
    func addSavedPinsToMap() {
        
        pins = fetchAllPins()
        print("Pin count in core data is \(pins.count)")
        
        for pin in pins {
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = pin.coordinate
            annotation.title = pin.pinTitle
            mapView.addAnnotation(annotation)
        }
    }
    
    // MARK: Long Press Sets Pin
    // Reference: http://stackoverflow.com/questions/5182082/mkmapview-drop-a-pin-on-touch
    func longPress(getstureRecognizer: UIGestureRecognizer) {
         // If it's in editing mode, do nothing
                if (editingPins) {
                    return
                } else {
        
        if getstureRecognizer.state != .began { return }
        
        let touchPoint = getstureRecognizer.location(in: self.mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = touchMapCoordinate
        
        let newPin = Pin(lat: annotation.coordinate.latitude, long: annotation.coordinate.longitude, context: sharedContext)
        
        // Saving to core data
        CoreDataStackManager.sharedInstance().saveContext()
        
        // Adding the newPin to the pins array
        pins.append(newPin)
        print("Pin Array: \(pins) Count: \(pins.count)")
        
        // Adding the newPin to the map
        mapView.addAnnotation(annotation)
        
// Downloading photos for new pin (only download it if it's a new pin)
//FlickrClient.sharedInstance().downloadPhotosForPin(newPin) { (success, error) in print("downloadPhotosForPin is success:\(success) - error:\(error)") }
        
        // Find out the location name based on the coordinates
        let coordinates = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(coordinates, completionHandler: { (placemark, error) -> Void in
            if error != nil {
                print("Error: \(error!.localizedDescription)")
                return
            }
            if placemark!.count > 0 {
                let pm = placemark![0] as CLPlacemark
                if (pm.locality != nil) && (pm.country != nil) {
                    // Assigning the city and country to the annotation's title
                    annotation.title = "\(pm.locality!), \(pm.country!)"
                }
            } else {
                print("Error with placemark")
            }
        })
        
    }
}

// MARK: Tap Pin to Segue
func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    //print("Pin Tapped Pin = \(thisPin!)")
    performSegue(withIdentifier: "toThePhotos", sender: self)
}

func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "toThePhotos" {
        //let photosVC = segue.destination as! FlickrPhotosViewController
        //            print("Prepare for Segue: \(thisLocation!))")
        //            photosVC.passedInPin = thisLocation
    }
}



}
