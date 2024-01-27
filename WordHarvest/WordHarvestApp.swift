//
//  WordHarvestApp.swift
//  WordHarvest
//
//  Created by Amari DeVaughn on 1/22/24.
//

import SwiftUI
import SwiftData

@main
struct WordHarvestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for:[SavedWord.self, Book.self])
              
        }
    }
}
