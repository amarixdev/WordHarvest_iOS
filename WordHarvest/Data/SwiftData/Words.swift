//
//  Words.swift
//  WordHarvest
//
//  Created by Amari DeVaughn on 1/22/24.
//

import Foundation
import SwiftData

struct WordData: Codable, Hashable {
    let word: String
    let phonetic: String?
    let phonetics: [Phonetic]
    let origin: String?
    let meanings: [Meaning]
}

// Structure for phonetics
struct Phonetic: Codable, Hashable {
    let text: String?
    let audio: String?
}

struct Meaning: Codable, Hashable {
    let partOfSpeech: String
    let definitions: [Definition]
}

// Structure for definitions
struct Definition: Codable, Hashable {
    let definition: String
    let example: String?
    let synonyms: [String]
    let antonyms: [String]
}


@Model
 class SavedWord {
     
        let word: String?
        let phonetic: String?
        let definitions: [String?]?
        let audio: URL?
        let example: String?
        let synonyms: [String?]?
        let book: String?
   
        var hasAudio: Bool {
         audio?.absoluteString.isEmpty == false
     }

     init(word: String? = nil, phonetic: String? = nil, definitions: [String?]? = nil, audio: URL? = nil, example: String? = nil, synonyms: [String?]? = nil, book: String? = nil) {
         self.word = word
         self.phonetic = phonetic
         self.definitions = definitions
         self.audio = audio
         self.example = example
         self.synonyms = synonyms
         self.book = book
     }
     
     
  
  
}


