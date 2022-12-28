// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let genre = try? newJSONDecoder().decode(Genre.self, from: jsonData)

import Foundation

// MARK: - Genre
struct Genre: Codable {
    let genres: [GenreResult]?
}

// MARK: - GenreElement
struct GenreResult: Codable {
    let id: Int?
    let name: String?
}
