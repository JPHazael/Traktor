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
 

        
        // MARK: Trakt Header Fields
        struct TraktHeaderFields {
            static let ContentType = "Content-Type"
            static let APIVersion = "trakt-api-version"
            static let APIKey = "trakt-api-key"

        }
        
        // MARK: Trakt Heaser Values
        struct TraktHeaderValues {
            static let ContentType = "application/json"
            static let APIVersion = "2"
            static let APIKey = "20a813842de3f9735f8cb5cae45b7d83c170f9c31eacd4ca63e9473073241a50"
        }
        
        // MARK: Trakt Response Keys
        struct TraktResponseKeys {
            static let Title = "title"
            static let Rating = "rating"
            static let Description = "overview"
            static let Tagline = "tagline"
            static let Genres = "genres"
            static let Trailer = "trailer"
            static let Poster = "Poster"

        }
    }
}
