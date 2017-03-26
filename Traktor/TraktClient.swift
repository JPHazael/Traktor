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
    
    var moviesArray = [Movie]()


    func getTrendingMovies(completionHandler:@escaping (_ moviesArray: [Movie], _ error: NSError?) -> Void)  {
        self.buildTraktRequest(forURL: Constants.BaseURL) { (request) in
        self.taskForGet(request: request, completionHandlerForGET: { (result, error) in
            if error == nil{
                self.getIDs(fromResult: result as! [[String : AnyObject]], completion: { (idArray) in
                    self.createTMDBInfoURLs(forIDs: idArray, completion: { (infoURLArray) in
                        self.getTMDBInfo(forURLs: infoURLArray, completion: { (resultsArray) in
                            self.createMoviesArray(from: resultsArray, completion: { (moviesArray) in
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
            
            let infoURL = "https://api.themoviedb.org/3/movie/\(id)?api_key=82e6ce64cce3c7687fa295b06ee204dd&append_to_response=releases,videos"
            
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
                }
            }
            
            if let releases = result["releases"]{
                if let countries = releases.value(forKey: "countries") as? [[String: AnyObject]]{
                    newMovie.rating = getRating(from: countries)
                }
            }
            
            print(newMovie.title, newMovie.tagline, newMovie.movieDescription, newMovie.genres, newMovie.rating, newMovie.posterURL, newMovie.trailerURL)
         moviesArray.append(newMovie)
        }
        completion(moviesArray)
    }
    
    
    // MARK: Helpers
    
    
    // Build the URL to get the trending movies from trakt
    
    
    func buildTraktRequest(forURL urlString: String, completion: (_ request: URLRequest)-> Void){
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        
        request.addValue(Constants.HeaderValues.ContentType, forHTTPHeaderField: Constants.HeaderFields.ContentType)
        request.addValue(Constants.HeaderValues.APIVersion, forHTTPHeaderField: Constants.HeaderFields.APIVersion)
        request.addValue(Constants.HeaderValues.APIKey, forHTTPHeaderField: Constants.HeaderFields.APIKey)
        
        completion(request)
    }
    
    // Create the data task and make sure you get a successful http response and the data exists
    
    func taskForGet (request: URLRequest, completionHandlerForGET:@escaping (_ result: AnyObject?, _ error: NSError?) -> Void)  {
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGet", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError(error: "There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
                sendError(error: "Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError(error: "No data was returned by the request!")
                return
            }
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data: data as NSData, completionHandlerForConvertData: completionHandlerForGET)
            
        }
        task.resume()
        
    }
    
    
    // given raw JSON, return a usable Foundation object
    func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: Any!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        
        
        completionHandlerForConvertData(parsedResult as AnyObject?, nil)
    }
    
    
    // from the array of all releases of a movie from all countries get the US releases
    // then get an array of ratings for each US release and take the top entry from the array
    
    func getRating(from countries: [[String: AnyObject]])->String{
        var certArray = [String]()
        
        for i in countries{
            if String(describing: i["iso_3166_1"]!) == "US"{
                if String(describing: i["certification"]!) != ""{
                    let cert = String(describing:i["certification"]!)
                    certArray.append(cert)
                }
            }
        }
        if certArray.isEmpty == false{
            let finalCert = certArray[0]
            return finalCert
        } else{
            return "Not Rated"
        }
    }
    
    
   // get a youtube link for the trailer
    
    func createTrailerURL(for vidResults:[[String: AnyObject]])->String{
        let trailerDict = vidResults[0]
        
        if trailerDict["key"] != nil {
            let key = String(describing: trailerDict["key"]!)
            let youTubeURL = "https://www.youtube.com/watch?v=\(key)"
            return youTubeURL
        } else {
            return "Not Available"
        }
        
    }
}

