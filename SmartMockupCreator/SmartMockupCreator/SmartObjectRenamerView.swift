//
//  SmartObjectRenamerView.swift
//  SmartMockupCreator
//
//  Created by SmartMockupCreator on 2024-01-01.
//

import SwiftUI

class SmartObjectRenamerViewModel: ObservableObject {
    @Published var psdFolderPath: String = "" {
        didSet { 
            validatePSDFolder()
            PathRestorationService.savePath(psdFolderPath, for: .psdFolder)
        }
    }
    @Published var newLayerName: String = "" {
        didSet { validateLayerName() }
    }
    @Published var showSuccessMessage: Bool = false
    @Published var errorMessage: String = ""
    @Published var validationResults: [String: ValidationResult] = [:]
    @Published var psdFileCount: Int = 0
    @Published var psdFilePreview: [String] = []
    
    init() {
        restorePaths()
    }
    
    private func restorePaths() {
        let restoredPSDPath = PathRestorationService.restorePath(for: .psdFolder)
        
        if !restoredPSDPath.isEmpty {
            _psdFolderPath = Published(initialValue: restoredPSDPath)
            psdFolderPath = restoredPSDPath
        }
    }
    
    func requestResetConfirmation() {
        showResetConfirmation = true
    }
    
    func confirmReset() {
        resetForm()
        showResetConfirmation = false
    }
    
    func cancelReset() {
        showResetConfirmation = false
    }
    
    private func resetForm() {
        psdFolderPath = ""
        newLayerName = ""
        showSuccessMessage = false
        errorMessage = ""
        validationResults.removeAll()
        psdFileCount = 0
        psdFilePreview = []
        generatedScriptPath = ""
        
        // Wyczyść zapisaną ścieżkę z UserDefaults
        PathRestorationService.removePath(for: .psdFolder)
    }
    
    private func validatePSDFolder() {
        let result = ValidationService.validatePSDFolder(psdFolderPath)
        validationResults["psdFolder"] = result
        
        if result.isValid {
            psdFileCount = ValidationService.getMockupFileCount(in: psdFolderPath)
            psdFilePreview = ValidationService.getFileNames(
                in: psdFolderPath, 
                withFormats: ValidationService.mockupFileFormats, 
                limit: 5
            )
        } else {
            psdFileCount = 0
            psdFilePreview = []
        }
        
        updateOverallValidation()
    }
    
    private func validateLayerName() {
        let result = ValidationService.validateSmartObjectLayerName(newLayerName)
        validationResults["layerName"] = result
        updateOverallValidation()
    }
    
    private func updateOverallValidation() {
        let overallResult = ValidationService.validateSmartObjectRenamerConfiguration(
            psdFolder: psdFolderPath,
            newLayerName: newLayerName
        )
        
        errorMessage = overallResult.errorMessage ?? ""
    }
    
    func validateForm() -> Bool {
        let result = ValidationService.validateSmartObjectRenamerConfiguration(
            psdFolder: psdFolderPath,
            newLayerName: newLayerName
        )
        
        if !result.isValid {
            errorMessage = result.errorMessage ?? "Formularz zawiera błędy"
        }
        
        return result.isValid
    }
    
    @Published var generatedScriptPath: String = ""
    @Published var showResetConfirmation: Bool = false
    
    func generateScript() {
        guard validateForm() else { return }
        
        let result = JSXGeneratorService.generateRenamerScript(
            psdFolderPath: psdFolderPath,
            newLayerName: newLayerName
        )
        
        if result.success {
            generatedScriptPath = result.filePath ?? ""
            showSuccessMessage = true
            errorMessage = ""
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.showSuccessMessage = false
            }
        } else {
            errorMessage = result.errorMessage ?? "Nie udało się wygenerować skryptu"
            showSuccessMessage = false
        }
    }
    
    func openGeneratedScriptFolder() {
        guard !generatedScriptPath.isEmpty else { return }
        JSXGeneratorService.openInFinder(path: generatedScriptPath)
    }
}

struct SmartObjectRenamerView: View {
    @StateObject private var viewModel = SmartObjectRenamerViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Opis funkcjonalności
                VStack(alignment: .leading, spacing: 10) {
                    Text("Zmieniacz Nazw Smart Object")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("Ten moduł pozwala na wsadową zmianę nazw warstw Smart Object w plikach PSD. Proces działa tylko z plikami, które mają dokładnie jedną warstwę Smart Object.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Divider()
                
                // Sekcja wyboru folderu z plikami PSD
                VStack(alignment: .leading, spacing: 15) {
                    Text("1. Wybór folderu z plikami PSD")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Folder z plikami PSD/PSB:")
                            .fontWeight(.medium)
                        
                        FolderPicker(
                            folderPath: $viewModel.psdFolderPath,
                            buttonText: "Wybierz folder PSD"
                        )
                        
                        if !viewModel.psdFolderPath.isEmpty {
                            if viewModel.psdFileCount > 0 {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.caption)
                                    Text("Znaleziono \(viewModel.psdFileCount) plików")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                if !viewModel.psdFilePreview.isEmpty {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Przykładowe pliki:")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                        
                                        ForEach(viewModel.psdFilePreview, id: \.self) { filename in
                                            HStack(spacing: 4) {
                                                Image(systemName: ValidationService.getFileIcon(for: filename))
                                                    .foregroundColor(.purple)
                                                    .font(.caption)
                                                Text(filename)
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                        
                                        if viewModel.psdFileCount > viewModel.psdFilePreview.count {
                                            Text("... i \(viewModel.psdFileCount - viewModel.psdFilePreview.count) więcej")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .padding(.leading, 20)
                                }
                            } else if let error = viewModel.validationResults["psdFolder"]?.errorMessage {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.orange)
                                        .font(.caption)
                                    Text(error)
                                        .font(.caption)
                                        .foregroundColor(.orange)
                                }
                            }
                        }
                        
                        Text("Obsługiwane formaty: .psd, .psb")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Divider()
                
                // Sekcja definicji nowej nazwy
                VStack(alignment: .leading, spacing: 15) {
                    Text("2. Nowa nazwa warstwy")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Wprowadź nową nazwę dla warstw Smart Object:")
                            .fontWeight(.medium)
                        
                        TextField("np. smart object", text: $viewModel.newLayerName)
                            .textFieldStyle(.roundedBorder)
                        
                        // Pokazuj walidację nazwy warstwy
                        if let validationError = viewModel.validationResults["layerName"]?.errorMessage {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                    .font(.caption)
                                Text(validationError)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Ograniczenia:")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            
                            Text("• Maksimum 100 znaków")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text("• Niedozwolone znaki: / \\ : * ? \" < > |")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Divider()
                
                // Informacja o raportowaniu
                VStack(alignment: .leading, spacing: 10) {
                    Text("ℹ️ Informacja")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("Po uruchomieniu skryptu zostanie utworzony plik raportu 'rename_log.txt' zawierający status przetwarzania dla każdego pliku PSD.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Divider()
                
                // Komunikaty błędów
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                }
                
                // Komunikat sukcesu
                if viewModel.showSuccessMessage {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        VStack(alignment: .leading) {
                            Text("Skrypt został wygenerowany pomyślnie!")
                            Text("Raport operacji zostanie zapisany jako 'rename_log.txt'")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Button("Otwórz folder") {
                            viewModel.openGeneratedScriptFolder()
                        }
                        .buttonStyle(.bordered)
                        .keyboardShortcut("o", modifiers: [.command, .shift])
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(8)
                }
                
                // Przyciski akcji
                HStack {
                    Button("Resetuj") {
                        viewModel.requestResetConfirmation()
                    }
                    .buttonStyle(.bordered)
                    .keyboardShortcut("r", modifiers: .command)
                    
                    Spacer()
                    
                    Button("Generuj Skrypt") {
                        viewModel.generateScript()
                    }
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut("g", modifiers: .command)
                    .disabled(viewModel.psdFolderPath.isEmpty || viewModel.newLayerName.isEmpty)
                }
            }
            .padding()
        }
        .alert("Potwierdź resetowanie", isPresented: $viewModel.showResetConfirmation) {
            Button("Anuluj", role: .cancel) {
                viewModel.cancelReset()
            }
            Button("Resetuj", role: .destructive) {
                viewModel.confirmReset()
            }
        } message: {
            Text("Czy na pewno chcesz wyczyścić wszystkie pola formularza? Ta operacja usunie również zapisaną ścieżkę folderu.")
        }
    }
}

#Preview {
    SmartObjectRenamerView()
}
