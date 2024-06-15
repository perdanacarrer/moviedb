//
//  MovieDetailView.swift
//  moviedb
//
//  Created by oscar perdana on 15/06/24.
//

import SwiftUI
import SDWebImageSwiftUI
import YouTubePlayerKit

struct MovieDetailView: View {
    var movie: Movie
    @StateObject private var detailManager = MovieDetailManager()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let posterPath = movie.posterPath {
                    ZStack {
                        WebImage(url: URL(string: "https://image.tmdb.org/t/p/w300\(posterPath)"))
                            .resizable()
                            .scaledToFill()
                            .blur(radius: 10)
                            .clipped()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxHeight: 120)
                    }
                    HStack(alignment: .top) {
                        WebImage(url: URL(string: "https://image.tmdb.org/t/p/w300\(posterPath)"))
                            .resizable()
                            .frame(width: 120, height: 160)
                            .cornerRadius(10.0)
                            .padding()
                    }
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text(movie.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    StarsView(rating: CGFloat(movie.voteAverage), votes: "")
                    if let releaseDate = movie.releaseDate {
                        Text("Release Date: \(releaseDate)")
                    }
                    Text(movie.overview)
                        .font(.body)
                        .padding(.top, 10)
                }
                .padding()
                
                Text("Actors")
                    .font(.headline)
                    .padding(.leading)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(detailManager.cast) { actor in
                            VStack {
                                if let profilePath = actor.profilePath {
                                    WebImage(url: URL(string: "https://image.tmdb.org/t/p/w200\(profilePath)"))
                                        .resizable()
                                        .frame(width: 100, height: 150)
                                        .cornerRadius(8)
                                } else {
                                    Rectangle()
                                        .fill(Color.gray)
                                        .frame(width: 100, height: 150)
                                }
                                Text(actor.name)
                                    .font(.caption)
                                    .lineLimit(1)
                            }
                            .padding(.leading, 10)
                        }
                    }
                }
                .frame(height: 180)
                
                Text("Related Videos")
                    .font(.headline)
                    .padding(.leading)
                    .padding(.top, 10)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(detailManager.videos) { video in
                            VStack {
                                YouTubePlayerView(YouTubePlayer(source: .url("https://www.youtube.com/watch?v=\(video.key)")))
                                    .frame(width: 200, height: 120)
                                    .cornerRadius(8)
                                Text(video.name)
                                    .font(.caption)
                                    .lineLimit(1)
                            }
                            .padding(.leading, 10)
                        }
                    }
                }
                .frame(height: 140)
            }
        }
        .onAppear {
            detailManager.fetchMovieDetails(movieId: movie.id)
        }
        .navigationBarTitle(Text(movie.title), displayMode: .inline)
    }
}

struct StarsView: View {
    var rating: CGFloat
    let votes: String
    let maxRating: Int = 10
    var starCount: Int = 5

    var body: some View {
        let adjustedRating = rating / 2.0

        HStack {
            let stars = HStack(spacing: 0) {
                ForEach(0..<starCount, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 20)
                }
            }

            stars.overlay(
                GeometryReader { g in
                    let width = adjustedRating / CGFloat(starCount) * g.size.width
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .frame(width: width)
                            .foregroundColor(.yellow)
                    }
                }
                .mask(stars)
            )
            .foregroundColor(.gray)
            .frame(height: 20)
            .padding(.trailing, 5)

            VStack(alignment: .leading, spacing: 5) {
                Text(String(format: "%.1f / %d", rating, maxRating))
                    .foregroundColor(.blue)
                    .font(.headline)
                
                Text("\(votes) Ratings")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
        }
        .padding(.bottom, 10)
    }
}
