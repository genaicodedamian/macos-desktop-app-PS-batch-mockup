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
                VStack(alignment: .leading) {
                    Text("Smart Mockup Creator")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("⌘G: Generuj • ⌘R: Resetuj • ⇧⌘O: Otwórz folder")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
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
            Group {
                if selectedTab == 0 {
                    MockupGeneratorView()
                        .transition(.opacity)
                } else {
                    SmartObjectRenamerView()
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: selectedTab)
        }
        .frame(minWidth: 800, minHeight: 600)
    }
}

#Preview {
    ContentView()
}
