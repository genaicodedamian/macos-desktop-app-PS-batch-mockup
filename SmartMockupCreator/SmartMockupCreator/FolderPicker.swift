//
//  FolderPicker.swift
//  SmartMockupCreator
//
//  Created by SmartMockupCreator on 2024-01-01.
//

import SwiftUI
import AppKit

struct FolderPicker: View {
    @Binding var folderPath: String
    let buttonText: String
    @State private var isHovering = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Button(action: selectFolder) {
                    HStack {
                        Image(systemName: "folder")
                        Text(buttonText)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
                .buttonStyle(.bordered)
                .scaleEffect(isHovering ? 1.02 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isHovering)
                .onHover { hovering in
                    isHovering = hovering
                }
            }
            
            if !folderPath.isEmpty {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.caption)
                    
                    Text(folderPath)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                    
                    Button(action: clearSelection) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                    .buttonStyle(.plain)
                    .help("Wyczyść wybór")
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.green.opacity(0.1))
                .cornerRadius(6)
            }
        }
    }
    
    private func selectFolder() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.canCreateDirectories = false
        panel.title = buttonText
        panel.prompt = "Wybierz"
        
        // Ustawienie początkowej lokalizacji
        if !folderPath.isEmpty {
            panel.directoryURL = URL(fileURLWithPath: folderPath)
        } else {
            // Domyślnie otwórz folder Dokumenty użytkownika
            panel.directoryURL = FileManager.default.urls(for: .documentDirectory, 
                                                         in: .userDomainMask).first
        }
        
        panel.begin { result in
            if result == .OK {
                if let selectedURL = panel.url {
                    DispatchQueue.main.async {
                        self.folderPath = selectedURL.path
                        
                        // Zapisz wybór w UserDefaults dla następnych sesji
                        let key = self.buttonText.replacingOccurrences(of: " ", with: "_").lowercased()
                        UserDefaults.standard.set(selectedURL.path, forKey: "last_\(key)_path")
                    }
                }
            }
        }
    }
    
    private func clearSelection() {
        folderPath = ""
        
        // Usuń z UserDefaults
        let key = buttonText.replacingOccurrences(of: " ", with: "_").lowercased()
        UserDefaults.standard.removeObject(forKey: "last_\(key)_path")
    }
}

// Extension do walidacji folderów
extension FolderPicker {
    static func validateFolderPath(_ path: String, expectedFileTypes: [String] = []) -> (isValid: Bool, error: String?) {
        guard !path.isEmpty else {
            return (false, "Ścieżka jest pusta")
        }
        
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        
        guard fileManager.fileExists(atPath: path, isDirectory: &isDirectory) else {
            return (false, "Folder nie istnieje")
        }
        
        guard isDirectory.boolValue else {
            return (false, "Wskazana ścieżka nie jest folderem")
        }
        
        // Sprawdź uprawnienia do odczytu
        guard fileManager.isReadableFile(atPath: path) else {
            return (false, "Brak uprawnień do odczytu folderu")
        }
        
        // Jeśli podano oczekiwane typy plików, sprawdź czy folder je zawiera
        if !expectedFileTypes.isEmpty {
            do {
                let contents = try fileManager.contentsOfDirectory(atPath: path)
                let hasExpectedFiles = contents.contains { filename in
                    expectedFileTypes.contains { fileType in
                        filename.lowercased().hasSuffix(".\(fileType.lowercased())")
                    }
                }
                
                guard hasExpectedFiles else {
                    let typesString = expectedFileTypes.joined(separator: ", ")
                    return (false, "Folder nie zawiera plików typu: \(typesString)")
                }
            } catch {
                return (false, "Nie można odczytać zawartości folderu: \(error.localizedDescription)")
            }
        }
        
        return (true, nil)
    }
    
    static func getFilesInFolder(_ path: String, withExtensions extensions: [String]) -> [String] {
        guard !path.isEmpty else { return [] }
        
        let fileManager = FileManager.default
        
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: path)
            return contents.filter { filename in
                extensions.contains { ext in
                    filename.lowercased().hasSuffix(".\(ext.lowercased())")
                }
            }.sorted()
        } catch {
            print("Error reading folder contents: \(error)")
            return []
        }
    }
    
    static func restoreLastPath(for buttonText: String) -> String {
        let key = buttonText.replacingOccurrences(of: " ", with: "_").lowercased()
        let savedPath = UserDefaults.standard.string(forKey: "last_\(key)_path") ?? ""
        
        // Sprawdź czy zapisana ścieżka nadal istnieje
        if !savedPath.isEmpty && FileManager.default.fileExists(atPath: savedPath) {
            return savedPath
        }
        
        return ""
    }
}

#Preview {
    VStack {
        @State var testPath = ""
        FolderPicker(folderPath: $testPath, buttonText: "Wybierz folder test")
    }
    .padding()
}
