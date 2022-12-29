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
    
    
    
    private override init(){}
    
    func getUpcomingMovies() -> Observable<[MovieResult]> {
        return rxnetworkAgent.getUpcomingMovies()
            .flatMap { (mov)->Observable<[MovieResult]> in
                return Observable.create { observer in
                    observer.onNext(mov.results ?? [MovieResult]())
                    observer.onCompleted()
                    return Disposables.create()
                }
            }
    }
    
    func getPopularMovies() -> Observable<[MovieResult]> {
        return rxnetworkAgent.getPopularMovies()
            .flatMap { movies -> Observable<[MovieResult]> in
                return Observable.create { observer in
                    observer.onNext(movies.results ?? [MovieResult]())
                    observer.onCompleted()
                    return Disposables.create()
                }
            }
    }
    
    func getMovieDetail(id: Int) -> Observable<MovieDetail> {
        return rxnetworkAgent.getMovieDetail(id: id)
    }
    
    func getGenreList()->Observable<[GenreResult]>{
        return rxnetworkAgent.getGenreList()
            .flatMap { genres->Observable<[GenreResult]> in
                return Observable.create { observer in
                    observer.onNext(genres.genres ?? [GenreResult]())
                    observer.onCompleted()
                    return Disposables.create()
                }
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
