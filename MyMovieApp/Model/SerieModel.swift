//
//  SerieModel.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 28/12/2022.
//

import Foundation
import RxSwift

protocol SerieModelProtocol {
    func getPopularSeries()->Observable<[SerieResult]>
    func getSerieDetail(id: Int) -> Observable<SerieDetail>
    func getSerieCasts(id: Int) -> Observable<[CastResult]>
    func getSerieTrailers(id: Int) -> Observable<[TrailerResult]>
}

class SerieModel : BaseModel, SerieModelProtocol{
    private override init() {}
    
    static let shared: SerieModelProtocol = SerieModel()
    
    func getPopularSeries() -> Observable<[SerieResult]> {
        return rxnetworkAgent.getPopularseries()
            .flatMap { series -> Observable<[SerieResult]> in
                return Observable.create { observer in
                    observer.onNext(series.results ?? [SerieResult]())
                    observer.onCompleted()
                    return Disposables.create()
                }
            }
    }
    
    func getSerieDetail(id: Int) -> Observable<SerieDetail> {
        return rxnetworkAgent.getSerieDetail(id: id)
    }
    
    func getSerieCasts(id: Int) -> Observable<[CastResult]> {
        return rxnetworkAgent.getSerieCasts(id: id)
            .flatMap { casts->Observable<[CastResult]> in
                return Observable.create { observer in
                    observer.onNext(casts.cast ?? [CastResult]())
                    observer.onCompleted()
                    return Disposables.create()
                }
            }
    }
    
    func getSerieTrailers(id: Int) -> Observable<[TrailerResult]> {
        return rxnetworkAgent.getSerieTrailers(id: id)
            .flatMap { trailers->Observable<[TrailerResult]> in
                return Observable.create { observer in
                    observer.onNext(trailers.results ?? [TrailerResult]())
                    observer.onCompleted()
                    return Disposables.create()
                }
            }
    }
    
    
}
