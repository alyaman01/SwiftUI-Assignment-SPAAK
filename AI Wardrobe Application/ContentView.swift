//
//  ContentView.swift
//  AI Wardrobe Application
//
//  Created by macbook on 02/10/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            // Task 3: AI Wardrobe Screen[cite: 4]
            WardrobeAppView()
                .tabItem {
                    Label("Wardrobe", systemImage: "tshirt.fill")
                }
            
            // Task 1: Arcade Game Screen[cite: 2]
            WardrobeAppView() // Aapka Game View struct name
                .tabItem {
                    Label("Arcade Game", systemImage: "gamecontroller.fill")
                }
        }
        .accentColor(.purple)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
