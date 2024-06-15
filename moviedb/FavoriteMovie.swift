//
//  FavoriteMovie.swift
//  moviedb
//
//  Created by oscar perdana on 15/06/24.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct FavoriteMoviesCarousel: View {
    @Binding var favoriteMovies: [Movie]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(favoriteMovies) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        VStack {
                            Text(movie.title)
                                .font(.headline)
                            if let posterPath = movie.posterPath {
                                WebImage(url: URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)"))
                                    .resizable()
                                    .frame(width: 100, height: 150)
                                    .cornerRadius(8)
                                    .transition(.fade(duration: 0.5))
                            } else {
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(width: 100, height: 150)
                            }
                            if let releaseDate = movie.releaseDate {
                                Text(releaseDate)
                                    .font(.subheadline)
                            } else {
                                Text("Unknown Release Date")
                                    .font(.subheadline)
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .frame(height: 200)
    }
}
