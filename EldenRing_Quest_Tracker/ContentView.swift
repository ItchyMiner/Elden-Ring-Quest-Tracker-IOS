//
//  ContentView.swift
//  EldenRing_Quest_Tracker
//
//  Created by Akshay Kotwal on 2025-07-17.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedPage = -12
    
    var body: some View {
        VStack {
            
            Group {
                switch selectedPage {
                case 0:
                    QuestLog()
                case 1:
                    ProgressToggles()
//                case 2:
//                    MapView()
                default:
                    WelcomePage()
                }
                
                
            }
        }
        .frame(maxHeight: .infinity)
        
        HStack {
            Button(action: { selectedPage = 0 }) {
                Text("Quest Log")
                    .font(.title2)
                    .padding()
            }
            
            
            Button(action: { selectedPage = 1}) {
                Text("Progess Toggles")
                    .font(.title2)
                    .padding()
            }
            
//            Button(action: { selectedPage = 2 }) {
//                Text("Map")
//                    .font(.title2)
//                    .padding()
//            }
            
        
//        TabView {
//            
//            WelcomePage()
//                .tabItem{
//                    Text("Tab 1")
//                }
//            FeaturesPage()
//                .tabItem {
//                    Text("Tab 2")
//                }
//                
        }
//        
//        .padding()
    }
}

#Preview {
    ContentView()
}
