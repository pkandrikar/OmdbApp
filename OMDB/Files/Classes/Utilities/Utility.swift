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
    
    static func addGradientToView(_ view: UIView){
        let gradient: CAGradientLayer = CAGradientLayer()

        gradient.colors = [UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0), UIColor.black.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height)

        view.layer.insertSublayer(gradient, at: 0)
    }
}
