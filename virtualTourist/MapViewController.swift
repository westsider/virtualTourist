//
//  MapViewController.swift
//  virtualTourist
//
//  Created by Warren Hansen on 10/22/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var deleteLabel: UILabel!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
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
        
        let latitude: CLLocationDegrees = 33.994275
        let longitude: CLLocationDegrees = -118.4547197
        let latDelta: CLLocationDegrees = 0.1  // bigger = wider view
        let lonDelta: CLLocationDegrees = 0.1
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
        deleteLabel.isHidden = true
        // load prior pins
        addSavedPinsToMap()
        
    }
    
    // MARK:  When the edit button is clicked, show the 'Done' button and flag the editingPins to true
    @IBAction func editButtonClicked(_ sender: UIBarButtonItem) {
        if editingPins == false {
            editingPins = true
            deleteLabel.isHidden = false
            navigationItem.rightBarButtonItem?.title = "Done"
        }
        else if editingPins {
            navigationItem.rightBarButtonItem?.title = "Edit"
            editingPins = false
            deleteLabel.isHidden = true
        }
    }
    
    // MARK:  Find all the saved pins and show it on the mapView
    func addSavedPinsToMap() {
        
        pins = fetchAllPins()
        print("\r\nPin count in core data is \(pins.count)")
        
        for pin in pins {
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = pin.coordinate
            annotation.title = pin.pinTitle
            mapView.addAnnotation(annotation)
        }
    }
    
    // MARK: Set Pin Behavior
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
            print("\r\n Pin Array: \(pins) Count: \(pins.count)")
            
            // Adding the newPin to the map
            mapView.addAnnotation(annotation)
            
            // MARK:  Downloading photos for new pin (only download it if it's a new pin)
           FlickrClient.sharedInstance().downloadPhotosForPin(newPin) { (success, error) in
            
            print("\r\ndownloadPhotosForPin is success:\(success) - error:\(error)") }
            print("\r\nNew Pin Set and Downloaded \(newPin)")
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
    
    // Mark: - When a pin is tapped, it will transition to the Phone Album View Controller
    // Update the view for the annotation this allows you to intercept taps on the annotation's view (the pin).
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        annotationView.canShowCallout = false
        
        return annotationView
    }
    
    // MARK:  Selecting Pin Behavior
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        mapView.deselectAnnotation(view.annotation, animated: true)
        guard let annotation = view.annotation else { /* no annotation */ return }
        
        let title = annotation.title!
        print(annotation.title)
        
        selectedPin = nil
        
        for pin in pins {
            
            if annotation.coordinate.latitude == pin.latitude && annotation.coordinate.longitude == pin.longitude {
                
                selectedPin = pin
                
                if editingPins {
                    print("\r\n Deleting pin - verify core data is deleting as well")
                    sharedContext.delete(selectedPin!)
                    
                    // Deleting selected pin on map
                    self.mapView.removeAnnotation(annotation)
                    
                    // Save the chanages to core data
                    CoreDataStackManager.sharedInstance().saveContext()
                    
                } else {
                    
                    if title != nil {
                        pin.pinTitle = title!
                        
                    } else {
                        pin.pinTitle = "This pin has no name"
                    }
                    // Move to the Phone Album View Controller
                    self.performSegue(withIdentifier: "toThePhotos", sender: nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toThePhotos") {
            print("\r\n<<<<<<<<<<< func prepare Selected Pin: \(selectedPin)")
            let viewController = segue.destination as! PhotoAlbumViewController
            viewController.pin = selectedPin
        }
    }
    
//    // MARK: Segue to Photos VC
//    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "toThePhotos" {
//            let viewController = segue.destination as! PhotoAlbumViewController
//            viewController.pin = selectedPin
//            print("<<<<<<<<<<<<<<< Sending pin: \(selectedPin!)")
//        }
//    }
}
