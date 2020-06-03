//
//  WebApiManager.swift
//  OMDBAPI
//
//  Created by Piyush on 2/4/20.
//  Copyright © 2020 Piyush Kandrikar. All rights reserved.
//

import Foundation
import UIKit

class WebApiManager: NSObject {
    //**************************************************
    //MARK: - Properties
    //**************************************************
    static let sharedInstance: WebApiManager = WebApiManager()
    
    //**************************************************
    //MARK: - Methods
    //**************************************************
    private override init() {
        
    }
    
    func getSearchResult(searchKeyword: String, pageNumber: Int, completionHandler: @escaping ([SearchItem]?, URLResponse?, Error?) -> Void) {
        
        let url_str = ApiConstants.OmdbAPI.search_keyword + searchKeyword + "&type=" + ApiConstants.TYPE
        guard let url = URL(string: url_str) else {
            return
        }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            if let data = data {
                do {
                    let responseModel = try JSONDecoder().decode(SearchResult_Base.self, from: data)
                    if let items = responseModel.search {
                        completionHandler(items, nil, nil)
                    }else{
                        let error_custom = NSError(domain: "", code: 400, userInfo: ["description" : "No more result found for your search."])
                        completionHandler(nil, nil, error_custom)
                    }
                } catch  {
                    let error_custom = NSError(domain: "", code: 400, userInfo: ["description" : "No more search result found."])
                    completionHandler(nil, nil, error_custom)
                }
            }else {
                let error_custom = NSError(domain: "", code: 400, userInfo: ["description" : "No more search result found."])
                completionHandler(nil, nil, error_custom)
            }
        }
        task.resume()
    }
    
    func getMovieDetails(movieID: String, completionHandler: @escaping (MovieDetails?, URLResponse?, Error?) -> Void) {
        
        let url_str = ApiConstants.OmdbAPI.movie_details + movieID
        guard let url = URL(string: url_str) else {
            return
        }
        let request = URLRequest(url: url)
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            if let data = data {
                do {
                    let responseModel = try JSONDecoder().decode(MovieDetails.self, from: data)
                    completionHandler(responseModel, nil, nil)
                } catch  {
                    completionHandler(nil, nil, self.getMovieDetailsError())
                }
            }else {
                completionHandler(nil, nil, self.getMovieDetailsError())
            }
        }
        task.resume()
    }
    
    func getMovieDetailsError() -> NSError{
        return NSError(domain: "", code: 400, userInfo: ["description" : "No data found"])
    }
}
