//
//  MovieDetailViewController.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 23/12/2022.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var networkAgent = NetworkAgent.shared
    var movieID : Int = 0
    
    var trailers: MovieTrailers? {
        didSet{
            if let trailers = trailers {
                trailers.results?.forEach({ trailer in
                    if trailer.name == "Official Trailer" {
                        self.trailerurl = trailer.key ?? ""
                    } else if trailer.name == "" {
                        self.trailerurl = trailers.results?.first?.key ?? ""
                    }
                })
            }
        }
    }
    
    //var movieDelegate: MovieDelegate?=nil
    
    @IBOutlet weak var overlayView: UIView!
    
    var trailerurl = ""
    
    var movieDetail: MovieDetail?{
        didSet {
            if let movieDetail = movieDetail {
                
                self.navigationItem.title = movieDetail.title
                let path = "\(imageBaseurl)\(movieDetail.posterPath ?? "")"
                self.poster.sd_setImage(with: URL(string: path)!)
                self.movieName.text = movieDetail.title ?? "Default"
                self.rating.text = String(format: "%.1f", movieDetail.voteAverage ?? 0.0)
                self.releaseDate.text = movieDetail.releaseDate ?? "0000-00-00"
                self.runtime.text = {
                    let hr = (movieDetail.runtime ?? 1) / 60
                    let min = (movieDetail.runtime ?? 1) % 60
                    return "\(hr) hr \(min) min"
                }()
                self.overview.text = movieDetail.overview ?? ""
                genreCollection.reloadData()
                
            }
        }
    }
    
    var movieCasts: [CastResult]? {
        didSet{
            if let movieCasts = movieCasts {
                castCollectionView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var seeMoreButton: UIButton!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var runtime: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var genreCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.trailerurl = ""
        fetchDetail()
        fetchCasts()
        fetchTrailers()
        
        
        
        let colorTop = UIColor.clear.cgColor
        let colorBottom = UIColor.black.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [colorTop,colorBottom]
        poster.layer.insertSublayer(gradientLayer, at: 0)
            
        genreCollection.delegate = self
        genreCollection.dataSource = self
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        genreCollection.registerCell(identifier: GenreCollectionViewCell.identifier)
        castCollectionView.registerCell(identifier: CastCollectionViewCell.identifier)
        
       // castCollectionView.automaticallyAdjustsScrollIndicatorInsets = false
    }
    

    @IBAction func onTapSeemore(_ sender: UIButton) {
        if overview.numberOfLines == 3 {
            overview.numberOfLines = 0
            seeMoreButton.setTitle("See Less", for: .normal)
            seeMoreButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        } else {
            overview.numberOfLines = 3
            seeMoreButton.setTitle("See More", for: .normal)
            seeMoreButton.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        }
    }
    
    @IBAction func playTrailer(_ sender: UIButton) {
        
        let vc = YoutubePlayerViewController()
        
        vc.stringURL = self.trailerurl
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func fetchDetail(){
        networkAgent.getMovieDetail(id: movieID) { result in
            switch result {
                case .success(let data):
                    self.movieDetail = data
                case .failure(let msg):
                    print(msg)
            }
        }
    }
    
    func fetchCasts(){
        networkAgent.getMovieCasts(id: movieID) { result in
            switch result {
                case .success(let data):
                    self.movieCasts = data
                case .failure(let msg):
                    print(msg)
            }
        }
    }
    
    func fetchTrailers(){
        networkAgent.getTrailers(id: movieID) { result in
            switch result{
                case .success(let data):
                    self.trailers = data
                case .failure(let msg):
                    print(msg)
                
            }
        }
    }

}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == genreCollection {
            return CGSize(width: widthOfString(text: movieDetail?.genres?[indexPath.row].name ?? "", font: UIFont(name: "Geeza Pro Regular", size: 14) ?? UIFont.systemFont(ofSize: 16))+40, height: 30)
        }else{
            return CGSize(width: view.frame.width*0.25, height: castCollectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == genreCollection {
            return movieDetail?.genres?.count ?? 0
        }else{
            return movieCasts?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == genreCollection {
            let cell = collectionView.dequeueCell(identifier: GenreCollectionViewCell.identifier, indexPath: indexPath) as GenreCollectionViewCell
            let gen = movieDetail?.genres?[indexPath.row]
            let genrevo = GenreVO(id: gen?.id ?? 0, name: gen?.name ?? "", isSelected:true)
            cell.genre = genrevo
            return cell
        } else {
            let cell = collectionView.dequeueCell(identifier: CastCollectionViewCell.identifier, indexPath: indexPath) as CastCollectionViewCell
            cell.cast = movieCasts?[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == castCollectionView {
            self.navigateToCastDetailViewController(id: movieCasts?[indexPath.row].id ?? 0)
        }
    }
    
    func widthOfString(text: String, font: UIFont)->CGFloat{
        let fontAttributes = [NSAttributedString.Key.font: font]
        let textSize = text.size(withAttributes: fontAttributes)
        return textSize.width
    }
    
    
}

