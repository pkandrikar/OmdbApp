//
//  Utility.swift
//  OMDBAPI
//
//  Created by Piyush on 2/4/20.
//  Copyright © 2020 Piyush Kandrikar. All rights reserved.
//

import UIKit
import Foundation

let imgCache = NSCache<NSString, AnyObject>()

class Utility: NSObject {
    static func getImageFromURlString(_ urlStr: String, completion: @escaping (UIImage?)->Void)  {
        if let cachedImg = imgCache.object(forKey: NSString(string: urlStr)) as? UIImage {
            completion(cachedImg)
            return
        }
        
        let url = URL(string: urlStr)
        if let url = url {
            DispatchQueue.global(qos: .background).async {
                URLSession.shared.dataTask(with: url) { (data, res, err) in
                    if let dataNew = data, let img = UIImage(data: dataNew) {
                        imgCache.setObject(img, forKey: NSString(string: urlStr))
                        completion(img)
                    }else {
                        completion(nil)
                    }
                }.resume()
            }
        }
    }
    
    static func addShadowToView(_ view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 5
    }
}
