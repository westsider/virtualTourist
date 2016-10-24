//
//  FlickrPhotosViewController.swift
//  virtualTourist
//
//  Created by Warren Hansen on 10/20/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//
//  Help with displaying flickr images on collection view here
//  https://www.raywenderlich.com/136159/uicollectionview-tutorial-getting-started
//  create map page view controller
//  make a pin go to photos page

//  Use api to display photos from pin
//  34.04865771697618, -118.25183063251399

//  Add Core-data elements
//  store photos in core data
//  add delete pin
//  add reload photos
//  check against rubric


import UIKit
import MapKit

final class FlickrPhotosViewController: UICollectionViewController, MKMapViewDelegate {
    
    // MARK: - Properties
    fileprivate let reuseIdentifier = "FlickrCell"
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    fileprivate var searches = [FlickrSearchResults]()
    
    fileprivate let flickr = Flickr()
    
    fileprivate let itemsPerRow: CGFloat = 3
    
    var passedIntext:String = "not Sending In A string"
    
    var passedInPin:CLLocationCoordinate2D? = nil
 
    // MARK: Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // thisLocation
        print("This is the Pin in Phots VC: \(thisPin!)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("This is the Pre Pin: \(thisPin!)")

    }
}


//func searchPhotos() {
//    flickrClientInstance.searchPhotos("\(pin.latitude)", longitude: "\(pin.longitude)") { photoURLS, error in
//        guard let photoURLS = photoURLS else {
//            return
//        }
//        self.savePhotos(photoURLS)
//    }
//    
//}

// MARK: - Private
private extension FlickrPhotosViewController {
    func photoForIndexPath(indexPath: IndexPath) -> FlickrPhoto {
        return searches[(indexPath as NSIndexPath).section].searchResults[(indexPath as NSIndexPath).row]
    }
}

// MARK: extention for search text
extension FlickrPhotosViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        
        //textField.text = "\(thisLocation!)"
        flickr.searchFlickrForTerm("\(thisPin!.latitude), longitude: \(thisPin!.longitude)") {
        //flickr.searchFlickrForTerm(textField.text!) {
            results, error in
            
            activityIndicator.removeFromSuperview()
            
            if let error = error {
                print("Error searching : \(error)")
                return
            }
            
            if let results = results {
                print("Found \(results.searchResults.count) matching \(results.searchTerm)")
                self.searches.insert(results, at: 0)
                self.collectionView?.reloadData()
            }
        }
        
        
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UICollectionViewDataSource
extension FlickrPhotosViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searches.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
        return searches[section].searchResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,for: indexPath) as! FlickrPhotoCell
        let flickrPhoto = photoForIndexPath(indexPath: indexPath)
        cell.backgroundColor = UIColor.white
        cell.imageView.image = flickrPhoto.thumbnail
        return cell
    }
}

extension FlickrPhotosViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
