//
//  MainViewController.swift
//  Traktor
//
//  Created by admin on 3/24/17.
//  Copyright © 2017 JPDaines. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    
    var arrayMovies: NSMutableArray?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrayMovies = NSMutableArray()
        
        TraktClient.sharedInstance.getTrendingMovies(arrayResults: arrayMovies!) { (response, error) in
            
            if error == nil{
                TraktClient.sharedInstance.getIDs(fromResult: response as! [[String : AnyObject]])
            }

        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
