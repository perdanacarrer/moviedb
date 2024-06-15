//
//  moviedbTests.swift
//  moviedbTests
//
//  Created by oscar perdana on 15/06/24.
//

import XCTest
@testable import moviedb

class ContentViewUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        
        let searchField = app.textFields["Search movies..."]
        XCTAssertTrue(searchField.exists, "Search field should exist")
        searchField.tap()
        searchField.typeText("Avengers")
        app.buttons["Search"].tap()
        
        let firstMovieCell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(firstMovieCell.exists, "First movie cell should exist")
        firstMovieCell.tap()
        
        let favoriteButton = app.buttons["star"]
        XCTAssertTrue(favoriteButton.exists, "Favorite button should exist")
        favoriteButton.tap()
        
        app.navigationBars["Movie Details"].buttons["Movies"].tap()
    }
}

class MovieDetailManagerTests: XCTestCase {
    
    var movieDetailManager: MovieDetailManager!
    
    override func setUp() {
        super.setUp()
        movieDetailManager = MovieDetailManager()
    }

    override func tearDown() {
        movieDetailManager = nil
        super.tearDown()
    }

    func testFetchMovieDetails() {
        let expectation = XCTestExpectation(description: "Fetch movie details expectation")
        let movieId = 56789 // Replace with a valid movie ID from TMDB
        
        movieDetailManager.fetchMovieDetails(movieId: movieId)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            XCTAssertFalse(self.movieDetailManager.cast.isEmpty, "Cast should not be empty")
            XCTAssertFalse(self.movieDetailManager.videos.isEmpty, "Videos should not be empty")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
