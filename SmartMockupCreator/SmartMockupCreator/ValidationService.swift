//
//  ValidationService.swift
//  SmartMockupCreator
//
//  Created by SmartMockupCreator on 2024-01-01.
//

import Foundation

struct ValidationResult {
    let isValid: Bool
    let errorMessage: String?
    
    static let valid = ValidationResult(isValid: true, errorMessage: nil)
    static func invalid(_ message: String) -> ValidationResult {
        return ValidationResult(isValid: false, errorMessage: message)
    }
}

class ValidationService: ObservableObject {
    
    // MARK: - Supported File Formats
    static let inputFileFormats = ["jpg", "jpeg", "png", "tiff", "tif", "gif", "bmp", "eps", "svg", "ai", "psd", "pdf"]
    static let mockupFileFormats = ["psd", "psb"]
    
    // MARK: - Folder Validation
    static func validateInputFolder(_ path: String) -> ValidationResult {
        guard !path.isEmpty else {
            return .invalid("Proszę wybrać folder z plikami wejściowymi")
        }
        
        let folderValidation = validateFolderExists(path)
        guard folderValidation.isValid else {
            return folderValidation
        }
        
        return validateFolderContainsFiles(path, expectedFormats: inputFileFormats, 
                                         errorMessage: "Folder nie zawiera obsługiwanych plików graficznych")
    }
    
    static func validateMockupFolder(_ path: String) -> ValidationResult {
        guard !path.isEmpty else {
            return .invalid("Proszę wybrać folder z plikami mockup")
        }
        
        let folderValidation = validateFolderExists(path)
        guard folderValidation.isValid else {
            return folderValidation
        }
        
        return validateFolderContainsFiles(path, expectedFormats: mockupFileFormats, 
                                         errorMessage: "Folder nie zawiera plików PSD/PSB")
    }
    
    static func validatePSDFolder(_ path: String) -> ValidationResult {
        guard !path.isEmpty else {
            return .invalid("Proszę wybrać folder z plikami PSD")
        }
        
        let folderValidation = validateFolderExists(path)
        guard folderValidation.isValid else {
            return folderValidation
        }
        
        return validateFolderContainsFiles(path, expectedFormats: mockupFileFormats, 
                                         errorMessage: "Folder nie zawiera plików PSD/PSB")
    }
    
    static func validateOutputFolder(_ path: String) -> ValidationResult {
        guard !path.isEmpty else {
            return .invalid("Proszę wybrać folder do zapisu wyników")
        }
        
        let folderValidation = validateFolderExists(path)
        guard folderValidation.isValid else {
            return folderValidation
        }
        
        // Sprawdzenie uprawnień do zapisu
        guard FileManager.default.isWritableFile(atPath: path) else {
            return .invalid("Brak uprawnień do zapisu w wybranym folderze")
        }
        
        return .valid
    }
    
    private static func validateFolderExists(_ path: String) -> ValidationResult {
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        
        guard fileManager.fileExists(atPath: path, isDirectory: &isDirectory) else {
            return .invalid("Folder nie istnieje")
        }
        
        guard isDirectory.boolValue else {
            return .invalid("Wskazana ścieżka nie jest folderem")
        }
        
        guard fileManager.isReadableFile(atPath: path) else {
            return .invalid("Brak uprawnień do odczytu folderu")
        }
        
        return .valid
    }
    
    private static func validateFolderContainsFiles(_ path: String, expectedFormats: [String], errorMessage: String) -> ValidationResult {
        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: path)
            let hasExpectedFiles = contents.contains { filename in
                expectedFormats.contains { format in
                    filename.lowercased().hasSuffix(".\(format.lowercased())")
                }
            }
            
            guard hasExpectedFiles else {
                let formatsString = expectedFormats.joined(separator: ", ")
                return .invalid("\(errorMessage). Obsługiwane formaty: \(formatsString)")
            }
            
            return .valid
        } catch {
            return .invalid("Nie można odczytać zawartości folderu: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Smart Object Layer Name Validation
    static func validateSmartObjectLayerName(_ name: String) -> ValidationResult {
        guard !name.isEmpty else {
            return .invalid("Nazwa warstwy Smart Object nie może być pusta")
        }
        
        guard name.count <= 100 else {
            return .invalid("Nazwa warstwy nie może być dłuższa niż 100 znaków")
        }
        
        // Sprawdzenie niedozwolonych znaków
        let forbiddenChars = CharacterSet(charactersIn: "/\\:*?\"<>|")
        if name.rangeOfCharacter(from: forbiddenChars) != nil {
            return .invalid("Nazwa warstwy nie może zawierać znaków: / \\ : * ? \" < > |")
        }
        
        // Sprawdzenie czy nazwa nie składa się tylko z białych znaków
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return .invalid("Nazwa warstwy nie może składać się tylko z białych znaków")
        }
        
        return .valid
    }
    
    // MARK: - File Counting Utilities
    static func getFileCount(in folderPath: String, withFormats formats: [String]) -> Int {
        guard !folderPath.isEmpty else { return 0 }
        
        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: folderPath)
            return contents.filter { filename in
                formats.contains { format in
                    filename.lowercased().hasSuffix(".\(format.lowercased())")
                }
            }.count
        } catch {
            return 0
        }
    }
    
    static func getInputFileCount(in folderPath: String) -> Int {
        return getFileCount(in: folderPath, withFormats: inputFileFormats)
    }
    
    static func getMockupFileCount(in folderPath: String) -> Int {
        return getFileCount(in: folderPath, withFormats: mockupFileFormats)
    }
    
    // MARK: - File Listing
    static func getFileNames(in folderPath: String, withFormats formats: [String], limit: Int = 10) -> [String] {
        guard !folderPath.isEmpty else { return [] }
        
        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: folderPath)
            let filteredFiles = contents.filter { filename in
                formats.contains { format in
                    filename.lowercased().hasSuffix(".\(format.lowercased())")
                }
            }.sorted()
            
            return Array(filteredFiles.prefix(limit))
        } catch {
            return []
        }
    }
    
    // MARK: - Complex Validation for Generator
    static func validateMockupGeneratorConfiguration(
        inputFolder: String,
        mockupFolder: String,
        outputFolder: String,
        smartObjectLayers: [SmartObjectLayer]
    ) -> ValidationResult {
        
        // Walidacja folderów
        let inputValidation = validateInputFolder(inputFolder)
        guard inputValidation.isValid else {
            return inputValidation
        }
        
        let mockupValidation = validateMockupFolder(mockupFolder)
        guard mockupValidation.isValid else {
            return mockupValidation
        }
        
        let outputValidation = validateOutputFolder(outputFolder)
        guard outputValidation.isValid else {
            return outputValidation
        }
        
        // Walidacja warstw Smart Object
        for (index, layer) in smartObjectLayers.enumerated() {
            let layerValidation = validateSmartObjectLayerName(layer.target)
            guard layerValidation.isValid else {
                return .invalid("Warstwa \(index + 1): \(layerValidation.errorMessage ?? "Nieprawidłowa nazwa warstwy")")
            }
        }
        
        // Sprawdzenie duplikatów nazw warstw
        let layerNames = smartObjectLayers.map { $0.target.trimmingCharacters(in: .whitespacesAndNewlines) }
        let uniqueNames = Set(layerNames)
        guard layerNames.count == uniqueNames.count else {
            return .invalid("Nazwy warstw Smart Object muszą być unikalne")
        }
        
        return .valid
    }
    
    // MARK: - Complex Validation for Renamer
    static func validateSmartObjectRenamerConfiguration(
        psdFolder: String,
        newLayerName: String
    ) -> ValidationResult {
        
        let folderValidation = validatePSDFolder(psdFolder)
        guard folderValidation.isValid else {
            return folderValidation
        }
        
        let nameValidation = validateSmartObjectLayerName(newLayerName)
        guard nameValidation.isValid else {
            return nameValidation
        }
        
        return .valid
    }
    
    // MARK: - UI Enhancement Utilities
    static func getFileIcon(for filename: String) -> String {
        let ext = filename.lowercased().components(separatedBy: ".").last ?? ""
        
        switch ext {
        case "jpg", "jpeg":
            return "photo"
        case "png":
            return "photo.fill"
        case "tiff", "tif":
            return "photo.on.rectangle"
        case "gif":
            return "livephoto"
        case "bmp":
            return "photo.circle"
        case "eps", "svg":
            return "point.3.connected.trianglepath.dotted"
        case "ai":
            return "paintbrush.pointed"
        case "psd", "psb":
            return "rectangle.stack.fill"
        case "pdf":
            return "doc.richtext"
        default:
            return "doc"
        }
    }
    
    static func getFileSize(at path: String) -> String {
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: path)
            if let fileSize = attributes[.size] as? Int64 {
                return ByteCountFormatter.string(fromByteCount: fileSize, countStyle: .file)
            }
        } catch {
            return "Unknown"
        }
        return "Unknown"
    }
    
    static func getFileModificationDate(at path: String) -> String {
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: path)
            if let modificationDate = attributes[.modificationDate] as? Date {
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                formatter.timeStyle = .short
                return formatter.string(from: modificationDate)
            }
        } catch {
            return "Unknown"
        }
        return "Unknown"
    }
}
