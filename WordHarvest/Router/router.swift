//
//  router.swift
//  WordHarvest
//
//  Created by Amari DeVaughn on 1/22/24.
//

import Foundation
import SwiftUI

enum Page: String {
    case addBook
    case addWord
}

enum Quote: String {
    case addQuote
}

enum Glossary: String {
    case glossary
}


class Router: ObservableObject {
    @Published var path = NavigationPath()
    
}
