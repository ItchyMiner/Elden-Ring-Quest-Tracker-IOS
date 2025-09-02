//
//  SwiftUIView.swift
//  EldenRing_Quest_Tracker
//
//  Created by Akshay Kotwal on 2025-07-20.
//

import SwiftUI

struct ProgressToggles: View {
    
    @State private var playerData: player_Save_Data = fetchPlayerSave()!
        
    let playerSaveKeys = ["Areas_Explored","Bosses_Killed","Events_Happened","Npcs_Killed"]
    
    
    var body: some View {
        
        
        
        NavigationStack{
            
            VStack {
                
                Text("Progress Toggles")
                    .font(.title)
                    .fontWeight(.bold)
                
                ForEach(playerSaveKeys, id: \.self) {playerSaveKey in
                    NavigationLink(destination: destinationView(for: playerSaveKey)) {
                        
                        
                        Text(playerSaveKey.replacingOccurrences(of: "_", with: " "))
                            .padding()
                            .background(Color.yellow)
                            .cornerRadius(10)
                            .foregroundStyle(.black)
                                .bold()
                            
                    }
                    
                }
                
                Rectangle()
                    .frame(height: 50)
                    .opacity(0)
                
                Button(action: {
                    deleteFileDocumentDirectory(named: "Player_save.json")
                    copyInitialPlayerSave()
                    populateQuestStagesSavedIfNeeded()
                }) {
                    Text("Delete Save Data")
                        .padding()
                        .cornerRadius(10)
                        .background(Color.black)
                        .foregroundStyle(.red)
                            .bold()
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding()
            
        }
        
    }
    @ViewBuilder
    private func destinationView(for playerSaveKey: String) -> some View {
        
        
        switch playerSaveKey {
        case "Areas_Explored":
            fullToggleView(togglePage: playerSaveKey, playerData: $playerData, toggleObjects: $playerData.Areas_Explored)
        case "Bosses_Killed":
            fullToggleView(togglePage: playerSaveKey, playerData: $playerData, toggleObjects: $playerData.Bosses_Killed)
        case "Events_Happened":
            fullToggleView(togglePage: playerSaveKey, playerData: $playerData, toggleObjects: $playerData.Events_Happened)
        case "Npcs_Killed":
            fullToggleView(togglePage: playerSaveKey, playerData: $playerData, toggleObjects: $playerData.Npcs_Killed)
        default:
            Text("Something broke")
        }
    }

}


struct fullToggleView: View {
    let togglePage: String
    @Binding var playerData: player_Save_Data
    var toggleObjects: Binding<[ToggleObjects]>
    
    
    
    var body: some View {
        VStack {
            Text(togglePage.replacingOccurrences(of: "_", with: " "))
                .font(.title)
                .bold()
                .padding(.bottom)
            
            List {
                ForEach(toggleObjects.indices, id: \.self) {index in
                    Toggle(isOn: toggleObjects[index].Status) {
                        Text(toggleObjects[index].Name.wrappedValue)
                    }
                    .onChange(of: toggleObjects[index].Status.wrappedValue, initial: false) { _, _ in
                        savePlayerData(playerData)
                    }
                }
            }
            
            Spacer()
            
        }
        .navigationTitle(togglePage)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    ProgressToggles()
}
