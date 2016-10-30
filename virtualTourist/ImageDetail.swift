//
//  ImageScrollView.swift
//  virtualTourist
//
//  Created by Warren Hansen on 10/27/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//

import UIKit

class ImageDetailView: UIViewController {
    
    
    @IBOutlet weak var myImageView: UIImageView!
    
    var selectedImage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedImage)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // ToDo: - I should probably list the title of the image
        let imageUrl = URL(string:self.selectedImage)
        let imageData = try? Data(contentsOf: imageUrl!)
        if (imageData != nil)
        {
            self.myImageView.image  = UIImage(data: imageData!)
        }
    }
}
