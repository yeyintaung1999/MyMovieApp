//
//  GenreRepository.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 03/01/2023.
//

import Foundation
import RxSwift
import CoreData

protocol GenreRepositoryProtocol {
    func saveGenres(genres: Genre)
    func getGenres()->Observable<[GenreResult]>
}

class GenreRepository: BaseRepository, GenreRepositoryProtocol {
    
    static let shared = GenreRepository()
    
    func saveGenres(genres: Genre) {
        let _ = genres.genres?.map({ genre in
            let entity = GenreEntity(context: coredata.context)
            entity.id = Int16(genre.id ?? 0)
            entity.name = genre.name
            return
        })
        coredata.saveContext()
    }
    
    func getGenres() -> Observable<[GenreResult]> {
        let fetchRequest : NSFetchRequest = GenreEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        if let items = try? coredata.context.fetch(fetchRequest) {
            return Observable<[GenreResult]>.create { observer in
                observer.onNext(
                    items.map({ genre in
                        return genre.toGenreResult(entity: genre)
                    })
                )
                observer.onCompleted()
                return Disposables.create()
            }
        } else {
            return Observable.empty()
        }
    }
    
    
}
