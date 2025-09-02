//
//  FeaturesPage.swift
//  EldenRing_Quest_Tracker
//
//  Created by Akshay Kotwal on 2025-07-17.
//

import SwiftUI

struct QuestLog: View {
    
    
//    let clearplayersave = deleteFileDocumentDirectory(named: "Player_save.json")
//    
//    let initializeplayersave = copyInitialPlayerSave()
//    
//    let popsavedata = populateQuestStagesSavedIfNeeded()

    @State private var viewRefreshID = UUID()
    
    let quest = loadQuestData(for: "Ranni")
    
    let playersave = fetchPlayerSave()
    
    let npcnames = fetchNpcNames()
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                VStack {
                    Text("NPC Quests")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    ForEach(npcnames, id: \.self) {name in
                        NavigationLink(destination: DetailedQuestView(npcName: name, viewRefreshID: $viewRefreshID)
                            .id(viewRefreshID)) {
                                HStack {
                                    
                                    if let uiImage = UIImage(named: "Npc_Data/\(name)/\(name).png") {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .frame(width: 60, height:60)
                                            .cornerRadius(8)
                                    }
                                    
                                    Text(name)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.yellow)
                                        .cornerRadius(10)
                                        .foregroundStyle(.black)
                                        .bold()
                                }
                            }
                    }
                    
                    //                if let quest = quest {
                    //                    //                Text("Loaded quest for \(quest.name)")
                    //                    Text("Stage 1 description: \(quest.stages.first?.Description ?? "No stages")")
                    //                } else {
                    //                    Text("Failed to load quest")
                    //                }
                    //                
                    //                if let playersave = playersave {
                    //                    Text("FirstAreaExplored: \(playersave.Areas_Explored.first?.Name ?? "No areas")")
                    //                }
                    
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding()
                .onAppear {
                    //                    deleteFileDocumentDirectory(named: "Player_save.json")
                    copyInitialPlayerSave()
                    populateQuestStagesSavedIfNeeded()
                    //                    testimagepath()
                }
            }
        }
    }
    
}

//func testimagepath() {
//    if let uiImage = UIImage(named: "Npc_Data/Ranni/Ranni.png") {
//        print("Image found")
//    } else {
//        print("Image not found")
//    }
//}



struct DetailedQuestView: View {
    
    @State private var refreshFlag = false
    
    let npcName: String
    @Binding var viewRefreshID: UUID
    
    var body: some View {
        
        let questData: QuestData = loadQuestData(for: npcName)!
        
        var playerSaveData: player_Save_Data = fetchPlayerSave()!

        
        ScrollView {
            VStack {
                Text("Quest for \(npcName)")
                    .font(.largeTitle)
                
                
                var currentstage = fetchNpcCurrentStage(for: npcName, savedata: playerSaveData)
                
                
                var currentstagedescription = questData.stages[currentstage].Description
                
                
                var conditions = testStageConditions(for: currentstage, questdata: questData, savedata: playerSaveData)
                
                let stagesCOS = fetchNpcStagesCompletedOrSkipped(for: npcName, savedata: playerSaveData)
                
                //            Text("\(stagesCOS)")
                
                ForEach(stagesCOS.indices, id: \.self) {cycleSCOS in
                    HStack {
                        
                        switch stagesCOS[cycleSCOS].Status {
                        case "Skipped":
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: 20, height: 20)
                                .cornerRadius(4)
                            //                    case "LockedOut":
                            //                        Rectangle()
                            //                            .fill(Color.red)
                            //                            .frame(width: 20, height: 20)
                            //                            .cornerRadius(4)
                        case "Completed":
                            Rectangle()
                                .fill(Color.green)
                                .frame(width: 20, height: 20)
                                .cornerRadius(4)
                        default:
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: 20, height: 20)
                                .cornerRadius(4)
                            
                        }
                        
                        Text("\(questData.stages[cycleSCOS].Description)")
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 12)
                }
                
                HStack {
                    
                    Text("\(currentstagedescription)")
                    
                    
                    
                    if conditions == "Skipped" {
                        Button(action:
                                {writeAStageCOS(for: npcName, stage: currentstage, status: conditions)
                            incrementCurrentStage(for: npcName)
                            viewRefreshID = UUID()
                        }) {
                            Text("Stage Skipped. View Next Stage?")
                        }
                        //                    let runthiscode1 = writeAStageCOS(for: npcName, stage: currentstage, status: conditions)
                        //                    let runthiscode2 = incrementCurrentStage(for: npcName)
                        //                    var runthiscode3 = refreshFlag.toggle()
                        
                        
                    }
                    else if conditions == "Lockout" {
                        Rectangle()
                            .fill(Color.red)
                            .frame(width: 20, height: 20)
                            .cornerRadius(4)
                    }
                    else if conditions == "Nothing Triggered" {
                        
                        if currentstage < questData.stagesAmount - 1 {
                            Button(action:
                                    {writeAStageCOS(for: npcName, stage: currentstage, status: "Completed")
                                incrementCurrentStage(for: npcName)
                                viewRefreshID = UUID()
                            }) {
                                Text("Check")
                                
                                
                            }
                        } else if currentstage == questData.stagesAmount - 1 {
                            Text("Final Stage! ")
                                .bold()
                            Rectangle()
                                .fill(Color.purple)
                                .frame(width: 20, height: 20)
                                .cornerRadius(4)
                            
                        } else {
                            Text("Quest Completed!")
                        }
                    }
                }
                .padding()
                
                //            switch conditions {
                //            case "Skipped":
                //
                //            }
                
                let listofSCOS = fetchNpcStagesCompletedOrSkipped(for: npcName, savedata: playerSaveData)
                
                //            Text("\(currentstage)")
                //            Text("\(listofSCOS)")
                //            Text("\(currentstagedescription)")
                //            Text("\(conditions)")
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
        
}



func questLogCheckList() {
//    Need to
    print("Hit Button")
}

func incrementCurrentStage(for npcName: String) {
    
    var playerSaveData: player_Save_Data = fetchPlayerSave()!
    
    let QuestStages = playerSaveData.Quests_Stages_Saved
    
    var ticker = 0
    
    for npcData in QuestStages {
        ticker += 1
        
        if npcData!.Npc_Name == npcName {
            
            print("\(npcData!.Npc_Name)")
            print(npcName)
//          ticker skips one so we have to subtract one
            playerSaveData.Quests_Stages_Saved[ticker - 1]!.Current_Stage += 1
            savePlayerData(playerSaveData)
            
            
        } else {
//            Do nothing
        }
    }
    
}

func writeAStageCOS(for npcName: String, stage currentStage: Int, status Status: String) {
    
    var playerSaveData: player_Save_Data = fetchPlayerSave()!
    
    var ticker = 0
    
    for npcData in playerSaveData.Quests_Stages_Saved {
        
        ticker += 1
        
        if npcData!.Npc_Name == npcName {
            print("\(npcData!.Npc_Name)")
            print("\(npcName)")
            playerSaveData.Quests_Stages_Saved[ticker - 1]!.Stages_Completed_Or_Skipped.append(ModifiedToggleObjects(Stage_Name: currentStage, Status: Status))
            savePlayerData(playerSaveData)
        }
    }
    
}

func testStageConditions(for currentStage: Int, questdata questData: QuestData, savedata playerSaveData: player_Save_Data) -> String {
    
    
    for bossSkip in questData.stages[currentStage].Boss_Skip {
        
        if bossSkip == "None" {
            break
        }
        
        for bossesKilled in playerSaveData.Bosses_Killed {
            if bossSkip == bossesKilled.Name && bossesKilled.Status == true {
                return "Skipped"
            }
        }
    }
    
    for areaSkip in questData.stages[currentStage].Area_Skip {
        
        if areaSkip == "None" {
            break
        }
        
        for areasExplored in playerSaveData.Areas_Explored {
            if areaSkip == areasExplored.Name && areasExplored.Status == true {
                return "Skipped"
            }
        }
    }
    
    for npcSkip in questData.stages[currentStage].Npc_Skip {
        
        if npcSkip == "None" {
            break
        }
        
        for npcsKilled in playerSaveData.Npcs_Killed {
            if npcSkip == npcsKilled.Name && npcsKilled.Status == true {
                return "Skipped"
            }
        }
    }
    
//    We will come back to this if we have time
//    for questSkip in questData.stages[currentStage].Quest_Skip {
//        
//        if questSkip == "None" {
//            break
//        }
//        
//        for npcsKilled in playerSaveData.Npcs_Killed {
//            if npcSkip == npcsKilled.Name && npcsKilled.Status == true {
//                return "Skipped"
//            }
//        }
//    }
    
    for eventSkip in questData.stages[currentStage].Event_Skip {
        
        if eventSkip == "None" {
            break
        }
        
        for eventsHappened in playerSaveData.Events_Happened {
            if eventSkip == eventsHappened.Name && eventsHappened.Status == true {
                return "Skipped"
            }
        }
    }
    
    for bossLockout in questData.stages[currentStage].Boss_Lockouts {
        
        if bossLockout == "None" {
            break
        }
        
        for bossesKilled in playerSaveData.Bosses_Killed {
            if bossLockout == bossesKilled.Name && bossesKilled.Status == true {
                return "Lockout"
            }
        }
    }
    
    for areaLockout in questData.stages[currentStage].Area_Lockouts {
        
        if areaLockout == "None" {
            break
        }
        
        for areasExplored in playerSaveData.Areas_Explored {
            if areaLockout == areasExplored.Name && areasExplored.Status == true {
                return "Lockout"
            }
        }
    }
    
    for npcLockout in questData.stages[currentStage].Npc_Lockout {
        
        if npcLockout == "None" {
            break
        }
        
        for npcsKilled in playerSaveData.Npcs_Killed {
            if npcLockout == npcsKilled.Name && npcsKilled.Status == true {
                return "Lockout"
            }
        }
    }
    
//    We will come back to this if we have time
//    for questSkip in questData.stages[currentStage].Quest_Skip {
//
//        if questSkip == "None" {
//            break
//        }
//
//        for npcsKilled in playerSaveData.Npcs_Killed {
//            if npcSkip == npcsKilled.Name && npcsKilled.Status == true {
//                return "Lockout"
//            }
//        }
//    }
    
    for eventLockout in questData.stages[currentStage].Event_Lockout {
        
        if eventLockout == "None" {
            break
        }
        
        for eventsHappened in playerSaveData.Events_Happened {
            if eventLockout == eventsHappened.Name && eventsHappened.Status == true {
                return "Lockout"
            }
        }
    }


    
    
    
    return "Nothing Triggered"
}

func fetchNpcCurrentStage(for npcName: String, savedata playerSaveData: player_Save_Data) -> Int {
    
    let QuestStages = playerSaveData.Quests_Stages_Saved
    
    for npcData in QuestStages {
        if npcData!.Npc_Name == npcName {
            return npcData!.Current_Stage
        } else {
//            Do nothing
        }
    }
    
    return 0
    
}

func fetchNpcStagesCompletedOrSkipped(for npcName: String, savedata playerSaveData: player_Save_Data) -> [ModifiedToggleObjects] {
    
    let QuestStages = playerSaveData.Quests_Stages_Saved
    var stageList: [ModifiedToggleObjects] = []
    
    for npcData in QuestStages {
        if let npc = npcData, npc.Npc_Name == npcName {
            print(npc.Stages_Completed_Or_Skipped)
            for stage in npc.Stages_Completed_Or_Skipped {
                if let unwrappedStage = stage {
                    print(unwrappedStage)
                    stageList.append(unwrappedStage)
                }
            }
            return stageList
        }
    }
    return []
    
}




//{
//    "Stage_Name": 0,
//    "Status": "Skipped"
//},
//{
//    "Stage_Name": 1,
//    "Status": "Skipped"
//}


struct QuestData: Codable {
    
    var name: String
    var stagesAmount: Int
    
    var stages: [QuestStages]
    
    
}

struct QuestStages: Codable {
    var Description: String
    var Location: String
    
    var Boss_Requirements: [String]
    var Quest_Requirements: [String]
    
    var Boss_Lockouts: [String]
    var Area_Lockouts: [String]
    var Npc_Lockout: [String]
    var Quest_Lockout: [String]
    var Event_Lockout: [String]
    
    var Boss_Skip: [String]
    var Area_Skip: [String]
    var Npc_Skip: [String]
    var Quest_Skip: [String]
    var Event_Skip: [String]
}

func loadQuestData(for npcName: String) ->  QuestData? {
    
    let fileName = npcName
    let subdirectory = "Npc_Data/\(npcName)"
    
//    print("Looking for: \(fileName).json in subdirectory: \(subdirectory)")
//    
//    let all = Bundle.main.paths(forResourcesOfType: "json", inDirectory: nil)
//    print("Found JSON files:", all)
//    
//    let allSub = Bundle.main.paths(forResourcesOfType: "json", inDirectory: subdirectory)
//    print("Found JSON in subdir", allSub)
    
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "json", subdirectory: subdirectory) else {
//    guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
        print("Failed to locate \(fileName).json in \(subdirectory)")
        return nil

        }
    
    do {
        let data = try Data(contentsOf: url)
        let decoded = try JSONDecoder().decode(QuestData.self, from: data)
        return decoded
    } catch {
        print("Failed to decode \(fileName).json: \(error)")
        return nil
    }
}

func getDocumentsDirectory() -> URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
}

func deleteFileDocumentDirectory(named fileName: String) {
    let fileManager = FileManager.default
    
    if let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                try fileManager.removeItem(at: fileURL)
                print("File deleted: \(fileURL.lastPathComponent)")
            } catch {
                print("Error deleted file: \(error)")
            }
        } else {
            print("File does not exist at path: \(fileURL.path)")
        }
    }
}

func savePlayerData(_ data: player_Save_Data) {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    do {
        let jsonData = try encoder.encode(data)
        let fileURL = getDocumentsDirectory().appendingPathComponent("Player_save.json")
        try jsonData.write(to: fileURL)
        print("Saved successfully at \(fileURL)")
    } catch {
        print("Failed to save player data: \(error)")
    }
}

func fetchPlayerSave() -> player_Save_Data? {
    let fileURL = getDocumentsDirectory().appendingPathComponent("Player_save.json")
    do {
        let jsonData = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        let data = try decoder.decode(player_Save_Data.self, from: jsonData)
        return data
    } catch {
        print("Failed to load player data: \(error)")
        return nil
    }
            
}


func copyInitialPlayerSave() {
    let fileManager = FileManager.default
    let fileURL = getDocumentsDirectory().appendingPathComponent("Player_save.json")
    
    let fileName = "Player_save"
    let subdirectory = "Player_save/"
    
    if !fileManager.fileExists(atPath: fileURL.path) {
        if let bundleURL = Bundle.main.url(forResource: fileName, withExtension: "json", subdirectory: subdirectory) {
            do {
                try fileManager.copyItem(at: bundleURL, to: fileURL)
                print("Copied Player_save.json to Documents")
            } catch {
                print("Failed to copy file: \(error)")
            }
        } else {
            print("Could not file Player_save.json in bundle")
        }
    }
}

//func populateQuestStagesSavedIfNeeded() {
//    
//    
//    
//    if var playerSave = fetchPlayerSave() {
//        if playerSave.Quests_Stages_Saved.isEmpty {
//            print("Quest_Stages_Saved is Empty")
//            let npcNamesList = fetchNpcNames()
//            
//            for npcName in npcNamesList {
//                playerSave.Quests_Stages_Saved.append(Player_Stages_Saved(Npc_Name: npcName, Current_Stage: 0, Stages_Completed_Or_Skipped: []))
//                savePlayerData(playerSave)
//                print(npcName)
//                print(playerSave.Quests_Stages_Saved)
//                print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
//            }
//            
//        } else {
//            print("Quest_Stages_Saved is not Empty")
//        }
//    } else {
//        print("Failed to load player save")
//    }
//    
//}

func populateQuestStagesSavedIfNeeded() {
    if var playerSave = fetchPlayerSave() {
        let npcNamesList = fetchNpcNames()
       
        var updated = false
        for npcName in npcNamesList {
            if !playerSave.Quests_Stages_Saved.contains(where: { $0?.Npc_Name == npcName }) {
                playerSave.Quests_Stages_Saved.append(
                    Player_Stages_Saved(
                        Npc_Name: npcName,
                        Current_Stage: 0,
                        Stages_Completed_Or_Skipped: []
                    )
                )
                updated = true
            }
        }
       
        if updated {
            savePlayerData(playerSave)
        }
    } else {
        print("Failed to load player save")
    }
}

func fetchNpcNames() -> [String] {
    var npcNames: [String] = []
    guard let npcDataURL = Bundle.main.url(forResource: "Npc_Data", withExtension: nil) else {
        print("Could not find Npc_Data folder in bundle")
        return []
    }
    
    do {
        let contents = try FileManager.default.contentsOfDirectory(at: npcDataURL, includingPropertiesForKeys: [.isDirectoryKey])
        
        for url in contents {
            let resourceValues = try url.resourceValues(forKeys: [.isDirectoryKey])
            if resourceValues.isDirectory == true {
                npcNames.append(url.lastPathComponent)
            }
        }
    } catch {
        print("Error reading Npc_Data: \(error)")
    }
    
    return npcNames
}


struct player_Save_Data: Codable {
    
    var Areas_Explored: [ToggleObjects]
    var Bosses_Killed: [ToggleObjects]
    var Events_Happened: [ToggleObjects]
    var Npcs_Killed: [ToggleObjects]
    
    var Quests_Stages_Saved: [Player_Stages_Saved?]
    
}

struct ToggleObjects: Codable {
    var Name: String
    var Status: Bool
}


struct Player_Stages_Saved: Codable {
    var Npc_Name: String
    var Current_Stage: Int
    var Stages_Completed_Or_Skipped: [ModifiedToggleObjects?]
}

struct ModifiedToggleObjects: Codable {
    var Stage_Name: Int
    var Status: String
}



#Preview {
    QuestLog()
}

//Potentially useful code later

////          Goes through all stages in the npcs quest data
//            ForEach(questData.stages.indices, id: \.self) {index in
//
////              lets the currently indexed stage be set to a constant so it can be used further
//                let stage = questData.stages[index]
//
//
//                HStack {
//                    Text(stage.Description)
////                    Text(stage.Location)
//                    Text("Stage \(index)")
////                    Button(stage.Description, action: questLogCheckList)
//
////                    Goes through the Quest_Stages saved in Player_save.json
//                    ForEach(playerSaveData.Quests_Stages_Saved.indices, id: \.self) {queststagesindex in
//
////                                      lets the currently indexed queststage be set to a constant so it can be used further
//                        let currentPlayerSavedQuest = playerSaveData.Quests_Stages_Saved[queststagesindex]
//
////                        if the Npc_Name of the indexed quest stage is the same as the npc in the sub menu, do something
//                        if currentPlayerSavedQuest?.Npc_Name == npcName {
//
////                          unpacks Stages_Completed or skipped, so that we can use it for the ForEach Loop
//                            if let cycleStagesCompletedOrSkipped = currentPlayerSavedQuest?.Stages_Completed_Or_Skipped {
//
////                              Cycles through the list of stages completed or skipped
//                                ForEach(cycleStagesCompletedOrSkipped.indices, id: \.self) {cycleSCOS in
//
////                                  lets the attributes of one instance of cycleStagesCompletedOrSkipped be read
//                                    let instanceOfCycle = cycleStagesCompletedOrSkipped[cycleSCOS]
//
////                                  If the Stagename is equal to the index in the stage from npc.json
//                                    if instanceOfCycle?.Stage_Name == index {
//                                        switch instanceOfCycle?.Status {
//                                        case "Skipped":
//                                            Rectangle()
//                                                .fill(Color.blue)
//                                                .frame(width: 20, height: 20)
//                                                .cornerRadius(4)
//                                        case "LockedOut":
//                                            Rectangle()
//                                                .fill(Color.red)
//                                                .frame(width: 20, height: 20)
//                                                .cornerRadius(4)
//                                        case "Completed":
//                                            Rectangle()
//                                                .fill(Color.green)
//                                                .frame(width: 20, height: 20)
//                                                .cornerRadius(4)
//                                        default:
//                                            Rectangle()
//                                                .fill(Color.gray)
//                                                .frame(width: 20, height: 20)
//                                                .cornerRadius(4)
//                                        }
//                                    }
//                                }
//                            } else {
////                                Do nothing
//                            }
//
//                            if currentPlayerSavedQuest?.Current_Stage == index {
//                                Text("Current Stage")
//
//
//                            } else {
////                                Do nothing
//                            }
//                        } else {
////                           Do nothing
//                        }
//
//                    }
//
//
//                }
//            }
