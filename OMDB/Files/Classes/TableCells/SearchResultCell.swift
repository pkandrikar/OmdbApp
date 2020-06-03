//
//  SearchResultCell.swift
//  OMDBAPI
//
//  Created by Piyush on 2/4/20.
//  Copyright © 2020 Piyush Kandrikar. All rights reserved.
//

import UIKit
import Foundation

class SearchResultCell: UITableViewCell {
    
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func initWithData(_ name: String, year: String, thumbnail: String) {
        label_name.text = name.capitalized
        label_year.text = year
        self.poster_movie.image = nil
        addLoadingView()
        
        Utility.getImageFromURlString(thumbnail) { (img) in
            if let img = img {
                DispatchQueue.main.async {
                    self.showImage(img)
                }
            }
        }
    }
    
    func addLoadingView() {
        loadingView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: poster_movie.frame.size.width, height: poster_movie.frame.size.height))
        if let loadingView = loadingView {
            loadingView.startAnimating()
            poster_movie.addSubview(loadingView)
        }
    }
    func removeLoadingView() {
        if let loadingView = self.loadingView {
            loadingView.stopAnimating()
            loadingView.removeFromSuperview()
        }
    }
    
    func showImage(_ img: UIImage) {
        self.poster_movie.image = img
        self.removeLoadingView()
    }
    
}
