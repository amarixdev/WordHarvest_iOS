//
//  FormatQuote.swift
//  WordHarvest
//
//  Created by Amari DeVaughn on 1/27/24.
//

import Foundation


func formatQuote (from input: String) -> String {
    let trimmedString = input.trimmingCharacters(in: .whitespacesAndNewlines)
    let noSingleQuotes = trimmedString.replacingOccurrences(of: "'", with: "")
    let noQuotes = noSingleQuotes.replacingOccurrences(of: "\"", with: "")
    return noQuotes
}
