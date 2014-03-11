afm-curve-procesing
===================

Curve processing software for JPK and Multiprobe AFMs


Changelog
_________

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
