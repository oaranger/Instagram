//
//  CustomImageView.swift
//  FirebaseInstagram
//
//  Created by Binh Huynh on 1/10/19.
//  Copyright © 2019 Binh Huynh. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    func loadImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        self.image = nil
        lastURLUsedToLoadImage = urlString
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch post images", error)
                return
            }            
            // prevent double loading of images from calling collectionView.reloadData() in UserProfileController
            if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }
            guard let imageData = data else { return }
            let photoImage = UIImage(data: imageData)
            imageCache[url.absoluteString] = photoImage            
            DispatchQueue.main.async {
                self.image = photoImage
            }
            }.resume()
    }
}
