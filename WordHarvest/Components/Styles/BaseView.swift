//
//  baseView.swift
//  WordHarvest
//
//  Created by Amari DeVaughn on 1/22/24.
//

import SwiftUI


func baseView<Content: View>(@ViewBuilder content: ()->Content) -> some View {
    ZStack {
 
        LinearGradient(colors: [.gray.opacity(0.2), .gray.opacity(0.1)], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
     
        VStack {
           content()
        }
      
   
    }
}

struct BaseView: View {
    var body: some View {
        baseView {
            Text("Hello World")
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    BaseView()
        .preferredColorScheme(.dark)
}
