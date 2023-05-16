//
//  MovieDetailViewController.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 23/12/2022.
//

import UIKit
import RxSwift

class MovieDetailViewController: UIViewController {
    
    var movieDetailViewModel: MovieDetailViewModel!
    var movieID : Int = 0
    var disposeBag = DisposeBag()
    
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
            }
        }
    }

        
    @IBOutlet weak var overlayView: UIView!
    
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
        
        movieDetailViewModel = MovieDetailViewModel()
        movieDetailViewModel.fetchRelayData(id: movieID)
        bindData()
        
        addGradientLayer()
        genreCollection.delegate = self
        castCollectionView.delegate = self
        genreCollection.registerCell(identifier: GenreCollectionViewCell.identifier)
        castCollectionView.registerCell(identifier: CastCollectionViewCell.identifier)
        
        addItemSelected()
    }
    
    
    
    func bindData(){
        //MARK: Bind Details
        movieDetailViewModel.getMovieDetail(id: movieID)
            .subscribe(onNext: { detail in
                self.movieDetail = detail
            }).disposed(by: disposeBag)
        
        //MARK: Bind Genre List
        movieDetailViewModel.genreVOList.bind(to: genreCollection.rx.items(cellIdentifier: GenreCollectionViewCell.identifier, cellType: GenreCollectionViewCell.self)){ indexPath, element, cell in
            cell.genre = element
        }.disposed(by: disposeBag)
        //MARK: Bind Cast List
        movieDetailViewModel.CastList.bind(to: castCollectionView.rx.items(cellIdentifier: CastCollectionViewCell.identifier, cellType: CastCollectionViewCell.self)) { index, item, cell in
            cell.cast = item
        }.disposed(by: disposeBag)
        
    }
    
    func onTapCast(id: Int){
        
        navigateToCastDetailViewController(id: id)
    }
    
    //MARK: DidSelectItemAt
    func addItemSelected(){
        castCollectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.onTapCast(id: self.movieDetailViewModel.getSelectedCastID(indexPath: indexPath))
            }).disposed(by: disposeBag)
    }
    //MARK: Add Gradient Layer on Image
    func addGradientLayer(){
        let colorTop = UIColor.clear.cgColor
        let colorBottom = UIColor.black.cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        gradientLayer.colors = [colorTop,colorBottom]
        poster.layer.insertSublayer(gradientLayer, at: 0)
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
        vc.stringURL = self.movieDetailViewModel.trailerKey
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == genreCollection {
            return CGSize(width: widthOfString(text: movieDetail?.genres?[indexPath.row].name ?? "", font: UIFont(name: "Geeza Pro Regular", size: 14) ?? UIFont.systemFont(ofSize: 16))+40, height: 30)
        }else{
            return CGSize(width: view.frame.width*0.25, height: castCollectionView.frame.height)
        }
    }
        
    func widthOfString(text: String, font: UIFont)->CGFloat{
        let fontAttributes = [NSAttributedString.Key.font: font]
        let textSize = text.size(withAttributes: fontAttributes)
        return textSize.width
    }
    
    
}

