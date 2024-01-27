//
//  AddQuoteView.swift
//  WordHarvest
//
//  Created by Amari DeVaughn on 1/25/24.
//

import SwiftUI
import SwiftData





struct AddQuoteView: View {
    let author: String?

    @State private var quoteText = ""
    @State private var writerSelection: String
    @State private var writerNameText = "Other"
    @State private var writerNameSet = false
    
    @State private var otherTapped = false
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var showAlert = false

    
    var other: String {
        if writerNameText == "" {
            return "Other"
        } else {
            return  writerNameSet ? writerNameText : "Other"
        }
       
    }
    
    
 
    
    var isOtherSelection: Bool {
        writerSelection != author && writerSelection != "Unknown"
    }
    
    
    var quoteAuthorSelections: [String] {
        if writerNameText == "" {
          return  [author ?? "", "Unknown", "Other"]
        } else {
          return  [author ?? "", "Unknown", writerNameText]
        }
        
    }
    
    init(author: String?) {
        self.author = author
        self._writerSelection = State(initialValue: author ?? "")
    }
    
   
    var body: some View {
        baseView {
            VStack {
          
           
                
                HStack() {
                    Image(systemName: "quote.opening")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.secondary.opacity(0.15))

                    TextEditor(text: $quoteText)
                        .font(.subheadline)
                        .padding()
                        .scrollContentBackground(.hidden)
                        .background(.ultraThinMaterial.opacity(0.5))
                        .frame(height: 150)
                        .cornerRadius(5)
                       
                        .padding()
                    Image(systemName: "quote.closing")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.secondary.opacity(0.15))

                    
                }
                .padding(.horizontal)
                
                VStack(spacing: 40) {
                    Text("- \(writerSelection)")
                        .foregroundStyle(.secondary)

                    
                    Picker("Quote By:", selection: $writerSelection) {
                        ForEach(quoteAuthorSelections, id:\.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .tint(.secondary)
                    .padding(.horizontal)
           
                   
                }

                Spacer()
                
                Button {
                    
                    if writerSelection == "Other" {
                       showAlert = true
                    } else
                    
                    {
                        Task {
                            do {
                                let quoteToAdd:Book.Quote = .init(quote: formatQuote(from: quoteText), author: writerSelection )

                                let fetchDescriptor = FetchDescriptor<Book>(predicate: #Predicate { book in book.author == author })
                                
                                let books = try modelContext.fetch(fetchDescriptor)

                                if let firstBook = books.first {

                                    if ((firstBook.quotes?.isEmpty ) == false) {
                                        firstBook.quotes?.append(quoteToAdd)
                                    } else {
                                        firstBook.quotes = [quoteToAdd]
                                    }

                                    // Save changes to the context
                                    try modelContext.save()
                                    print(quoteText)
                                    dismiss()
                                    
                                } else {
                                    print("No book found for the given author.")
                                }
                                
                            } catch {
                                print("ERROR: \(error.localizedDescription)")
                            }
                        }
                    }

  
                    
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 75, height: 75)
                            .foregroundStyle(.ultraThinMaterial)
                            Text("Add")
                            .font(.subheadline)
                            .tint(.white)
                    
                    }
                    .padding(.bottom, 40)
                }
              
               
            }
        }
        .navigationTitle("Add A Quote")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $otherTapped) {
            TextSheet(writerNameText: $writerNameText, writerNameSet: $writerNameSet, writerSelection: $writerSelection )
                .presentationDetents([.height(150)])
        }
        .onChange(of: writerSelection) { oldValue, newValue in
            if newValue != author && newValue != "Unknown" {
                otherTapped = true
            }
        }
        .alert("Invalid Input - Other", isPresented: $showAlert) {
            Button("OK") {
                
            }
        } message: {
            Text("Please name an author for the quote, or select \"Unknown\" ")
        }
      
       
           
    }
 
    
    func tapOther () {
        if isOtherSelection {
            otherTapped = true
        }
    }
    
}




#Preview {
    NavigationStack {
        AddQuoteView(author: "Ram Dass")
            .preferredColorScheme(.dark)
    }
    
}
