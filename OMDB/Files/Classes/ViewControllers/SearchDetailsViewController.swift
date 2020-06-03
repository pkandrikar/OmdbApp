//
//  SearchDetailsViewController.swift
//  OMDBAPI
//
//  Created by Piyush on 6/3/20.
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
    var movieDetails: MovieDetails?
    
    @IBOutlet weak var label_name: UILabel!
    @IBOutlet weak var movie_poster: UIImageView!
    @IBOutlet weak var view_imgHolder: UIView!
    @IBOutlet weak var view_gradient: UIView!
    
    @IBOutlet weak var label_year: UILabel!
    @IBOutlet weak var label_time: UILabel!
    @IBOutlet weak var label_genre: UILabel!
    @IBOutlet weak var label_synopsis: UILabel!
    @IBOutlet weak var label_score: UILabel!
    @IBOutlet weak var label_reviews: UILabel!
    @IBOutlet weak var label_popularity: UILabel!
    @IBOutlet weak var label_director: UILabel!
    @IBOutlet weak var label_writer: UILabel!
    @IBOutlet weak var label_actors: UILabel!
    
    var loadingView:UIActivityIndicatorView?
    lazy var viewModel = MovieDetailsViewModel()
    
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
        
        self.title = "Movie details"
        addLoadingView()
    
        if let name = name {
            label_name.text = name.capitalized
        }
        
        if let id = movieID {
            viewModel.getDetails(movieID: id) { (data, response, error) in
                if error == nil {
                    self.movieDetails = data
                    DispatchQueue.main.async {
                        self.plotScreen()
                    }
                }
            }
        }
    }
    
    func plotScreen() {
        guard let movieDetails = self.movieDetails else {
            return
        }
        
        Utility.addGradientToView(view_gradient)
        
        if let posterURL = movieDetails.poster {
            Utility.getImageFromURlString(posterURL, completion: { (img) in
                if let img = img {
                    DispatchQueue.main.async {
                        self.movie_poster.image = img
                        self.movie_poster.backgroundColor = UIColor.black
                        self.movie_poster.contentMode = .scaleAspectFill
                    }
                }
            })
        }
        
        label_year.text = movieDetails.year ?? "NA"
        label_time.text = movieDetails.runtime ?? "NA"
        label_genre.text = movieDetails.genre ?? "NA"
        label_synopsis.text = movieDetails.plot ?? "NA"
        
        label_score.text = movieDetails.metascore ?? "NA"
        label_reviews.text = movieDetails.imdbVotes ?? "NA"
        label_popularity.text = movieDetails.imdbRating ?? "NA"
        
        label_director.text = movieDetails.director ?? "NA"
        label_writer.text = movieDetails.writer ?? "NA"
        label_actors.text = movieDetails.actors ?? "NA"
        
        if let loadingView = self.loadingView {
            loadingView.stopAnimating()
            loadingView.removeFromSuperview()
        }
    }
    
    func addLoadingView() {
        loadingView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:  self.view.frame.size.height))
        if let loadingView = loadingView {
            loadingView.backgroundColor = UIColor.black;
            loadingView.startAnimating()
            self.view.addSubview(loadingView)
        }
    }
}
