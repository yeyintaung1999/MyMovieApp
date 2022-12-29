//
//  ViewController.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 21/12/2022.
//

import UIKit
import RxSwift
import RxDataSources

class ViewController: UIViewController {

    var viewModel: HomeViewModel!
    
    @IBOutlet weak var mainTableView: UITableView!
    
    let movieModel = MovieModel.shared
    let serieModel = SerieModel.shared
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backButtonTitle = ""
        
        self.viewModel = HomeViewModel()
        // Do any additional setup after loading the view.
        setupMainTableView()
        
        self.viewModel.fetchAllData()
        self.bindData()
    }
    
    func bindData(){
        viewModel.homeItemList
            .throttle(.milliseconds(90), scheduler: MainScheduler.instance)
            .bind(to: mainTableView.rx.items(dataSource: initRxDataSource()))
            .disposed(by: disposeBag)
    }
    
    func initRxDataSource()->RxTableViewSectionedReloadDataSource<HomeViewSectionModel>{
        return RxTableViewSectionedReloadDataSource<HomeViewSectionModel>.init{ (datasource, tableView, indexPath, items) in
            switch items {
                    
                case .upcomingMovieSection(items: let items):
                    let cell = tableView.dequeueCell(identifier: PopularTableViewCell.identifier, indexPath: indexPath) as PopularTableViewCell
                    cell.movies = items
                    cell.navigateDelegate = self
                    return cell
                case .popularMovieSection(items: let items):
                    let cell = tableView.dequeueCell(identifier: MovTableViewCell.identifier, indexPath: indexPath) as MovTableViewCell
                    cell.movieDelegate = self
                    cell.title = "Popular Movies"
                    cell.movies = items
                    return cell
                case .popularSerieSection(items: let items):
                    let cell = tableView.dequeueCell(identifier: SerieTableViewCell.identifier, indexPath: indexPath) as SerieTableViewCell
                    cell.movieDelegate = self
                    cell.series = items
                    return cell

                case .genreListSection(items: let items):
                    let cell = tableView.dequeueCell(identifier: GenreTableViewCell.identifier, indexPath: indexPath) as GenreTableViewCell
                    let genreVOList: [GenreVO]? = items.map({ (genre) in
                        return GenreVO(id: genre.id ?? 0, name: genre.name ?? "", isSelected: false)
                    })
                    genreVOList?.first?.isSelected=true
                    cell.genreVOList = genreVOList
                    cell.allMovies = self.viewModel.moviesForGenreList()
                    cell.movieDelegate = self
                    return cell
            }
        }
    }
    
    func setupMainTableView(){
        mainTableView.delegate = self
        mainTableView.registerCell(identifier: PopularTableViewCell.identifier)
        mainTableView.registerCell(identifier: MovTableViewCell.identifier)
        mainTableView.registerCell(identifier: SerieTableViewCell.identifier)
        mainTableView.registerCell(identifier: GenreTableViewCell.identifier)
    }
    
    
    @IBAction func onTapSearch(_ sender: UIBarButtonItem) {
        navigateToSearchViewController()
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return (view.frame.height * 0.26)
        }else {
             return view.frame.height * 0.25
        }
    }
    
    
}


extension ViewController: MovieDelegate {
    
    func onTapMovie(movieID: Int) {
        navigateToMovieDetailViewController(id: movieID)
        
    }
    
    func onTapSerie(serieID: Int) {
        navigateToSerieDetailViewController(id: serieID)
    }
    
    
    
}
