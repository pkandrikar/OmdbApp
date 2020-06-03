//
//  SearchDetailsViewController.swift
//  OMDBAPI
//
//  Created by Piyush on 2/4/20.
//  Copyright © 2020 Piyush Kandrikar. All rights reserved.
//

import UIKit
import SafariServices

class SearchDetailsViewController: UIViewController {
    
    //**************************************************
    //MARK: - Properties
    //**************************************************
    var name: String?
    var posterURL: String?
    var movieID: String?
    
    @IBOutlet weak var label_name: UILabel!
    @IBOutlet weak var movie_poster: UIImageView!
    @IBOutlet weak var view_imgHolder: UIView!
    
    var loadingView:UIActivityIndicatorView?
    
    //**************************************************
    //MARK: - Constants
    //**************************************************
    enum Constants {
    }

    //**************************************************
    //MARK: - Methods
    //**************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plotScreen()
    }
    
    func plotScreen() {
        self.title = "Movie details"
        
        addLoadingView()
        
        if let webLink = posterURL {
            Utility.getImageFromURlString(webLink, completion: { (img) in
                if let img = img {
                    DispatchQueue.main.async {
                        self.movie_poster.image = img
                        if let loadingView = self.loadingView {
                            loadingView.stopAnimating()
                            loadingView.removeFromSuperview()
                        }
                    }
                }
            })
        }
        
        if let name = name {
            label_name.text = name.capitalized
        }
    }
    
    func addLoadingView() {
        loadingView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: view_imgHolder.frame.size.width, height: view_imgHolder.frame.size.height))
        if let loadingView = loadingView {
            loadingView.startAnimating()
            view_imgHolder.addSubview(loadingView)
        }
    }
}
