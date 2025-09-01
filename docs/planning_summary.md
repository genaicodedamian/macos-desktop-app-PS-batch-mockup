<conversation_summary>
<decisions>
1.  **Dwie Główne Funkcjonalności**: Aplikacja będzie posiadać dwa odrębne tryby pracy: "Generator Mockupów" i "Zmieniacz Nazw Smart Object".
2.  **Interfejs Użytkownika**: Nawigacja między dwoma głównymi trybami będzie realizowana za pomocą zakładek (tabs).
3.  **Generator Mockupów - Zakres**: Funkcjonalność będzie wspierać przetwarzanie wsadowe dla wielu plików mockup (poprzez wskazanie folderu) oraz obsługę wielu warstw Smart Object w ramach jednego pliku `.psd`. Użytkownik będzie mógł dynamicznie dodawać kolejne reguły dla kolejnych warstw.
4.  **Generator Mockupów - Parametry MVP**: Dla każdej warstwy Smart Object w MVP dostępne będą cztery kluczowe opcje: `target` (nazwa warstwy), `input` (folder z grafikami), `align` (wyrównanie) i `resize` (dopasowanie).
5.  **Nazewnictwo Plików Wyjściowych**: Format nazwy pliku wyjściowego jest sztywno zdefiniowany jako konkatenacja nazwy pliku wejściowego i nazwy pliku mockup, rozdzielona znakiem podkreślenia (`nazwa_input_nazwa_mockupu.jpg`). Aplikacja nie będzie udostępniać użytkownikowi elastycznej opcji `output.filename`.
6.  **Zmieniacz Nazw - Logika**: Funkcjonalność będzie operować wyłącznie na plikach `.psd` zawierających dokładnie jeden Smart Object. Użytkownik samodzielnie zdefiniuje nową, docelową nazwę dla tej warstwy.
7.  **Obsługa Błędów i Raportowanie**: Aplikacja musi generować raport dla użytkownika, informujący o plikach, które zostały pominięte w procesie zmiany nazwy z powodu zerowej lub większej niż jeden liczby warstw Smart Object.
8.  **Silnik Skryptu**: Aplikacja będzie zakładać, że pliki `.jsx` stanowiące "silnik" (dla generowania mockupów i dla zmiany nazw) znajdują się w stałej, predefiniowanej lokalizacji i nie wymaga od użytkownika ich wskazywania.
9.  **Doświadczenie Użytkownika po Generacji**: Po pomyślnym wygenerowaniu pliku `.jsx`, aplikacja wyświetli komunikat o sukcesie oraz udostępni przycisk "Otwórz folder", przenoszący do lokalizacji zapisanego skryptu.
10. **Priorytety MVP**: Obie funkcjonalności (Generator i Zmieniacz Nazw) są kluczowe i muszą znaleźć się w wersji MVP. Zapisywanie/wczytywanie konfiguracji nie jest pilne.
</decisions>

<matched_recommendations>
1.  **Separacja Logiki**: Zostaną stworzone dwa oddzielne pliki "silnika" `.jsx`: jeden istniejący dla generowania mockupów i jeden nowy, dedykowany do zmiany nazw, co uprości kod i utrzymanie.
2.  **Struktura UI**: Interfejs aplikacji zostanie logicznie podzielony na sekcje z nagłówkami (np. "Krok 1: Wybierz Ścieżki", "Krok 2: Ustaw Opcje"), aby prowadzić użytkownika przez proces.
3.  **Walidacja Danych Wejściowych**: Aplikacja będzie przeprowadzać walidację "po stronie klienta" przed generacją skryptu, sprawdzając m.in. czy wskazane ścieżki do folderów istnieją, aby zapobiegać tworzeniu błędnych skryptów.
4.  **Zarządzanie Pamięcią**: Potwierdzono, że istniejący skrypt do generowania mockupów już zawiera mechanizm zamykania plików po przetworzeniu, co jest kluczowe dla wydajności przy dużych batchach.
5.  **Raportowanie w Logu**: Funkcja zmiany nazw będzie generować plik `log.txt`, w którym znajdzie się status operacji dla każdego przetwarzanego pliku `.psd`.
6.  **Komfort Użytkownika**: Aplikacja będzie posiadać przycisk "Resetuj" do szybkiego czyszczenia formularza. Dodatkowo, zapisywanie ostatnio używanych ścieżek folderów między sesjami jest rekomendowane jako usprawnienie.
7.  **Szablon Kodu**: Generowanie kodu `.jsx` będzie oparte o wewnętrzny szablon, w którym aplikacja będzie jedynie uzupełniać puste pola danymi od użytkownika, co ułatwi zarządzanie kodem.
</matched_recommendations>

<prd_planning_summary>
### Główne wymagania funkcjonalne produktu

Produkt to natywna aplikacja desktopowa na macOS, która rozwiązuje problem czasochłonnego, ręcznego tworzenia mockupów w Photoshopie. Aplikacja generuje skrypty `.jsx` automatyzujące ten proces. MVP będzie składać się z dwóch głównych modułów dostępnych w zakładkach:

1.  **Generator Mockupów**:
    *   **Cel**: Automatyczne generowanie dużej liczby wariantów mockupów na podstawie zestawu grafik wejściowych i plików `.psd`.
    *   **Wejścia**: Użytkownik wskazuje folder z plikami wejściowymi (np. `.jpg`, `.png`) oraz folder z plikami mockup (`.psd`).
    *   **Konfiguracja**: Umożliwia zdefiniowanie reguł dla wielu warstw Smart Object. Dla każdej reguły użytkownik podaje nazwę warstwy (`target`) i konfiguruje opcje dopasowania (`align`, `resize`).
    *   **Wyjście**: Wygenerowany plik `.jsx`, który po uruchomieniu w Photoshopie tworzy pliki `.jpg` w folderze wyjściowym, z nazwami w formacie `[nazwa_pliku_input]_[nazwa_pliku_mockup].jpg`.

2.  **Zmieniacz Nazw Smart Object**:
    *   **Cel**: Przygotowanie plików `.psd` do użycia w Generatorze poprzez wsadową zmianę nazwy warstwy Smart Object.
    *   **Wejścia**: Użytkownik wskazuje folder z plikami `.psd` oraz podaje nową, docelową nazwę dla warstwy.
    *   **Logika**: Skrypt przetwarza tylko te pliki `.psd`, które zawierają dokładnie jedną warstwę Smart Object.
    *   **Wyjście**: Wygenerowany plik `.jsx` do uruchomienia w Photoshopie oraz plik `rename_log.txt` z raportem o statusie operacji dla każdego pliku.

### Kluczowe historie użytkownika i ścieżki korzystania

*   **Historia 1 (Generator Mockupów)**: "Jako projektant, chcę móc wybrać folder z moimi projektami logo oraz folder z różnymi mockupami (kubki, koszulki, billboardy), aby automatycznie wygenerować wszystkie możliwe kombinacje jako pliki JPG, oszczędzając w ten sposób godziny ręcznej pracy."
*   **Ścieżka 1**: Użytkownik otwiera aplikację -> przechodzi do zakładki "Generator Mockupów" -> klika "Wybierz folder" dla plików wejściowych -> wybiera folder z logo -> klika "Wybierz folder" dla plików mockup -> wybiera folder z plikami `.psd` -> wprowadza nazwę warstwy Smart Object "Twoje Logo Tutaj" -> klika "Generuj Skrypt" -> zapisuje plik `settings.jsx` -> uruchamia go w Photoshopie.

*   **Historia 2 (Zmieniacz Nazw)**: "Jako projektant, chcę móc szybko ujednolicić nazwę warstwy Smart Object we wszystkich moich plikach mockup do 'Design', aby przygotować je do użycia w skrypcie do generowania mockupów."
*   **Ścieżka 2**: Użytkownik otwiera aplikację -> przechodzi do zakładki "Zmieniacz Nazw" -> wybiera folder z plikami `.psd` -> wpisuje w polu tekstowym nową nazwę "Design" -> klika "Generuj Skrypt" -> uruchamia go w Photoshopie -> sprawdza plik `log.txt`, aby zobaczyć, które pliki zostały przetworzone.

### Ważne kryteria sukcesu i sposoby ich mierzenia

*   **Główne kryterium**: **Poprawność i niezawodność generowanego skryptu.** Miarą sukcesu jest 100% poprawnie wygenerowanych plików `.jsx`, które wykonują się w Photoshopie bez błędów i tworzą oczekiwany rezultat.
*   **Drugorzędne kryterium**: **Prostota i szybkość użytkowania.** Miarą będzie subiektywna ocena użytkowników oraz mierzalny czas potrzebny na skonfigurowanie i wygenerowanie skryptu w porównaniu do czasu potrzebnego na ręczne wykonanie tej samej pracy.

</prd_planning_summary>

<unresolved_issues>
1.  **Dodatkowe Zarządzanie Pamięcią**: Użytkownik wyraził prośbę o "dodatkowy mechanizm, by jeszcze lepiej zarządzać pamięcią", mimo że skrypt już zawiera podstawową optymalizację (zamykanie plików). Należy doprecyzować, jakie konkretne problemy z pamięcią występowały w przeszłości i jakie dodatkowe mechanizmy (np. okresowe czyszczenie pamięci podręcznej Photoshopa, wstawianie opóźnień) mogłyby zostać zaimplementowane w skrypcie `.jsx`.
</unresolved_issues>
</conversation_summary>
