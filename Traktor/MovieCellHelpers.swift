//
//  MovieCellHelpers.swift
//  Traktor
//
//  Created by admin on 3/27/17.
//  Copyright © 2017 JPDaines. All rights reserved.
//

import Foundation
import UIKit

extension MovieCell{
    
    
    //MARK: - Helper Methods
    
    func disableTrailerButton(for key: String){
        if key == "XXX"{
            trailerButton.isEnabled = false
            trailerButton.titleLabel?.text  = "Not Available"
        }
    }
    
    
    func configureCell(for movie: Movie){
        
        weak var weakSelf = self

        
        weakSelf?.titleLabel.text = movie.title
        weakSelf?.genreLabel.text = movie.genres.joined(separator: ", ")
        weakSelf?.ratingLabel.text = movie.rating
        weakSelf?.descriptionTextView.text = movie.movieDescription
        weakSelf?.taglineTextfield.text = movie.tagline
        weakSelf?.imageView.imageFromUrl(urlString: movie.posterURL)
        weakSelf?.youtubeLink = movie.trailerURL
        weakSelf?.youtubeURL = "youtube://\(movie.ytKey!)"
        weakSelf?.disableTrailerButton(for: movie.ytKey!)
    }
    
    
}
