//
//  SearchViewModel.swift
//  OMDBAPI
//
//  Created by Piyush on 2/4/20.
//  Copyright © 2020 Piyush Kandrikar. All rights reserved.
//

import UIKit

class MovieDetailsViewModel: NSObject {
    
    //**************************************************
    //MARK: - Constants
    //**************************************************
    enum Constants {
        
    }
    
    //**************************************************
    //MARK: - Properties
    //**************************************************
    
    //**************************************************
    //MARK: - Methods
    //**************************************************
    
    func getDetails(movieID: String, completion: @escaping (MovieDetails?, URLResponse?, Error?) -> Void) {
        WebApiManager.sharedInstance.getMovieDetails(movieID: movieID) { (data, response, error) in
            completion(data, response, error)
        }
    }
    
}
