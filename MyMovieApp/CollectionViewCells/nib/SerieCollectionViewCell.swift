//
//  SerieCollectionViewCell.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 22/12/2022.
//

import UIKit

class SerieCollectionViewCell: UICollectionViewCell {
    
    
    var serie: SerieResult?{
        didSet{
            if let serie = serie {
                let path = "\(imageBaseurl)\(serie.posterPath ?? "")"
                self.name.text = serie.originalName
                self.poster.sd_setImage(with: URL(string: path)!)
                //self.rating.text = "\(serie.voteAverage ?? 0.0)"
            }
        }
    }
    @IBOutlet weak var poster: UIImageView!
    
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var name: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
