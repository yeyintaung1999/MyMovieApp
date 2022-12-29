//
//  GenreCollectionViewCell.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 22/12/2022.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    
    var delegate : GenreDelegate? = nil
    
    var genre: GenreVO? {
        didSet{
            if let genre = genre {
                if genre.isSelected {
                    genrename.backgroundColor = UIColor(named: "label")
                } else {
                    genrename.backgroundColor = UIColor(named: "secBackground")
                }
                genrename.text = genre.name
            }
        }
    }
    
    @IBOutlet weak var genrename: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

}
