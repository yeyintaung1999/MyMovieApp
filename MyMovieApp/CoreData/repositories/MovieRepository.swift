//
//  MovieRepositories.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 03/01/2023.
//

import Foundation
import RxSwift


protocol MovieRepositoryProtocol {
    func saveMovies(type: MovieSerieGroupType, data: UpcomingMOV)
}

class MovieRepository: BaseRepository, MovieRepositoryProtocol {
    
    let contentTypeRepo = ContentTypeRepository.shared
    
    static let shared = MovieRepository()
    
    func saveMovies(type: MovieSerieGroupType, data: UpcomingMOV) {
        data.results?.forEach{
            $0.toMovieEntity(context: coredata.context, type: self.contentTypeRepo.getBelongsToTypeEntity(type: type))
            self.coredata.saveContext()
            
        }
            }
    
}
