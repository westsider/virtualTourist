//
//  FlickrPhotosViewController.swift
//  virtualTourist
//
//  Created by Warren Hansen on 10/20/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//

// Store pins on core data
// Reload pins on relaunch
 
// Flickr API
// How do I send a pin to flicker search. Implement into a search
// Load photos from search
// Load pin on photos page
// Save the photos to core data
// Reload new photos
 
// Delete pins
 
// Save map location ion before quit: applicationWillTerminate may not be the ideal point in the app lifecycle to save lat,lon,zoom, as it only fires when the application is about to be terminated and purged from memory.
// Since the user navigates the map, a better place to save would be when the user stops navigating the map. See mapView(_:regionDidChangeAnimated:) within MKMapViewDelegate for additional optional MKMapViewmethods.




import UIKit
import MapKit
import CoreData

final class FlickrPhotosViewController: UICollectionViewController, MKMapViewDelegate {
    
    // MARK: - Properties
    fileprivate let reuseIdentifier = "FlickrCell"
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
//    fileprivate var searches = [FlickrSearchResults]()
//    
//    fileprivate let flickr = Flickr()
    
    fileprivate let itemsPerRow: CGFloat = 3
    
    var pin: Pin? = nil
 
    // MARK: Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // thisLocation
       // print("This is the Pin in Phots VC: \(thisPin!)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // print("This is the Pre Pin: \(thisPin!)")

    }
}


// MARK: - Private
//private extension FlickrPhotosViewController {
//    func photoForIndexPath(indexPath: IndexPath) -> FlickrPhoto {
//        return searches[(indexPath as NSIndexPath).section].searchResults[(indexPath as NSIndexPath).row]
//    }
//}

// MARK: extention for search text
//extension FlickrPhotosViewController : UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//        textField.addSubview(activityIndicator)
//        activityIndicator.frame = textField.bounds
//        activityIndicator.startAnimating()
//        
//        //textField.text = "\(thisLocation!)"
//        //flickr.searchFlickrForTerm("\(thisPin!.latitude), longitude: \(thisPin!.longitude)") {
//        flickr.searchFlickrForTerm(textField.text!) {
//            results, error in
//            
//            activityIndicator.removeFromSuperview()
//            
//            if let error = error {
//                print("Error searching : \(error)")
//                return
//            }
//            
//            if let results = results {
//                print("Found \(results.searchResults.count) matching \(results.searchTerm)")
//                self.searches.insert(results, at: 0)
//                self.collectionView?.reloadData()
//            }
//        }
//        
//        
//        textField.resignFirstResponder()
//        return true
//    }
//}

// MARK: - UICollectionViewDataSource
//extension FlickrPhotosViewController {
//    
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return searches.count
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
//        return searches[section].searchResults.count
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,for: indexPath) as! FlickrPhotoCell
//        let flickrPhoto = photoForIndexPath(indexPath: indexPath)
//        cell.backgroundColor = UIColor.white
//        cell.imageView.image = flickrPhoto.thumbnail
//        return cell
//    }
//}

//extension FlickrPhotosViewController : UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
//        let availableWidth = view.frame.width - paddingSpace
//        let widthPerItem = availableWidth / itemsPerRow
//        return CGSize(width: widthPerItem, height: widthPerItem)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//        return sectionInsets
//    }
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return sectionInsets.left
//    }
//}
