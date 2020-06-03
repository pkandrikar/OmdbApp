//
//  SearchResultViewModel.swift
//  OMDBAPI
//
//  Created by Piyush on 6/3/20.
//  Copyright © 2020 Piyush Kandrikar. All rights reserved.
//

import UIKit

class SearchResultViewModel: NSObject {
    
    //**************************************************
    //MARK: - Properties
    //**************************************************
    var pageNumber = 1
    private var searchResult: [SearchItem] = []
    
    //**************************************************
    //MARK: - Methods
    //**************************************************
    func getSearchResult(completion: @escaping ([SearchItem]?, URLResponse?, Error?) -> Void) {
        guard let keyword = SearchManager.sharedInstance.getSearchKeyword() else { return }
        
        WebApiManager.sharedInstance.getSearchResult(searchKeyword: keyword, pageNumber: pageNumber) { (data, response, error) in
            if let data = data, data.count > 0 {
                self.pageNumber += 1
            }
            completion(data, response, error)
        }
    }
    
    func setPageNumber() {
        pageNumber = 1
    }
    
    func getSearchResults() -> [SearchItem] {
        return searchResult
    }
    func appendSearchResults(_ results: [SearchItem]) {
        searchResult.append(contentsOf: results)
    }
    func getSearchResultsCount() -> Int {
        return searchResult.count
    }
    
}
