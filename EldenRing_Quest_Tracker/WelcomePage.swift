//
//  WelcomePage.swift
//  EldenRing_Quest_Tracker
//
//  Created by Akshay Kotwal on 2025-07-17.
//

import SwiftUI

struct WelcomePage: View {
    var body: some View {
        
        ZStack {
            
            Rectangle()
                .frame(width: 370, height: 600)
                .cornerRadius(10)
            
            VStack {
                
                Rectangle()
                    .frame(height: 30)
                    .opacity(0)
                
                Text("Foolish Ambitions")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(10)
                    .foregroundStyle(.black)
                    .bold()
                
                Text("An Elden Ring Quest Tracker")
                    .font(.title2)
                    .padding(10)
                    .background(Color.black)
                //                .cornerRadius(10)
                    .foregroundStyle(.red)
                    .bold()
                
                Rectangle()
                    .frame(height: 0)
                    .opacity(0)
                
                
                if let uiImage = UIImage(named: "HomePageImage/EldenRingLogo.png") {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 300, height:300)
                        .cornerRadius(20)
                    
                }
                
                Rectangle()
                    .frame(height: 100)
                    .opacity(0)
                
                
            }
            .padding()
        
            
        }
    }
}

#Preview {
    WelcomePage()
}
