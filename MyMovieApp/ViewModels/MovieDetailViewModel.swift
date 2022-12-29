//
//  MovieDetailViewModel.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 29/12/2022.
//

import Foundation
import RxSwift
import RxDataSources
import RxRelay

class MovieDetailViewModel {
    var movieModel: MovieModelProtocol!
    
    var disposeBag = DisposeBag()
    
    init(movieModel: MovieModelProtocol = MovieModel.shared){
        self.movieModel = movieModel
    }
    
    var genreVOList = BehaviorSubject<[GenreVO]>(value: [])
    var CastList = BehaviorSubject<[CastResult]>(value: [])
    var trailerKey = ""
    
    
    func fetchRelayData(id: Int){
        fetchGenreList(id: id)
        fetchMovieCast(id: id)
        fetchTrailerKey(id: id)
    }
    
    func getMovieDetail(id: Int)->Observable<MovieDetail>{
        return movieModel.getMovieDetail(id: id)
    }
    
    func fetchGenreList(id: Int) {
        var items : [GenreVO] = []
        movieModel.getMovieDetail(id: id)
            .subscribe(onNext: { detail in
                detail.genres?.forEach({ genre in
                    items.append(GenreVO(id: genre.id ?? 0, name: genre.name ?? "", isSelected: true))
                })
                self.genreVOList.onNext(items)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchMovieCast(id: Int) {
        movieModel.getMovieCasts(id: id)
            .subscribe(onNext: { data in
                self.CastList.onNext(data)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchTrailerKey(id: Int){
        movieModel.getMovieTrailer(id: id)
            .subscribe(onNext: { trailers in
                trailers.forEach({ trailer in
                    if trailer.name == "Official Trailer" {
                        self.trailerKey = trailer.key ?? ""
                    } else if self.trailerKey == "" {
                        self.trailerKey = trailers.first?.key ?? ""
                    }
                })

            }).disposed(by: disposeBag)
    }
    
    func getSelectedCastID(indexPath: IndexPath)->Int{
        let items = try! CastList.value()
        let id = items[indexPath.row].id ?? 0
        return id
    }
    
}
