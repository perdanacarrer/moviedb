//
//  moviedbApp.swift
//  moviedb
//
//  Created by oscar perdana on 15/06/24.
//

import SwiftUI

@main
struct moviedbApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
