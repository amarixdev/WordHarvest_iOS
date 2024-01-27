//
//  HomeView.swift
//  WordHarvest
//
//  Created by Amari DeVaughn on 1/22/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var wordToAdd = ""
    @StateObject var router = Router()
    let savedWords: [SavedWord]
    let books: [Book]
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var randomIndex = 0
    
    var wordOfTheDay: SavedWord? {
        if savedWords.isEmpty {
            return nil
        } else {
            return savedWords[randomIndex]
        }
      
    }
   
    @State private var headerOpacity:Double = 1
    @State private var shuffled = Bool()
    
    @State private var longPressedToggle = false
    @State private var showDeleteConfirmation = false
    @State private var showEditTitleSheet = false

    @State private var selectedBook = Book()
    @State private var editTitleText = ""
    
    
    enum Swipe: String {
        case left
        case right
    }
    func handleSwipe(dir: Swipe) {
        
        if dir == .left {
            if randomIndex == 0 {
                randomIndex = savedWords.count - 1
            } else {
                randomIndex -= 1
            }
        }
        
        if dir == .right {
            if randomIndex == savedWords.count - 1 {
                randomIndex = 0
            } else {
                randomIndex += 1
            }
        }
        
       
        
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            baseView {
                ScrollView {
                    Text("Vocab Builder")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .underline()
                        .padding()
                        .opacity(headerOpacity)
                        .padding(.bottom, 20)
                    
                    if books.isEmpty {
                        Text("You haven't added any books yet!")
                            .foregroundStyle(.secondary)
                        Spacer()
                        
                        ZStack {
                            Circle()
                                 .frame(width: 60, height: 60)
                                 .padding()
                                 .foregroundStyle(.app)
                                 .cornerRadius(30)
                            
                            Image(systemName: "plus")
                                .imageScale(.large)
                        }
                            .onTapGesture {
                                router.path.append(Page.addBook)
                            }
                        Spacer()
                        
                    } else {
                        
                        VStack(alignment:.leading) {
                            HStack {
                                Text(wordOfTheDay?.word ?? "")
                                    .font(.title.bold())
                                Text(wordOfTheDay?.phonetic ?? "" )
                                    .foregroundStyle(.secondary)
                                    Spacer()
                              
                            }
                            .padding(.horizontal)
                            
                            
                            
                            if  wordOfTheDay == nil {
                                VStack(alignment:.leading) {
                                    Text("Build your vocabulary as your read!")
                                        .foregroundStyle(.primary)
                                        .font(.headline)
                                    Text("Select a book to get started")
                                        .foregroundStyle(.secondary)
                                        .font(.subheadline)
                                }
                                .padding()
                                
                               }
                            
                            if wordOfTheDay != nil {
                                VStack(alignment: .leading) {
                                    Text( wordOfTheDay?.definitions?[0] ?? "")
                                        .font(.subheadline)
                                        .padding()
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(8)
                                        .shadow(color:.black, radius: 6, y: 4)
                                        .gesture (
                                            DragGesture()
                                                .onEnded { value in
                                                    if value.translation.width > 50 {
                                                        handleSwipe(dir: .right)
                                                    } else if value.translation.width < -50 {
                                                        handleSwipe(dir: .left)
                                                    }
                                                }
                                        )

                                }
                                .padding(.horizontal)
                                .frame(height: 150, alignment: .top)
         
                            }
                        }
                      
                   
                        if wordOfTheDay != nil  {
                            Spacer()
                        }
                        VStack(alignment:.leading) {
                            Text("Books (\(books.count))")
                                .font(.title.bold())
                                .padding(.leading)
                                ScrollView(.horizontal) {
                          
                                    HStack {
                                        ForEach(books) { book in
                                            
                                            let index = books.firstIndex { BOOK in
                                                BOOK.title == book.title
                                            }
                                            
                                            VStack(alignment:.leading) {
                                                    ZStack {
                                                        Rectangle()
                                                            .frame(width: 150, height: 150)
                                                            .cornerRadius(5)
                                                            .foregroundStyle(getBookColor(bookIndex: (index ?? 0)).opacity(0.6))
                                                        VStack {
                                                            Image(systemName: "book")
                                                                .resizable()
                                                                .frame(width: 60, height: 60)
                                                                .foregroundStyle(.secondary)
                                                        }
                                                    }
                                                    Text(book.title ?? "")
                                                        .font(.subheadline)
                                                        .fontWeight(.semibold)
                                                    Text(book.author ?? "")
                                                        .font(.subheadline)
                                                        .foregroundStyle(.secondary)
                                                }
                                                
                                                .frame(width: 150, height: 220, alignment: .top)
                                                .padding()
                                                .onTapGesture {
                                                    headerOpacity = 0
                                                    router.path.append(book)
                                                }
                                                .onLongPressGesture {
                                                    longPressedToggle.toggle()
                                               
                                                }
                                                .contextMenu {
                                                    
                                                    Button {
                                                        showDeleteConfirmation = true
                                                     selectedBook = book
                                                    } label: {
                                                            Label("Delete book",  systemImage: "trash")
                                                    }

                                                                }
                                        }
                                    }
                                }
                                .scrollBounceBehavior(.basedOnSize)
                        }
                        .padding(.top, 20)
                       
                
                           

                        Spacer()
                        HStack {
                            VStack {
                                ZStack {
                                    Circle()
                                         .frame(width: 60, height: 60)
                                         .padding(.horizontal)
                                         .foregroundStyle(.app)
                                         .cornerRadius(30)
                                    
                                    Image(systemName: "plus")
                                        .imageScale(.large)
                                }
                                    .onTapGesture {
                                        router.path.append(Page.addBook)
                                    }
                                Text("Add book")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                          
                            Spacer()
                        }
                      

                    }
                }
                .scrollBounceBehavior(.basedOnSize)
                .sensoryFeedback(.selection, trigger: shuffled)
                .onAppear {
                    headerOpacity = 1
                    print(books.count)
                }
                .navigationDestination(for: Book.self) { book in
                    AddWordView(viewModel: WordViewModel(), words: savedWords, book: book, router: router)
                }
                .navigationDestination(for: Page.self) { page in
                    if page.rawValue == "addBook" {
                        AddBookView(router: router)
                    }
                }
             
            }
            .sensoryFeedback(.success, trigger: longPressedToggle )
            .sensoryFeedback(.impact, trigger: randomIndex )
                    
                }
        .onAppear {
            if savedWords.isEmpty != true {
                randomIndex = Int.random(in: 0...(savedWords.count - 1))
            }
            
        }
        
        .alert("Delete Book",isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
              deleteBook(bookToDelete: selectedBook)
            }
        } message: {
            Text("Are you sure you want to remove this book?")
           
        }
            
    
                
               
    }
    
    
    func deleteBook (bookToDelete: Book) {
        modelContext.delete(bookToDelete)
    }
    
    func editBook (bookToEdit: Book) {
       
    }
    
    
    
    
    func getBookColor(bookIndex: Int) -> Color {
        var totalBooks = savedWords.count
        let divisor = Int(floor( Double ((bookIndex) / 7)))
        
        if bookIndex > 7 {
           totalBooks = bookIndex - (7 * divisor )
        } else {
            totalBooks = bookIndex
        }
      
        switch(totalBooks) {
        case 1 : return .orange
        case 2 : return .yellow
        case 3 : return .green
        case 4 : return .cyan
        case 5 : return .purple
        case 6 : return .indigo
        default: return .red
        }
    }
 
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: SavedWord.self, Book.self, configurations: config)

        return  NavigationStack {
            HomeView(savedWords: [imagination, dream], books: [beHereNow])
                .preferredColorScheme(.dark)
                .modelContainer(container)
        }
      
        
    } catch  {
        return Text("No Data error: \(error.localizedDescription)")
    }
}
