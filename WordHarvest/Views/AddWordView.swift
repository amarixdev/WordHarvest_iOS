//
//  AddWordView.swift
//  WordHarvest
//
//  Created by Amari DeVaughn on 1/22/24.
//

import SwiftUI
import AVFoundation
import SwiftData


extension Color {
    static let lightShadow = Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255)
    static let darkShadow = Color(red: 163 / 255, green: 177 / 255, blue: 198 / 255)
    static let background = Color(red: 224 / 255, green: 229 / 255, blue: 236 / 255)
    static let neumorphictextColor = Color(red: 132 / 255, green: 132 / 255, blue: 132 / 255)
}



struct AddWordView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var viewModel: WordViewModel
    @State private var loading = false
    @State private var searchText =  ""
    @FocusState  private var isFocused: Bool
    let words: [SavedWord]
    let book: Book
    let router: Router

   
    
    var audioURL: URL? {
        // Combine audioURLs into an array
        var audioURLs = viewModel.currentWord.flatMap { data in
            data.phonetics.compactMap { phonetic in
                phonetic.audio
            }
        }

        // Remove empty urls
        audioURLs.removeAll { $0.isEmpty }

        // Safely unwrap the first URL if available
        if let URLString = audioURLs.first, let url = URL(string: URLString) {
            return url
        } else {
            return nil
        }
    }
    
    var currentWordData: WordData {
        viewModel.currentWord[0]
    }
    
    var word: String {
        viewModel.currentWord[0].word
    }
    
    var phonetic: String? {
        viewModel.currentWord[0].phonetic
    }
    
    var definitions: [String] {
        viewModel.currentWord[0].meanings[0].definitions.compactMap { definitions in
            definitions.definition
        }
    }
    
    var synonyms: [String] {
        viewModel.currentWord[0].meanings.flatMap { meaning in
            meaning.definitions.flatMap { $0.synonyms }
        }
    }
    
    var example: String? {
        currentWordData.meanings[0].definitions[0].example
    }
    
    @State private var definitionIndex = 0
   

    var hasMultipleDefinitions: Bool {
        definitions.count > 1
    }
    
    var hasAudio: Bool {
        ((audioURL?.absoluteString.isEmpty) == false)
    }
    
    
    var collectedWords: [SavedWord] {
        words.filter { word in
            word.book == book.title
        }
    }
    
//    var quoteContainsQuotes: Bool {
//        return quoteText.contains("'") || quoteText.contains("\"")
//    }
//    
//    
    
    //ADD FOCUS VIEW.. HIDE everything: animate a view ("Build your vocabulary) == less crowded
  
    @Environment(\.dismiss) var dismiss
    
    var body: some View {


        baseView {
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.darkShadow)
                TextField("Look up a word...", text: $viewModel.word)
                }
                .padding()
                .foregroundColor(.neumorphictextColor)
                .background(.ultraThinMaterial)
                .cornerRadius(6)
                .padding()
                .focused($isFocused)
                .onSubmit {
                        
                    if viewModel.word.isEmpty {
                       return
                    }
                    
                    if viewModel.currentWord.isEmpty {
                        searchWord()
                    } else if currentWordData.word.lowercased() != viewModel.word.lowercased() {
                        searchWord()
                    }
                   
                }
            Spacer()

                
            if viewModel.currentWord.isEmpty {
                
                VStack(alignment:.leading) {
                    
                    Button {
                        router.path.append(Glossary.glossary)
                    } label: {
                        VStack(alignment:.leading) {
                            HStack {
                                Text("Collected words(\(collectedWords.count))")
                                    .font(.headline)
                                Image(systemName: "chevron.right")
                                
                            }
                            Text("Last added: \(collectedWords.last?.word?.capitalized ?? "") ")
                                .italic()
                                .foregroundStyle(.secondary)
                        }
                        .overlay {
                            if loading {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                        .offset(y: -50)
                             
                                }
                               
                               
                              
                            }
                        }
                    
                        .padding()
                       
                    }
                    .tint(.white)
                    .padding(.bottom, 50)
                    
                    if book.quotes?.count != 0 {
                        HStack {
                            Text("Saved Quotes")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                                .padding(.leading)
                            
                         
                            Spacer()
                        }
                    }
                 
                    
                    VStack(alignment: .leading, spacing:20) {
                        List {
                            if let allQuotes = book.quotes {
                                ForEach(allQuotes, id:\.self) { QUOTE in
                                    VStack {
                                        Text(QUOTE.quote!)
                                            .foregroundStyle(.primary).font(.subheadline) + Text(" - \(QUOTE.author ?? "") " )
                                            .foregroundStyle(.secondary).font(.subheadline)
                                        
                                    }
                                    .padding(.vertical)
                                    .listRowBackground(Color.app.opacity(0.5))

                                }
                                .onDelete(perform: deleteOffer)
                                .onMove { book.quotes?.move(fromOffsets: $0, toOffset: $1) }
                            }
                            
                        }
                        .listStyle(.plain)
                        .listRowSpacing(10)
                        
                    
                  
                    }
                    .padding(.top)
                    if !isFocused {
                        VStack {
                            ZStack {
                                Circle()
                                     .frame(width: 60, height: 60)
                                     .padding(.horizontal)
                                     .foregroundStyle(.app)
                                     .cornerRadius(30)
                                
                                Image(systemName: "plus")
                                    .imageScale(.large)
                                    .animation(.easeInOut, value: viewModel.invalidResponse)
                            }
                            .onTapGesture {
                                router.path.append(Quote.addQuote)
                            }
                            Text("Add quote")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                   
                  
                }
                .opacity(viewModel.word.isEmpty ? 1 : 0)
                .animation(.easeInOut(duration: 0.25), value: viewModel.word.isEmpty)
                .padding()
                
               Spacer()
            }
            
            if !viewModel.currentWord.isEmpty {
                
                ScrollView {
                    VStack(alignment:.leading, spacing: 5) {
                        HStack {
                            Text(currentWordData.word)
                                .font(.title.bold())
                            Text(phonetic ?? "")
                                .foregroundStyle(.secondary)
                        }
                       
                        HStack(alignment:.top) {
                            Text(definitions[definitionIndex])
                                .font(.subheadline)
                            Spacer()
                            if hasMultipleDefinitions  {
                                Button {
                                    definitionIndex += 1
                                    if definitionIndex == definitions.count {
                                        definitionIndex = 0
                                    }
                                } label: {
                                    Image(systemName: "arrow.right.circle")
                                        .imageScale(.large)
                                     
                                }
                            }
                      
                        }

                       PlayButton(hasAudio: hasAudio, audioURL: audioURL)
                        
                        VStack(alignment:.leading) {
                            Text("Example")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .underline()
                            Text(example ?? "Not Available")
                                .font(.subheadline)
                                .italic()
                        }
                        .padding(.vertical)
                        
                        if !synonyms.isEmpty {
                            VStack(alignment: .leading)
                             {
                                Text("Synonyms")
                                     .font(.subheadline)
                                    .foregroundStyle(.white)
                                 
                                    LazyVGrid(columns: [GridItem(spacing: 0), GridItem(spacing: 0)], alignment: .leading) {
                                        ForEach(synonyms.prefix(4), id:\.self) { word in
                                                Text(word)
                                                .padding(.horizontal, 20)
                                                .padding(.vertical, 10)
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                    .background(.ultraThickMaterial)
                                                    .cornerRadius(5)
                                                    .padding(.vertical, 5)
                                                    .onTapGesture {
                                                        print(synonyms)
                                                    }
                                           
                                        }
                                    }
                                    .padding(.vertical)

                                }

                            
                        }
                        
                      
                    }
                    .onAppear {
                        viewModel.word = ""
                        loading = false
                        print("SYNONYMS: ", synonyms)
                      
                    }
                    .padding(.horizontal)
                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                .foregroundStyle(.white)
                }
                
                Spacer()
                
                HStack(spacing: 150) {
                    Button{
                        viewModel.currentWord  = []
                    } label: {
                        VStack {
                            ZStack {
                                Circle()
                                    .frame(width: 60, height: 60)
                                    .foregroundStyle(.red)
                               Image(systemName: "xmark")
                                    .imageScale(.large)
                                    .foregroundStyle(.white)
                            }
                            Text("Clear")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                        }
                   
                       
                    }
                    Button{
                        let wordToSave = SavedWord(word: currentWordData.word, phonetic: phonetic, definitions: definitions, audio: audioURL, example: example, synonyms: synonyms, book: book.title ?? "")
                        
                        modelContext.insert(wordToSave)
                        
                        viewModel.currentWord  = []
                        
                    } label: {
                        VStack {
                            ZStack {
                                Circle()
                                    .frame(width: 60, height: 60)
                                    .foregroundStyle(.green)
                               Image(systemName: "checkmark")
                                    .imageScale(.large)
                                    .foregroundStyle(.white)
                            }
                            
                            Text("Save")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                        }
                   
                       
                    }
                }
                .padding(.bottom, 20)
            }

        }
        .scrollBounceBehavior(.basedOnSize)
        .navigationTitle(book.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Quote.self) { _ in
            AddQuoteView(author: book.author)
        }
        .navigationDestination(for: Glossary.self) { _ in
            GlossaryView(savedWords: collectedWords)
        }
        .alert("Invalid Response",isPresented: $viewModel.invalidResponse) {
            Button("OK") {
                viewModel.invalidResponse = false
                loading = false
            }
        } message: {
           Text("There was an issue finding the word")
           
        }

        .toolbar {
            if book.quotes?.count != 0 {
                ToolbarItem(placement: .topBarTrailing) {
                        EditButton()

                }
                   }
            }
           

      
        
    }
    

    
    func deleteOffer(offsets: IndexSet) {
        do {
            book.quotes?.remove(atOffsets: offsets)
           try modelContext.save()
        } catch {
            print(error.localizedDescription)
        }
               
        }
    

    
    func searchWord() {
        viewModel.fetchWordData(for: viewModel.word)
        searchText = viewModel.word
        loading = true
    }
  
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: SavedWord.self, Book.self, configurations: config)

        return  NavigationStack {
            AddWordView(viewModel: WordViewModel(), words: [imagination, dream], book: beHereNow, router: Router())
                .preferredColorScheme(.dark)
                .modelContainer(container)
            
        }
      
        
    } catch  {
        return Text("No Data error: \(error.localizedDescription)")
    }
   
    
}
