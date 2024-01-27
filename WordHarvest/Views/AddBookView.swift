//
//  BookView.swift
//  WordHarvest
//
//  Created by Amari DeVaughn on 1/24/24.
//

import SwiftUI

struct AddBookView: View {
    let router: Router
    @State private var bookTitle = ""
    @State private var bookAuthor = ""
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    var buttonDisabled: Bool {
        bookTitle.isEmpty == true || bookAuthor.isEmpty == true
    }

    var body: some View {
        baseView {
            VStack {
                HStack(spacing:20) {
                    Text("What are you reading?")
                          .font(.title2.bold())
                          .fontWeight(.medium)
                          .padding(.vertical)
      
                }
            
                VStack {
                    TextField("Title", text: $bookTitle)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                        .padding()
                        
                    Divider()
                        .padding(.horizontal)
                
                    TextField("Author", text: $bookAuthor)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .padding()
                    
                    
                }
                .padding(.vertical, 40)
                
                Spacer()
                
                Button {
                    dismiss()
                    
                    let bookToAdd = Book(title: bookTitle, author: bookAuthor)
                    modelContext.insert(bookToAdd)
                    
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 100, height: 100)
                            .foregroundStyle(.ultraThinMaterial)
                            Text("Add")
                            .font(.headline)
                            .tint(.white)
                    
                    }
                }
                .disabled(buttonDisabled)
                
              
  
                
                Spacer()
                
               
            }
            .padding()
        }
        
     
  
    }
    
    func addWord() {
        router.path.append(Page.addWord)
    }
}

#Preview {
    AddBookView(router: Router())
        .preferredColorScheme(.dark)
}
