//
//  CastDetailViewModel.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 29/12/2022.
//

import Foundation
import RxSwift

class CastDetailViewModel {
    
    var castModel: ActorModelProtocol!
    var disposebag = DisposeBag()
    
    init(castModel: ActorModelProtocol = ActorModel.shared){
        self.castModel = castModel
        
        
    }
    
    var creditList = BehaviorSubject<[MovieResult]>(value: [])
    
    func fetchCastDetail(id: Int)->Observable<CastDetail>{
        return castModel.getCastDetail(id: id)
    }
    
    func fetchMovieCredits(id: Int){
        castModel.getMovieCredits(id: id)
            .subscribe(onNext: { credits in
                self.creditList.onNext(credits)
            })
            .disposed(by: disposebag)
    }
    
    func getSelectedMovieID(indexpath: IndexPath)->Int {
        let items = try! creditList.value()
        let id = items[indexpath.row].id ?? 0
        return id
    }
    
}
