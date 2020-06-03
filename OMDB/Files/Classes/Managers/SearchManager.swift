//
//  SearchManager.swift
//  OMDBAPI
//
//  Created by Piyush on 2/4/20.
//  Copyright © 2020 Piyush Kandrikar. All rights reserved.
//

import UIKit

class SearchManager: NSObject {
    
    //**************************************************
    //MARK: - Properties
    //**************************************************
    static let sharedInstance: SearchManager = SearchManager()
    var searchKeyword: String?
    
    //**************************************************
    //MARK: - Methods
    //**************************************************
    private override init() {
        
    }
    
    func setSearchKeyword(_ keyword: String) {
        searchKeyword = keyword
    }
    
    func getSearchKeyword() -> String? {
        return searchKeyword
    }
    
}
