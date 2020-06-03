//
//  ApiConstants.swift
//  OMDBAPI
//
//  Created by Piyush on 2/4/20.
//  Copyright © 2020 Piyush Kandrikar. All rights reserved.
//

struct ApiConstants {
    
    //**************************************************
    //MARK: - Constants
    //**************************************************
    static let BASE_URL = "https://www.omdbapi.com"
    static let API_KEY = "b9bd48a6"
    static let TYPE = "movie"
    static let NUMBER_OF_RECORDS_TO_FETCH = 10
    
    struct OmdbAPI {
        static let search_keyword = BASE_URL + "/?apikey=" + API_KEY + "&s="
        static let movie_details = BASE_URL + "/?apikey=" + API_KEY + "&i="
    }

}
