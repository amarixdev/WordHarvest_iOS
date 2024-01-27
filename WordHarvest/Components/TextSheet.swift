//
//  TextSheet.swift
//  WordHarvest
//
//  Created by Amari DeVaughn on 1/26/24.
//

import SwiftUI




struct TextSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var writerNameText: String
    @Binding var writerNameSet: Bool
    @Binding var writerSelection: String
    
    
    var body: some View {
        VStack(alignment:.leading) {
            Text("Name an author for the quote")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top)
                .padding(.leading)
            TextField("Quote By... ", text: $writerNameText) {
                if !writerNameText.isEmpty {
                    writerNameSet = true
                    writerSelection = writerNameText
                    dismiss()
                }
             
            }
                .padding()
                
                 .frame(height: 50)
                 .background(.ultraThinMaterial)
                 .cornerRadius(6)
                 .padding()
            
            Spacer()
        }
        
    }
}
#Preview {
    TextSheet(writerNameText: .constant(""), writerNameSet: .constant(false), writerSelection: .constant(""))
}
