//
//  ImageViewController.swift
//  Traktor
//
//  Created by admin on 3/27/17.
//  Copyright © 2017 JPDaines. All rights reserved.
//

import UIKit
extension UIImageView{
    
    func imageFromUrl(urlString: String) {
        
        let urlRequest = URLRequest(url: URL(string: urlString)!)
        let task = URLSession.shared.dataTask(with: urlRequest){ (data, response, error) in
            if error != nil {
                print(error as Any)
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}
