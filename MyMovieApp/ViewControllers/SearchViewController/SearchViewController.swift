//
//  SearchViewController.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 23/12/2022.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    let searchBar: UISearchBar = UISearchBar()
    let networkAgent = NetworkAgent.shared
    
    @IBOutlet weak var resultCollectionView: UICollectionView!
    var movies: [MovieResult]?{
        didSet{
            resultCollectionView.reloadData()
        }
    }
    
    var disposebag = DisposeBag()
    
    var movieDelegate: MovieDelegate?=nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        RxSearchMovie()
        // Do any additional setup after loading the view.
    }
    
    func initView(){
        resultCollectionView.delegate = self
        resultCollectionView.dataSource = self
        resultCollectionView.registerCell(identifier: MovCollectionViewCell.identifier)
        
        searchBar.placeholder = "Search ..."
        searchBar.searchTextField.textColor = UIColor(named: "label")
        navigationItem.titleView = searchBar
        
    }
    
    func searchMovie(query: String, page: Int){
        networkAgent.searchMovie(query: query, page: page) { results in
            switch results{
                case .success(let result):
                    self.movies = result
                    print(result.count)
                case .failure(let msg):
                    print(msg)
            }
        }
    }
    
    func attriString(text: String)-> NSAttributedString {
        let stringAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "secBackground")]
        let string = NSAttributedString.init(string: text, attributes: stringAttributes as [NSAttributedString.Key : Any])
        return string
    }
    

    
}

//MARK: Rx Extension

extension SearchViewController {
    func RxSearchMovie(){
        self.searchBar.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { value in
                if value.isEmpty {
                    print("Empty Search")
                } else {
                    let value1 = value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                    self.searchMovie(query: value1, page: 1)
                }
            })
            .disposed(by: disposebag)
    }
}



//MARK: CollectionView FlowLayout Delegate
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifier: MovCollectionViewCell.identifier, indexPath: indexPath) as MovCollectionViewCell
        cell.movie = self.movies?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = searchBar.frame.width * 0.27
        return CGSize(width: width, height: width*1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToMovieDetailViewController(id: movies?[indexPath.row].id ?? 0)
        print("\(movies?[indexPath.row].id ?? 0000)")
    }
    
}
