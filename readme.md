# Smart Mockup Creator - Instrukcja Uruchomienia

## Wymagania wstępne

- **macOS**: Wersja 12.0 lub nowsza
- **Xcode**: Wersja 14.0 lub nowsza (dostępny w Mac App Store)

## Kroki do uruchomienia aplikacji

### 1. Otwórz projekt w Xcode

1.  Znajdź folder projektu `SmartMockupCreator` w głównym katalogu.
2.  Kliknij dwukrotnie plik `SmartMockupCreator.xcodeproj`, aby otworzyć go w Xcode.

    ```bash
    /path/to/your/project/SmartMockupCreator/SmartMockupCreator.xcodeproj
    ```

### 2. Zbuduj i uruchom aplikację

1.  Po otwarciu projektu w Xcode, upewnij się, że w lewym górnym rogu paska narzędzi wybrany jest target **SmartMockupCreator** oraz urządzenie **My Mac**.

    ![Xcode Toolbar](https://i.imgur.com/8J3d6r2.png) 

2.  Naciśnij przycisk **"Play"** (trójkąt) w lewym górnym rogu lub użyj skrótu klawiszowego **⌘R** (Command + R).

    ![Xcode Play Button](https://i.imgur.com/L4f4F7j.png)

3.  Xcode automatycznie zbuduje projekt i uruchomi aplikację na Twoim Macu.

### 3. Używanie aplikacji

Po pomyślnym uruchomieniu, aplikacja Smart Mockup Creator pojawi się na ekranie. Możesz teraz zacząć korzystać z obu modułów:

- **Generator Mockupów**: Do tworzenia wariantów mockupów.
- **Zmieniacz Nazw**: Do przygotowywania plików PSD.

## Rozwiązywanie problemów

- **Problem z Xcode:** Jeśli pojawi się błąd "xcode-select: error: tool 'xcodebuild' requires Xcode", upewnij się, że masz zainstalowane pełne Xcode (nie tylko Command Line Tools) i że ścieżka jest poprawnie ustawiona. Możesz to zrobić poleceniem w terminalu:
  ```bash
  sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
  ```
- **Problem z uprawnieniami:** Przy pierwszym wyborze folderu, macOS może poprosić o nadanie aplikacji uprawnień do dostępu do plików. Należy na to zezwolić, aby aplikacja mogła poprawnie odczytywać i zapisywać pliki.
