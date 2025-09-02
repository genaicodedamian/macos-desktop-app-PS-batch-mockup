# Dokument wymagań produktu (PRD) - Konwerter WebP

## 1. Przegląd produktu
Nowa funkcja, "Konwerter WebP", zostanie zintegrowana jako trzecia zakładka w istniejącej aplikacji `Smart Mockup Creator`. Jej celem jest umożliwienie użytkownikom masowej konwersji plików graficznych z formatów JPG i PNG do nowoczesnego formatu WebP. Proces będzie napędzany przez dołączony do aplikacji silnik ImageMagick, eliminując potrzebę instalacji zewnętrznych zależności przez użytkownika. Funkcja zapewni prosty interfejs do wyboru folderów, konfiguracji podstawowych parametrów konwersji oraz monitorowania postępu w czasie rzeczywistym.

## 2. Problem użytkownika
Projektanci, deweloperzy i twórcy treści internetowych często muszą optymalizować obrazy na potrzeby stron internetowych, aby skrócić czas ładowania i poprawić wydajność. Format WebP oferuje znacznie lepszą kompresję niż tradycyjne formaty JPG i PNG, zachowując przy tym wysoką jakość. Obecnie proces konwersji wielu plików jest często manualny, czasochłonny i wymaga korzystania z wielu różnych narzędzi, które nie zawsze oferują potrzebne opcje konfiguracyjne. Brak zintegrowanego, wydajnego narzędzia do konwersji wsadowej w ramach jednego ekosystemu spowalnia pracę i jest źródłem frustracji.

## 3. Wymagania funkcjonalne
- `FR-001`: Interfejs użytkownika umożliwiający wybór folderu źródłowego z obrazami oraz folderu docelowego dla przekonwertowanych plików.
- `FR-002`: Aplikacja musi obsługiwać pliki w formatach JPG i PNG jako pliki wejściowe.
- `FR-003`: Użytkownik musi mieć możliwość skonfigurowania następujących parametrów konwersji WebP:
    - Poziom jakości (suwak, np. 1-100) dla kompresji stratnej.
    - Opcja trybu bezstratnego (checkbox).
    - Opcja zachowania przezroczystości (kanału alfa) (checkbox).
- `FR-004`: Interfejs musi zawierać przycisk "Rozpocznij konwersję" inicjujący proces.
- `FR-005`: Proces konwersji musi działać asynchronicznie, nie blokując interfejsu użytkownika, co pozwoli na dalszą pracę z aplikacją.
- `FR-006`: Aplikacja musi wyświetlać interaktywną tabelę postępu, pokazującą w czasie rzeczywistym status każdego pliku (nazwa, rozmiar oryginalny, rozmiar po konwersji, status: w kolejce, w trakcie, ukończono, błąd).
- `FR-007`: System musi być odporny na błędy pojedynczych plików; błąd konwersji jednego pliku nie może przerywać całego procesu wsadowego.
- `FR-008`: Po zakończeniu konwersji aplikacja musi wyświetlić okno podsumowujące (np. "Przekonwertowano X z Y plików") oraz przycisk umożliwiający bezpośrednie otwarcie folderu docelowego.
- `FR-009`: Aplikacja musi zawierać wbudowane pliki binarne ImageMagick, aby działać samodzielnie bez potrzeby instalacji przez użytkownika.

## 4. Granice produktu
Następujące funkcje są celowo wykluczone z zakresu MVP (Minimum Viable Product):
- Obsługa innych formatów wejściowych niż JPG i PNG (np. GIF, TIFF, SVG, PSD).
- Funkcja iteracyjnej konwersji w celu osiągnięcia docelowego rozmiaru pliku.
- Możliwość automatycznego usuwania oryginalnych plików po konwersji.
- Dostęp do zaawansowanych, mniej popularnych opcji konfiguracyjnych ImageMagick.
- Zapisywanie i wczytywanie presetów konfiguracyjnych.

## 5. Historyjki użytkowników

- ID: `US-001`
- Tytuł: Konfiguracja zadania konwersji
- Opis: Jako użytkownik, chcę wybrać folder z obrazami, folder docelowy oraz ustawić parametry konwersji, aby przygotować proces zgodnie z moimi wymaganiami.
- Kryteria akceptacji:
    1. Mogę kliknąć przycisk, aby otworzyć systemowe okno wyboru folderu źródłowego.
    2. Po wybraniu folderu źródłowego, widzę jego ścieżkę w interfejsie.
    3. Mogę kliknąć przycisk, aby otworzyć systemowe okno wyboru folderu docelowego.
    4. Po wybraniu folderu docelowego, widzę jego ścieżkę w interfejsie.
    5. Widzę suwak do ustawienia jakości w zakresie od 1 do 100.
    6. Widzę pole wyboru (checkbox) do włączenia trybu bezstratnego.
    7. Widzę pole wyboru (checkbox) do włączenia/wyłączenia obsługi przezroczystości.
    8. Przycisk "Rozpocznij konwersję" jest nieaktywny, dopóki nie zostaną wybrane oba foldery.

- ID: `US-002`
- Tytuł: Uruchomienie pomyślnej konwersji wsadowej
- Opis: Jako użytkownik, chcę uruchomić proces konwersji i zobaczyć, jak wszystkie moje obrazy JPG i PNG są poprawnie przekształcane do formatu WebP i zapisywane w folderze docelowym.
- Kryteria akceptacji:
    1. Po kliknięciu "Rozpocznij konwersję", proces rozpoczyna się w tle.
    2. Interfejs użytkownika pozostaje w pełni responsywny podczas konwersji.
    3. Dla każdego pliku JPG/PNG w folderze źródłowym, w folderze docelowym tworzony jest odpowiedni plik .webp.
    4. Nazwy plików wyjściowych są takie same jak pliki wejściowe, ze zmienionym rozszerzeniem.
    5. Po zakończeniu całego procesu, otrzymuję komunikat o pomyślnym zakończeniu.

- ID: `US-003`
- Tytuł: Monitorowanie postępu konwersji
- Opis: Jako użytkownik, chcę widzieć szczegółowy postęp przetwarzania dużej liczby plików, aby wiedzieć, co się dzieje i oszacować pozostały czas.
- Kryteria akceptacji:
    1. W momencie rozpoczęcia konwersji, w interfejsie pojawia się tabela postępu.
    2. Tabela zawiera kolumny: Nazwa pliku, Rozmiar oryginalny, Nowy rozmiar, Status.
    3. Tabela jest natychmiast wypełniana listą wszystkich znalezionych plików ze statusem "W kolejce".
    4. Status pliku zmienia się na "Przetwarzanie...", gdy rozpoczyna się jego konwersja.
    5. Po pomyślnej konwersji, status pliku zmienia się na "Ukończono", a w kolumnie "Nowy rozmiar" pojawia się aktualny rozmiar pliku.
    6. Widzę ogólny wskaźnik postępu (np. pasek postępu lub licznik "X/Y ukończono").

- ID: `US-004`
- Tytuł: Obsługa częściowych niepowodzeń w zadaniu wsadowym
- Opis: Jako użytkownik, w przypadku gdy niektóre pliki są uszkodzone lub w nieobsługiwanym formacie, chcę, aby proces był kontynuowany dla poprawnych plików, a problematyczne pliki zostały wyraźnie oznaczone.
- Kryteria akceptacji:
    1. Jeśli konwersja pojedynczego pliku się nie powiedzie, proces nie jest przerywany.
    2. W tabeli postępu, status problematycznego pliku zmienia się na "Błąd".
    3. Opcjonalnie: po najechaniu na status "Błąd" widzę dymek z przyczyną błędu.
    4. Po zakończeniu całego procesu, w podsumowaniu widzę informację o liczbie plików, których nie udało się przekonwertować.

- ID: `US-005`
- Tytuł: Obsługa nieprawidłowych danych wejściowych
- Opis: Jako użytkownik, chcę otrzymać informację zwrotną, jeśli spróbuję uruchomić konwersję dla pustego folderu lub folderu bez obsługiwanych plików.
- Kryteria akceptacji:
    1. Jeśli wybrany folder źródłowy jest pusty, przycisk "Rozpocznij konwersję" pozostaje nieaktywny.
    2. Po wybraniu folderu źródłowego, aplikacja skanuje go i wyświetla informację o liczbie znalezionych plików (np. "Znaleziono X plików JPG/PNG").
    3. Jeśli w folderze nie ma żadnych plików JPG ani PNG, wyświetlany jest komunikat "Nie znaleziono obsługiwanych plików", a przycisk konwersji jest nieaktywny.

- ID: `US-006`
- Tytuł: Przegląd wyników konwersji
- Opis: Jako użytkownik, po zakończeniu konwersji chcę łatwo przejrzeć jej wyniki i szybko dostać się do przekonwertowanych plików.
- Kryteria akceptacji:
    1. Po zakończeniu procesu (pomyślnym lub częściowo pomyślnym), wyświetlane jest okno dialogowe z podsumowaniem (np. "Ukończono. Pomyślnie przekonwertowano: 98/100").
    2. W oknie podsumowania znajduje się przycisk "Otwórz folder docelowy".
    3. Kliknięcie tego przycisku otwiera folder docelowy w systemowym Finderze.

## 6. Plan implementacji

### Faza 1: Przygotowanie infrastruktury (1-2 dni)

#### 1.1. Integracja ImageMagick
- **Cel**: Dołączenie biblioteki ImageMagick do projektu
- **Kroki**:
  1. Pobranie statycznych plików binarnych ImageMagick dla macOS z oficjalnej strony
  2. Utworzenie folderu `Resources/ImageMagick/` w projekcie Xcode
  3. Dodanie plików binarnych (`magick`, biblioteki .dylib) do bundle'a aplikacji
  4. Konfiguracja `Info.plist` z odpowiednimi uprawnieniami do uruchamiania procesów
  5. Testowanie podstawowej integracji z prostym poleceniem `magick --version`

#### 1.2. Utworzenie podstawowej struktury plików
- **Cel**: Przygotowanie nowych komponentów zgodnie z architekturą MVVM
- **Kroki**:
  1. Utworzenie `WebPConverterView.swift` (UI)
  2. Utworzenie `WebPConverterViewModel.swift` (logika interfejsu)
  3. Utworzenie `WebPConversionService.swift` (logika biznesowa)
  4. Rozszerzenie `ValidationService.swift` o funkcje dla WebP
  5. Rozszerzenie `PathRestorationService.swift` o nowe ścieżki

### Faza 2: Implementacja UI i logiki podstawowej (2-3 dni)

#### 2.1. Budowa interfejsu użytkownika (WebPConverterView.swift)
- **Komponenty UI**:
  1. Sekcja wyboru folderu źródłowego (reużycie `FolderPicker`)
  2. Sekcja wyboru folderu docelowego (reużycie `FolderPicker`)
  3. Panel konfiguracji konwersji:
     - Suwak jakości (1-100) z `Slider` i `TextField`
     - Checkbox "Tryb bezstratny" (`Toggle`)
     - Checkbox "Zachowaj przezroczystość" (`Toggle`)
  4. Przycisk "Rozpocznij konwersję" z walidacją stanu
  5. Obszar statusu z podglądem znalezionych plików

#### 2.2. Implementacja ViewModel (WebPConverterViewModel.swift)
- **Właściwości `@Published`**:
  ```swift
  @Published var sourceFolderPath: String = ""
  @Published var destinationFolderPath: String = ""
  @Published var quality: Double = 80
  @Published var lossless: Bool = false
  @Published var preserveAlpha: Bool = true
  @Published var isConverting: Bool = false
  @Published var validationResults: [String: ValidationResult] = [:]
  @Published var sourceFileCount: Int = 0
  @Published var sourceFilePreview: [String] = []
  ```
- **Metody**:
  - `validateSourceFolder()` - walidacja w czasie rzeczywistym
  - `validateDestinationFolder()` - walidacja dostępu do zapisu
  - `startConversion()` - uruchomienie procesu asynchronicznego
  - `restorePaths()` - przywracanie zapisanych ścieżek

#### 2.3. Integracja z istniejącym ContentView
- **Kroki**:
  1. Rozszerzenie `Picker` o trzecią opcję "Konwerter WebP" (tag: 2)
  2. Dodanie `WebPConverterView()` do bloku `Group` z warunkiem `selectedTab == 2`
  3. Aktualizacja tytułu i skrótów klawiszowych w nagłówku

### Faza 3: Implementacja logiki konwersji (3-4 dni)

#### 3.1. Budowa WebPConversionService.swift
- **Struktura danych**:
  ```swift
  struct ConversionTask {
      let sourceFile: String
      let destinationFile: String
      var status: ConversionStatus = .queued
      var originalSize: Int64 = 0
      var convertedSize: Int64 = 0
      var errorMessage: String?
  }
  
  enum ConversionStatus {
      case queued, processing, completed, error
  }
  ```

- **Kluczowe metody**:
  - `convertToWebP(settings:)` - główna metoda konwersji wsadowej
  - `buildImageMagickCommand()` - budowanie polecenia CLI
  - `executeImageMagickProcess()` - uruchamianie procesu w tle
  - `monitorProgress()` - śledzenie postępu dla każdego pliku

#### 3.2. Logika uruchamiania ImageMagick
- **Proces**:
  1. Zlokalizowanie pliku binarnego `magick` w bundle'u aplikacji
  2. Budowanie polecenia: `magick convert input.jpg -quality 80 -define webp:lossless=false output.webp`
  3. Konfiguracja `Process` z odpowiednim środowiskiem
  4. Obsługa stdout/stderr dla diagnostyki
  5. Asynchroniczne wykonanie z callback'iem dla aktualizacji UI

#### 3.3. Rozszerzenie ValidationService.swift
- **Nowe funkcje**:
  ```swift
  static func validateWebPConverter(
      sourceFolder: String,
      destinationFolder: String
  ) -> ValidationResult
  
  static func getImageFiles(in path: String) -> [String]
  // Zwraca pliki .jpg i .png
  ```

### Faza 4: UI dla monitorowania postępu (2-3 dni)

#### 4.1. Implementacja tabeli postępu
- **Komponenty**:
  1. `Table` z kolumnami: Nazwa pliku, Rozmiar oryginalny, Nowy rozmiar, Status
  2. Kolorowanie wierszy według statusu (szary=kolejka, niebieski=przetwarzanie, zielony=ukończono, czerwony=błąd)
  3. Pasek postępu ogólnego nad tabelą
  4. Licznik "X/Y ukończono"

#### 4.2. Logika aktualizacji w czasie rzeczywistym
- **Mechanizm**:
  1. ViewModel subskrybuje `@Published` właściwości z `WebPConversionService`
  2. Service aktualizuje status każdego `ConversionTask` 
  3. UI automatycznie odświeża tabelę dzięki `@ObservableObject`
  4. Smooth animacje przy zmianie statusu wierszy

#### 4.3. Obsługa błędów i diagnostyka
- **Implementacja**:
  1. Tooltip z szczegółami błędu przy najechaniu na status "Błąd"
  2. Przycisk "Szczegóły" otwierający okno z pełnym logiem dla problematycznych plików
  3. Możliwość eksportu logu konwersji do pliku tekstowego

### Faza 5: Podsumowanie i finalizacja (1-2 dni)

#### 5.1. Okno dialogowe podsumowania
- **Elementy**:
  1. `Alert` lub custom `Sheet` z wynikami końcowymi
  2. Statystyki: "Ukończono X z Y plików"
  3. Czas trwania procesu
  4. Oszczędność miejsca (porównanie rozmiarów)
  5. Przycisk "Otwórz folder docelowy"

#### 5.2. Skróty klawiszowe i accessibility
- **Dodania**:
  1. `⌘W` - rozpoczęcie konwersji WebP
  2. `⌘⇧W` - otwarcie folderu docelowego
  3. Aktualizacja podpowiedzi w nagłówku aplikacji
  4. Oznaczenia accessibility dla wszystkich kontrolek

#### 5.3. Przywracanie ścieżek i ustawień
- **Implementacja**:
  1. Rozszerzenie `PathRestorationService.PathType` o `.webpSource` i `.webpDestination`
  2. Zapisywanie ustawień jakości i opcji w `UserDefaults`
  3. Automatyczne przywracanie przy ponownym uruchomieniu aplikacji

### Faza 6: Testowanie i optymalizacja (2-3 dni)

#### 6.1. Testy funkcjonalne
- **Scenariusze testowe**:
  1. Konwersja małej liczby plików (1-10)
  2. Konwersja średniej liczby plików (50-100)
  3. Test wydajnościowy z dużą liczbą plików (500+)
  4. Testowanie różnych kombinacji ustawień jakości
  5. Testowanie z uszkodzonymi/nieprawidłowymi plikami
  6. Test przerwania procesu w połowie

#### 6.2. Walidacja PRD
- **Sprawdzenie zgodności**:
  1. Weryfikacja realizacji wszystkich User Stories (US-001 do US-006)
  2. Test wszystkich wymagań funkcjonalnych (FR-001 do FR-009)
  3. Pomiary wydajności dla określenia baseline'u metryk sukcesu
  4. Testy UX z użytkownikami końcowymi

#### 6.3. Optymalizacje
- **Obszary poprawy**:
  1. Optymalizacja wykorzystania CPU przy dużej liczbie plików
  2. Implementacja kolejkowania zadań dla lepszej responsywności
  3. Dodanie opcji zatrzymania/wznowienia procesu
  4. Poprawa komunikatów błędów dla lepszego UX

### Szacowane zasoby
- **Czas realizacji**: 11-17 dni roboczych
- **Zespół**: 1 deweloper Swift/SwiftUI + 1 tester QA (opcjonalnie)
- **Ryzyko**: Średnie (głównie związane z integracją ImageMagick i wydajnością)

### Kryteria akceptacji implementacji
1. ✅ Aplikacja kompiluje się i uruchamia bez błędów
2. ✅ Wszystkie User Stories z PRD są zaimplementowane i przetestowane
3. ✅ Konwersja 100 plików JPG/PNG zajmuje mniej niż 2 minuty na standardowym MacBooku
4. ✅ Aplikacja gracefully obsługuje błędy bez crashowania
5. ✅ UI pozostaje responsywne podczas konwersji setek plików
6. ✅ Wszystkie ścieżki i ustawienia są zapisywane i przywracane między sesjami

