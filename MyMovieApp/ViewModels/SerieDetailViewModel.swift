//
//  SerieDetailViewModel.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 29/12/2022.
//

import Foundation
import RxSwift

class SerieDetailViewModel{
    var serieModel: SerieModelProtocol!
    var disposeBag = DisposeBag()
    
    init(serieModel: SerieModelProtocol = SerieModel.shared){
        self.serieModel = serieModel
    }
    
    var trailerKey = ""
    var genreVOList = BehaviorSubject<[GenreVO]>(value: [])
    var castList = BehaviorSubject<[CastResult]>(value: [])
    
    func fetchData(id: Int){
        fetchGenreVo(id: id)
        fetchCastList(id: id)
        fetchTrailerKey(id: id)
    }
    
    func fetchSerieDetail(id: Int)->Observable<SerieDetail>{
        return serieModel.getSerieDetail(id: id)
    }
    
    func fetchGenreVo(id: Int){
        var items: [GenreVO]=[]
        serieModel.getSerieDetail(id: id)
            .subscribe(onNext: { detail in
                detail.genres?.forEach({ genre in
                    items.append(GenreVO(id: genre.id ?? 0, name: genre.name ?? "", isSelected: true))
                })
                self.genreVOList.onNext(items)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchCastList(id: Int){
        serieModel.getSerieCasts(id: id)
            .subscribe(onNext: { casts in
                self.castList.onNext(casts)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchTrailerKey(id: Int){
        serieModel.getSerieTrailers(id: id)
            .subscribe(onNext: { trailers in
                trailers.forEach { trailer in
                    if trailer.key == "Official Trailer"{
                        self.trailerKey = trailer.key ?? ""
                    }else if self.trailerKey == "" {
                        self.trailerKey = trailers.first?.key ?? ""
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    func getSelectedCastID(indexPath: IndexPath)->Int{
        let items = try! castList.value()
        let id = items[indexPath.row].id ?? 0
        return id
    }
}
