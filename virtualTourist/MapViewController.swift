//
//  MapViewController.swift
//  virtualTourist
//
//  Created by Warren Hansen on 10/22/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//

import UIKit
import MapKit

//var thisLocation:CLLocationCoordinate2D? = nil
var thisPin:Pin? = nil

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet var mapView: MKMapView!

    
    
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
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.longPress(gestureReconizer:)))
        
        uilpgr.minimumPressDuration = 1
        
        mapView.addGestureRecognizer(uilpgr)
        
    }
    
    // MARK: Long Press Sets Pin
    func longPress(gestureReconizer: UIGestureRecognizer) {
        let touchPoint = gestureReconizer.location(in: self.mapView)
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        
        thisPin = Pin(coordinate: coordinate, latitude: latitude, longitude: longitude)
        let annotation = MKPointAnnotation()
        
        //thisPin = Pin(coordinate: coordinate, latitude: map, longitude: <#T##CLLocationDegrees#>)
//        thisLocation = coordinate
//        if thisLocation != nil {
//             print("Setting the Pin: \(thisLocation!)")
//        } else {
//            print("The location is Nil")
//        }
       
        
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
       
        // let thisPin = Pin(coordinate: coordinate)
        
        /*
            let point = gestureRecognizer.locationInView(mapView)
            let coordinate = mapView.convertPoint(point, toCoordinateFromView: mapView)
            let latitude = coordinate.latitude
            let longitude = coordinate.longitude
 
            let annotation = Pin(latitude: latitude, longitude: longitude, context: stack.context)
            mapView.addAnnotation(annotation)
            stack.save()
         */
    }

    // MARK: Tap Pin
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Pin Tapped Pin = \(thisPin!)")
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
