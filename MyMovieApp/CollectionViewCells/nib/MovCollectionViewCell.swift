//
//  MovCollectionViewCell.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 22/12/2022.
//

import UIKit

class MovCollectionViewCell: UICollectionViewCell {
    
    var movie: MovieResult? {
        didSet {
            if let movie = movie {
                let path = "\(imageBaseurl)\(movie.backdropPath ?? "")"
                name.text = movie.title ?? ""
                //rating.text = "\(movie.voteAverage ?? 0.00)"
                poster.sd_setImage(with: URL(string: path)!)
            }
        }
    }
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var poster: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
