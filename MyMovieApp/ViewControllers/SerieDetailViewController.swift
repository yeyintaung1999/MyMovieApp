//
//  SerieDetailViewController.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 26/12/2022.
//

import UIKit
import SDWebImage
import RxSwift

class SerieDetailViewController: UIViewController {
    
    var serieID = 0
    var viewModel : SerieDetailViewModel!
    var disposeBag = DisposeBag()
    
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
        self.viewModel = SerieDetailViewModel()
        viewModel.fetchData(id: serieID)
        
        let gl = CAGradientLayer()
        gl.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        gl.frame = self.view.bounds
        self.poster.layer.insertSublayer(gl, at: 0)

        genreCollection.delegate = self
        genreCollection.registerCell(identifier: GenreCollectionViewCell.identifier)
        castCollectionView.delegate = self
        castCollectionView.registerCell(identifier: CastCollectionViewCell.identifier)
        
        bindData()
        addDidSelectedAt()
    }
    
    func bindData(){
        //MARK: Bind Detail
        viewModel.fetchSerieDetail(id: serieID)
            .subscribe(onNext: { detail in
                self.serieDetail = detail
            }).disposed(by: disposeBag)
        //MARK: Bind Genre List
        viewModel.genreVOList.bind(to: genreCollection.rx.items(cellIdentifier: GenreCollectionViewCell.identifier, cellType: GenreCollectionViewCell.self)){
            indexPath, item, cell in
            cell.genre = item
        }.disposed(by: disposeBag)
        //MARK: Bind Cast List
        viewModel.castList.bind(to: castCollectionView.rx.items(cellIdentifier: CastCollectionViewCell.identifier, cellType: CastCollectionViewCell.self)){
            index, item, cell in
            cell.cast = item
        }.disposed(by: disposeBag)
    }
    
    func addDidSelectedAt(){
        self.castCollectionView.rx.itemSelected
            .subscribe(onNext: { indexpath in
                self.onTapCast(id: self.viewModel.getSelectedCastID(indexPath: indexpath))
            }).disposed(by: disposeBag)
    }
    
    func onTapCast(id: Int){
        self.navigateToCastDetailViewController(id: id)
    }
    
    @IBAction func onTapTrailer(_ sender: UIButton) {
        let vc = YoutubePlayerViewController()
        vc.stringURL = self.viewModel.trailerKey
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

extension SerieDetailViewController: UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == genreCollection {
            return CGSize(width: widthOfString(text: serieDetail?.genres?[indexPath.row].name ?? "", font: UIFont(name: "Geeza Pro Regular", size: 14) ?? UIFont.systemFont(ofSize: 16))+40, height: 30)
        } else {
            return CGSize(width: view.frame.width * 0.25 , height: castCollectionView.frame.height)
        }
        
    }
    
    func widthOfString(text: String, font: UIFont)->CGFloat{
        let fontAttributes = [NSAttributedString.Key.font: font]
        let textSize = text.size(withAttributes: fontAttributes)
        return textSize.width
    }
}
