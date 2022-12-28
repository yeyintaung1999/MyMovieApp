//
//  UpcomingCollectionViewCell.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 22/12/2022.
//

import UIKit
import SDWebImage

class UpcomingCollectionViewCell: UICollectionViewCell {
    
    var movie: MovieResult?{
        didSet{
            if let movie = movie {
                let urlstring = "\(imageBaseurl)\(movie.backdropPath ?? "")"
                self.movName.text = movie.title ?? "Default Value"
                self.poster.sd_setImage(with: URL(string: urlstring)!)
            }
        }
    }
    
    @IBOutlet weak var poster: UIImageView!
    
    @IBOutlet weak var movName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
