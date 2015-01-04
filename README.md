afm-curve-procesing
===================

Curve processing software for JPK and Multiprobe AFMs


Changelog
_________

**2014-01-04**
* naprawa fatalnego błędu przy skalowaniu Z piezo przy imporcie danych z DI (3 nieprzespane noce)

**2014-12-29**
* przycisk _Select contact point_ w główynm oknie programu, pod krzywa FD
* zapisuj stiffness jako dodatnie wartosci

**2014-03-24**
* eksport stress relaxation domyslnie do katalogu, z ktorego otwarto krzywe
* poprawka przy wczytywaniu wczesniej zapisanych w programie krzywych
* Mozliwosc ustawienia domyslengo zakresu dopasowania do stress relaxation w menu Opcje oraz zapisywanie domyslnie w katalogu, z ktorego otwarto krzywe


**2014-03-23**
* export pause segment to excel in ASCII
* przy ficie stress relaxation jako parametry startowe brane te z poprzedniego dopasowania; wczytywanie krzywych .force-map, jesli obecny jest segment pause-retract (pauza przed dojechaniem)

**2014-03-21**
* automatyczne dopasowanie stress relaxation i creep compliance do calego pakietu wczytywanych krzywych (75% dlugosci segmentu pauzy)

**2014-03-20**
* eksport skoków adhezji do Excela, skonki zapamiętywane pomiędzy krzywymi


**2014-03-12**
* dodano wczytywanie krzywych z plików .jpk-force-map

**2014-03-07 do 2014-03-11**
* wczytywanie natywnych krzywych .jpk-force (wraz z segmentami pauzy)
* poprawa wczytywania natywnych krzywych Multimode (ignorowanie plików z obrazkiem, jeśli jest w folderze)
* przełączanie widoczności menu kontekstowego w oknie głównym na wykresie
* panel do analizy stress relaxation przeniesiony do osobnego okna
* można już obrabiać elastyczność krzywych z segmentem pauzy
* poprawne rysowanie reference slope dla krzywych z JPK
* zamykanie stiffness panel usuwa kursory i callback z okna wykresu force-distance
* kyrzwą pomocniczną do wyznaczania punktu kontaktu można zacząć rysować z dowolnej strony
* gdy otwierana jest krzywa z segmentem pauzy, automatycznie otwiera sie okno do analizy stress relaxation
* można wygodnie przełączać się między wykresami force-time a force-distance
* automatyczne dopasowanie odpowiedniej krzywej do segmentu pauzy
* stress i creep eksportują się wspólnie do Excela
* wyniki dopasowania elastyczności są widoczne w osobnym okienku i eksportowane do osobnego pliku
* wyniki dopasowania elastyczności są zapamiętywane przy przechodzeniu między kolejnymi krzywymi
