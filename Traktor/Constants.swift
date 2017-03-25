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
        
       static let TMDBDetailsURL =  "https://api.themoviedb.org/3/movie/157336?api_key=82e6ce64cce3c7687fa295b06ee204dd&language=en-US"
        
        static let TMDBTrailerURL = "http://api.themoviedb.org/3/movie/157336/videos?api_key=82e6ce64cce3c7687fa295b06ee204dd"
        
        static let TMDBKey = "82e6ce64cce3c7687fa295b06ee204dd"
        
        static let YouTubeLink = "https://www.youtube.com/watch?v=2LqzF5WauAw"
        
            static let PosterURL = "https://image.tmdb.org/t/p/w342/nBNZadXqJSdt05SHLqgT0HuC5Gm.jpg"
 

        
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
        
        // MARK: JSON Response Keys
        struct JSONResponseKeys {
            static let Title = "title"
            static let ID = "id"
            static let Rating = "rating"
            static let Description = "overview"
            static let Tagline = "tagline"
            static let Genres = "genres"
            static let Trailer = "trailer"
            static let Poster = "Poster"

        }
    }
}
