//
//  Library.swift
//  WordHarvest
//
//  Created by Amari DeVaughn on 1/24/24.
//

import SwiftUI
import SwiftData

struct GlossaryView: View {
    let savedWords: [SavedWord]
    @Environment(\.modelContext) var modelContext
    @State private var showDeleteConfirmation = false
    @State private var selectedWord:SavedWord = .init()
    @State  var searchText = ""
    
    func deleteWord(wordToDelete: SavedWord) {
        modelContext.delete(wordToDelete)
    }
    
    var body: some View {
 
            baseView {
                ScrollView {
                    ForEach(savedWords) { data in
                        VStack(alignment:.leading) {
                            HStack(alignment: .top) {
                                VStack(alignment:.leading) {
                                    Text(data.word ?? "")
                                        .font(.subheadline)
                            
                                Text(data.definitions?[0] ?? "")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                                }
                               Spacer()
                                
                                Menu {
                                    Button {
                                        showDeleteConfirmation = true
                                        selectedWord = data                              } label: {
                                            Label("Delete book",  systemImage: "trash")
                                    }
                                } label: {
                                    VStack(spacing: 5) {
                                        ForEach(0..<3) {_ in
                                            Circle()
                                                .frame(width: 4, height: 4)
                                                .foregroundStyle(.primary)
                                        }
                                        
                                    }
                                    .padding()
                                  
                                }
                                .tint(.primary)
                                
                              
                            }
                              
                        }
                        .listSectionSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .frame(alignment: .leading)
                            .padding(.leading)
                            .padding(.vertical)
                            .background(.ultraThinMaterial.opacity(0.5))
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
            
                        

                    }
                }
                .padding(.top, 20)
                     
                           
                   Spacer()
                
                   .listStyle(.plain)
              
                
               }
            .navigationTitle("Glossary")
            .searchable(text: $searchText, prompt: "Search")
            .alert("Delete word",isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    deleteWord(wordToDelete: selectedWord)
                }
            } message: {
                Text("Are you sure you want to remove this book?")
               
            }

        }

}

    
    #Preview {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: SavedWord.self, configurations: config)

            return  NavigationStack {
                GlossaryView(savedWords: [imagination, dream])
                    .preferredColorScheme(.dark)
                    .modelContainer(container)
            }
          
            
        } catch  {
            return Text("No Data error: \(error.localizedDescription)")
        }
       
        
    }
    
