//
//  APIHelpers.swift
//  Traktor
//
//  Created by admin on 3/27/17.
//  Copyright © 2017 JPDaines. All rights reserved.
//

import Foundation
extension TraktClient{
    
    // Build the URL to get the trending movies from trakt
    
    func buildTraktRequest(forURL urlString: String, completion: (_ request: URLRequest)-> Void){
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        
        request.addValue(Constants.HeaderValues.ContentType, forHTTPHeaderField: Constants.HeaderFields.ContentType)
        request.addValue(Constants.HeaderValues.APIVersion, forHTTPHeaderField: Constants.HeaderFields.APIVersion)
        request.addValue(Constants.HeaderValues.APIKey, forHTTPHeaderField: Constants.HeaderFields.APIKey)
        
        completion(request)
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
            let youTubeURL = Constants.TMDBURLS.YouTubeLink + key
            return youTubeURL
        } else {
            return "XXX"
        }
        
    }
    
    // seperate the youtube key for native app URL
    
    func getYouTubeKey(for vidResults:[[String: AnyObject]])->String{
        let trailerDict = vidResults[0]
        
        if trailerDict["key"] != nil {
            let key = String(describing: trailerDict["key"]!)
            return key
        } else {
            return "XXX"
        }
    }
}
