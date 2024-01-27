//
//  Books.swift
//  WordHarvest
//
//  Created by Amari DeVaughn on 1/24/24.
//

import SwiftData
import SwiftUI

@Model
class Book {
    var title: String?
    var author: String?
    var quotes: [Quote]?
    var completed: Bool?


    struct Quote:Codable, Hashable {
        var quote: String?
        var author: String?
    }
  
    init(title: String? = nil, author: String? = nil, quotes: [Quote]? = nil, completed: Bool? = nil) {
        self.title = title
        self.author = author
        self.quotes = quotes
        self.completed = completed
    }

}
