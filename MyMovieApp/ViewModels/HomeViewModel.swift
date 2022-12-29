
import Foundation
import RxRelay
import RxSwift

class HomeViewModel {
    
    var movieModel: MovieModelProtocol!
    var serieModel: SerieModelProtocol!
    
    init(movieModel: MovieModelProtocol = MovieModel.shared, serieModel: SerieModelProtocol = SerieModel.shared){
        self.movieModel = movieModel
        self.serieModel = serieModel
        
        initObserver()
        
    }
    
    var disposebag = DisposeBag()
    
    var homeItemList = BehaviorRelay<[HomeViewSectionModel]>(value: [])
    
    var observableUpcomingMovies = BehaviorRelay<[MovieResult]>(value: [])
    var observablePopularMovies = BehaviorRelay<[MovieResult]>(value: [])
    var observablePopularSeries = BehaviorRelay<[SerieResult]>(value: [])
    var observableGenreList = BehaviorRelay<[GenreResult]>(value: [])
    
    func initObserver(){
        
        Observable.combineLatest(
            observableUpcomingMovies,
            observablePopularMovies,
            observablePopularSeries,
            observableGenreList
        ).subscribe{
            (   upcomingmovies,
                popularmovies,
                popularseries,
                genrelist) in
            
            var items = [HomeViewSectionModel]()
            
            if !upcomingmovies.isEmpty{
                items.append(HomeViewSectionModel.movieResult(items: [.upcomingMovieSection(items: upcomingmovies)]))
            }
            
            if !popularmovies.isEmpty {
                items.append(HomeViewSectionModel.movieResult(items: [.popularMovieSection(items: popularmovies)]))
            }
            
            if !popularseries.isEmpty {
                items.append(HomeViewSectionModel.serieResult(items: [.popularSerieSection(items: popularseries)]))
            }
            
            if !genrelist.isEmpty {
                items.append(HomeViewSectionModel.genreResult(items: [.genreListSection(items: genrelist)]))
            }
            
            self.homeItemList.accept(items)
        }
        .disposed(by: disposebag)
        
    }
    
    func fetchAllData(){
        fetchUpcomingMovies()
        fetchPopularMovies()
        fetchPopularSeries()
        fetchGenreList()
    }
    
    func fetchUpcomingMovies(){
        movieModel.getUpcomingMovies()
            .subscribe(onNext: {self.observableUpcomingMovies.accept($0) } )
            .disposed(by: disposebag)
    }
    
    func fetchPopularMovies(){
        movieModel.getPopularMovies()
            .subscribe(onNext: { self.observablePopularMovies.accept($0) } )
            .disposed(by: disposebag)
    }
    
    func fetchPopularSeries(){
        serieModel.getPopularSeries()
            .subscribe(onNext: { self.observablePopularSeries.accept($0) } )
            .disposed(by: disposebag)
    }
    
    func fetchGenreList(){
        movieModel.getGenreList()
            .subscribe(onNext: { self.observableGenreList.accept($0) } )
            .disposed(by: disposebag)
    }
    
    func moviesForGenreList()->[MovieResult]{
        var allMovies: [MovieResult] = [MovieResult]()
        
        let observables = Observable
            .combineLatest(observableUpcomingMovies, observablePopularMovies)
            .flatMap { (upcome, popular)->Observable<[MovieResult]> in
                return Observable.create { observer in
                    observer.onNext(upcome)
                    observer.onNext(popular)
                    return Disposables.create()
                }
            }
        
        observables.subscribe(onNext: { data in
            allMovies.removeAll()
            allMovies.append(contentsOf: data)
        })
        .disposed(by: disposebag)
                    
        return allMovies
    }
}

