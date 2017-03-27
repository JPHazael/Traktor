//
//  Constants.swift
//  Traktor
//
//  Created by admin on 3/24/17.
//  Copyright © 2017 JPDaines. All rights reserved.
//

import Foundation


extension TraktClient{

    // MARK: - Constants
    struct Constants {
    
        // MARK: Trakt URL
        static let BaseURL = "https://api.trakt.tv/movies/trending"
        
        
        //MARK: - TMDB URLS
        
    struct TMDBURLS{
        
       static let TMDBMovieURL =  "https://api.themoviedb.org/3/movie/"
            
        static let TMDBURLQuery = "?api_key=\(Constants.APIKeys.TMDBKey)&append_to_response=releases,videos"

        static let YouTubeLink = "https://www.youtube.com/watch?v="
        }
 
        // MARK: API keys
        
        struct APIKeys{
            static let TraktAPIKey = "20a813842de3f9735f8cb5cae45b7d83c170f9c31eacd4ca63e9473073241a50"
            static let TMDBKey = "82e6ce64cce3c7687fa295b06ee204dd"
            
        }

        
        // MARK: Trakt Header Fields
        struct HeaderFields {
            static let ContentType = "Content-Type"
            static let APIVersion = "trakt-api-version"
            static let APIKey = "trakt-api-key"

        }
        
        // MARK: Trakt Heaser Values
        struct HeaderValues {
            static let ContentType = "application/json"
            static let APIVersion = "2"
            static let APIKey = "20a813842de3f9735f8cb5cae45b7d83c170f9c31eacd4ca63e9473073241a50"
        }
    }
}
