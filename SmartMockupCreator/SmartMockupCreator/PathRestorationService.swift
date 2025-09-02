//
//  PathRestorationService.swift
//  SmartMockupCreator
//
//  Created by SmartMockupCreator on 2024-01-01.
//

import Foundation

enum FolderType: String, CaseIterable {
    case inputFolder = "input_folder"
    case mockupFolder = "mockup_folder"
    case outputFolder = "output_folder"
    case psdFolder = "psd_folder"
    
    var defaultKey: String {
        return "last_\(self.rawValue)_path"
    }
    
    var displayName: String {
        switch self {
        case .inputFolder:
            return "Folder z plikami wejściowymi"
        case .mockupFolder:
            return "Folder z plikami mockup"
        case .outputFolder:
            return "Folder do zapisu wyników"
        case .psdFolder:
            return "Folder z plikami PSD"
        }
    }
}

class PathRestorationService: ObservableObject {
    
    // MARK: - Save Path
    static func savePath(_ path: String, for folderType: FolderType) {
        guard !path.isEmpty else {
            removePath(for: folderType)
            return
        }
        
        UserDefaults.standard.set(path, forKey: folderType.defaultKey)
    }
    
    // MARK: - Restore Path
    static func restorePath(for folderType: FolderType) -> String {
        let savedPath = UserDefaults.standard.string(forKey: folderType.defaultKey) ?? ""
        
        // Sprawdź czy zapisana ścieżka nadal istnieje
        if !savedPath.isEmpty && FileManager.default.fileExists(atPath: savedPath) {
            return savedPath
        } else if !savedPath.isEmpty {
            // Ścieżka już nie istnieje, usuń ją z UserDefaults
            removePath(for: folderType)
        }
        
        return ""
    }
    
    // MARK: - Remove Path
    static func removePath(for folderType: FolderType) {
        UserDefaults.standard.removeObject(forKey: folderType.defaultKey)
    }
    
    // MARK: - Clear All Paths
    static func clearAllPaths() {
        for folderType in FolderType.allCases {
            removePath(for: folderType)
        }
    }
    
    // MARK: - Bulk Operations
    static func getAllSavedPaths() -> [FolderType: String] {
        var paths: [FolderType: String] = [:]
        
        for folderType in FolderType.allCases {
            let path = restorePath(for: folderType)
            if !path.isEmpty {
                paths[folderType] = path
            }
        }
        
        return paths
    }
    
    static func validateAllSavedPaths() -> [FolderType: Bool] {
        var validation: [FolderType: Bool] = [:]
        
        for folderType in FolderType.allCases {
            let path = UserDefaults.standard.string(forKey: folderType.defaultKey) ?? ""
            validation[folderType] = !path.isEmpty && FileManager.default.fileExists(atPath: path)
        }
        
        return validation
    }
    
    // MARK: - Debug Information
    static func getDebugInfo() -> String {
        var info = "PathRestorationService Debug Info:\n"
        
        for folderType in FolderType.allCases {
            let savedPath = UserDefaults.standard.string(forKey: folderType.defaultKey) ?? "(none)"
            let exists = !savedPath.isEmpty && FileManager.default.fileExists(atPath: savedPath)
            info += "- \(folderType.displayName): \(savedPath) [\(exists ? "exists" : "missing")]\n"
        }
        
        return info
    }
}
