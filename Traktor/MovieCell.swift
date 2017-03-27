//
//  MovieCell.swift
//  Traktor
//
//  Created by admin on 3/26/17.
//  Copyright © 2017 JPDaines. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var taglineTextfield: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var trailerButton: UIButton!
    
    var youtubeLink: String!
    var youtubeURL: String!

    // MARK: - Cell Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 3.0
        self.clipsToBounds = false
    }

    @IBAction func playTrailer(_ sender: UIButton) {
        
        // first try to open through the youtube app
        if UIApplication.shared.canOpenURL(URL(string: self.youtubeURL)!){
            UIApplication.shared.open(URL(string: self.youtubeURL)!, options: [:], completionHandler: nil)
        } else{
            //if that doesnt work, open with the browser
           UIApplication.shared.open(URL(string: youtubeLink)!, options: [:], completionHandler: nil)
        }
    }
}
