//
//  ContentView.swift
//  moviedb
//
//  Created by oscar perdana on 15/06/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    @ObservedObject var connectionManager = ConnectionManager()
    @State private var searchQuery = ""
    @State private var emptyString = ""
    @State private var favoriteMovies: [Movie] = []
    @State private var isNetworkConnected = true

    var body: some View {
        NavigationView {
            VStack {
                ZStack(alignment: .leading) {
                    TextField("", text: $emptyString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 20)
                        TextField("Search movies...", text: $searchQuery, onCommit: {
                            connectionManager.fetchMovies(query: searchQuery)
                        })
                            .foregroundColor(.black)
                            .padding(.trailing, 20)
                    }
                }

                if !favoriteMovies.isEmpty {
                    Text("Favorite Movies")
                        .font(.headline)
                        .padding(.leading)
                        .padding(.top, 10)
                    FavoriteMoviesCarousel(favoriteMovies: $favoriteMovies)
                        .padding(.vertical)
                }

                List(connectionManager.movies) { movie in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(movie.title)
                                .font(.headline)
                            if let releaseDate = movie.releaseDate {
                                Text(releaseDate)
                                    .font(.subheadline)
                            } else {
                                Text("Unknown Release Date")
                                    .font(.subheadline)
                            }
                            Text(movie.overview)
                                .font(.body)
                                .lineLimit(3)
                        }
                        Spacer()
                        if let posterPath = movie.posterPath {
                            WebImage(url: URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)"))
                                .resizable()
                                .transition(.fade(duration: 0.5))
                                .frame(width: 50, height: 75)
                                .cornerRadius(8)
                        }
                        Button(action: {
                            toggleFavorite(movie: movie)
                        }) {
                            Image(systemName: favoriteMovies.contains(movie) ? "star.fill" : "star")
                                .foregroundColor(favoriteMovies.contains(movie) ? .yellow : .gray)
                        }
                    }
                }
                .onAppear {
                    checkNetworkStatus()
                    connectionManager.fetchPopularMovies()
                }
                .overlay(
                    Text(connectionManager.movies.isEmpty ? "No Data" : "")
                        .padding()
                )
            }
            .navigationBarTitle("Movies")
        }
    }

    private func toggleFavorite(movie: Movie) {
        if let index = favoriteMovies.firstIndex(of: movie) {
            favoriteMovies.remove(at: index)
        } else {
            favoriteMovies.append(movie)
        }
    }

    private func checkNetworkStatus() {
        isNetworkConnected = NetworkReachability.shared.isConnected()
        if !isNetworkConnected {
            connectionManager.movies = connectionManager.loadMoviesFromCoreData()
        }
    }
}
