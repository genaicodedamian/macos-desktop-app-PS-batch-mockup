//
//  MockupGeneratorView.swift
//  SmartMockupCreator
//
//  Created by SmartMockupCreator on 2024-01-01.
//

import SwiftUI

struct SmartObjectLayer: Identifiable {
    let id = UUID()
    var target: String = ""
    var align: String = "center center"
    var resize: String = "fill"
}

class MockupGeneratorViewModel: ObservableObject {
    @Published var inputFolderPath: String = "" {
        didSet { 
            validateInputFolder()
            PathRestorationService.savePath(inputFolderPath, for: .inputFolder)
        }
    }
    @Published var mockupFolderPath: String = "" {
        didSet { 
            validateMockupFolder()
            PathRestorationService.savePath(mockupFolderPath, for: .mockupFolder)
        }
    }
    @Published var outputFolderPath: String = "" {
        didSet { 
            validateOutputFolder()
            PathRestorationService.savePath(outputFolderPath, for: .outputFolder)
        }
    }
    @Published var outputFormat: String = "jpg"
    @Published var smartObjectLayers: [SmartObjectLayer] = [SmartObjectLayer()] {
        didSet { validateLayers() }
    }
    @Published var showSuccessMessage: Bool = false
    @Published var errorMessage: String = ""
    @Published var validationResults: [String: ValidationResult] = [:]
    @Published var inputFileCount: Int = 0
    @Published var mockupFileCount: Int = 0
    @Published var inputFilePreview: [String] = []
    @Published var mockupFilePreview: [String] = []
    
    let alignOptions = [
        "left top", "left center", "left bottom",
        "center top", "center center", "center bottom", 
        "right top", "right center", "right bottom"
    ]
    
    let resizeOptions = ["fit", "fill", "fillX", "fillY"]
    
    let formatOptions = JSXGeneratorService.getSupportedOutputFormats()
    
    init() {
        restorePaths()
    }
    
    func addLayer() {
        if smartObjectLayers.count < 10 {
            smartObjectLayers.append(SmartObjectLayer())
        }
    }
    
    func removeLayer(at index: Int) {
        if smartObjectLayers.count > 1 && index > 0 {
            smartObjectLayers.remove(at: index)
        }
    }
    
    private func restorePaths() {
        let restoredInputPath = PathRestorationService.restorePath(for: .inputFolder)
        let restoredMockupPath = PathRestorationService.restorePath(for: .mockupFolder)
        let restoredOutputPath = PathRestorationService.restorePath(for: .outputFolder)
        
        // Użyj bezpośredniego przypisania, żeby uniknąć podwójnego wywołania didSet
        if !restoredInputPath.isEmpty {
            _inputFolderPath = Published(initialValue: restoredInputPath)
            inputFolderPath = restoredInputPath
        }
        
        if !restoredMockupPath.isEmpty {
            _mockupFolderPath = Published(initialValue: restoredMockupPath)
            mockupFolderPath = restoredMockupPath
        }
        
        if !restoredOutputPath.isEmpty {
            _outputFolderPath = Published(initialValue: restoredOutputPath)
            outputFolderPath = restoredOutputPath
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
        inputFolderPath = ""
        mockupFolderPath = ""
        outputFolderPath = ""
        outputFormat = "jpg"
        smartObjectLayers = [SmartObjectLayer()]
        showSuccessMessage = false
        errorMessage = ""
        validationResults.removeAll()
        inputFileCount = 0
        mockupFileCount = 0
        inputFilePreview = []
        mockupFilePreview = []
        generatedScriptPath = ""
        
        // Wyczyść zapisane ścieżki z UserDefaults
        PathRestorationService.removePath(for: .inputFolder)
        PathRestorationService.removePath(for: .mockupFolder)
        PathRestorationService.removePath(for: .outputFolder)
    }
    
    private func validateInputFolder() {
        let result = ValidationService.validateInputFolder(inputFolderPath)
        validationResults["inputFolder"] = result
        
        if result.isValid {
            inputFileCount = ValidationService.getInputFileCount(in: inputFolderPath)
            inputFilePreview = ValidationService.getFileNames(
                in: inputFolderPath, 
                withFormats: ValidationService.inputFileFormats, 
                limit: 5
            )
        } else {
            inputFileCount = 0
            inputFilePreview = []
        }
        
        updateOverallValidation()
    }
    
    private func validateMockupFolder() {
        let result = ValidationService.validateMockupFolder(mockupFolderPath)
        validationResults["mockupFolder"] = result
        
        if result.isValid {
            mockupFileCount = ValidationService.getMockupFileCount(in: mockupFolderPath)
            mockupFilePreview = ValidationService.getFileNames(
                in: mockupFolderPath, 
                withFormats: ValidationService.mockupFileFormats, 
                limit: 5
            )
        } else {
            mockupFileCount = 0
            mockupFilePreview = []
        }
        
        updateOverallValidation()
    }
    
    private func validateOutputFolder() {
        let result = ValidationService.validateOutputFolder(outputFolderPath)
        validationResults["outputFolder"] = result
        updateOverallValidation()
    }
    
    private func validateLayers() {
        for (index, layer) in smartObjectLayers.enumerated() {
            let result = ValidationService.validateSmartObjectLayerName(layer.target)
            validationResults["layer_\(index)"] = result
        }
        updateOverallValidation()
    }
    
    func validateLayer(at index: Int) {
        guard index < smartObjectLayers.count else { return }
        
        let layer = smartObjectLayers[index]
        let result = ValidationService.validateSmartObjectLayerName(layer.target)
        validationResults["layer_\(index)"] = result
        updateOverallValidation()
    }
    
    private func updateOverallValidation() {
        let overallResult = ValidationService.validateMockupGeneratorConfiguration(
            inputFolder: inputFolderPath,
            mockupFolder: mockupFolderPath,
            outputFolder: outputFolderPath,
            smartObjectLayers: smartObjectLayers
        )
        
        errorMessage = overallResult.errorMessage ?? ""
    }
    
    func validateForm() -> Bool {
        let result = ValidationService.validateMockupGeneratorConfiguration(
            inputFolder: inputFolderPath,
            mockupFolder: mockupFolderPath,
            outputFolder: outputFolderPath,
            smartObjectLayers: smartObjectLayers
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
        
        let result = JSXGeneratorService.generateMockupScript(
            inputFolderPath: inputFolderPath,
            mockupFolderPath: mockupFolderPath,
            outputFolderPath: outputFolderPath,
            outputFormat: outputFormat,
            smartObjectLayers: smartObjectLayers
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

struct MockupGeneratorView: View {
    @StateObject private var viewModel = MockupGeneratorViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Sekcja wyboru folderów
                VStack(alignment: .leading, spacing: 15) {
                    Text("1. Wybór folderów")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Folder z plikami wejściowymi:")
                            .fontWeight(.medium)
                        
                        FolderPicker(
                            folderPath: $viewModel.inputFolderPath,
                            buttonText: "Wybierz folder input"
                        )
                        
                        if !viewModel.inputFolderPath.isEmpty {
                            if viewModel.inputFileCount > 0 {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.caption)
                                    Text("Znaleziono \(viewModel.inputFileCount) plików")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                if !viewModel.inputFilePreview.isEmpty {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Przykładowe pliki:")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                        
                                        ForEach(viewModel.inputFilePreview, id: \.self) { filename in
                                            HStack(spacing: 4) {
                                                Image(systemName: ValidationService.getFileIcon(for: filename))
                                                    .foregroundColor(.blue)
                                                    .font(.caption)
                                                Text(filename)
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                        
                                        if viewModel.inputFileCount > viewModel.inputFilePreview.count {
                                            Text("... i \(viewModel.inputFileCount - viewModel.inputFilePreview.count) więcej")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .padding(.leading, 20)
                                }
                            } else if let error = viewModel.validationResults["inputFolder"]?.errorMessage {
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
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Folder z plikami mockup:")
                            .fontWeight(.medium)
                        
                        FolderPicker(
                            folderPath: $viewModel.mockupFolderPath,
                            buttonText: "Wybierz folder mockup"
                        )
                        
                        if !viewModel.mockupFolderPath.isEmpty {
                            if viewModel.mockupFileCount > 0 {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.caption)
                                    Text("Znaleziono \(viewModel.mockupFileCount) plików")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                if !viewModel.mockupFilePreview.isEmpty {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Przykładowe pliki:")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                        
                                        ForEach(viewModel.mockupFilePreview, id: \.self) { filename in
                                            HStack(spacing: 4) {
                                                Image(systemName: ValidationService.getFileIcon(for: filename))
                                                    .foregroundColor(.purple)
                                                    .font(.caption)
                                                Text(filename)
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                        
                                        if viewModel.mockupFileCount > viewModel.mockupFilePreview.count {
                                            Text("... i \(viewModel.mockupFileCount - viewModel.mockupFilePreview.count) więcej")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .padding(.leading, 20)
                                }
                            } else if let error = viewModel.validationResults["mockupFolder"]?.errorMessage {
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
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Folder do zapisu wyników:")
                            .fontWeight(.medium)
                        
                        FolderPicker(
                            folderPath: $viewModel.outputFolderPath,
                            buttonText: "Wybierz folder output"
                        )
                        
                        if !viewModel.outputFolderPath.isEmpty {
                            if let error = viewModel.validationResults["outputFolder"]?.errorMessage {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.orange)
                                        .font(.caption)
                                    Text(error)
                                        .font(.caption)
                                        .foregroundColor(.orange)
                                }
                            } else {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.caption)
                                    Text("Folder jest gotowy do zapisu")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Format plików wynikowych:")
                            .fontWeight(.medium)
                        
                        Picker("Format", selection: $viewModel.outputFormat) {
                            ForEach(viewModel.formatOptions, id: \.self) { format in
                                Text(format.uppercased()).tag(format)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(maxWidth: 200)
                    }
                }
                
                Divider()
                
                // Sekcja konfiguracji warstw Smart Object
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("2. Konfiguracja warstw Smart Object")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        if viewModel.smartObjectLayers.count < 10 {
                            Button("+ Dodaj kolejną warstwę") {
                                viewModel.addLayer()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    
                    ForEach(Array(viewModel.smartObjectLayers.enumerated()), id: \.element.id) { index, layer in
                        SmartObjectLayerView(
                            layer: $viewModel.smartObjectLayers[index],
                            layerNumber: index + 1,
                            alignOptions: viewModel.alignOptions,
                            resizeOptions: viewModel.resizeOptions,
                            canRemove: index > 0,
                            onRemove: {
                                viewModel.removeLayer(at: index)
                            },
                            onValidate: {
                                viewModel.validateLayer(at: index)
                            },
                            getValidationError: {
                                return viewModel.validationResults["layer_\(index)"]?.errorMessage
                            }
                        )
                    }
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
                        Text("Skrypt został wygenerowany pomyślnie!")
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
                    .disabled(viewModel.inputFolderPath.isEmpty || viewModel.mockupFolderPath.isEmpty || viewModel.outputFolderPath.isEmpty)
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
            Text("Czy na pewno chcesz wyczyścić wszystkie pola formularza? Ta operacja usunie również zapisane ścieżki folderów.")
        }
    }
}

struct SmartObjectLayerView: View {
    @Binding var layer: SmartObjectLayer
    let layerNumber: Int
    let alignOptions: [String]
    let resizeOptions: [String]
    let canRemove: Bool
    let onRemove: () -> Void
    let onValidate: () -> Void
    let getValidationError: () -> String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Warstwa \(layerNumber)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                if canRemove {
                    Button("Usuń") {
                        onRemove()
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.red)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Nazwa warstwy Smart Object:")
                    .font(.caption)
                
                TextField("np. smart object layer name", text: $layer.target)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: layer.target) { _ in
                        onValidate()
                    }
                
                // Pokazuj walidację dla tej warstwy
                if let validationError = getValidationError() {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                            .font(.caption)
                        Text(validationError)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
            
            HStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Wyrównanie:")
                        .font(.caption)
                    
                    Picker("Align", selection: $layer.align) {
                        ForEach(alignOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(width: 150)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Dopasowanie:")
                        .font(.caption)
                    
                    Picker("Resize", selection: $layer.resize) {
                        ForEach(resizeOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(width: 100)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
    }
}

#Preview {
    MockupGeneratorView()
}
