//
//  UIImage+Extension.swift
//  MarvelApp
//
//  Created by Jesus Parada on 26/09/21.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImage(with image: MarvelImage, size: ImageSize) {
        let urlString = image.path + "/\(size.rawValue)." + image.imageExtension
        let url = URL(string: urlString)
        if url == nil {return}
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }
        
        let loaderColor = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        let activityIndicator: UIActivityIndicatorView = loaderColor
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.center
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    activityIndicator.removeFromSuperview()
                }
            }
            
        }).resume()
    }
}
