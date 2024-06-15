//
//  MovieDBModel.swift
//  moviedb
//
//  Created by oscar perdana on 15/06/24.
//

import Foundation

struct Movie: Identifiable, Codable, Equatable {
    let id: Int
    var title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

struct MovieResponse: Codable {
    let results: [Movie]
}

struct CastResponse: Codable {
    let cast: [Actor]
}

struct Actor: Identifiable, Codable {
    let id: Int
    let name: String
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePath = "profile_path"
    }
}

struct VideoResponse: Codable {
    let results: [Video]
}

struct Video: Identifiable, Codable {
    let id: String
    let key: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case key
        case name
    }
}
