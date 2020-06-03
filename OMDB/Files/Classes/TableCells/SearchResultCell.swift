//
//  SearchResultCell.swift
//  OMDBAPI
//
//  Created by Piyush on 6/3/20.
//  Copyright © 2020 Piyush Kandrikar. All rights reserved.
//

import UIKit
import Foundation

class SearchResultCell: UICollectionViewCell {
    
    //**************************************************
    //MARK: - Properties
    //**************************************************
    @IBOutlet weak var label_name: UILabel!
    @IBOutlet weak var poster_movie: UIImageView!
    @IBOutlet weak var label_year: UILabel!
    
    var loadingView:UIActivityIndicatorView?
    
    //**************************************************
    //MARK: - Constants
    //**************************************************
    
    
    //**************************************************
    //MARK: - Methods
    //**************************************************
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initWithData(_ name: String, year: String, thumbnail: String) {
        label_name.text = name.capitalized
        label_year.text = year
        self.poster_movie.image = UIImage(named: "ic_image_placeholder.png")
        self.poster_movie.contentMode = .center
        Utility.getImageFromURlString(thumbnail) { (img) in
            if let img = img {
                DispatchQueue.main.async {
                    self.showImage(img)
                }
            }
        }
    }
    
    func showImage(_ img: UIImage) {
        self.poster_movie.image = img
        self.poster_movie.contentMode = .scaleToFill
    }
    
}
