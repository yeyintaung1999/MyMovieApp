//
//  CastViewController.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 28/12/2022.
//

import UIKit
import SDWebImage

class CastDetailViewController: UIViewController {
    
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
    
    var credits: [MovieResult]?{
        didSet{
            self.movieCreditCollectionView.reloadData()
        }
    }
    
    var networkAgent = NetworkAgent.shared
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

        clipDetailViewTopCorners()
        fetchCastDetail(id: castID)
        fetchMovieCredit(id: castID)
        // Do any additional setup after loading the view.
        
        movieCreditCollectionView.dataSource = self
        movieCreditCollectionView.delegate = self
        movieCreditCollectionView.registerCell(identifier: MovCollectionViewCell.identifier)
    }
    
    func clipDetailViewTopCorners(){
        self.DetailStackView.layer.cornerRadius = 30
    }
    
    func fetchCastDetail(id: Int){
        networkAgent.getCastDetail(id: id) { result in
            switch result{
                case .success(let data):
                    self.castDetail = data
                case .failure(let msg):
                    print(msg)
                
            }
        }
    }
    
    func fetchMovieCredit(id: Int) {
        networkAgent.getMovieCredit(id: id) { result in
            switch result {
                case .success(let data):
                    self.credits = data
                case .failure(let msg):
                    print(msg)
            }
        }
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

extension CastDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return credits?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifier: MovCollectionViewCell.identifier, indexPath: indexPath) as MovCollectionViewCell
        cell.movie = credits?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.25, height: movieCreditCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToMovieDetailViewController(id: self.credits?[indexPath.row].id ?? 0)
    }
}
