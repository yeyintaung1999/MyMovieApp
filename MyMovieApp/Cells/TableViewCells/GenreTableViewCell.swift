//
//  GenreTableViewCell.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 22/12/2022.
//

import UIKit

class GenreTableViewCell: UITableViewCell, GenreDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var movCollectionView: UICollectionView!
    
    var movieDelegate : MovieDelegate?=nil
    
    var genreVOList: [GenreVO]?{
        didSet{
            onTapGenreVO(id: self.genreVOList?.first?.id ?? 0)
            collectionView.reloadData()
            movCollectionView.reloadData()
        }
    }
    
    var listbyGenre: [Int:Set<MovieResult>] = [:]
    
    var allMovies: [MovieResult]? {
        didSet{
            if let allMovies = allMovies {
                allMovies.forEach { movie in
                    movie.genreIDS?.forEach({ genreID in
                        let key = genreID
                        
                        if var _ = listbyGenre[key] {
                            listbyGenre[key]!.insert(movie)
                        } else {
                            listbyGenre[key] = [movie]
                        }
                        
                    })
                }
            }
        }
    }
    
    var selectedMovie: [MovieResult] = [] {
        didSet{
            movCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        movCollectionView.delegate = self
        movCollectionView.dataSource = self
        collectionView.registerCell(identifier: GenreCollectionViewCell.identifier)
        movCollectionView.registerCell(identifier: MovCollectionViewCell.identifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func onTapGenreVO(id: Int) {
        self.genreVOList?.forEach({ vo in
            if vo.id == id {
                vo.isSelected = true
            }else{
                vo.isSelected = false
            }
        })
        
        let movieList = self.listbyGenre[id]
        self.selectedMovie = movieList?.map({$0}) ?? [MovieResult]()
        collectionView.reloadData()
        movCollectionView.reloadData()
    }
    
}

extension GenreTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueCell(identifier: GenreCollectionViewCell.identifier, indexPath: indexPath) as GenreCollectionViewCell
            cell.genre = self.genreVOList?[indexPath.row]
            cell.delegate = self
            return cell
        }else {
            let cell = collectionView.dequeueCell(identifier: MovCollectionViewCell.identifier, indexPath: indexPath) as MovCollectionViewCell
            cell.movie = selectedMovie[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return self.genreVOList?.count ?? 2
        } else {
            return selectedMovie.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return CGSize(
                width: widthOfString(text: genreVOList?[indexPath.row].name ?? "empty", font: UIFont(name: "Geeza Pro Regular", size: 14) ?? UIFont.systemFont(ofSize: 16))+30,
                height: 30)
        }else {
            return CGSize(width: frame.width * 0.27, height: frame.height - 70)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            onTapGenreVO(id: genreVOList?[indexPath.row].id ?? 0)
        } else {
            movieDelegate?.onTapMovie(movieID: self.selectedMovie[indexPath.row].id ?? 0)
        }
    }
    
    func widthOfString(text: String, font: UIFont)->CGFloat{
        let fontAttributes = [NSAttributedString.Key.font: font]
        let textSize = text.size(withAttributes: fontAttributes)
        return textSize.width
    }
    
    
    
}
