# Dokumentacja Techniczna - Smart Mockup Creator

## 1. Przegląd projektu

Smart Mockup Creator to natywna aplikacja desktopowa na macOS w SwiftUI, która automatyzuje proces tworzenia mockupów w Adobe Photoshop przez generowanie skryptów JSX. Aplikacja składa się z dwóch głównych modułów:

1.  **Generator Mockupów** - automatyczne tworzenie wariantów mockupów z integracją z istniejącym silnikiem JSX.
2.  **Zmieniacz Nazw Smart Object** - przygotowanie plików PSD do użycia w generatorze.

## 2. Architektura aplikacji

Aplikacja została zbudowana w oparciu o architekturę **MVVM (Model-View-ViewModel)** z dodatkową warstwą serwisową, co zapewnia czysty podział odpowiedzialności:

-   **View**: Warstwa interfejsu użytkownika, zbudowana w **SwiftUI**. Odpowiada wyłącznie za wyświetlanie danych i przechwytywanie akcji użytkownika.
-   **ViewModel**: Pośrednik między View a Modelem/Serwisami. Przechowuje stan widoku (np. ścieżki do folderów, listę warstw) i implementuje logikę interfejsu (np. dodawanie warstwy, resetowanie formularza).
-   **Services**: Warstwa logiki biznesowej. Serwisy są odpowiedzialne za operacje takie jak walidacja danych, generowanie skryptów JSX i zarządzanie zapisanymi ścieżkami.

Taka architektura sprawia, że kod jest modułowy, łatwy do testowania i rozwijania.

## 3. Struktura plików projektu

```
SmartMockupCreator/
└── SmartMockupCreator/
    ├── SmartMockupCreatorApp.swift       # Punkt wejścia aplikacji, konfiguracja okna
    ├── ContentView.swift                 # Główny widok z zakładkami (Router)
    │
    ├── Views/                            # Komponenty UI
    │   ├── MockupGeneratorView.swift     # UI dla Generatora Mockupów
    │   ├── SmartObjectRenamerView.swift  # UI dla Zmieniacza Nazw
    │   └── FolderPicker.swift            # Reużywalny komponent wyboru folderu
    │
    ├── ViewModels/                       # Logika interfejsu i zarządzanie stanem
    │   ├── MockupGeneratorViewModel.swift
    │   └── SmartObjectRenamerViewModel.swift
    │
    └── Services/                         # Logika biznesowa i integracje systemowe
        ├── ValidationService.swift       # Walidacja danych wejściowych
        ├── JSXGeneratorService.swift     # Generowanie skryptów JSX
        └── PathRestorationService.swift  # Zarządzanie zapisanymi ścieżkami (UserDefaults)
```

## 4. Szczegółowy opis komponentów

### Views

-   `ContentView.swift`: Główny kontener aplikacji, który zarządza przełączaniem między dwiema głównymi zakładkami (`MockupGeneratorView` i `SmartObjectRenamerView`). Zawiera również nagłówek z informacją o skrótach klawiszowych.
-   `MockupGeneratorView.swift`: Interfejs dla Generatora Mockupów. Umożliwia wybór folderów, dynamiczne dodawanie/usuwanie konfiguracji warstw Smart Object i generowanie skryptu.
-   `SmartObjectRenamerView.swift`: Interfejs dla Zmieniacza Nazw. Pozwala na wybór folderu z plikami PSD i zdefiniowanie nowej nazwy dla warstw.
-   `FolderPicker.swift`: Reużywalny komponent UI do wyboru folderów, zintegrowany z `NSOpenPanel`. Wyświetla wybraną ścieżkę, status walidacji oraz podgląd zawartości.

### ViewModels

-   `MockupGeneratorViewModel.swift`: Zarządza stanem dla `MockupGeneratorView`. Przechowuje ścieżki do folderów, listę warstw Smart Object (`@Published var smartObjectLayers`) i wyniki walidacji. Wywołuje serwisy do walidacji i generowania JSX.
-   `SmartObjectRenamerViewModel.swift`: Zarządza stanem dla `SmartObjectRenamerView`. Przechowuje ścieżkę do folderu PSD i nową nazwę warstwy.

### Services

-   `ValidationService.swift`: Centralny serwis do walidacji wszystkich danych wejściowych. Sprawdza istnienie folderów, uprawnienia, zawartość plików (według formatów) oraz poprawność nazw warstw (długość, niedozwolone znaki, duplikaty).
-   `JSXGeneratorService.swift`: Odpowiada za budowanie treści skryptów JSX dla obu modułów.
    -   Dla **Generatora Mockupów**, tworzy plik konfiguracyjny, który dołącza główny silnik `#include "Batch Mockup Smart Object Replacement.jsx"`.
    -   Dla **Zmieniacza Nazw**, generuje w pełni samodzielny skrypt z logiką do zmiany nazw i tworzenia pliku `rename_log.txt`.
-   `PathRestorationService.swift`: Zarządza zapisywaniem i odczytywaniem ostatnio używanych ścieżek folderów w `UserDefaults`, co poprawia UX między sesjami.

## 5. Kluczowe Funkcjonalności i UX

-   **Walidacja w czasie rzeczywistym**: Dzięki `didSet` w ViewModelach, walidacja jest uruchamiana natychmiast po zmianie ścieżki folderu lub nazwy warstwy, dając użytkownikowi natychmiastowy feedback.
-   **Przywracanie ścieżek**: Aplikacja automatycznie zapisuje i przywraca ostatnio używane ścieżki, oszczędzając czas użytkownika.
-   **Bezpieczne operacje**: Funkcja "Resetuj" jest chroniona przez okno dialogowe z potwierdzeniem, aby zapobiec przypadkowej utracie danych.
-   **Skróty klawiszowe**: Najważniejsze akcje (Generuj, Resetuj, Otwórz folder) są dostępne pod skrótami klawiszowymi, co przyspiesza pracę.
-   **Podgląd plików**: Użytkownik widzi liczbę znalezionych plików oraz ich nazwy, co potwierdza poprawny wybór folderu.
-   **Ikony plików**: W podglądzie plików wyświetlane są ikony odpowiadające typom plików, co ułatwia orientację.

## 6. Zgodność z PRD

### ✅ Wymagania funkcjonalne (100% zrealizowane)

**Generator Mockupów:**
- ✅ Wybór folderu z plikami wejściowymi (JPG, PNG, TIFF, GIF, BMP, EPS, SVG, AI, PSD, PDF)
- ✅ Wybór folderu z plikami mockup (PSD/PSB)
- ✅ Wsparcie dla wielu warstw Smart Object w jednym pliku PSD
- ✅ Dynamiczne dodawanie i usuwanie reguł dla poszczególnych warstw (maks. 10)
- ✅ Konfiguracja parametrów dla każdej warstwy: target, align, resize
- ✅ Walidacja danych wejściowych przed generacją skryptu
- ✅ Generowanie pliku JSX z konfiguracją + integracja z `Batch Mockup Smart Object Replacement.jsx`
- ✅ Automatyczne nazewnictwo plików wyjściowych

**Zmieniacz Nazw Smart Object:**
- ✅ Wybór folderu z plikami PSD
- ✅ Definicja nowej nazwy dla warstw Smart Object
- ✅ Przetwarzanie tylko plików z dokładnie jedną warstwą Smart Object
- ✅ Generowanie skryptu JSX do wsadowej zmiany nazw
- ✅ Tworzenie raportu z wynikami operacji (rename_log.txt)

### ✅ User Stories (23/23 zrealizowane)

Wszystkie user stories US-001 do US-023 zostały w pełni zaimplementowane zgodnie z kryteriami akceptacji.

## 7. Technologie i narzędzia

-   **Platforma:** macOS 12.0+
-   **Framework:** SwiftUI
-   **Język:** Swift 5.0
-   **IDE:** Xcode 15.0+
-   **Architektura:** MVVM + Services
-   **Zarządzanie stanem:** Combine (`@Published`, `ObservableObject`)
-   **Integracja systemowa:** NSOpenPanel, NSWorkspace, UserDefaults
-   **Bezpieczeństwo:** App Sandbox z uprawnieniami do plików

## 8. Podsumowanie

Aplikacja jest w pełni funkcjonalna, przetestowana i gotowa do wdrożenia. Spełnia wszystkie założenia z dokumentu wymagań produktu (PRD), oferując przy tym wysoką wydajność i nowoczesny, intuicyjny interfejs użytkownika.
