//
//  NetworkingConvenience.swift
//  Traktor
//
//  Created by admin on 3/27/17.
//  Copyright © 2017 JPDaines. All rights reserved.
//

import Foundation
extension TraktClient{
    
    
    //MARK: - Create the task
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
                sendError(error: "There was an error with your request: \(String(describing: error))")
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
    
    
    // MARK: - Parse the JSON
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
}
