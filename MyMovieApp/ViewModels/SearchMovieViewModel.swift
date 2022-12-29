//
//  SearchMovieViewModel.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 30/12/2022.
//

import Foundation
import RxSwift

class SearchMovieViewModel {
    var movieModel: MovieModelProtocol!
    var disposeBag = DisposeBag()
    
    init(model: MovieModelProtocol = MovieModel.shared){
        self.movieModel = model
    }
    
    var searchResult = BehaviorSubject<[MovieResult]>(value: [])
    
    var currentPage = 1
    var totalPage = 1
    
    func searchMovie(query: String){
        movieModel.getSearchResult(query: query, page: currentPage)
            .do(onNext: { result in
                self.totalPage = result.totalPages ?? 1
            })
                .compactMap({$0.results})
                .subscribe(onNext: { results in
                    if self.currentPage == 1 {
                        self.searchResult.onNext(results)
                    } else {
                        self.searchResult.onNext( try! self.searchResult.value()+results )
                    }
                })
                .disposed(by: disposeBag)
            
    }
    
    func handleEmptySearch(){
        self.currentPage = 1
        self.totalPage = 1
        self.searchResult.onNext([])
    }
    
    func handlePagination(indexpath: IndexPath, query: String){
        let searchKeyWord = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let totalItems = try! self.searchResult.value().count
        let isAtLastRow = indexpath.row == totalItems-1
        let hasMorePage = self.currentPage<self.totalPage
        if isAtLastRow && hasMorePage {
            self.currentPage += 1
            self.searchMovie(query: searchKeyWord)
        }
    }
    
    func getSelectedMovieID(indexPath: IndexPath)->Int{
        let items = try! self.searchResult.value()
        let item = items[indexPath.row]
        let id = item.id ?? 0
        return id
    }
    
}
