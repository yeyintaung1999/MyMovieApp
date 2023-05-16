//
//  GenreExtension.swift
//  MyMovieApp
//
//  Created by Ye Yint Aung on 03/01/2023.
//

import Foundation

extension GenreEntity {
    func toGenreResult(entity: GenreEntity)->GenreResult{
        let genre = GenreResult(id: Int(entity.id), name: entity.name)
        return genre
    }
}

extension MovieEntity {
    
    func toMovieResult(entity: MovieEntity)->MovieResult {
        return MovieResult(adult: entity.adult,
                           backdropPath: entity.backdropPath,
                           genreIDS: entity.genreIds?.components(separatedBy: ",").compactMap{
            Int($0.trimmingCharacters(in: .whitespaces))
        },
                           id: Int(entity.id),
                           originalLanguage: OriginalLanguage.init(rawValue: entity.originalLanguage!),
                           originalTitle: entity.originalTitle,
                           overview: entity.overview,
                           popularity: entity.popularity,
                           posterPath: entity.posterPath,
                           releaseDate: entity.releaseDate,
                           title: entity.title,
                           video: nil,
                           voteAverage: entity.voteAverage,
                           voteCount: nil)
    }
}
