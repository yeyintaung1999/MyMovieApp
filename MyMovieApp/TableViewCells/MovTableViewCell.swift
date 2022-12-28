//
//  MovTableViewCell.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 22/12/2022.
//

import UIKit

class MovTableViewCell: UITableViewCell {
    
    var movies: [MovieResult]?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    var title: String? {
        didSet{
            if let title = title {
                populartitle.text = title
            }
        }
    }

    @IBOutlet weak var populartitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movieDelegate: MovieDelegate?=nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCell(identifier: MovCollectionViewCell.identifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension MovTableViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifier: MovCollectionViewCell.identifier, indexPath: indexPath) as MovCollectionViewCell
        cell.movie = self.movies?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width * 0.27, height: frame.height * 0.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        movieDelegate?.onTapMovie(movieID: movies?[indexPath.row].id ?? 0)
    }
    
}


