//
//  MoviesViewController.swift
//  Traktor
//
//  Created by admin on 3/26/17.
//  Copyright © 2017 JPDaines. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var refreshButton: UIButton!
    
    var moviesArray = [Movie]()
    let cellScaling: CGFloat = 0.75
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self

        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * self.cellScaling)
        let cellHeight = floor(screenSize.height * self.cellScaling)
        
        let layout = self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        setupMovies()
    }
    
    @IBAction func refreshWasPressed(_ sender: UIButton) {
        moviesArray.removeAll()
        collectionView.reloadData()
        if moviesArray.count == 0 {
            setupMovies()
        }
    }
    
    
    func setupMovies(){
        
        refreshButton.titleLabel?.text = "Just a moment."
        refreshButton.isEnabled = false
        
        TraktClient.sharedInstance.getTrendingMovies { (movies, error) in
            if error == nil{
                self.moviesArray = movies
                DispatchQueue.main.async {
                self.refreshButton.titleLabel?.text = "Load the newest trending movies!"
                self.refreshButton.isEnabled = true
                self.collectionView!.reloadData()
                    }
                }
                else {
                let alert = SCLAlertView()
                _ = alert.showWarning("OOPS", subTitle: "Something went wrong.")
            }
        }
    }
}

extension MoviesViewController : UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        cell.configureCell(for: moviesArray[indexPath.row])
        
        return cell
    }
}
