//
//  ViewController.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 21/12/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    
    var upcomingMovies: [MovieResult]?
    var popularMovies: [MovieResult]?
    var popularSeries: [SerieResult]?
    var genreList: [GenreResult]?
    
    let networkAgent = NetworkAgent.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backButtonTitle = ""
        // Do any additional setup after loading the view.
        setupMainTableView()
        fetchData()
    }
    
    func setupMainTableView(){
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.registerCell(identifier: PopularTableViewCell.identifier)
        mainTableView.registerCell(identifier: MovTableViewCell.identifier)
        mainTableView.registerCell(identifier: SerieTableViewCell.identifier)
        mainTableView.registerCell(identifier: GenreTableViewCell.identifier)
    }
    
    func fetchData(){
        
        getUpcomingMovies()
        getPopularMovies()
        getPopularSeries()
        getGenreList()
    }
    
    func getUpcomingMovies(){
        networkAgent.getUpcomingMovies { result in
            switch result {
                case .success(let data):
                    self.upcomingMovies = data
                    self.mainTableView.reloadData()
                case .failure(let msg):
                    print(msg)
            }
        }
        
    }
    
    func getPopularMovies(){
        networkAgent.getPopularMovies { results in
            switch results{
                case .success(let data):
                    self.popularMovies = data
                    self.mainTableView.reloadData()
                case .failure(let msg):
                    print(msg)
            }
        }
    }
    
    func getPopularSeries(){
        networkAgent.getPopularseries { results in
            switch results {
                case .success(let data):
                    self.popularSeries = data
                    self.mainTableView.reloadData()
                case .failure(let msg):
                    print(msg)
            }
        }
    }

    func getGenreList(){
        networkAgent.getGenreList { result in
            switch result {
                case .success(let data):
                    self.genreList = data
                    
                    self.mainTableView.reloadData()
                case .failure(let msg):
                    print(msg)
            }
        }
    }
    
    
    @IBAction func onTapSearch(_ sender: UIBarButtonItem) {
        navigateToSearchViewController()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueCell(identifier: PopularTableViewCell.identifier, indexPath: indexPath) as PopularTableViewCell
            cell.movies = self.upcomingMovies ?? [MovieResult]()
            cell.navigateDelegate = self
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueCell(identifier: MovTableViewCell.identifier, indexPath: indexPath) as MovTableViewCell
            cell.movieDelegate = self
            cell.title = "Popular Movies"
            cell.movies = self.popularMovies ?? [MovieResult]()
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueCell(identifier: SerieTableViewCell.identifier, indexPath: indexPath) as SerieTableViewCell
            cell.movieDelegate = self
            cell.series = self.popularSeries ?? [SerieResult]()
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueCell(identifier: GenreTableViewCell.identifier, indexPath: indexPath) as GenreTableViewCell
            let genreVOList: [GenreVO]? = self.genreList?.map({ (genre) in
                return GenreVO(id: genre.id ?? 0, name: genre.name ?? "", isSelected: false)
            })
            genreVOList?.first?.isSelected=true
            cell.genreVOList = genreVOList
            cell.allMovies = self.popularMovies
            cell.movieDelegate = self
            return cell
        }
        else {
            return UITableViewCell()
        }
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
