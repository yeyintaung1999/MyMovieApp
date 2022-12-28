// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let movieCasts = try? newJSONDecoder().decode(MovieCasts.self, from: jsonData)

import Foundation

// MARK: - MovieCasts
struct Casts: Codable {
    let id: Int?
    let cast, crew: [CastResult]?
}

// MARK: - Cast
struct CastResult: Codable {
    let adult: Bool?
    let gender, id: Int?
    let knownForDepartment: Department?
    let name, originalName: String?
    let popularity: Double?
    let profilePath: String?
    let castID: Int?
    let character, creditID: String?
    let order: Int?
    let department: Department?
    let job: String?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order, department, job
    }
}

enum Department: String, Codable {
    case acting = "Acting"
    case art = "Art"
    case camera = "Camera"
    case other
    
    init(from decoder: Decoder) throws {
        let container = try  decoder.singleValueContainer()
        let value = try container.decode(String.self)
        
        switch value {
            case "Acting": self = .acting
            case "Art": self = .art
            case "Camera": self = .camera
            default: self = .other
        }
    }
    
}
