// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let upcomingMOV = try? newJSONDecoder().decode(UpcomingMOV.self, from: jsonData)

import Foundation
import CoreData

// MARK: - UpcomingMOV
struct UpcomingMOV: Codable {
    let dates: Dates?
    let page: Int?
    let results: [MovieResult]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Dates
struct Dates: Codable {
    let maximum, minimum: String?
}

// MARK: - Result
struct MovieResult: Codable, Hashable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage: OriginalLanguage?
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let character: String?=nil
    let creditID: String?=nil
    let order: Int?=nil
    let department: String?=nil
    let job: String?=nil
    
    func toMovieEntity(context: NSManagedObjectContext, type: BelongsToTypeEntity)->MovieEntity{
        let entity = MovieEntity(context: context)
        entity.adult = adult ?? false
        entity.backdropPath = backdropPath ?? ""
        entity.genreIds = genreIDS?.map{ String($0) }.joined(separator: ",")
        entity.id = Int32(id ?? 0)
        entity.originalLanguage = originalLanguage?.rawValue
        entity.originalTitle = originalTitle
        entity.overview = overview
        entity.popularity = popularity ?? 0.00
        entity.posterPath = posterPath
        entity.releaseDate = releaseDate
        entity.title = title
        entity.voteAverage = voteAverage ?? 0.00
        entity.addToBelongsToType(type)
        return entity
    }

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case character
        case creditID = "credit_id"
        case order, department, job
    }
}

enum OriginalLanguage: String, Codable {
    case en = "en"
    case es = "es"
    case ja = "ja"
    case vi = "vi"
    case other
    
    init(from decoder: Decoder) throws {
        let container = try  decoder.singleValueContainer()
        let value = try container.decode(String.self)
        
        switch value {
            case "en": self = .en
            case "es": self = .es
            case "ja": self = .ja
            case "vi": self = .vi
            default: self = .other
        }
    }
    
}
