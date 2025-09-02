//
//  MapView.swift
//  EldenRing_Quest_Tracker
//
//  Created by Akshay Kotwal on 2025-07-21.
//

import SwiftUI

struct MapView: View {
    
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @GestureState private var draggingOffset: CGSize = .zero
    
    
    
    var body: some View {
        
        GeometryReader {geo in
            let imageSize = CGSize(width: 12000, height: 12000)
            
            ZStack(alignment: .topLeading) {
                if let uiImage = UIImage(named: "Map/Map.jpg") {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(scale)
                        .offset(x: offset.width + draggingOffset.width, y: offset.height + draggingOffset.height)
                        .gesture(
                            SimultaneousGesture(
                                MagnificationGesture()
                                    .onChanged {value in
                                        scale = value
                                    },
                                DragGesture()
                                    .updating($draggingOffset) {value, state, _ in
                                        state = value.translation
                                    }
                                    .onEnded {value in
                                        offset.width += value.translation.width
                                        offset.height += value.translation.height
                                    }
                            )
                        )

                } else {
//                    Nothing happens
                }
                                      
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
            
            
        }
        
    }
}

#Preview {
    MapView()
}
