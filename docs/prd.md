# Dokument wymagań produktu (PRD) - Smart Mockup Creator

## 1. Przegląd produktu

Smart Mockup Creator to natywna aplikacja desktopowa na macOS, która automatyzuje proces tworzenia mockupów w Adobe Photoshop przez generowanie skryptów JSX. Aplikacja eliminuje czasochłonną, ręczną pracę związaną z zastępowaniem Smart Object w plikach PSD, umożliwiając projektantom szybkie tworzenie setek wariantów mockupów z różnymi grafikami wejściowymi.

Produkt składa się z dwóch głównych modułów funkcjonalnych dostępnych przez interfejs z zakładkami:
- Generator Mockupów - automatyczne tworzenie wariantów mockupów
- Zmieniacz Nazw Smart Object - przygotowanie plików PSD do użycia w generatorze

Aplikacja nie wymaga połączenia z internetem i działa lokalnie, generując pliki JSX gotowe do uruchomienia w Photoshopie.

## 2. Problem użytkownika

Projektanci i agencje kreacyjne napotykają znaczące wyzwania w procesie tworzenia prezentacji projektów dla klientów:

1. **Czasochłonność procesu manualnego**: Ręczne zastępowanie Smart Object w dziesiątkach plików PSD dla różnych mockupów (kubki, koszulki, billboardy) zajmuje godziny pracy
2. **Błędy ludzkie**: Manualna praca prowadzi do pomyłek w nazewnictwie, nieprawidłowym dopasowaniu grafik lub pominiętych wariantów
3. **Brak standaryzacji**: Różne nazwy warstw Smart Object w plikach PSD utrudniają automatyzację
4. **Skalowanie projektów**: Im większy projekt (więcej grafik × więcej mockupów), tym bardziej nieefektywny staje się proces manualny

Projektanci potrzebują narzędzia, które pozwoli im na:
- Wsadowe przetwarzanie dużych ilości grafik i mockupów
- Standaryzację nazw warstw Smart Object
- Automatyzację całego procesu tworzenia wariantów
- Oszczędność czasu i zmniejszenie ryzyka błędów

## 3. Wymagania funkcjonalne

### 3.1 Generator Mockupów
- Wybór folderu z plikami wejściowymi (obsługa formatów: JPG, PNG, TIFF, GIF, BMP, EPS, SVG, AI, PSD, PDF)
- Wybór folderu z plikami mockup (pliki PSD/PSB)
- Wsparcie dla wielu warstw Smart Object w jednym pliku PSD
- Dynamiczne dodawanie i usuwanie reguł dla poszczególnych warstw
- Konfiguracja parametrów dla każdej warstwy: target (nazwa warstwy), align (wyrównanie), resize (dopasowanie)
- Walidacja danych wejściowych przed generacją skryptu
- Generowanie pliku JSX z konfiguracją
- Automatyczne nazewnictwo plików wyjściowych: `nazwa_input_nazwa_mockup.jpg`

### 3.2 Zmieniacz Nazw Smart Object
- Wybór folderu z plikami PSD
- Definicja nowej nazwy dla warstw Smart Object
- Przetwarzanie tylko plików z dokładnie jedną warstwą Smart Object
- Generowanie skryptu JSX do wsadowej zmiany nazw
- Tworzenie raportu z wynikami operacji (rename_log.txt)

### 3.3 Interfejs użytkownika
- Struktura z zakładkami (Generator Mockupów / Zmieniacz Nazw)
- Podział na logiczne sekcje z przewodnikiem krok po kroku
- Przyciski wyboru folderów z integracją z systemem plików macOS
- Przycisk "Resetuj" do czyszczenia formularza
- Podgląd generowanego kodu JSX (opcjonalnie)
- Komunikaty o sukcesie z przyciskiem "Otwórz folder"

### 3.4 Walidacja i obsługa błędów
- Sprawdzanie istnienia wskazanych ścieżek folderów
- Walidacja wypełnienia wszystkich wymaganych pól
- Informowanie o plikach pominiętych w procesie (brak Smart Object lub za dużo warstw)
- Komunikaty błędów z jasnymi instrukcjami naprawy

## 4. Granice produktu

### 4.1 Funkcjonalności wykluczone z MVP
- Zapisywanie i wczytywanie konfiguracji (planowane na kolejne wersje)
- Edycja plików PSD bezpośrednio w aplikacji
- Integracja z chmurą lub zdalnymi repozytoriami
- Wsparcie dla innych platform niż macOS
- Automatyczne wykrywanie nazw warstw Smart Object z plików PSD

### 4.2 Ograniczenia techniczne
- Aplikacja nie może odczytywać zawartości plików PSD - nazwy warstw muszą być podane ręcznie
- Wymagana obecność silników JSX w predefiniowanych lokalizacjach
- Zmieniacz nazw operuje tylko na plikach z jedną warstwą Smart Object
- Sztywny format nazewnictwa plików wyjściowych (brak elastycznej konfiguracji)

### 4.3 Zależności zewnętrzne
- Adobe Photoshop (dowolna wersja obsługująca skrypty JSX)
- Istniejące pliki silnika JSX (Batch Mockup Smart Object Replacement.jsx i nowy silnik do zmiany nazw)
- System macOS

## 5. Historyjki użytkowników

### US-001: Uruchomienie aplikacji
**Tytuł**: Uruchomienie aplikacji Smart Mockup Creator  
**Opis**: Jako projektant, chcę móc uruchomić aplikację na moim macOS, aby uzyskać dostęp do narzędzi automatyzacji mockupów.  
**Kryteria akceptacji**:
1. Aplikacja uruchamia się w ciągu 3 sekund na systemie macOS
2. Wyświetlany jest główny interfejs z dwiema zakładkami
3. Domyślnie aktywna jest zakładka "Generator Mockupów"
4. Wszystkie elementy interfejsu są prawidłowo wyświetlane

### US-002: Wybór trybu Generator Mockupów
**Tytuł**: Przełączenie na tryb Generator Mockupów  
**Opis**: Jako projektant, chcę móc przełączyć się na tryb Generator Mockupów, aby automatycznie tworzyć warianty mockupów.  
**Kryteria akceptacji**:
1. Kliknięcie zakładki "Generator Mockupów" aktywuje odpowiedni widok
2. Wyświetlane są sekcje: wybór folderów, konfiguracja warstw, opcje generacji
3. Wszystkie pola są puste przy pierwszym uruchomieniu
4. Widoczny jest przycisk "Generuj Skrypt"

### US-003: Wybór folderu z plikami wejściowymi
**Tytuł**: Wybór folderu z grafikami wejściowymi  
**Opis**: Jako projektant, chcę móc wybrać folder zawierający moje pliki graficzne (logo, projekty), aby użyć ich jako materiał wejściowy dla mockupów.  
**Kryteria akceptacji**:
1. Kliknięcie przycisku "Wybierz folder input" otwiera systemowy dialog wyboru folderu
2. Po wyborze, ścieżka folderu jest wyświetlana w polu tekstowym
3. Aplikacja akceptuje foldery zawierające pliki JPG, PNG, TIFF, GIF, BMP, EPS, SVG, AI, PSD, PDF
4. Wyświetlany jest komunikat błędu, jeśli folder nie istnieje lub jest pusty

### US-004: Wybór folderu z plikami mockup
**Tytuł**: Wybór folderu z plikami mockup PSD  
**Opis**: Jako projektant, chcę móc wybrać folder zawierający pliki PSD z mockupami, aby użyć ich jako szablonów do wygenerowania wariantów.  
**Kryteria akceptacji**:
1. Kliknięcie przycisku "Wybierz folder mockup" otwiera systemowy dialog wyboru folderu
2. Po wyborze, ścieżka folderu jest wyświetlana w polu tekstowym
3. Aplikacja akceptuje foldery zawierające pliki PSD i PSB
4. Wyświetlany jest komunikat błędu, jeśli folder nie zawiera plików PSD/PSB

### US-005: Konfiguracja pierwszej warstwy Smart Object
**Tytuł**: Dodanie konfiguracji dla warstwy Smart Object  
**Opis**: Jako projektant, chcę móc skonfigurować parametry dla warstwy Smart Object w moich plikach mockup, aby określić sposób zastąpienia grafiki.  
**Kryteria akceptacji**:
1. Domyślnie wyświetlana jest jedna sekcja konfiguracji warstwy
2. Pole "Target" pozwala na wprowadzenie nazwy warstwy Smart Object
3. Lista rozwijana "Align" zawiera opcje: left top, left center, left bottom, right top, right center, right bottom, center top, center center, center bottom
4. Lista rozwijana "Resize" zawiera opcje: fit, fill, fillX, fillY
5. Wszystkie pola są wymagane do wypełnienia

### US-006: Dodawanie dodatkowych warstw Smart Object
**Tytuł**: Dynamiczne dodawanie konfiguracji dla kolejnych warstw  
**Opis**: Jako projektant, chcę móc dodać konfigurację dla wielu warstw Smart Object w tym samym pliku mockup, aby zastąpić różne elementy różnymi grafikami.  
**Kryteria akceptacji**:
1. Przycisk "+ Dodaj kolejną warstwę" jest widoczny pod ostatnią konfiguracją
2. Kliknięcie przycisku dodaje nową sekcję konfiguracji warstwy
3. Każda nowa sekcja ma identyczne pola jak pierwsza
4. Każda sekcja ma przycisk "Usuń" (poza pierwszą)
5. Maksymalna liczba warstw: 10

### US-007: Usuwanie konfiguracji warstwy
**Tytuł**: Usunięcie konfiguracji warstwy Smart Object  
**Opis**: Jako projektant, chcę móc usunąć niepotrzebną konfigurację warstwy, aby skorygować błędnie dodane reguły.  
**Kryteria akceptacji**:
1. Każda sekcja warstwy (poza pierwszą) ma przycisk "Usuń"
2. Kliknięcie usuwa całą sekcję konfiguracji
3. Numery pozostałych sekcji są automatycznie aktualizowane
4. Pierwsza sekcja nie może być usunięta

### US-008: Walidacja danych przed generacją skryptu
**Tytuł**: Sprawdzenie poprawności danych przed generacją  
**Opis**: Jako projektant, chcę otrzymać informację o błędach w konfiguracji przed próbą wygenerowania skryptu, aby uniknąć tworzenia nieprawidłowych plików.  
**Kryteria akceptacji**:
1. Aplikacja sprawdza czy wszystkie wymagane pola są wypełnione
2. Sprawdzane jest istnienie wskazanych folderów
3. Sprawdzane jest czy foldery zawierają odpowiednie typy plików
4. Komunikaty błędów są wyświetlane nad przyciskiem "Generuj Skrypt"
5. Generacja jest blokowana do czasu usunięcia wszystkich błędów

### US-009: Generowanie skryptu JSX dla mockupów
**Tytuł**: Wygenerowanie pliku JSX z konfiguracją mockupów  
**Opis**: Jako projektant, chcę móc wygenerować plik JSX z moją konfiguracją, aby uruchomić go w Photoshopie i automatycznie stworzyć wszystkie warianty mockupów.  
**Kryteria akceptacji**:
1. Po kliknięciu "Generuj Skrypt" otwiera się dialog zapisu pliku
2. Domyślna nazwa pliku: "mockup_generator_[data].jsx"
3. Wygenerowany plik zawiera prawidłową składnię JSX
4. Plik zawiera wszystkie skonfigurowane parametry
5. Plik zawiera odwołanie do silnika "Batch Mockup Smart Object Replacement.jsx"

### US-010: Potwierdzenie sukcesu generacji skryptu
**Tytuł**: Informacja o pomyślnym wygenerowaniu skryptu  
**Opis**: Jako projektant, chcę otrzymać potwierdzenie pomyślnego wygenerowania skryptu oraz łatwy dostęp do jego lokalizacji.  
**Kryteria akceptacji**:
1. Po zapisaniu pliku wyświetlany jest komunikat "Skrypt został wygenerowany pomyślnie"
2. Widoczny jest przycisk "Otwórz folder"
3. Kliknięcie przycisku otwiera folder z zapisanym plikiem w Finder
4. Komunikat znika po 5 sekundach lub kliknięciu X

### US-011: Przełączenie na tryb Zmieniacz Nazw
**Tytuł**: Aktywacja trybu Zmieniacz Nazw Smart Object  
**Opis**: Jako projektant, chcę móc przełączyć się na tryb Zmieniacz Nazw, aby ujednolicić nazwy warstw Smart Object w moich plikach PSD.  
**Kryteria akceptacji**:
1. Kliknięcie zakładki "Zmieniacz Nazw" aktywuje odpowiedni widok
2. Wyświetlane są pola: wybór folderu PSD, nowa nazwa warstwy
3. Wszystkie pola są puste przy pierwszym uruchomieniu
4. Widoczny jest przycisk "Generuj Skrypt"

### US-012: Wybór folderu z plikami PSD do zmiany nazw
**Tytuł**: Wybór folderu z plikami PSD dla zmiany nazw warstw  
**Opis**: Jako projektant, chcę móc wybrać folder zawierający pliki PSD, w których chcę zmienić nazwy warstw Smart Object.  
**Kryteria akceptacji**:
1. Kliknięcie przycisku "Wybierz folder PSD" otwiera systemowy dialog wyboru folderu
2. Po wyborze, ścieżka folderu jest wyświetlana w polu tekstowym
3. Aplikacja akceptuje foldery zawierające pliki PSD i PSB
4. Wyświetlany jest komunikat błędu, jeśli folder nie zawiera plików PSD/PSB

### US-013: Definicja nowej nazwy warstwy
**Tytuł**: Wprowadzenie nowej nazwy dla warstw Smart Object  
**Opis**: Jako projektant, chcę móc określić nową nazwę, którą mają otrzymać wszystkie warstwy Smart Object w przetwarzanych plikach.  
**Kryteria akceptacji**:
1. Pole tekstowe "Nowa nazwa warstwy" pozwala na wprowadzenie nazwy
2. Nazwa może zawierać litery, cyfry, spacje i podstawowe znaki specjalne
3. Maksymalna długość nazwy: 100 znaków
4. Pole jest wymagane do wypełnienia

### US-014: Generowanie skryptu JSX dla zmiany nazw
**Tytuł**: Wygenerowanie pliku JSX do zmiany nazw warstw  
**Opis**: Jako projektant, chcę móc wygenerować plik JSX, który automatycznie zmieni nazwy warstw Smart Object w moich plikach PSD.  
**Kryteria akceptacji**:
1. Po kliknięciu "Generuj Skrypt" otwiera się dialog zapisu pliku
2. Domyślna nazwa pliku: "rename_smart_objects_[data].jsx"
3. Wygenerowany plik zawiera prawidłową składnię JSX
4. Plik zawiera ścieżkę do folderu PSD i nową nazwę warstwy
5. Plik zawiera logikę do przetwarzania tylko plików z jedną warstwą Smart Object

### US-015: Informacja o raportowaniu w trybie zmiany nazw
**Tytuł**: Wyjaśnienie funkcji raportowania dla użytkownika  
**Opis**: Jako projektant, chcę wiedzieć że otrzymam raport o tym, które pliki zostały przetworzone, aby móc sprawdzić wyniki operacji.  
**Kryteria akceptacji**:
1. Przy generacji skryptu wyświetlana jest informacja o tworzeniu pliku raportu
2. Użytkownik jest informowany że raport będzie zapisany jako "rename_log.txt"
3. Wyjaśnione jest że raport będzie zawierał status dla każdego pliku PSD
4. Informacja jest wyświetlana w komunikacie sukcesu

### US-016: Resetowanie formularza
**Tytuł**: Wyczyszczenie wszystkich pól formularza  
**Opis**: Jako projektant, chcę móc szybko wyczyścić wszystkie wprowadzone dane, aby rozpocząć konfigurację od nowa.  
**Kryteria akceptacji**:
1. Przycisk "Resetuj" jest widoczny w każdym trybie
2. Kliknięcie czyści wszystkie pola tekstowe i wybory folderów
3. W trybie Generator Mockupów pozostaje tylko pierwsza sekcja warstwy
4. Wszystkie dodatkowe sekcje warstw są usuwane
5. Wyświetlane jest potwierdzenie przed wykonaniem resetowania

### US-017: Obsługa błędu braku uprawnień do folderu
**Tytuł**: Informowanie o problemach z dostępem do folderów  
**Opis**: Jako projektant, chcę otrzymać jasny komunikat, gdy aplikacja nie może uzyskać dostępu do wybranego folderu.  
**Kryteria akceptacji**:
1. Aplikacja sprawdza uprawnienia do odczytu wybranych folderów
2. Wyświetlany jest komunikat błędu: "Brak uprawnień do odczytu folderu"
3. Podawana jest instrukcja jak nadać uprawnienia w ustawieniach systemu
4. Generacja skryptu jest blokowana do rozwiązania problemu

### US-018: Obsługa błędu pustych folderów
**Tytuł**: Informowanie o folderach bez odpowiednich plików  
**Opis**: Jako projektant, chcę otrzymać informację, gdy wybrany folder nie zawiera plików odpowiedniego typu.  
**Kryteria akceptacji**:
1. Aplikacja skanuje wybrane foldery pod kątem odpowiednich formatów plików
2. Dla folderu input: komunikat "Folder nie zawiera obsługiwanych plików graficznych"
3. Dla folderu mockup: komunikat "Folder nie zawiera plików PSD/PSB"
4. Lista obsługiwanych formatów jest wyświetlana w komunikacie błędu

### US-019: Zapisywanie ostatnio używanych ścieżek
**Tytuł**: Zapamiętywanie lokalizacji folderów między sesjami  
**Opis**: Jako projektant pracujący regularnie z tymi samymi folderami, chcę aby aplikacja zapamiętała ostatnio używane ścieżki.  
**Kryteria akceptacji**:
1. Aplikacja zapisuje ścieżki do folderów po każdym pomyślnym wyborze
2. Przy następnym uruchomieniu aplikacji ścieżki są przywracane
3. Funkcja działa oddzielnie dla każdego trybu (Generator/Zmieniacz)
4. Ścieżki są przywracane tylko jeśli foldery nadal istnieją

### US-020: Podgląd generowanego kodu JSX
**Tytuł**: Wyświetlenie podglądu kodu przed zapisem  
**Opis**: Jako projektant, chcę móc zobaczyć fragment generowanego kodu JSX, aby upewnić się że konfiguracja jest poprawna.  
**Kryteria akceptacji**:
1. Sekcja "Podgląd kodu" jest widoczna pod konfiguracją (opcjonalnie zwijana)
2. Kod jest aktualizowany na żywo przy zmianach w konfiguracji
3. Wyświetlanych jest pierwszych 20 linii kodu z oznaczeniem "..."
4. Kod jest sformatowany z podświetlaniem składni

### US-021: Obsługa błędów podczas zapisu pliku
**Tytuł**: Informowanie o problemach z zapisem wygenerowanego skryptu  
**Opis**: Jako projektant, chcę otrzymać jasny komunikat, gdy aplikacja nie może zapisać pliku JSX.  
**Kryteria akceptacji**:
1. Aplikacja sprawdza uprawnienia do zapisu w wybranej lokalizacji
2. Wyświetlany jest komunikat błędu z przyczyną (brak uprawnień, brak miejsca, etc.)
3. Użytkownik może wybrać inną lokalizację do zapisu
4. Dialog zapisu pozostaje otwarty do pomyślnego zapisu

### US-022: Walidacja nazwy warstwy Smart Object
**Tytuł**: Sprawdzenie poprawności nazwy warstwy  
**Opis**: Jako projektant, chcę otrzymać informację o nieprawidłowych znakach w nazwie warstwy Smart Object.  
**Kryteria akceptacji**:
1. Aplikacja sprawdza nazwy warstw pod kątem niedozwolonych znaków
2. Komunikat błędu wymienia niedozwolone znaki: / \ : * ? " < > |
3. Podawane są przykłady prawidłowych nazw warstw
4. Walidacja działa w czasie rzeczywistym podczas wpisywania

### US-023: Zamknięcie aplikacji
**Tytuł**: Bezpieczne zamknięcie aplikacji  
**Opis**: Jako projektant, chcę móc bezpiecznie zamknąć aplikację bez utraty niezapisanych danych.  
**Kryteria akceptacji**:
1. Przy próbie zamknięcia aplikacji sprawdzane są niezapisane zmiany
2. Jeśli konfiguracja została zmieniona, wyświetlane jest pytanie o zapisanie
3. Użytkownik może wybrać: "Zapisz i zamknij", "Zamknij bez zapisywania", "Anuluj"
4. Ostatnio używane ścieżki są zapisywane automatycznie

## 6. Plan implementacji

### Faza 1: Architektura i setup (Tydzień 1-2)
- Konfiguracja projektu aplikacji macOS (SwiftUI lub AppKit)
- Implementacja podstawowej struktury z zakładkami
- Stworzenie komponentów UI dla wyboru folderów
- Implementacja systemu walidacji danych wejściowych

### Faza 2: Generator Mockupów - Core (Tydzień 3-4)
- Implementacja wyboru folderów input i mockup
- Budowa dynamicznego systemu konfiguracji warstw Smart Object
- Implementacja formularzy z polami target, align, resize
- Dodanie funkcjonalności dodawania/usuwania sekcji warstw

### Faza 3: Generator Mockupów - Zaawansowane (Tydzień 5)
- Implementacja walidacji danych w czasie rzeczywistym
- Budowa systemu generacji kodu JSX z szablonów
- Implementacja zapisu plików JSX
- Dodanie komunikatów sukcesu i obsługi błędów

### Faza 4: Zmieniacz Nazw Smart Object (Tydzień 6)
- Implementacja wyboru folderu PSD
- Budowa formularza dla nowej nazwy warstwy
- Stworzenie nowego silnika JSX do zmiany nazw
- Implementacja generacji skryptu JSX dla zmiany nazw

### Faza 5: Usprawnienia UX (Tydzień 7)
- Implementacja przycisku "Resetuj"
- Dodanie zapisywania ostatnio używanych ścieżek
- Implementacja podglądu generowanego kodu
- Dodanie przycisków "Otwórz folder"

### Faza 6: Testy i optymalizacja (Tydzień 8)
- Kompleksowe testowanie wszystkich user stories
- Testowanie integracji z silnikami JSX
- Optymalizacja wydajności aplikacji
- Finalne poprawki UI/UX

### Faza 7: Dodatkowe mechanizmy zarządzania pamięcią (Tydzień 9)
- Analiza istniejącego silnika JSX pod kątem optymalizacji pamięci
- Implementacja dodatkowych mechanizmów (np. periodic memory cleanup)
- Dodanie opcji opóźnień między przetwarzaniem plików
- Testowanie z dużymi batchami plików

### Wymagania techniczne:
- Środowisko: Xcode, Swift/SwiftUI
- Docelowy system: macOS 12.0+
- Zależności: FileManager dla operacji na plikach, AppKit dla integracji systemowej
- Testowanie: XCTest dla testów jednostkowych, UI tests dla automatyzacji

### Definicja gotowości (Definition of Done):
- Wszystkie user stories zaimplementowane i przetestowane
- Aplikacja przechodzi wszystkie testy automatyczne
- Generowane skrypty JSX działają poprawnie w Photoshopie
- Dokumentacja użytkownika jest kompletna
- Aplikacja jest zoptymalizowana pod kątem wydajności
