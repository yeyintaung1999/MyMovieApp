//
//  CastCollectionViewCell.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 24/12/2022.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {

    var cast : CastResult? {
        didSet{
            if let cast = cast {
                let path = "\(imageBaseurl)\(cast.profilePath ?? "")"
                self.name.text = cast.name
                self.imageview.sd_setImage(with: URL(string: path)!)
            }
        }
    }
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageview.clipsToBounds = true
    }

}
