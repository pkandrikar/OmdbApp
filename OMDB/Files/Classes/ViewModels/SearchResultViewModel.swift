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
    var pageNumber = SearchResultViewModel.getLastStoredIndex()
    private var searchResult: [SearchItem] = []
    
    //**************************************************
    //MARK: - Methods
    //**************************************************
    func getSearchResult(completion: @escaping ([SearchItem]?, URLResponse?, Error?) -> Void) {
        guard let keyword = SearchManager.sharedInstance.getSearchKeyword() else { return }
        
        UserDefaults.standard.set(pageNumber, forKey: SearchResultViewModel.getLastStoredIndexKey())
        UserDefaults.standard.synchronize()
        
        WebApiManager.sharedInstance.getSearchResult(searchKeyword: keyword, pageNumber: pageNumber) { (data, response, error) in
            if let data = data, data.count > 0 {
                self.pageNumber += 1
                UserDefaults.standard.set(self.pageNumber, forKey: SearchResultViewModel.getLastStoredIndexKey())
                UserDefaults.standard.synchronize()
            }
            completion(data, response, error)
        }
    }
    
    func setPageNumber() {
        pageNumber = SearchResultViewModel.getLastStoredIndex()
    }
    
    static func getLastStoredIndex() -> Int {
        guard let _ = SearchManager.sharedInstance.getSearchKeyword() else { return 1}
        
        if let index = UserDefaults.standard.value(forKey: SearchResultViewModel.getLastStoredIndexKey()) as? Int {
            return index
        }
        
        return 1
    }
    static func getLastStoredIndexKey() -> String {
        guard let keyword = SearchManager.sharedInstance.getSearchKeyword() else { return ""}
        return "\(keyword)pageNumber"
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
