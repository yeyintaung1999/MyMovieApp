//
//  MovieModel.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 28/12/2022.
//

import Foundation
import RxSwift

protocol MovieModelProtocol {
    
    func getUpcomingMovies()->Observable<[MovieResult]>
    func getPopularMovies()->Observable<[MovieResult]>
    func getMovieDetail(id: Int)->Observable<MovieDetail>
    func getGenreList()->Observable<[GenreResult]>
    func getMovieCasts(id: Int)->Observable<[CastResult]>
    func getMovieTrailer(id: Int)->Observable<[TrailerResult]>
    func getSearchResult(query: String, page: Int)->Observable<UpcomingMOV>
}

class MovieModel: BaseModel, MovieModelProtocol {
    
    static let shared: MovieModelProtocol = MovieModel()
    var disposeBag = DisposeBag()
    let genreRepo = GenreRepository.shared
    let movieRepo = MovieRepository.shared
    let contentTypeRepo = ContentTypeRepository.shared
    
    private override init(){}
    
    func getUpcomingMovies() -> Observable<[MovieResult]> {
        let remoteData = rxnetworkAgent.getUpcomingMovies()
        return remoteData
            .flatMap { data -> Observable<[MovieResult]> in
                self.movieRepo.saveMovies(type: .upcoming, data: data)
                return self.contentTypeRepo.getMovies(type: .upcoming)
            }
    }
    
    func getPopularMovies() -> Observable<[MovieResult]> {
        let remoteData = rxnetworkAgent.getPopularMovies()
        return remoteData
            .flatMap { (data) -> Observable<[MovieResult]> in
                self.movieRepo.saveMovies(type: .popularMovie, data: data)
                return self.contentTypeRepo.getMovies(type: .popularMovie)
            }
    }
    
    func getMovieDetail(id: Int) -> Observable<MovieDetail> {
        return rxnetworkAgent.getMovieDetail(id: id)
    }
    
    func getGenreList()->Observable<[GenreResult]>{
        let remoteObservableResult = rxnetworkAgent.getGenreList()
        
        return remoteObservableResult
            .flatMap { genre -> Observable<[GenreResult]> in
                self.genreRepo.saveGenres(genres: genre)
                return self.genreRepo.getGenres()
            }
    }
    
    func getMovieCasts(id: Int)->Observable<[CastResult]>{
        return rxnetworkAgent.getMovieCasts(id: id)
            .flatMap { (casts)->Observable<[CastResult]> in
                return Observable.create { observer in
                    observer.onNext(casts.cast ?? [CastResult]())
                    observer.onCompleted()
                    return Disposables.create()
                }
            }
    }
    
    func getMovieTrailer(id: Int)->Observable<[TrailerResult]>{
        return rxnetworkAgent.getTrailers(id: id)
            .flatMap { trailers->Observable<[TrailerResult]> in
                return Observable.create { observer in
                    observer.onNext(trailers.results ?? [TrailerResult]())
                    observer.onCompleted()
                    return Disposables.create()
                }
            }
    }
    
    func getSearchResult(query: String, page: Int) -> Observable<UpcomingMOV> {
        return rxnetworkAgent.searchMovie(query: query, page: page)
            
    }
    
}
