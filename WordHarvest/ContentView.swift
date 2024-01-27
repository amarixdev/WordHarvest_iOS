//
//  ContentView.swift
//  WordHarvest
//
//  Created by Amari DeVaughn on 1/22/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query var savedWords: [SavedWord]
    @Query var books: [Book]
    @StateObject var router = Router()
    
    init() {
        // Customize the UITabBar appearance
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor.black // Set your color here

        // Apply the appearance to all tab bars
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some View {
        TabView {
                HomeView(savedWords: savedWords, books: books)
                    .ignoresSafeArea(.keyboard)
                .tabItem { Image(systemName: "house.fill") }
                .tint(.white)
                .tag("Home")
                
            NavigationStack(path: $router.path ) {
                GlossaryView(savedWords: savedWords)
              
            }
            .tabItem { Image(systemName: "book.fill") }
            .tint(.white)
            .tag("Library")
               

            //Home
         
        }
      
       
       
    }
    
   
}
