//
//  PlayButton.swift
//  WordHarvest
//
//  Created by Amari DeVaughn on 1/24/24.
//

import SwiftUI
import SwiftData

struct PlayButton: View {
    var hasAudio: Bool
    var audioURL: URL?
    
    var body: some View {
        Button {
            if ((audioURL?.absoluteString.isEmpty) == false) {
                Sounds.playSounds(soundFileURL: audioURL)
            }
            
        } label: {
            Label("Pronunciation", systemImage: "speaker.wave.2")
        }
        .disabled(!hasAudio)
        .buttonStyle(.borderedProminent)
        .foregroundStyle(.black)
        .tint(.scroll)
        .padding(.top)
    }
}

#Preview {
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: SavedWord.self, configurations: config)

        return  NavigationStack {
            PlayButton(hasAudio: true, audioURL: imagination.audio)
                .preferredColorScheme(.dark)
                .modelContainer(container)
        }
      
        
    } catch  {
        return Text("No Data error: \(error.localizedDescription)")
    }
   
}
