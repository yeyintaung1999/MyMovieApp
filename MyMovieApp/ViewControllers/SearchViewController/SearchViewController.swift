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

    var viewModel : SearchMovieViewModel!
    
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    var disposebag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SearchMovieViewModel()
        initView()
        initObservers()
        // Do any additional setup after loading the view.
    }
    
    func initView(){
        resultCollectionView.delegate = self
        resultCollectionView.registerCell(identifier: MovCollectionViewCell.identifier)
        
        searchBar.placeholder = "Search ..."
        searchBar.searchTextField.textColor = UIColor(named: "label")
        navigationItem.titleView = searchBar
    }
    
    func attriString(text: String)-> NSAttributedString {
        let stringAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "secBackground")]
        let string = NSAttributedString.init(string: text, attributes: stringAttributes as [NSAttributedString.Key : Any])
        return string
    }
    
    func initObservers(){
        RxSearchMovie()
        bindResult()
        handlePagination()
        addDidSelectItemAt()
    }
    
}

//MARK: Rx Extension

extension SearchViewController {
    func RxSearchMovie(){
        self.searchBar.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { value in
                if value.isEmpty {
                    self.viewModel.handleEmptySearch()
                } else {
                    let value1 = value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                    self.viewModel.searchMovie(query: value1)
                }
            })
            .disposed(by: disposebag)
    }
    
    func bindResult(){
        self.viewModel.searchResult.bind(to: resultCollectionView.rx.items(cellIdentifier: MovCollectionViewCell.identifier, cellType: MovCollectionViewCell.self)){ indexPath, element, cell in
            cell.movie = element
        }.disposed(by: disposebag)
    }
    
    func handlePagination(){
        Observable.combineLatest(
            self.resultCollectionView.rx.willDisplayCell,
            searchBar.rx.text.orEmpty
        )
        .subscribe(onNext: { cellAndIndexPath,query in
            let (_,indexPath) = cellAndIndexPath
            self.viewModel.handlePagination(indexpath: indexPath, query: query)
        }).disposed(by: disposebag)
    }
    
    func addDidSelectItemAt(){
        self.resultCollectionView.rx.itemSelected
            .subscribe(onNext: { indexpath in
                self.onTapMovie(id: self.viewModel.getSelectedMovieID(indexPath: indexpath))
            })
            .disposed(by: disposebag)
    }
    
    func onTapMovie(id: Int){
        self.navigateToMovieDetailViewController(id: id)
    }
}



//MARK: CollectionView FlowLayout Delegate
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = searchBar.frame.width * 0.27
        return CGSize(width: width, height: width*1.5)
    }

    
}
