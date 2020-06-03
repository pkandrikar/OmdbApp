//
//  SearchViewModel.swift
//  OMDBAPI
//
//  Created by Piyush on 6/3/20.
//  Copyright © 2020 Piyush Kandrikar. All rights reserved.
//

import UIKit

class SearchViewModel: NSObject {
    
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
    
    func isValidKeyword(_ keyword: String?) -> Bool {
        guard let keyword = keyword else {
            return false
        }
        
        return !(keyword.replacingOccurrences(of: " ", with: "") == "")
    }
    
}
