//
//  DictionaryAPI.swift
//  WordHarvest
//
//  Created by Amari DeVaughn on 1/22/24.
//

import Foundation


    
    // Main structure for the word data

    





@Observable
class WordViewModel: Identifiable {
    var word = ""
    var currentWord: [WordData] = [WordData]()
    var invalidResponse = false
    
    func fetchWordData(for word: String) {
        let urlString = "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)"
        
        guard let url = URL(string: urlString) else {
            print("invalid URL")
            return
        }
        
        let task  = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
       
                print("Error fetching data: \(error.localizedDescription)")
                            return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                self.invalidResponse = true
                
                print("invalid response")
                return
            }
            
            
            guard let data = data else {
                print("No data received")
                 return
            }
            
            
            do {
                //decode JSON
                let wordData = try JSONDecoder().decode([WordData].self, from: data)
                self.currentWord = wordData
                //handle the decoded data
                for data in wordData {
                    print(data)
                }
                
               
                print(wordData[0].meanings[0].definitions.count)
                self.invalidResponse = false
               
                
            } catch {
                self.invalidResponse = true
                print("Error parsing data: \(error.localizedDescription)")
            }
                
        }
        task.resume()
    }

}



