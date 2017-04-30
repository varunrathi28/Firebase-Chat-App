//
//  Extensions.swift
//  FireChat
//
//  Created by Varun Rathi on 30/04/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView
{

  func  loadCachedImageWith(url:String)
    {

        if let cachedImage = imageCache.object(forKey: url as NSString)
        {
            self.image = cachedImage
        }
        
        else
        {
            let imageURL = URL(string:url)
            URLSession.shared.dataTask(with: imageURL!, completionHandler: { (data, response, error) in
                
                if error != nil
                {
                    print(error)
                    return
                }
                
                DispatchQueue.main.async {
                    
                    if let downladedImage =  UIImage(data: data!)
                    {
                        imageCache.setObject(downladedImage, forKey: url as NSString)
                        self.image = downladedImage
                    }
                    
                }
                
            }).resume()
        }
    }
}
