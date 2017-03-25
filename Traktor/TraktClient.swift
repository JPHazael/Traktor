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
    
    var resultsArray = [[String:AnyObject]]()


    
    
    func buildRequest(forURL urlString: String, completion: (_ request: URLRequest)-> Void){
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        
        request.addValue(Constants.HeaderValues.ContentType, forHTTPHeaderField: Constants.HeaderFields.ContentType)
        request.addValue(Constants.HeaderValues.APIVersion, forHTTPHeaderField: Constants.HeaderFields.APIVersion)
        request.addValue(Constants.HeaderValues.APIKey, forHTTPHeaderField: Constants.HeaderFields.APIKey)
        
        completion(request)
    }


    func getTrendingMovies(arrayResults : NSMutableArray, completionHandlerForGET:@escaping (_ result: AnyObject?, _ error: NSError?) -> Void)  {
        
        
        self.buildRequest(forURL: Constants.BaseURL) { (request) in
        
        
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                
                func sendError(error: String) {
                    print(error)
                    let userInfo = [NSLocalizedDescriptionKey : error]
                    completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
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
    }
    
    
    
    
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
    
    
    //Get IDs from all the movies in the dictionary
    
    
    func getIDs(fromResult results: [[String: AnyObject]]){
        
       // var moviesArray = [Movie]()
        
        var idArray = [AnyObject!]()

        for i in 0  ..< results.count{
            
            let result = results[i]
            
            let movieDetails = result["movie"]
            let title = movieDetails?.value(forKey: "title") as! String
            
            let movieIDs = movieDetails?.value(forKey: "ids") as! [String: AnyObject]
            let tMDBID = movieIDs["tmdb"] as AnyObject
            
            print("\(title) \(tMDBID)")
            
            idArray.append(tMDBID)
            
            
        }
        
        print(idArray)
        getTMDBInfo(forIDs: idArray)
        
        //print(result)
        
    }


    //Use IDs to search for info from TMDB API
    
    
    
   func getTMDBInfo(forIDs ids: [AnyObject]){
    
    var inforURLArray = [String]()
    
        for id in ids{
            
            let infoURL = "https://api.themoviedb.org/3/movie/\(id)?api_key=82e6ce64cce3c7687fa295b06ee204dd&append_to_response=releases,videos"
            
            inforURLArray.append(infoURL)
            
        }
        print(inforURLArray)
    
    for i in inforURLArray{
        let url = URL(string: i)!
        let request = URLRequest(url: url)
        
        self.taskForGet(request: request, completionHandlerForGET: { (results, error) in
            self.resultsArray.append(results as! [String : AnyObject])
            print(self.resultsArray.count)
                if self.resultsArray.count == 10{
                    self.createMoviesArray(from: self.resultsArray)
                }
        })
        }
    }
    
    
    // Save TMDB info to the dictionary
    
    func createMoviesArray(from results:[[String:AnyObject]]){
        
        print(results[0])
        
        for i in 0  ..< results.count{
            let result = results[i]
            
             let title = String(describing: result["title"]!)
            print(title)
            
            
            let description = String(describing: result["overview"]!)
            print(description)
            
            let tagline = String(describing: result["tagline"]!)
            print(tagline)
            
            let posterPath = String(describing: result["poster_path"]!)
            let posterURL = "https://image.tmdb.org/t/p/w342\(posterPath)"
            print(posterURL)
            
            let genres = result["genres"]!.value(forKey: "name")! as! [String]
            print(genres)
            
            //Make a function to get a youtube link for the trailer
            
            let videos = result["videos"]!
            let vidResults = videos.value(forKey: "results")! as! [[String: AnyObject]]
            //print(vidResults)
            
            for i in vidResults{
               if String(describing: i["name"]!) == "Trailer" {
                let key = String(describing: i["key"]!)
                let youTubeURL = "https://www.youtube.com/watch?v=\(key)"
                print(youTubeURL)
               } else if String(describing: i["name"]!) == "Trailer #1" {
                let key = String(describing: i["key"]!)
                let youTubeURL = "https://www.youtube.com/watch?v=\(key)"
                print(youTubeURL)
               } else{
                if String(describing: i["name"]!) == "Official Trailer" {
                let key = String(describing: i["key"]!)
                let youTubeURL = "https://www.youtube.com/watch?v=\(key)"
                print(youTubeURL)
                    }
                }
            }
            
            
            // Turn into a function called getRating
            
            let releases = result["releases"]!
            let countries = releases.value(forKey: "countries")! as! [[String: AnyObject]]
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
            print(finalCert)
            } else{
                let finalCert = "Not Rated"
                print(finalCert)
            }
        }
    
    }

    
    
    // MARK: Helpers
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: Any!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        

        
        completionHandlerForConvertData(parsedResult as AnyObject?, nil)
    }
    
}

