# Skrypty do Killer MUDa.

![Screenshot](https://github.com/KillerMUD-pl/MudletScripts/blob/master/screenshot.png?raw=true)

Aktualnie posiadana funkcjonalność:
#### Mapa
- Automatyczne podążanie za graczem.
- Wyświetlanie skróconych imion graczy z grupy na mapie, oraz znaczki oznaczające jego charmy.
- Speedwalk

Komendy:
- `+map` - włącza mapę
- `-map` - wyłącza mapę
- `+poi` - pokazuje listę zapisanych lokacji
- `+poi <nazwa>` - dodaje lokację w któ®ej stoisz do listy zapisanych lokacji
- `+walk <nazwa>` - idzie do zapisanej lokacji
- `+walk` - rozpoczyna podróż do lokacji po dwukliku na room na mapie. Jeżeli już masz wyznaczoną trasę, i naprzykład na chwilę usiadłeś, komenda `+walk` wznawia podróż.

Dodatkowe informacje:
- Dwuklik na room na mapie powoduje wyznaczenie trasy do tego miejsca.
- Jeśli przypadkiem popsujesz obrazki tła mapy, po prostu zrestartuj Mudleta, a obrazki się przerysują
- Jeśli przypadkiem popsujesz same roomy na mapie, możesz wydać komendę `+map reload` by przywrócić oryginalną wersję. UWAGA - to nadpisuje wszelkie Twoje zmiany

#### Panel gracza
- Imię, płeć i poziom gracza.
- Najważniejsze informacje z `condition`.
- Wszystkie affekty.

Komendy:
- `+info` - włącza panel info
- `-info` - wyłącza panel info
- `+info color` - pokazuje schemat kolorowania afektów
- `+info color <nazwa afektu>` - ustawia kolor afektu

#### Panel grupy
- Nazwa gracza/charma
- HP i MV gracza/charma w formie uśrednionej, tak jak w komendzie `group`)
- pozycja gracza/charma oraz ilośc jego memów

Komendy:
- `+group` - włącza panel grupy
- `-group` - wyłącza panel grupy

#### Inne
- `+reset` - resetuje wszystkie ustawienia, oprócz zapisanych punktów POI. Przydatne jeśli coś się popsuje z ustawieniem okienek itp.

## Instalacja

**UWAGA! wymagana wersja Mudleta to 4.12+**

Ściągnij plik [kinstall.zip](https://github.com/KillerMUD-pl/MudletScripts/raw/master/dist/kinstall.zip) i przeciągnij go na okno Mudleta.

# Instrukcja używania "mappera"
### Czyli instrukcji do edycji mapy.

**Jeśli zrobiłeś jakieś zmiany na mapie którymi chcesz się podzielić, podeślij je do mnie na Slacku albo Discordzie, to wrzucę je tutaj i wszyscy dostaną je w następnej aktualizacji.**

Komendy mappera:

#### +map start

Włącza śledzenie ruchu i zaczyna rysować po mapie, oczywiście tylko jeśli jest coś nowego.
Jak jesteś w tym trybie, może tylko się poruszać plus możesz wykonać tylko te komendy:
- look
- open
- close
- say
- tell
- reply
- imm
- map
- who

plus parę podstawowych komend immowskich

#### +map stop

Wyłącza śledzenie ruchu i rysowanie

#### +map step <cyfra>
  
Ustawia o jaką odległośc (1, 2, 3 itd) tratek mają być oddalone nowo rysowane roomy na mapie, domyślnie 2

#### +map area

Dodaje nową krainkę do listy map, czyli tworzy nową mapę któ®ą można wybierać z listy rozwijanej. Tą komendę należy wydać jeśli się przeszło do nowego dużego obszaru któ®y nie mieści się na oryginalnej mapie.

#### +map reload 

Ponowne załadowanie mapy z dysku. **UWAGA! to usuwa wszystkie twoje zmiany i przywraca wersje która była ostatnio ściągnięta z GitHuba. Nie ma kopi tego co zrobiłeś!**

#### +map symbol <symbol>

Ustawia symbol roomu (znaczek/literka na środku roomu). Można używać Unicode, nie każdą ikonkę Mudlet może pokazywać ale większość działa.
  
Wpisz samo `+map symbol` bez parametru, żeby zobaczyć sugerowane oznaczenia dla roomów.

#### +map label <tekst>

Dodaje labelkę do mapy.
  
W <tekst> piszesz tekst labelki jeśli tekst nie zaczyna się znaczkiem # to jest małą labelką jeśli zaczyna się # jest małym tytułem jeśli ## jest średnim tytułem jeśli ### jest dużym tytułem.
Jeśli labelka kończy się znakiem `!` to na początku labelki dorysuje się czaszka, a wykrzyknik z końca zniknie.

Jeśli koniecznie chcesz wykrzyknik na końcu labelki to musisz napisać wykrzynik i spacje po nim.
  
#### +map check
  
Wykonuje sprawdzenie poprawności danych na mapie, wylistowuje konflikty i błędy.
  
#### +map redraw
  
Przerysowuje obrazki na mapie, użyj jeśli przypadkiem przesunałeś obrazek na tle.
  
#### +map load

Ładowanie mapy z dysku. **UWAGA! to usuwa wszystkie twoje zmiany.**

#### +map info

Pokazuje informacje które mapa ma zapisane na temat roomu w którym się znajdujesz

#### +map zoom

Ustawia przybliżenie mapy. To samo co używanie scrolla na mapie, ale przydaje się na Macbooku bo tam scroll marnie działa.

#### +map refresh

Odświeża cache vnumów, używaj jeśli masz wrażenie że mapper nie działa tak jak trzeba.

#### +map forget

Zapomina informacje o roomie, przydatne jeśli coś się źle zmapowało.

#### +map special <kierunek> <fraza>
  
Dodaje progowe przejście do innego rooma. 

Dodawanie specjalnych przejść działa tak:
- należy to stosować wyłącznie do przejść które powodują natychmiastowy mob transfer. Inaczej to nie zadziała. Jeśli masz przejście z delayami typu "wspinaj", nie można tego użyć. W przypadku przejscia z delayami i tak nie ma sensu dodawanie tego jako "przejście" bo żaden autowalk czy inne bajery i tak nie zadziałają na czymś takim. Takie rzeczy dodaje się po prostu do mapy ręcznie jako połączenie dwóch roomów, niech się gracz domyśla jaki input ma dać.
- jak już masz przejście "natychmiastowe" z proga, którego nie ma w wyjściach roomu, stajesz w takim roomie i piszesz: `+map special <kierunek> <komenda>` np. `+map special e przecisnij`
- mapper od razu przejdzie do tego rooma i go zmapuje. 
- uwaga! należy od razu potem zrobić map special w drugą stronę ponieważ przejście może mieć inną komendę, mapper jej nie zna więc narazie zrobił tylko przejscie w jedną stronę
- jak się zrobi przejście w obie strony to już można sobie przechodzić i wszystko śmiga na mapie

Przykład:
Mapuje sobie trakt do karakris, jestem w trybie map start oczywiście, ide sobie i jest ukryte przejście na E, wchodze tam i w opisie rooma widzę że jest szczelina przez ktorą można się przecisnąć. Pisze:
```
+map special e przecisnij
+map special w przecisnij
```

wróciłem do punktu z którego wszedłem do szczeliny i na mapie mam narysowane przejście i nowy room na E odemnie. Teraz już mogę chodzić swobodnie, więc przechodzę i mapuje pozostałą część jaskini: `przecisnij` - mapa podąża za mną, więc ide sobie dalej na E i mapuje dalej



