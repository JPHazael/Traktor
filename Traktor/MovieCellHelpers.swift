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
        
        self.titleLabel.text = movie.title
        self.genreLabel.text = movie.genres.joined(separator: ", ")
        self.ratingLabel.text = movie.rating
        self.descriptionTextView.text = movie.movieDescription
        self.taglineTextfield.text = movie.tagline
        self.imageView.imageFromUrl(urlString: movie.posterURL)
        self.youtubeLink = movie.trailerURL
        self.youtubeURL = "youtube://\(movie.ytKey!)"
        self.disableTrailerButton(for: movie.ytKey!)
    }
    
    
}
