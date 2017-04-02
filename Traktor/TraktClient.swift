//
//  ViewController.swift
//  Traktor
//
//  Created by admin on 3/23/17.
//  Copyright © 2017 JPDaines. All rights reserved.
//

import Foundation

// MARK: - TraktClient: NSObject

class TraktClient : NSObject {
    
    //MARK: - Shared Instance
    
    static let sharedInstance = TraktClient()
    
    
    //MARK: - Build an array of Movie structs

    func getTrendingMovies(completionHandler:@escaping( _ moviesArray: [Movie], _ error: NSError?) -> Void)  {
        self.buildTraktRequest(forURL: Constants.BaseURL) { [weak self](request) in
        self?.taskForGet(request: request, completionHandlerForGET: { (result, error) in
            if error == nil{
                self?.getIDs(fromResult: result as! [[String : AnyObject]], completion: { (idArray) in
                    self?.createTMDBInfoURLs(forIDs: idArray, completion: { (infoURLArray) in
                        self?.getTMDBInfo(forURLs: infoURLArray, completion: { (resultsArray) in
                            self?.createMoviesArray(from: resultsArray, completion: { (moviesArray) in
                                completionHandler(moviesArray, nil)
                                })
                            })
                        })
                    })
                }
            })
        }
    }
    
    
    
    
    //Get IDs from all the movies in the dictionary
    
    
    func getIDs(fromResult results: [[String: AnyObject]], completion: (_ idArray: [AnyObject])-> Void){
        
        var idArray = [AnyObject!]()

        for i in 0  ..< results.count{
            let result = results[i]
            let movieDetails = result["movie"]
            let movieIDs = movieDetails?.value(forKey: "ids") as! [String: AnyObject]
            let tMDBID = movieIDs["tmdb"] as AnyObject
            idArray.append(tMDBID)
        }
        completion(idArray)
    }


    //Use IDs to create URLS for the TMDB API
    
    func createTMDBInfoURLs(forIDs ids: [AnyObject], completion: (_ infoURLArray: [String])-> Void){
        
        var inforURLArray = [String]()
        
        for id in ids{
            let infoURL = Constants.TMDBURLS.TMDBMovieURL + String(describing:id) + Constants.TMDBURLS.TMDBURLQuery
            
            inforURLArray.append(infoURL)
        }
        completion(inforURLArray)
        
    }
    
    // get and parse the JSON from TMDB for each movie in the trending 10
    
   func getTMDBInfo(forURLs URLs: [String], completion: @escaping (_ resultsArray: [[String:AnyObject]])-> Void){
    var resultsArray = [[String:AnyObject]]()

    
    for i in URLs{
        let url = URL(string: i)!
        let request = URLRequest(url: url)
        self.taskForGet(request: request, completionHandlerForGET: { (results, error) in
            resultsArray.append(results as! [String : AnyObject])
                if resultsArray.count == 10{
                    completion(resultsArray)
                }
            })
        }
    }
    
    
    // Save TMDB info to a dictionary of Movie Structs
    
    func createMoviesArray(from results:[[String:AnyObject]], completion: @escaping (_ moviesArray: [Movie])-> Void){
        
        var moviesArray = [Movie]()

        
        for i in 0  ..< results.count{
            let result = results[i]
            
            var newMovie = Movie()
            
           if let title = result["title"] as? String, let description = result["overview"] as? String,
            let tagline = result["tagline"] as? String, let genres = result["genres"]?.value(forKey: "name") as? [String]{
            
            newMovie.title = title
            newMovie.movieDescription = description
            newMovie.tagline = tagline
            newMovie.genres = genres
            }
            
            if let posterPath = result["poster_path"] as? String{
                let posterURL = "https://image.tmdb.org/t/p/w342\(posterPath)"
                newMovie.posterURL = posterURL
            }
            
            if let videos = result["videos"]{
                if let vidResults = videos.value(forKey: "results") as? [[String: AnyObject]]{
                    newMovie.trailerURL = createTrailerURL(for: vidResults)
                    newMovie.ytKey = getYouTubeKey(for: vidResults)
                }
            }
            
            if let releases = result["releases"]{
                if let countries = releases.value(forKey: "countries") as? [[String: AnyObject]]{
                    newMovie.rating = getRating(from: countries)
                }
            }
         moviesArray.append(newMovie)
        }
        completion(moviesArray)
    }

}

