//
//  PopularTableViewCell.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 22/12/2022.
//

import UIKit

class PopularTableViewCell: UITableViewCell {
    
    var navigateDelegate: MovieDelegate?=nil
    
    var movies: [MovieResult]? {
        didSet{
            upcomingCollectionView.reloadData()
        }
    }

    @IBOutlet weak var upcomingCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        upcomingCollectionView.delegate = self
        upcomingCollectionView.dataSource = self
        upcomingCollectionView.registerCell(identifier: UpcomingCollectionViewCell.identifier)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension PopularTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?.count ?? 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifier: UpcomingCollectionViewCell.identifier, indexPath: indexPath) as UpcomingCollectionViewCell
        cell.movie = movies?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath ) -> CGSize {
        return CGSize(width: frame.width*0.85, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateDelegate?.onTapMovie(movieID: movies?[indexPath.row].id ?? 0)
        print("Tapped")
    }
}
