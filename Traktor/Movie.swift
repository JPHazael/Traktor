//
//  Movie.swift
//  Traktor
//
//  Created by admin on 3/24/17.
//  Copyright © 2017 JPDaines. All rights reserved.
//

import Foundation

// MARK: -Movie object

struct Movie {
    
    // MARK: Properties
    
    let title: String
    let id: String
    let rating: String?
    let description: String?
    let tagline: String?
    let genres: String?
    let trailer: String?
    //let posterPath: Str
  
    
    // MARK: Initializers
    
    // construct a Movie object from a dictionary
    init(dictionary: [String:AnyObject]) {
        title = dictionary[TraktClient.Constants.JSONResponseKeys.Title] as! String
        id = dictionary[TraktClient.Constants.JSONResponseKeys.ID] as! String
        rating = dictionary[TraktClient.Constants.JSONResponseKeys.Rating] as? String
        description = dictionary[TraktClient.Constants.JSONResponseKeys.Description] as? String
        tagline = dictionary[TraktClient.Constants.JSONResponseKeys.Tagline] as? String
        genres = dictionary[TraktClient.Constants.JSONResponseKeys.Genres] as? String
        trailer = dictionary[TraktClient.Constants.JSONResponseKeys.Trailer] as? String
        //posterPath = dictionary[TraktClient.Constants.JSONResponseKeys.Poster] as? String
        
    }
    
    static func moviesFromResults(results: [[String:AnyObject]]) -> [Movie] {
        
        var movies = [Movie]()
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            movies.append(Movie(dictionary: result))
        }
        
        return movies
    }
}
