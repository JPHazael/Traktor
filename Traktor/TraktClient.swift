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
    
    let clientID = "20a813842de3f9735f8cb5cae45b7d83c170f9c31eacd4ca63e9473073241a50"
    
    
    func buildRequest(forURL urlString: String, completion: (_ request: URLRequest)-> Void){
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("2", forHTTPHeaderField: "trakt-api-version")
        request.addValue("\(clientID)", forHTTPHeaderField: "trakt-api-key")
        
        completion(request)
    }


    func getTrendingMovies(){
        
        
        self.buildRequest(forURL: Constants.BaseURL) { (request) in
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response, let data = data {
                print(response)
                print(String(data: data, encoding: .utf8))
            } else {
                print(error)
            }
        }
        
        task.resume()
        
        }
    }
}


