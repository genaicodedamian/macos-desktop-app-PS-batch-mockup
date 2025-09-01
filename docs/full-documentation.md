# Batch Mockup Smart Object Replacement - Dokumentacja

## 1. Szybki start

### 1.1. Utwórz `Batch Mockup Smart Object Replacement.jsx`

Skorzystaj z dostarczonego kodu do stworzenia tego pliku.

### 1.2. Utwórz `settings-script.jsx`

Utwórz nowy, pusty plik o nazwie `settings-script.jsx` i umieść w nim poniższy szablon. Ten plik inicjuje proces wsadowy i przekazuje ustawienia do głównego skryptu "silnika".

Upewnij się, że dyrektywa `#include` w pierwszej linii wskazuje na plik skryptu silnika. Domyślnie szablon szuka tego pliku obok skryptu ustawień. Będziesz musiał również dostosować ustawienia `mockupPath`, `target` i `input`. Aby uzyskać unikalną nazwę warstwy obiektu inteligentnego, musisz otworzyć plik makiety, znaleźć docelową warstwę i ewentualnie zmienić jej nazwę, aby była unikalna.

Prefix `$` we wszystkich przykładowych ścieżkach wskazuje na folder nadrzędny samego pliku skryptu ustawień. Istnieje jeszcze jeden prefiks ścieżki, który wskazuje na plik psd makiety. Możesz również używać ścieżek bezwzględnych, ale nie jest to zalecane. Więcej o ścieżkach plików przeczytasz w sekcji [Ścieżki plików i prefiksy](#4-ścieżki-plików-i-prefiksy).

```javascript
// settings-script.jsx
#include "Batch Mockup Smart Object Replacement.jsx"

var outputOpts = {
  path: '$/_output',
};

mockups([
  {
    output: outputOpts,
    mockupPath: '$/Mockup/file.psd',
    smartObjects: [
      {
        target: 'smart object layer name (should be unique)', 
        input: '$/Input',
      },
      // {..},  przecinkami oddzielaj kolejne obiekty inteligentne 
    ],
  },
  // {..},  przecinkami oddzielaj kolejne makiety 
]);
```

### 1.3. Przykładowa struktura folderu projektu

```
- Batch process - settings script.jsx
- Batch Mockup Smart Object Replacement.jsx
- Mockup/
    - file.psd
- Input/
    - image-1.jpg
    - image-2.jpg
    - image-3.jpg
    - image-4.jpg
```

**Uwaga:** Wystarczy utworzyć zwykły plik tekstowy z rozszerzeniem `.jsx`. `smartObjects[].input` może być również tablicą.

Sprawdź przykłady w repozytorium projektu. Przykłady są gotowe do uruchomienia, ale warto usunąć foldery wyjściowe przed uruchomieniem skryptów, aby zobaczyć, co robią.

## 2. Anatomia skryptu ustawień

Skrypt ustawień to plik, który rozpoczyna proces wsadowy.

*   Jeśli chcesz przetworzyć wiele **makiet**, po prostu zduplikuj obiekt makiety tyle razy, ile potrzebujesz, a następnie dostosuj opcje dla każdej makiety.
*   Jeśli którykolwiek z twoich plików makiety ma wiele wymienialnych warstw **obiektów inteligentnych**, po prostu zduplikuj obiekt `smartObject` tyle razy, ile potrzebujesz, a następnie dostosuj opcje dla każdej warstwy obiektu inteligentnego.

## 3. Przykłady konfiguracji

### 3.1. Minimalna konfiguracja

Jedna makieta PSD i jeden obiekt inteligentny.

```javascript
#include "Batch Mockup Smart Object Replacement.jsx"

var outputOpts = {
  path: '$/_output',
};

mockups([
  {
    output: outputOpts,
    mockupPath: '$/mockup/file.psd',
    smartObjects: [
      {
        target: 'smart object layer name',
        input: '$/input',
      },
    ],
  },
]);
```

### 3.2. Użycie wielu obiektów inteligentnych

Niektóre makiety mają wiele obiektów inteligentnych, które można targetować w następujący sposób:

```javascript
#include "Batch Mockup Smart Object Replacement.jsx"

var outputOpts = {
  path: '$/_output',
};

mockups([
  {
    output: outputOpts,
    mockupPath: '$/mockup/file1.psd',
    smartObjects: [
      // SMART OBJECT #1
      {
        target: '@iphone',
        input: '$/input/iphone',
      },
      // SMART OBJECT #2
      {
        target: '@macbook',
        input: '$/input/macbook',
      },
      // SMART OBJECT #3
      {
        target: '@imac',
        input: '$/input/imac',
      },
      // SMART OBJECT #4
      {
        target: '@ipad',
        input: '$/input/ipad',
      },
    ],
  },
]);
```

### 3.3. Użycie wielu makiet

Po prostu skopiuj poprzedni blok obiektu makiety i zmień ścieżki:

```javascript
#include "Batch Mockup Smart Object Replacement.jsx"

var outputOpts = {
  path: '$/_output',
};

mockups([
  // MOCKUP #1
  {
    output: outputOpts,
    mockupPath: '$/mockup/file1.psd',
    smartObjects: [
      {
        target: 'smart object layer name',
        input: '$/input',
      },
    ],
  },
  
  // MOCKUP #2
  {
    output: outputOpts,
    mockupPath: '$/mockup/file2.psd',
    smartObjects: [
      {
        target: 'smart object layer name 1',
        input: '$/input',
      },
      {
        target: 'smart object layer name 2',
        input: [
          '$/input-1',
          '$/input-2',
        ],
      },
    ],
  },
  
  // MOCKUP #3
  {
    output: outputOpts,
    mockupPath: '$/mockup/file3.psd',
    smartObjects: [
      {
        target: 'smart object layer name',
        input: '$/input',
      },
    ],
  },
]);
```

### 3.4. Wiele folderów wejściowych (tablica `input`)

`smartObjects[].input` może być ciągiem znaków ze ścieżką do jednego folderu wejściowego lub tablicą z wieloma ścieżkami.

W niektórych przypadkach można uniknąć przekazywania skryptowi tablicy ścieżek wejściowych, używając ustawienia `smartObjects[].inputNested`, które sprawia, że skrypt przeszukuje każdy zagnieżdżony folder wewnątrz (każdego) folderu wejściowego.

```javascript
#include "Batch Mockup Smart Object Replacement.jsx"

var outputOpts = {
  path: '$/_output',
};

mockups([
  // MOCKUP #1
  {
    output: outputOpts,
    mockupPath: '$/mockup/file.psd',
    smartObjects: [
      // SMART OBJECT #1
      {
        target: 'smart object layer name',
        input: '$/input-1',
      },
      // SMART OBJECT #2
      {
        target: 'smart object layer name',
        input: [
          '$/input-1',
          '$/input-2',
          '$/input-3',
        ],
      },
    ],
  },
  // MOCKUP #2
  {
    output: outputOpts,
    mockupPath: '$/mockup/file.psd',
    smartObjects: [
      // SMART OBJECT #1
      {
        target: 'smart object layer name',
        input: '$/input-1',
      },
      // SMART OBJECT #2
      {
        target: 'smart object layer name',
        input: [
          '$/input-1',
          '$/input-2',
          '$/input-3',
          '$/input-4',
          '$/input-5',
          '$/input-6',
        ],
      },
    ],
  },
]);
```

## 4. Ścieżki plików i prefiksy

Ścieżki bezwzględne mogą być używane z dowolną ścieżką, ale nie jest to zalecane, ponieważ mogą one w końcu przestać działać. Jeśli masz samodzielny folder projektu ze ścieżkami względnymi, możesz przenieść folder lub wysłać go komuś bez konieczności ponownego konfigurowania ścieżek.

*   **Prefix skryptu ustawień (`$`)** może być użyty z: `output.path`, `mockupPath` i `input`.
*   **Prefix pliku makiety (`.`)** może być użyty z: `output.path` i `input`.

Oba te prefiksy obsługują przechodzenie w górę w strukturze folderów.

**Przykład (`~/Desktop/example/settings-script.jsx`):**

```javascript
// Skrypt silnika
#include "Batch Mockup Smart Object Replacement.jsx" 
// Wskazuje na "~/Desktop/example/Batch Mockup Smart Object Replacement.jsx"

#include "../Batch Mockup Smart Object Replacement.jsx"
// Wskazuje na "~/Desktop/Batch Mockup Smart Object Replacement.jsx"

// ---

// Względne do skryptu ustawień
mockupPath: "$/assets/mockup.psd",
// Wskazuje na "~Desktop/example/assets/mockup.psd",

mockupPath: "../$/assets/mockup.psd",
// Wskazuje na "~Desktop/assets/mockup.psd",

// ---

// Względne do makiety PSD
// Zakładając, że plik PSD również znajduje się w folderze assets
input: "./input files",
// Wskazuje na "~Desktop/example/assets/input files",

input: ".././input files",
// Wskazuje na "~Desktop/example/input files",
```

## 5. Wszystkie opcje konfiguracji

Poniżej znajduje się skrypt ustawień ze wszystkimi dostępnymi opcjami i ich wartościami domyślnymi.

```javascript
#include "Batch Mockup Smart Object Replacement.jsx"

mockups([
  {
    output: {
      path: '$/_output',
      format: 'jpg',
      zeroPadding: true,
      folders: false,
      filename: '@mockup - $',
    },
    mockupPath: '', 
    mockupNested: false, // Jeśli powyższa ścieżka prowadzi do folderu
    input: '',    // Jeśli ustawione, nadpisuje smartObjects[].input, inputNested i inputFormats. Każdy obiekt inteligentny pobiera stąd pliki sekwencyjnie.
    inputNested: false, 
    inputFormats: 'tiff?|gif|jpe?g|bmp|eps|svg|png|ai|psd|pdf',
    hideLayers: [],
    showLayers: [],
    noRepeats: false,
    smartObjects: [
      {
        target: '',
        nestedTarget: '',
        input: '',
        inputNested: false,
        inputFormats: 'tiff?|gif|jpe?g|bmp|eps|svg|png|ai|psd|pdf',
        align: 'center center',
        resize: 'fill',
        trimTransparency: true,
        inputPlaced_runScript: '',
        inputPlaced_runAction: [],
      },
    ]
  },
]);
```

---

### Opis opcji

#### `output.path`
Ścieżka wyjściowa jest tworzona automatycznie. Akceptowane prefiksy: `.` i `$`. Można użyć `../` z prefiksami, aby przejść w górę w strukturze folderów.

#### `output.format`
Formaty: `jpg`, `png`, `tif`, `psd`, `pdf`

#### `output.zeroPadding`
Dopełnienie zerami jest oparte na liczbie obrazów wyjściowych.

#### `output.folders`
Każda makieta generuje wyniki w podfolderze wewnątrz ścieżki wyjściowej.

#### `output.filename`
Słowa kluczowe: `@mockup` = nazwa pliku makiety, `@input` = nazwa pliku wejściowego. Przy wielu docelowych obiektach inteligentnych jako źródło używany jest ten z największą liczbą plików wejściowych. `$` = liczby przyrostowe. Możesz dostosować ten ciąg, np.: `"My mockups - @mockup - @input - $"`. Uważaj na zduplikowane nazwy plików.

#### `mockupPath`
Ścieżka do makiety psd. Akceptowany prefiks: `$`. Jeśli ta ścieżka wskazuje na folder, a nie na plik PSD lub PSB, przetworzy wszystkie znalezione pliki makiet z tymi samymi ustawieniami.

#### `mockupNested`
Jeśli `mockupPath` wskazuje na folder, ta opcja sprawia, że skrypt szuka plików PSD i PSB we wszystkich zagnieżdżonych folderach.

#### `input`
Ta opcja nadpisuje ustawienie `input` w każdym obiekcie inteligentnym i zamiast tego sekwencyjnie dystrybuuje pliki wejściowe do obiektów inteligentnych.

#### `inputNested`
Normalnie skrypt szuka plików tylko w folderach wejściowych, ale z włączoną tą opcją będzie szukał plików obrazów we wszystkich podfolderach.

#### `inputFormats`
Oddzielaj formaty pionową kreską (`|`). Zazwyczaj nie trzeba tego zmieniać.

#### `hideLayers`
Tablica ciągów znaków z unikalnymi nazwami warstw. Te warstwy są ukrywane przed dokonaniem jakichkolwiek zamian w makiecie.

#### `showLayers`
Tablica ciągów znaków z unikalnymi nazwami warstw. Te warstwy są pokazywane przed dokonaniem jakichkolwiek zamian w makiecie. Docelowy obiekt inteligentny jest zawsze widoczny.

#### `noRepeats`
Jeśli makieta ma wiele docelowych obiektów inteligentnych, skrypt zapewnia, że każdy z nich używa tej samej liczby plików wejściowych, powtarzając istniejące pliki wejściowe tyle razy, ile jest to konieczne. Więcej informacji w sekcji [`noRepeats`](#6-opcja-norepeats).

#### `smartObjects`
Tablica obiektów. Każdy obiekt reprezentuje jeden docelowy obiekt inteligentny w makiecie.

#### `smartObjects[].target`
Unikalna nazwa warstwy obiektu inteligentnego.

#### `smartObjects[].nestedTarget`
Używane do dokładniejszego pozycjonowania pliku wejściowego wewnątrz docelowego obiektu inteligentnego, który ma dużo białego miejsca wokół.

#### `smartObjects[].input`
Ścieżka do folderu z plikami wejściowymi. Użyj tablicy ciągów znaków, aby ustawić wiele ścieżek, np.: `["$/input-files/one/", "$/input-files/two/"]`. Akceptowane prefiksy: `$` i `.`.

#### `smartObjects[].inputNested`
Normalnie skrypt szuka plików tylko w folderach wejściowych, ale z włączoną tą opcją będzie szukał plików obrazów we wszystkich podfolderach.

#### `smartObjects[].inputFormats`
Oddzielaj formaty pionową kreską (`|`).

#### `smartObjects[].align`
Logika: `'x y'`. Wartości: `'left top'`, `'left center'`, `'left bottom'`, `'right top'`, `'right center'`, `'right bottom'`, `'center top'`, `'center center'`, `'center bottom'`

#### `smartObjects[].resize`
Wartości: `false`, `'fill'`, `'fit'`, `'xFill'`, `'yFill'`

#### `smartObjects[].trimTransparency`
Ustaw na `false`, jeśli chcesz, aby zmiana rozmiaru uwzględniała przezroczyste białe miejsce.

#### `smartObjects[].inputPlaced_runScript`
Uruchom skrypt za każdym razem, gdy plik wejściowy zostanie umieszczony (wciąż wewnątrz obiektu inteligentnego). Możesz użyć prefiksu skryptu: `$/Input placed script.jsx`

#### `smartObjects[].inputPlaced_runAction`
`['nazwa folderu', 'nazwa akcji']` → `['Default Actions', 'Gradient Map']`

---

### Zalecany minimalny skrypt ustawień

Zaleca się używanie tego jako punktu wyjścia. Pełną listę opcji traktuj jako odniesienie. Łatwiej jest zarządzać skryptem ustawień, jeśli zawiera tylko to, czego potrzebujesz.

```javascript
#include "Batch Mockup Smart Object Replacement.jsx"

var outputOpts = {
  path: '$/_output',
};

mockups([
  {
    output: outputOpts,
    mockupPath: '$/mockup/file.psd',
    smartObjects: [
      {
        target: 'smart object layer name',
        input: '$/input',
      },
    ]
  },
]);
```

## 6. Opcja `noRepeats`

Jeśli makieta ma wiele docelowych obiektów inteligentnych, skrypt domyślnie powtarza pliki wejściowe, aby zapewnić, że wszystkie obiekty w makiecie mają tę samą liczbę plików. Celem tego zachowania jest to, aby każdy obraz wyjściowy coś zawierał, zamiast kończyć z pustymi obiektami inteligentnymi.

### `noRepeats: false` (domyślnie)
W tym przypadku `@black-mug` ma 4 pliki wejściowe, a `@white-mug` ma 2. Loga w białym kubku zaczynają się powtarzać po drugim obrazie wyjściowym.

### `noRepeats: true`
Warstwa `@white-mug` jest ukrywana po drugim obrazie wyjściowym. Jeśli używasz `noRepeats: true`, musisz upewnić się, że każdy docelowy obiekt inteligentny ma taką samą liczbę plików wejściowych, lub pogodzić się z faktem, że niektóre pliki wyjściowe będą miały obiekty bez grafik.

### Wizualizacja przykładu

Kolumny `@phone`, `@tablet`, `@laptop` reprezentują docelowy obiekt inteligentny w jednym pliku makiety, a każdy wiersz pokazuje, które pliki wejściowe trafiają do którego pliku wyjściowego.

#### `noRepeats: true`
Brakujące pliki wejściowe są oznaczone 🚫. Gdy skrypt zacznie pracę nad `mockup 3.jpg`, obiekt `@tablet` zostanie ukryty, ponieważ zabrakło mu plików wejściowych. To samo stanie się z obiektem `@laptop` przy `mockup 5.jpg`.

| output (mockup.psd) | @phone | @tablet | @laptop |
| :--- | :--- | :--- | :--- |
| **mockup 1.jpg** | 1.jpg | 1.jpg | 1.jpg |
| **mockup 2.jpg** | 2.jpg | 2.jpg | 2.jpg |
| **mockup 3.jpg** | 3.jpg | 🚫 | 3.jpg |
| **mockup 4.jpg** | 4.jpg | 🚫 | 4.jpg |
| **mockup 5.jpg** | 5.jpg | 🚫 | 🚫 |
| **mockup 6.jpg** | 6.jpg | 🚫 | 🚫 |
| **mockup 7.jpg** | 7.jpg | 🚫 | 🚫 |


#### `noRepeats: false` (domyślnie)
Pliki wejściowe, które będą się powtarzać w wielu plikach wyjściowych, są oznaczone ‼️.

| output (mockup.psd) | @phone | @tablet | @laptop |
| :--- | :--- | :--- | :--- |
| **mockup 1.jpg** | 1.jpg | 1.jpg | 1.jpg |
| **mockup 2.jpg** | 2.jpg | 2.jpg | 2.jpg |
| **mockup 3.jpg** | 3.jpg | 1.jpg ‼️ | 3.jpg |
| **mockup 4.jpg** | 4.jpg | 2.jpg ‼️ | 4.jpg |
| **mockup 5.jpg** | 5.jpg | 1.jpg ‼️ | 1.jpg ‼️ |
| **mockup 6.jpg** | 6.jpg | 2.jpg ‼️ | 2.jpg ‼️ |
| **mockup 7.jpg** | 7.jpg | 1.jpg ‼️ | 3.jpg ‼️ |

## 7. Rozwiązywanie problemów

### 1. Sortowanie
Pliki wejściowe są sortowane alfanumerycznie. Aby upewnić się, że pliki wyjściowe mają określoną kolejność, dodaj numery w nazwach plików.

### 2. Różna liczba obrazów wejściowych
Jeśli masz więcej niż jeden docelowy obiekt inteligentny na plik makiety, skrypt powtórzy pliki wejściowe, aby dopasować się do obiektu z największą liczbą plików. Możesz wyłączyć to zachowanie za pomocą ustawienia `noRepeats`.

### 3. Obiekty inteligentne z przezroczystym białym tłem
Czasami makiety mają dużo białego miejsca w obiekcie inteligentnym otaczającym grafikę zastępczą.

#### Szybka metoda
1.  W makiety psd, otwórz docelowy obiekt inteligentny, klikając dwukrotnie miniaturę warstwy.
2.  Przekonwertuj grafikę zastępczą na obiekt inteligentny (Prawy przycisk myszy -> Konwertuj na obiekt inteligentny).
3.  Zapisz i zamknij obiekt inteligentny, a następnie zapisz i zamknij makietę psd.
4.  Użyj nazwy tej warstwy w skrypcie ustawień jako `nestedTarget`.
5.  Prawdopodobnie będziesz chciał również użyć ustawienia `resize: 'fit'`.

W ten sposób skrypt zamieni zawartość zagnieżdżonego celu, a wszystkie pliki wejściowe zostaną dopasowane do granic zagnieżdżonego obiektu inteligentnego.

#### Dokładna metoda
Ta metoda jest wolniejsza, ponieważ musisz upewnić się, że każdy plik wejściowy ma określony rozmiar.
1.  Upewnij się, że wszystkie obrazy wejściowe mają dokładnie taki sam rozmiar jak dokument obiektu inteligentnego.
2.  Dodaj ustawienia `trimTransparency: false` z `resize: false`.

Zaleca się używanie obiektu inteligentnego jako szablonu dla plików wejściowych.

### 4. Okna dialogowe przerywające proces wsadowy
Mogą pojawić się 3 typy okien dialogowych, które mogą przerwać proces. Wszystkie powinny mieć pole wyboru `Don't show again`, które zaleca się zaznaczyć.

### 5. Ostatni plik wejściowy pozostaje w wyniku przy użyciu `noRepeats: true`
Czasami w dokumencie znajduje się zduplikowany obiekt inteligentny. Gdy skryptowi skończą się obrazy wejściowe, docelowy obiekt inteligentny jest ukrywany, ale jego duplikat pozostaje. Najprostszym rozwiązaniem jest zmiana celu na ten zduplikowany obiekt inteligentny.