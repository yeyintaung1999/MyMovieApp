//
//  ActorModel.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 29/12/2022.
//

import Foundation
import RxSwift

protocol ActorModelProtocol {
    func getCastDetail(id: Int)->Observable<CastDetail>
    func getMovieCredits(id: Int)->Observable<[MovieResult]>
}

class ActorModel: BaseModel, ActorModelProtocol {
    
    private override init() {
        
    }
    static let shared: ActorModelProtocol = ActorModel()
    
    func getCastDetail(id: Int) -> Observable<CastDetail> {
        return rxnetworkAgent.getCastDetail(id: id)
    }
    
    func getMovieCredits(id: Int) -> Observable<[MovieResult]> {
        return rxnetworkAgent.getMovieCredit(id: id)
            .flatMap { credits in
                return Observable.just(credits.cast ?? [MovieResult]())
            }
    }
    
    
}
