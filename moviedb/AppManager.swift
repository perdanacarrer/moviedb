//
//  ConnectionManager.swift
//  moviedb
//
//  Created by oscar perdana on 15/06/24.
//

import Foundation
import Alamofire
import CoreData

class ConnectionManager: ObservableObject {
    private let apiKey = "200aa5f549e82d071c687e56cf678548"
    private let baseUrl = "https://api.themoviedb.org/3"
    private let coreDataManager = PersistenceController.shared
    @Published var movies: [Movie] = []

    func fetchMovies(query: String) {
        let url = "\(baseUrl)/search/movie?api_key=\(apiKey)&query=\(query)"
        AF.request(url).responseDecodable(of: MovieResponse.self) { [weak self] response in
            switch response.result {
            case .success(let movieResponse):
                DispatchQueue.main.async {
                    self?.movies = movieResponse.results
                    self?.updateCoreData(with: self?.movies ?? [])
                }
            case .failure(let error):
                print("Error fetching movies: \(error)")
            }
        }
    }

    func fetchPopularMovies() {
        let url = "\(baseUrl)/movie/popular?api_key=\(apiKey)"
        AF.request(url).responseDecodable(of: MovieResponse.self) { [weak self] response in
            switch response.result {
            case .success(let movieResponse):
                DispatchQueue.main.async {
                    self?.movies = movieResponse.results
                    self?.updateCoreData(with: self?.movies ?? [])
                }
            case .failure(let error):
                print("Error fetching popular movies: \(error)")
            }
        }
    }
    
    private func updateCoreData(with movies: [Movie]) {
        clearCoreData()
        
        let context = coreDataManager.context
        for movie in movies {
            let movieEntity = MovieEntity(context: context)
            movieEntity.id = Int32(movie.id)
            movieEntity.title = movie.title
            movieEntity.overview = movie.overview
            movieEntity.posterPath = movie.posterPath
            movieEntity.releaseDate = movie.releaseDate
            movieEntity.voteAverage = movie.voteAverage
        }
        
        coreDataManager.saveContext()
    }

    private func clearCoreData() {
        let context = coreDataManager.context
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "MovieEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
        } catch {
            print("Error deleting objects from CoreData: \(error)")
        }
    }
    
    func loadMoviesFromCoreData() -> [Movie] {
        let context = coreDataManager.context
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()

        do {
            let movieEntities = try context.fetch(fetchRequest)
            let movies = movieEntities.map { Movie(id: Int($0.id), title: $0.title ?? "", overview: $0.overview ?? "", posterPath: $0.posterPath, backdropPath: $0.backdropPath, releaseDate: $0.releaseDate, voteAverage: $0.voteAverage) }
            return movies
        } catch {
            print("Error fetching movies from CoreData: \(error)")
            return []
        }
    }
}

class MovieDetailManager: ObservableObject {
    @Published var cast: [Actor] = []
    @Published var videos: [Video] = []
    
    func fetchMovieDetails(movieId: Int) {
        let apiKey = "200aa5f549e82d071c687e56cf678548"
        let castUrl = "https://api.themoviedb.org/3/movie/\(movieId)/credits?api_key=\(apiKey)"
        let videosUrl = "https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=\(apiKey)"
        
        AF.request(castUrl).responseDecodable(of: CastResponse.self) { [weak self] response in
            switch response.result {
            case .success(let castResponse):
                self?.cast = castResponse.cast
            case .failure(let error):
                print("Error fetching cast: \(error)")
            }
        }
        
        AF.request(videosUrl).responseDecodable(of: VideoResponse.self) { [weak self] response in
            switch response.result {
            case .success(let videoResponse):
                self?.videos = videoResponse.results
            case .failure(let error):
                print("Error fetching videos: \(error)")
            }
        }
    }
}
