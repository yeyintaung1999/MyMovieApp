//
//  SerieDetailViewController.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 26/12/2022.
//

import UIKit
import SDWebImage

class SerieDetailViewController: UIViewController {
    
    var serieID = 0
    let networkAgent = NetworkAgent.shared
    
    var trailerurl: String = ""
    
    var serieDetail: SerieDetail? {
        didSet{
            if let serieDetail = serieDetail {
                self.navigationItem.title = serieDetail.name
                let path = "\(imageBaseurl)\(serieDetail.posterPath ?? "")"
                self.poster.sd_setImage(with: URL(string: path)!)
                self.serieName.text = serieDetail.originalName ?? ""
                self.rating.text = String(format: "%.1f", serieDetail.voteAverage ?? 0.0)
                self.releaseDate.text = serieDetail.firstAirDate ?? ""
                self.runtime.text = "\(serieDetail.episodeRunTime?.first ?? 0)"
                self.genreCollection.reloadData()
                self.overview.text = serieDetail.overview ?? "no overview"
            }
        }
    }
    
    var casts: [CastResult]? {
        didSet{
            castCollectionView.reloadData()
        }
    }
    
    var trailers: [TrailerResult]? {
        didSet{
            if let trailers = trailers {
                trailers.forEach { trailer in
                    if trailer.name == "Official Trailer"{
                        self.trailerurl = trailer.key ?? ""
                    } else {
                        return
                    }
                }
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
    @IBOutlet weak var serieName: UILabel!
    @IBOutlet weak var genreCollection: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchSerieDetail(id: serieID)
        fetchSerieCast(id: serieID)
        fetchTrailers(id: serieID)
        
        let gl = CAGradientLayer()
        gl.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        gl.frame = self.view.bounds
        self.poster.layer.insertSublayer(gl, at: 0)
        
        genreCollection.dataSource = self
        genreCollection.delegate = self
        genreCollection.registerCell(identifier: GenreCollectionViewCell.identifier)
        
        castCollectionView.dataSource = self
        castCollectionView.delegate = self
        castCollectionView.registerCell(identifier: CastCollectionViewCell.identifier)
    }
    

    func fetchSerieDetail(id: Int){
        networkAgent.getSerieDetail(id: id) { response in
            switch response {
                case .success(let detail):
                    self.serieDetail = detail
                    print("\(detail.posterPath ?? "")")
                case .failure(let msg):
                    print(msg)
            }
        }
    }
    
    func fetchSerieCast(id: Int){
        networkAgent.getSerieCasts(id: id) { result in
            switch result {
                case .success(let data):
                    self.casts = data
                case .failure(let msg):
                    print(msg)
            }
        }
    }
    
    func fetchTrailers(id: Int){
        networkAgent.getSerieTrailers(id: id) { result in
            switch result{
                case .success(let data):
                    self.trailers = data
                case .failure(let msg):
                    print(msg)
            }
        }
    }
    
    @IBAction func onTapTrailer(_ sender: UIButton) {
        let vc = YoutubePlayerViewController()
        vc.stringURL = self.trailerurl
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onTapSeeMore(_ sender: UIButton) {
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
    

}

extension SerieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == genreCollection {
            return self.serieDetail?.genres?.count ?? 1
        }else {
            return self.casts?.count ?? 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == genreCollection {
            let cell = collectionView.dequeueCell(identifier: GenreCollectionViewCell.identifier, indexPath: indexPath) as GenreCollectionViewCell
            let genre = self.serieDetail?.genres?[indexPath.row]
            let genrevo = GenreVO(id: genre?.id ?? 0, name: genre?.name ?? "default", isSelected: false)
            cell.genre = genrevo
            
            return cell
        } else {
            let cell = collectionView.dequeueCell(identifier: CastCollectionViewCell.identifier, indexPath: indexPath) as CastCollectionViewCell
            cell.cast = self.casts?[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == genreCollection {
            return CGSize(width: widthOfString(text: serieDetail?.genres?[indexPath.row].name ?? "", font: UIFont(name: "Geeza Pro Regular", size: 14) ?? UIFont.systemFont(ofSize: 16))+40, height: 30)
        } else {
            return CGSize(width: view.frame.width * 0.25 , height: castCollectionView.frame.height)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == castCollectionView {
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: CastDetailViewController.self)) as? CastDetailViewController else {return}
            vc.castID = casts?[indexPath.row].id ?? 0
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func widthOfString(text: String, font: UIFont)->CGFloat{
        let fontAttributes = [NSAttributedString.Key.font: font]
        let textSize = text.size(withAttributes: fontAttributes)
        return textSize.width
    }
}
