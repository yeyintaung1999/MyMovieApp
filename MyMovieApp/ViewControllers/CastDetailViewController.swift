//
//  CastViewController.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 28/12/2022.
//

import UIKit
import SDWebImage
import RxSwift

class CastDetailViewController: UIViewController {
    
    var viewModel : CastDetailViewModel!
    
    var castDetail: CastDetail? {
        didSet{
            if let castDetail = castDetail {
                let stringurl = "\(imageBaseurl)\(castDetail.profilePath ?? "")"
                self.profileImage.sd_setImage(with: URL(string: stringurl)!)
                self.name.text = castDetail.name ?? ""
                self.birthday.text = castDetail.birthday ?? "null"
                self.placeOFBirth.text = castDetail.placeOfBirth ?? "null"
                self.biography.text = castDetail.biography ?? "null"
            }
        }
    }

    var disposebag = DisposeBag()
    var castID: Int = 0
    
    @IBOutlet weak var seemoreButton: UIButton!
    @IBOutlet weak var movieCreditCollectionView: UICollectionView!
    @IBOutlet weak var biography: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var placeOFBirth: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var DetailStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = CastDetailViewModel()
        viewModel.fetchMovieCredits(id: castID)
        clipDetailViewTopCorners()

        // Do any additional setup after loading the view.
        
        movieCreditCollectionView.delegate = self
        movieCreditCollectionView.registerCell(identifier: MovCollectionViewCell.identifier)
        
        bindData()
        addDidSelectedItemAt()
    }
    
    func bindData(){
        //MARK: Bind Cast Detail
        viewModel.fetchCastDetail(id: castID)
            .subscribe(onNext: { detail in
                self.castDetail = detail
            }).disposed(by: disposebag)
        //MARK: Bind Movie Credits
        viewModel.creditList.bind(to: movieCreditCollectionView.rx.items(cellIdentifier: MovCollectionViewCell.identifier, cellType: MovCollectionViewCell.self)){ indexpath, item, cell in
            cell.movie = item
        }.disposed(by: disposebag)
    }
    
    func addDidSelectedItemAt(){
        movieCreditCollectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.onTapMovieCredit(id: self.viewModel.getSelectedMovieID(indexpath: indexPath))
            })
            .disposed(by: disposebag)
    }
    
    func onTapMovieCredit(id : Int){
        self.navigateToMovieDetailViewController(id: id)
    }
    
    func clipDetailViewTopCorners(){
        self.DetailStackView.layer.cornerRadius = 30
    }
    
    @IBAction func onTapSeeMore(_ sender: UIButton) {
        if biography.numberOfLines == 3 {
            self.biography.numberOfLines = 0
            self.seemoreButton.setTitle("See Less", for: .normal)
            self.seemoreButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        }else {
            self.biography.numberOfLines = 3
            self.seemoreButton.setTitle("See More", for: .normal)
            self.seemoreButton.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        }
    }
    
}

extension CastDetailViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.25, height: movieCreditCollectionView.frame.height)
    }
}
