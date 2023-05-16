//
//  ContentTypeRepository.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 03/01/2023.
//

import Foundation
import RxSwift
import CoreData
import RxCoreData
import RxRelay

protocol ContentTypeRepositoryProtocol {
    func save(name: String)->BelongsToTypeEntity
    
    func getBelongsToTypeEntity(type: MovieSerieGroupType)->BelongsToTypeEntity
    
    func getMovies(type: MovieSerieGroupType)->Observable<[MovieResult]>
}

class ContentTypeRepository: BaseRepository, ContentTypeRepositoryProtocol {
    
    
    static let shared = ContentTypeRepository()
    
    var contentTypeMap = [String:BelongsToTypeEntity]()
    
    override init() {
        super.init()
        
        initializeData()
    }
    
    func initializeData(){
        
        let fetchrequest = BelongsToTypeEntity.fetchRequest()
        
        let entities = try? coredata.context.fetch(fetchrequest)
        
        let items = entities!
        
        if items.isEmpty {
            
            MovieSerieGroupType.allCases.forEach({save(name: $0.rawValue) })
        } else {
            
            items.forEach { entity in
                contentTypeMap[entity.name!] = entity
            }
           
        }
    }
    
    
    func save(name: String)->BelongsToTypeEntity{
        let entity = BelongsToTypeEntity(context: coredata.context)
        entity.name = name
        coredata.saveContext()
        return entity
    }
    
    func getBelongsToTypeEntity(type: MovieSerieGroupType)->BelongsToTypeEntity{
        if let entity = contentTypeMap[type.rawValue]{
            return entity
        }
        return save(name: type.rawValue)
    }
    
    func getMovies(type: MovieSerieGroupType) -> Observable<[MovieResult]> {
        if let entity = contentTypeMap[type.rawValue],
           let movies = entity.movies,
            let itemset = movies as? Set<MovieEntity>{
            return Observable<[MovieResult]>.create { observer in
                observer.onNext(
                    Array(
                        itemset.sorted(by: { (first, second)->Bool in
                            let dateformatter = DateFormatter()
                            dateformatter.dateFormat = "yyyy-MM-dd"
                            let firstDate = dateformatter.date(from: first.releaseDate ?? "") ?? Date()
                            let secondDate = dateformatter.date(from: second.releaseDate ?? "") ?? Date()
                            return firstDate.compare(secondDate) == .orderedDescending
                        })
                    ).map { $0.toMovieResult(entity: $0)}
                )
                return Disposables.create()
            }
            }else {
                return Observable.empty()
            }
           
    }
    
    func getSeries(type: MovieSerieGroupType)->Observable<[SerieResult]> {
//        if let entity = contentTypeMap[type.rawValue],
//           let series = entity.series,
//            let itemset = series as? Set<SerieEntity>{
//            return Observable<[SerieResult]>.create { observer in
//                observer.onNext(
//                    Array(
//                        itemset.sorted(by: { (first, second)->Bool in
//                            let dateformatter = DateFormatter()
//                            dateformatter.dateFormat = "yyyy-MM-dd"
//                            let firstDate = dateformatter.date(from: first.releaseDate ?? "") ?? Date()
//                            let secondDate = dateformatter.date(from: second.releaseDate ?? "") ?? Date()
//                            return firstDate.compare(secondDate) == .orderedDescending
//                        })
//                    ).map { $0.toSerieResult(entity: $0)}
//                )
//                return Disposables.create()
//            }
//            }else {
//                return Observable.empty()
//            }
        return Observable.empty()
    }
    
    func sortByDate(first: MovieEntity, second: MovieEntity)->Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let firstDate = dateFormatter.date(from: first.releaseDate ?? "") ?? Date()
        let secondDate = dateFormatter.date(from: second.releaseDate ?? "") ?? Date()
        return firstDate.compare(secondDate) == .orderedDescending
    }
}


enum MovieSerieGroupType: String, CaseIterable {
    
case upcoming = "Upcoming Movies"
case popularMovie = "Popular Movies"
case popularSerie = "Popular Series"
case castCredit = "Cast Credits"
}
