//
//  ContentView.swift
//  SmartMockupCreator
//
//  Created by SmartMockupCreator on 2024-01-01.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack {
            // Header z logo/tytułem
            HStack {
                Image(systemName: "photo.fill.on.rectangle.fill")
                    .font(.title)
                    .foregroundColor(.blue)
                Text("Smart Mockup Creator")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Zakładki
            Picker("", selection: $selectedTab) {
                Text("Generator Mockupów").tag(0)
                Text("Zmieniacz Nazw").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            // Zawartość zakładek
            TabView(selection: $selectedTab) {
                MockupGeneratorView()
                    .tag(0)
                
                SmartObjectRenamerView()
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut, value: selectedTab)
        }
        .frame(minWidth: 800, minHeight: 600)
    }
}

#Preview {
    ContentView()
}
