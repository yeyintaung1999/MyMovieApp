//
//  RxNetworkAgnet.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 29/12/2022.
//

import Foundation
import RxSwift
import RxAlamofire

protocol RxNetworkAgentProtocol {
    func getUpcomingMovies()->Observable<UpcomingMOV>
    func getPopularMovies()->Observable<UpcomingMOV>
    func getPopularseries()->Observable<PopularSeries>
    func getGenreList()->Observable<Genre>
    func searchMovie(query: String,page: Int)->Observable<UpcomingMOV>
    func getMovieDetail(id: Int)->Observable<MovieDetail>
    func getMovieCasts(id: Int)->Observable<Casts>
    func getTrailers(id: Int)->Observable<MovieTrailers>
    func getSerieDetail(id: Int)->Observable<SerieDetail>
    func getSerieCasts(id: Int)->Observable<Casts>
    func getSerieTrailers(id: Int)->Observable<MovieTrailers>
    func getCastDetail(id: Int)->Observable<CastDetail>
    func getMovieCredit(id: Int)->Observable<MovieCredit>
}

class RxNetworkAgent: RxNetworkAgentProtocol {
    
    private init(){
        
    }
    
    static let shared = RxNetworkAgent()
    
    func getUpcomingMovies() -> Observable<UpcomingMOV> {
        return RxAlamofire.requestDecodable(.get, MDBEndPoint.upcoming(1))
            .flatMap { (response, item) in
                return Observable.just(item)
            }
    }
    
    func getPopularMovies() -> Observable<UpcomingMOV> {
        return RxAlamofire.requestDecodable(.get, MDBEndPoint.popularMov(1))
            .flatMap { (response, item) in
                return Observable.just(item)
            }
    }
    
    func getPopularseries() -> Observable<PopularSeries> {
        return RxAlamofire.requestDecodable(.get, MDBEndPoint.popularSer)
            .flatMap { (response, item) in
                return Observable.just(item)
            }
    }
    
    func getGenreList() -> Observable<Genre> {
        return RxAlamofire.requestDecodable(.get, MDBEndPoint.genreList)
            .flatMap { (response, item) in
                return Observable.just(item)
            }
    }
    
    func searchMovie(query: String, page: Int) -> Observable<UpcomingMOV> {
        return RxAlamofire.requestDecodable(.get, MDBEndPoint.searchMovie(query, page))
            .flatMap { (response, item) in
                return Observable.just(item)
            }
    }
    
    func getMovieDetail(id: Int) -> Observable<MovieDetail> {
        return RxAlamofire.requestDecodable(.get, MDBEndPoint.movieDetail(id))
            .flatMap { (response, item) in
                return Observable.just(item)
            }
    }
    
    func getMovieCasts(id: Int) -> Observable<Casts> {
        return RxAlamofire.requestDecodable(.get, MDBEndPoint.movieCasts(id))
            .flatMap { (response, item) in
                return Observable.just(item)
            }
    }
    
    func getTrailers(id: Int) -> Observable<MovieTrailers> {
        return RxAlamofire.requestDecodable(.get, MDBEndPoint.trailer(id))
            .flatMap { (response, item) in
                return Observable.just(item)
            }
    }
    
    func getSerieDetail(id: Int) -> Observable<SerieDetail> {
        return RxAlamofire.requestDecodable(.get, MDBEndPoint.serieDetail(id))
            .flatMap { (response, item) in
                return Observable.just(item)
            }
    }
    
    func getSerieCasts(id: Int) -> Observable<Casts> {
        return RxAlamofire.requestDecodable(.get, MDBEndPoint.serieCasts(id))
            .flatMap { (response, item) in
                return Observable.just(item)
            }
    }
    
    func getSerieTrailers(id: Int) -> Observable<MovieTrailers> {
        return RxAlamofire.requestDecodable(.get, MDBEndPoint.serieTrailer(id))
            .flatMap { (response, item) in
                return Observable.just(item)
            }
    }
    
    func getCastDetail(id: Int) -> Observable<CastDetail> {
        return RxAlamofire.requestDecodable(.get, MDBEndPoint.castDetail(id))
            .flatMap { (response, item) in
                return Observable.just(item)
            }
    }
    
    func getMovieCredit(id: Int) -> Observable<MovieCredit> {
        return RxAlamofire.requestDecodable(.get, MDBEndPoint.movieCredit(id))
            .flatMap { (response, item) in
                return Observable.just(item)
            }
    }
    
    
}
