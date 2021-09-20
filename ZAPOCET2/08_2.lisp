;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Zdrojov� soubor k u�ebn�mu textu M. Krupka: Objektov� programov�n�
;;;;
;;;; Kapitola 8, knihovna OMG, verze 1.0
;;;;

#| 
P�ed na�ten�m souboru na�t�te knihovnu micro-graphics
Pokud p�i na��t�n� (kompilaci) dojde k chyb� 
"Reader cannot find package MG",
znamen� to, �e knihovna micro-graphics nen� na�ten�.
|#

#|

DOKUMENTACE
-----------

T��DA OMG-OBJECT
----------------

Jej�mi potomky jsou v�echny t��dy na�� grafick� knihovny. Nen� ur�ena k
vytv��en� p��m�ch instanc�. Implementuje vlastnick� vztahy mezi objekty:
deleg�ta, syst�m ud�lost�, hl�en� zm�n a z�kladn� ud�losti (ev-changing, 
ev-change, ev-mouse-down). Teorie kolem vlastnick�ch vztah� je pops�na 
v textu.

V r�mci syst�mu hl�en� zm�n rozum� zpr�v�m send-with-change, changing a 
change. Sou��st� syst�mu hl�en� zm�n jsou ud�losti ev-changing a ev-change.


NOV� VLASTNOSTI

delegate     Obsahuje deleg�ta (neboli vlastn�ka) objektu. Povoleno nastavovat
             pouze vlastn�kem (obvykle v moment�, kdy se objekt st�v� jeho
             sou��st�).
change-level Po��tadlo s hodnotami 0 a v�ce. Slou�� k blokov�n� hl�en� zm�n
             v metod�ch change a changing. Jen ke �ten�, ale d� se nastavovat 
             pomoc� inc-change-level a dec-change-level.
             

NOV� ZPR�VY

send-event object event &rest event-args

Zpr�vu pos�l� objekt object s�m sob�, kdy� chce odeslat ud�lost event s
argumenty event-args. Ve t��d� omg-object d�l� metoda n�sleduj�c�:
- zkontroluje, �e objekt m� deleg�ta (vlastnost delegate)
- zkontroluje, �e deleg�t implementuje metodu pro ud�lost event
- ud�lost ode�le (p��padn� pod p�elo�en�m jm�nem)
- jako v�sledek vr�t� object nebo hodnotu vr�cenou ud�lost�.

change object message changed-obj msg-args

Zpr�vu pos�l� objekt s�m sob� pot�, co u n�j do�lo ke zm�n�, kterou je t�eba
ozn�mit deleg�tovi (ud�lost� ev-change). Ve t��d� omg-object metoda testuje,
nen�-li (po��tadlem change-level) u objektu potla�eno pos�l�n� ud�lost� ev-change
a ev-changing. Pokud nen�, po�le (pomoc� zpr�vy send-event) ud�lost ev-change.
Parametry:
- message      jm�no zpr�vy, kter� zm�nu vyvolala
- changed-obj  objekt, u n�j� do�lo ke zm�n� (m��e se li�it od objektu object)
- msg-args     argumenty zpr�vy
Hodnoty t�chto parametr� se stanou argumenty ud�losti ev-change.

changing object message changed-obj msg-args

Zpr�vu pos�l� objekt s�m sob� p�edt�m, ne� u n�j dojde ke zm�n�, kterou je 
t�eba ozn�mit deleg�tovi (ud�lost� ev-changing). Ve t��d� omg-object metoda 
testuje, nen�-li (po��tadlem change-level) u objektu potla�eno pos�l�n� ud�lost� 
ev-change a ev-changing. Pokud nen�, po�le (pomoc� zpr�vy send-event) ud�lost
ev-changing.
Parametry:
- message      jm�no zpr�vy, kter� zm�nu vyvolala
- changed-obj  objekt, u n�j� dojde ke zm�n� (m��e se li�it od objektu object)
- msg-args     argumenty zpr�vy
Hodnoty t�chto parametr� se stanou argumenty ud�losti ev-changing.

send-with-change object msg reported-msg msg-args

Za��d� posl�n� zpr�vy jm�nem msg objektu object s argumenty msg-args. P�edt�m
pomoc� zpr�vy changing za��d� odesl�n� ud�losti ev-changing a potom pomoc�
zpr�vy change posl�n� ud�losti ev-change. Jako zpr�vu, kter� vyvol� (vyvolala)
zm�nu pou�ije zpr�vu reported-msg. Tedy, parametrem message ud�losti ev-change
a ev-changing bude parametr reported-msg. Parametrem changed-obj bude objekt
object a parametrem msg-args bude hodnota msg-args.
- Pokud ov�em ud�lost ev-changing vr�t� nil, znamen� to, �e deleg�t objektu
  si nep�eje, aby se zm�na provedla. Proto se zpr�vy msg a change nepo�lou.
- Zpr�va msg se pos�l� s inkrementovan�m po��tadlem change-level, co� zabr�n�
  generov�n� dal��ch pod��zen�ch ud�lost� o zm�n�. 

inc-change-level object
dec-change-level object

Inkrementace a dekrementace po��tadla change-level.


NOV� P�IJ�MAN� UD�LOSTI

ev-change   receiver sender message changed-obj args
ev-changing receiver sender message changed-obj args

Implementov�ny ve t��d� omg-object, aby jim ka�d� objekt rozum�l. V t�to t��d�
pouze p�epos�laj� ud�lost deleg�tovi pomoc� zpr�vy change (resp. changing).

ev-mouse-down receiver sender clicked-obj button position

P�epos�l� ud�lost deleg�tovi.


NOV� ZAS�LAN� UD�LOSTI

ev-change   receiver sender message changing-obj args 
ev-changing receiver sender message changing-obj args

Tyto ud�losti pos�l� objekt deleg�tovi, kdy� u n�j doch�z� ke zm�n�. Ud�lost
ev-changing bezprost�edn� p�ed zm�nou, ev-change bezprost�edn� po (viz zpr�vu
send-with-change). Krom� standardn�ch parametr� receiver a sender
(spole�n�ch v�em ud�lostem), jsou dal��mi parametry:
- message: zpr�va, v d�sledku jej�ho� p�ijet� ke zm�n� doch�z�
- changing-obj: p��jemce t�to zpr�vy, tj, objekt, u n�j� doch�z� ke zm�n�
- args: argumenty, se kter�mi byla zpr�va odesl�na (bez p��jemce)
Vyhodnocen�m seznamu (message changing-obj . args) by se zopakovalo posl�n�
zpr�vy.

ev-mouse-down receiver sender clicked-obj button position

Posl�na, pokud objekt zjist�, �e na n�j nebo na pod��zen� objekt u�ivatel 
klikl. Parametr clicked-obj je objekt, na kter� se kliklo p�vodn� (m��e to 
b�t podobjekt odes�laj�c�ho objektu; pak se hodnoty sender a clicked-obj 
li��). button je :left, :center, nebo :right. position je bod (instance t��dy
point), na kter� se kliklo.



T��DA SHAPE (OMG-OBJECT)
------------------------

Potomky t��dy shape jsou v�echny t��dy grafick�ch objekt�. Sama nen� ur�ena k
vytv��en� p��m�ch instanc�.


NOV� VLASTNOSTI

window    Okno, ve kter�m je objekt um�st�n, nebo nil. Typicky ho instance 
          pou��vaj� p�i kreslen�. Nastavovat ho sm� pouze nad��zen� objekty
shape-mg-window 
          mg-window okna window.
color, thickness, filledp     
          Grafick� parametry. Metody nastavuj�c� tyto hodnoty zaji��uj�
          signalizaci zm�n ud�lostmi ev-changing a ev-change a zas�laj�
          objektu pomocnou zpr�vu do-set-color (-thickness, -filledp).
          D�laj� to p�i inkrementovan�m vnit�n�m po��tadle, tak�e v r�mci
          obsluhy t�chto pomocn�ch zpr�v objekt dal�� ud�losti o zm�n�ch
          nepos�l�. Metody set-color, set-thickness, set-filledp nejsou ur�eny
          k p�episov�n�. P�episujte metody do-set-color atd.
solidp    Zda objekt p�ij�m� zpr�vu mouse-down. Ve t��d� shape je v�dy t.
solid-shapes
          Seznam podobjekt� (v�etn� objektu sam�ho) s nastavenou vlastnost�
          solidp. Je-li solidp Pravda u� u tohoto objektu, je to jednoprvkov�
          seznam s objektem samotn�m. Jinak je to hodnota vlastnosti
          solid-subshapes.
solid-subshapes
          Seznam podobjekt� (mimo objektu sam�ho) s nastavenou vlastnost�
          solidp. Zji��uje se jen u objekt�, kter� maj� vlastnost solidp nil.
          Pokud m� objekt vlastnost solidp nastavenu na Pravda, mus� m�t 
          implementov�nu metodu solid-subshapes. Ve t��d� shape vede k chyb�.

NOV� ZPR�VY

do-set-color object value
do-set-thickness object value
do-set-filledp object value

Nastavuj� hodnoty p��slu�n�ch vlastnost�. Jsou vol�ny z metod set-color,
set-thickness, set-filledp t��dy shape. Tyto metody mohou potomci p�epsat a
modifikovat tak jejich chov�n�. Nejsou ur�eny k vol�n�. 

move object dx dy
rotate object angle center
scale object coeff center

Realizuj� geometrick� transformace objektu object. Ve t��d� shape za��d�
signalizaci zm�n a zas�laj� p��slu�n� do-zpr�vy. B�hem jejich vykon�v�n� je
signalizace zm�n potla�ena vnit�n�m po��tadlem.

do-move object dx dy
do-rotate object angle center
do-scale object coeff center

Potomci t��dy shape p�episuj� tyto metody a implementuj� v nich p��slu�n�
geometrick� transformace. Tyto zpr�vy nejsou ur�eny k p��m�mu vol�n�; jsou
vol�ny z metod move, rotate, scale t��dy shape, kter� vytv��� spr�vn� 
prost�ed� pro hl�en� zm�n. Ve t��d� shape metody ned�laj� nic.

draw shape

Vykresl� shape do jej�ho okna. Typicky vol�no nad��zen�m objektem. Ve t��d� 
shape zas�l� zpr�vy set-mg-params a do-draw.

set-mg-params shape

Nastav� kreslic� parametry okna knihovny micro-graphics, ve kter�m je objekt 
um�st�n, tak, aby mohl b�t pozd�ji vykreslen. Ve t��d� shape nastavuje 
parametry :foreground, :filledp, :thickness podle hodnot vlastnost� color,
filledp a thickness (po�ad�). Zas�l� se z metody draw t��dy shape. Nen� nutn�
volat jindy. Potomci mohou p�epsat.

do-draw shape

Vykresl� objekt shape do jeho okna. M��e po��tat s t�m, �e grafick� parametry
okna knihovny micro-graphics jsou u� nastaveny (metodou set-mg-params).
Zas�l� se z metody draw t��dy shape. Nen� nutn� volat jindy. Potomci mohou 
p�epsat. Ve t��d� shape ned�l� nic.

contains-point-p shape point

Vrac� logickou hodnotu "shape obsahuje point". Ve t��d� shape vrac� nil.

mouse-down object button position

Objekt obdr�� tuto zpr�vu od okna pot�, co do n�j u�ivatel klikl my��. 
button je :left, :center, nebo :right, position bod. Lze se
spolehnout, �e bod position je opravdu uvnit� objektu. Zpr�vu dost�vaj�
pouze objekty s nastavenou vlastnost� solidp. Metoda t��dy
shape pos�l� ud�lost ev-mouse-down s argumentem clicked-obj rovn�m 
object.


T��DA POINT (SHAPE)
-------------------

Geometrick� bod s kart�zsk�mi a pol�rn�mi sou�adnicemi. Kresl� se jako
vypln�n� kole�ko.


NOV� VLASTNOSTI

x, y, r, phi  Sou�adnice. Nastaven� vyvol� hl�en� o zm�n�.

NOV� ZPR�VY

set-r-phi point r phi

Soub�n� nastaven� obou pol�rn�ch sou�adnic. Vyvol�v� hl�en� o zm�n�.

P�EPSAN� METODY

do-move point dx dy
do-rotate point angle center
do-scale point coeff center

Implementuj� geometrick� transformace bodu.

set-mg-params point

Modifikuje zd�d�nou metodu tak, �e nastavuje :filledp na T.

do-draw point

Vykresl� bod jako vypln�n� kole�ko o polom�ru rovn�m nastaven� thickness.

contains-point-p point point2

Vrac� true pr�v� kdy� je vzd�lenost bod� <= (thickness point).


T��DA CIRCLE (SHAPE)
--------------------

Kole�ka se st�edem (instance t��dy point) a polom�rem. St�edu lze nastavovat
sou�adnice a aplikovat na n�j transformace.

NOV� VLASTNOSTI

center   St�ed. Instance t��dy point. Jen ke �ten�.
radius   Polom�r.


P�EPSAN� METODY

do-move circle dx dy
do-rotate circle angle center
do-scale circle coeff center

Implementuj� geometrick� transformace kruhu.

contains-point-p circle point

Je-li (filledp circle) true, vrac� true pr�v� kdy� je vzd�lenost bodu point
od st�edu <= (radius circle). Je-li (filledp circle) false, vrac� true pr�v� 
kdy� point le�� na kru�nici s polom�rem (radius circle) a st�edem (center 
circle) o tlou��ce (thickness circle).


T��DA COMPOUND-SHAPE (SHAPE)
----------------------------

P�edek t��d grafick�ch objekt�, slo�en�ch z jin�ch grafick�ch objekt�.

NOV� VLASTNOSTI

items   Seznam podobjekt�. P�i nastavov�n� otestuje validitu nastavovan�ch
        podobjekt� (zpr�vou check-items), p�iprav� hl�en� zm�ny p�ed a po 
        nastaven� a po�le zpr�vu do-set-items s inkrementovan�m po��tadlem
        pro zm�ny. P�i �ten� vrac� kopii seznamu.


NOV� ZPR�VY

check-item shape item

Otestuje, zda objekt item m��e b�t podobjektem slo�en�ho objektu shape. Pokud
ne, vyvol� chybu. Ve t��d� compound-shape vyvol�v� chybu po��d (abstraktn�
metoda), potomci metodu mus� p�epsat.

check-items shape items

Otestuje, zda seznam items m��e b�t seznamem podobjekt� objektu shape. Pokud
ne, vyvol� chybu. Ve t��d� compound-shape pos�l� zpr�vu check-item pro ka�d�
prvek seznamu items.

do-set-items shape value

Nastav� kopii seznamu value jako vlastnost items slo�en�ho objektu shape.
Seznam u� je prov��en� zpr�vou check-items. Nen� ur�eno k vol�n�. Je vol�no z
metody set-items t��dy compound-shape po nastaven� prost�ed� pro hl�en� zm�n.
Ve t��d� compound shape krom� vlastn�ho nastaven� vlastnosti items nastavuje
v�em objekt�m v seznamu vlastnosti window a delegate.

send-to-items shape message &rest arguments

Lze pou��t, pokud chceme v�em podobjekt�m slo�en�ho objektu shape poslat
tut� zpr�vu se stejn�mi argumenty.


P�EPSAN� METODY

do-move shape dx dy
do-rotate shape angle center
do-scale shape coeff center

Pomoc� zpr�vy send-to-items p�epo�le zpr�vu move (nebo rotate, nebo scale) 
v�em podobjekt�m.


T��DA PICTURE (COMPOUND-SHAPE)
------------------------------

Slo�en� grafick� objekt, kter� se vykresluje tak, �e postupn� vykresl� v�echny
podobjekty.


P�EPSAN� VLASTNOSTI

window   P�i nastavov�n� automaticky nastav� tot� okno i v�em podobjekt�m


P�EPSAN� METODY

check-item picture item

Vyvol� chybu, pokud item nen� typu shape.

do-draw picture

Po�le zpr�vu draw v�em podobjekt�m (v opa�n�m po�ad�, aby se vykreslily zezadu
dop�edu)

contains-point-p picture point

Proch�z� podobjekty a p�epos�l� jim zpr�vu contains-point-p. Pokud pro n�kter�
podobjekt je v�sledek true, vr�t� true. Jinak false.


T��DA POLYGON (COMPOUND-SHAPE)
------------------------------

Grafick� objekt slo�en� z bod�. Vykresluje se jako polygon. Proti 
compound-shape m� novou vlastnost: closedp.

NOV� VLASTNOSTI

closedp  P�i filledp nastaven�m na false ur�uje, zda do polygonu pat�� i
         �se�ka spojuj�c� prvn� a posledn� bod. P�i nastavov�n� nachyst�
         prost�ed� hl�en� zm�n a vlastn� nastaven� provede zasl�n�m zpr�vy
         do-set-closedp.


NOV� ZPR�VY

do-set-closedp polygon value

Vlastn� nastaven� vlastnosti closedp. Vol�no z metody set-closedp t��dy
polygon, kter� p�ipravuje prost�ed� pro hl�en� zm�n. Nevolat p��mo, pouze
p�episovat.

P�EPSAN� METODY

check-item polygon item

Vyvol� chybu, pokud item nen� bod.

set-mg-params polygon

Vol� zd�d�nou metodu a pak nastavuje kreslic� parametr closedp.

do-draw polygon

Vykresl� polygon zavol�n�m mg:draw-polygon.

contains-point-p polygon point

Vrac�, zda polygon obsahuje bod point. Bere v �vahu vlastnosti closedp,
filledp, thickness.


T��DA WINDOW (OMG-OBJECT)
------------------------

Instance reprezentuj� okna knihovny micro-graphics. Okno se otev�e automaticky
p�i vytv��en� nov� instance. Oknu lze nastavit barvu pozad� a vykreslovan�
grafick� objekt.


NOV� VLASTNOSTI

shape      Grafick� objekt vykreslovan� do okna. P�i nastaven� se nachyst�
           prost�ed� na hl�en� zm�n a pak se zavol� do-set-shape. Potom
           se okno ozna�� k p�ekreslen� zpr�vou invalidate.
background Barva pozad� okna. P�i nastaven� se nachyst� prost�ed� na hl�en�
           zm�n a pak se zavol� do-set-background. Potom se okno ozna�� k 
           p�ekreslen� zpr�vou invalidate.
mg-window  Odkaz na okno knihovny micro-graphics. Jen ke �ten�.


NOV� ZPR�VY

do-set-shape window shape

Vlastn� nastaven� vlastnosti shape. Po nastaven� vlastnosti se objektu shape
nastav� vlastnost window a delegate na window a ud�lost ev-change.

do-set-background window color

Vlastn� nastaven� vlastnosti background.

invalidate window

Pos�l� se oknu, pokud je t�eba ho p�ekreslit. Ozna�� okno k p�ekreslen� a 
n�kdy pozd�ji okno dostane zpr�vu redraw.

change window message changed-obj args

Zavol� zd�d�nou metodu a pak invalidate.

redraw window

Vyma�e okno barvou pozad� (vlastnost background) a pak vykresl� do okna objekt
ulo�en� ve vlastnosti shape t�m, �e mu po�le zpr�vu draw. Nevolat p��mo, 
pou��vat zpr�vu invalidate.

install-callbacks window

Pos�l� se oknu jako sou��st inicializace. Slou�� k instalaci zp�tn�ch
vol�n� knihovny micro-graphics. Ve t��d� window instaluje zp�tn� vol�n�
:display a :mouse-down pomoc� zpr�v install-display-callback a
install-mouse-down-callback.

install-display-callback window
install-mouse-down-callback window

Nainstaluj� p��slu�n� zp�tn� vol�n�.

window-mouse-down window button position

Tuto zpr�vu okno dostane, pokud do n�j u�ivatel klikne my��. Parametr
button je :left, :center, nebo :right, position je bod, ur�uj�c� pozici my�i
p�i kliknut�. Metoda ve t��d� window zjist�, zda se kliklo dovnit� grafick�ho
objektu v okn�, kter� m� nastavenu vlastnost solidp na Pravda. Pokud ano, 
po�le si zpr�vu mouse-down-inside-shape, jinak si po�le zpr�vu
mouse-down-no-shape. Nen� ur�eno k p��m�mu vol�n�.


P�IJ�MAN� UD�LOSTI

ev-change

Ve t��d� window po�le oknu zpr�vu invalidate, aby se vyvolalo jeho
p�ekreslen�. Vol� zd�d�nou metodu.
|#

;;;
;;; T��da omg-object
;;;

(defclass omg-object () 
  ((delegate :initform nil)
   (change-level :initform 0)))

(defmethod delegate ((obj omg-object))
  (slot-value obj 'delegate))

(defmethod set-delegate ((obj omg-object) delegate)
  (setf (slot-value obj 'delegate) delegate))


(defmethod change-level ((obj omg-object))
  (slot-value obj 'change-level))

(defmethod inc-change-level ((obj omg-object))
  (setf (slot-value obj 'change-level)
        (+ (slot-value obj 'change-level) 1))
  obj)

(defmethod dec-change-level ((obj omg-object))
  (setf (slot-value obj 'change-level)
        (- (slot-value obj 'change-level) 1))
  obj)


;;Funkce has-method-p zji��uje, zda existuje metoda pro danou
;;zpr�vu a dan� argumenty. Nen� nutn� j� rozum�t.
(defun has-method-p (object message arguments)
  (and (fboundp message)              ;je se symbolem message 
                                      ;sv�z�na zpr�va (funkce)?
       (compute-applicable-methods    ;vypo�te seznam metod
        (symbol-function message)     ;pro zpr�vu sv�zanou s message
        (cons object arguments))))    ;s dan�mi argumenty


;; pos�l�n� ud�lost�: send-event

(defmethod send-event ((object omg-object) event 
		       &rest event-args)
  (let ((delegate (delegate object)))
    (if (and delegate 
             (has-method-p delegate 
                           event 
                           (cons object event-args)))
        (apply event delegate object event-args)
      object)))

(defmethod change ((object omg-object) message changed-obj args)
  (if (= (change-level object) 0)
      (send-event object 'ev-change message changed-obj args)
    object))

(defmethod changing ((object omg-object) message changing-obj args)
  (if (= (change-level object) 0)
      (send-event object 'ev-changing message changing-obj args)
    object))

(defmethod send-with-change 
           ((obj omg-object) msg reported-msg args)
  (when (changing obj reported-msg obj args)
    (unwind-protect
        (progn (inc-change-level obj)
          (apply 'funcall msg obj args))
      (dec-change-level obj))
    (change obj reported-msg obj args))
  obj)


;; z�kladn� ud�losti

(defmethod ev-change 
           ((obj omg-object) sender msg orig-obj args)
  (change obj msg orig-obj args))

(defmethod ev-changing 
           ((obj omg-object) sender msg orig-obj args)
  (changing obj msg orig-obj args))

(defmethod ev-mouse-down 
           ((obj omg-object) sender clicked button position)
  (send-event obj 'ev-mouse-down clicked button position))


;;;
;;; T��da shape
;;;

(defclass shape (omg-object)
  ((color :initform :black)
   (thickness :initform 1)
   (filledp :initform nil)
   (window :initform nil)))

(defmethod window ((shape shape)) 
  (slot-value shape 'window))

(defmethod set-window ((shape shape) value) 
  (setf (slot-value shape 'window) value)
  shape)

(defmethod shape-mg-window ((shape shape))
  (when (window shape)
    (mg-window (window shape))))

(defmethod color ((shape shape)) 
  (slot-value shape 'color))

(defmethod do-set-color ((shape shape) value)
  (setf (slot-value shape 'color) value))


(defmethod set-color ((shape shape) value) 
  (send-with-change shape 
                    'do-set-color 'set-color 
                    `(,value)))

(defmethod thickness ((shape shape)) 
  (slot-value shape 'thickness)) 

(defmethod do-set-thickness ((shape shape) value) 
  (setf (slot-value shape 'thickness) value)) 


(defmethod set-thickness ((shape shape) value)
  (send-with-change shape 
                    'do-set-thickness 'set-thickness 
                    `(,value)))

(defmethod filledp ((shape shape))
  (slot-value shape 'filledp))

(defmethod do-set-filledp ((shape shape) value)
  (setf (slot-value shape 'filledp) value))


(defmethod set-filledp ((shape shape) value)
  (send-with-change shape 
                    'do-set-filledp 'set-filledp 
                    `(,value)))

(defmethod do-move ((shape shape) dx dy)
  shape)

(defmethod move ((shape shape) dx dy)
  (send-with-change shape 
                    'do-move 'move 
                    `(,dx ,dy)))

(defmethod do-rotate ((shape shape) angle center)
  shape)


(defmethod rotate ((shape shape) angle center)
  (send-with-change shape 
                    'do-rotate 'rotate 
                    `(,angle ,center)))

(defmethod do-scale ((shape shape) coeff center)
  shape)


(defmethod scale ((shape shape) coeff center)
  (send-with-change shape 
                    'do-scale 'scale 
                    `(,coeff ,center)))

(defmethod set-mg-params ((shape shape)) 
  (let ((mgw (shape-mg-window shape)))
    (mg:set-param mgw :foreground (color shape)) 
    (mg:set-param mgw :filledp (filledp shape))
    (mg:set-param mgw :thickness (thickness shape)))
  shape)

(defmethod do-draw ((shape shape)) 
  shape)

(defmethod draw ((shape shape))
  (set-mg-params shape)
  (do-draw shape))


;;; Pr�ce s my��

(defmethod solidp ((shape shape))
  t)

(defmethod solid-shapes ((shape shape))
  (if (solidp shape)
      (list shape)
    (solid-subshapes shape)))

(defmethod solid-subshapes ((shape shape))
  (error "Method has to be rewritten."))

(defmethod contains-point-p ((shape shape) point)
  nil)

(defmethod mouse-down ((shape shape) button position)
  (send-event shape 'ev-mouse-down shape button position))


;;;
;;; T��da point
;;;

(defclass point (shape) 
  ((x :initform 0) 
   (y :initform 0)))

(defmethod x ((point point))
  (slot-value point 'x))

(defmethod y ((point point))
  (slot-value point 'y))

(defmethod do-set-x ((point point) value)
  (setf (slot-value point 'x) value))

(defmethod set-x ((point point) value)
  (unless (typep value 'number)
    (error "x coordinate of a point should be a number"))
  (send-with-change point 
                    'do-set-x 'set-x 
                    `(,value)))

(defmethod do-set-y ((point point) value)
  (setf (slot-value point 'y) value))


(defmethod set-y ((point point) value)
  (unless (typep value 'number)
    (error "y coordinate of a point should be a number"))
  (send-with-change point 
                    'do-set-y 'set-y 
                    `(,value)))

(defmethod r ((point point)) 
  (let ((x (slot-value point 'x)) 
        (y (slot-value point 'y))) 
    (sqrt (+ (* x x) (* y y)))))

(defmethod phi ((point point)) 
  (let ((x (slot-value point 'x)) 
        (y (slot-value point 'y))) 
    (cond ((> x 0) (atan (/ y x))) 
          ((< x 0) (+ pi (atan (/ y x)))) 
          (t (* (signum y) (/ pi 2))))))

(defmethod do-set-r-phi ((point point) r phi)
  (set-x point (* r (cos phi)))
  (set-y point (* r (sin phi))))

(defmethod set-r-phi ((point point) r phi) 
  (send-with-change point 
                    'do-set-r-phi 'set-r-phi 
                    `(,r ,phi)))

(defmethod do-set-r ((point point) value)
  (set-r-phi point value (phi point)))

(defmethod set-r ((point point) value) 
  (send-with-change point 
                    'do-set-r 'set-r 
                    `(,value)))

(defmethod do-set-phi ((point point) value)
  (set-r-phi point (r point) value))

(defmethod set-phi ((point point) value) 
  (send-with-change point 
                    'do-set-phi 'set-phi
                    `(,value)))

(defmethod set-mg-params ((pt point))
  (call-next-method)
  (mg:set-param (shape-mg-window pt) :filledp t)
  pt)

(defmethod do-draw ((pt point)) 
  (mg:draw-circle (shape-mg-window pt) 
                  (x pt) 
                  (y pt) 
                  (thickness pt))
  pt)

(defmethod do-move ((pt point) dx dy)
  (set-x pt (+ (x pt) dx))
  (set-y pt (+ (y pt) dy))
  pt)

(defmethod do-rotate ((pt point) angle center)
  (let ((cx (x center))
        (cy (y center)))
    (move pt (- cx) (- cy))
    (set-phi pt (+ (phi pt) angle))
    (move pt cx cy)
    pt))

(defmethod do-scale ((pt point) coeff center)
  (let ((cx (x center))
        (cy (y center)))
    (move pt (- cx) (- cy))
    (set-r pt (* (r pt) coeff))
    (move pt cx cy)
    pt))


;; Pr�ce s my��

;; Pomocn� funkce (vzd�lenost bod�)

(defun sqr (x)
  (expt x 2))

(defun point-dist (pt1 pt2)
  (sqrt (+ (sqr (- (x pt1) (x pt2)))
           (sqr (- (y pt1) (y pt2))))))

(defmethod contains-point-p ((shape point) point)
  (<= (point-dist shape point) 
      (thickness shape)))


;;;
;;; T��da circle
;;;

(defclass circle (shape) 
  ((center :initform (make-instance 'point)) 
   (radius :initform 1)))

(defmethod initialize-instance ((c circle) &key)
  (call-next-method)
  (set-delegate (center c) c))

(defmethod radius ((c circle))
  (slot-value c 'radius))

(defmethod do-set-radius ((c circle) value)
  (setf (slot-value c 'radius) value))

(defmethod set-radius ((c circle) value)
  (when (< value 0)
    (error "Circle radius should be a non-negative number"))
  (send-with-change c 
                    'do-set-radius 'set-radius 
                    `(,value)))

(defmethod center ((c circle))
  (slot-value c 'center))

(defmethod do-draw ((c circle))
  (mg:draw-circle (shape-mg-window c)
                  (x (center c))
                  (y (center c))
                  (radius c))
  c)

(defmethod do-move ((c circle) dx dy)
  (move (center c) dx dy)
  c)

(defmethod do-rotate ((c circle) angle center)
  (rotate (center c) angle center)
  c)

(defmethod do-scale ((c circle) coeff center)
  (scale (center c) coeff center)
  (set-radius c (* (radius c) coeff))
  c)


;; Pr�ce s my��

(defmethod contains-point-p ((circle circle) point)
  (let ((dist (point-dist (center circle) point))
        (half-thickness (/ (thickness circle) 2)))
    (if (filledp circle)
        (<= dist (radius circle))
      (<= (- (radius circle) half-thickness)
          dist
          (+ (radius circle) half-thickness)))))


;;;
;;; T��da compound-shape
;;;

(defclass compound-shape (shape)
  ((items :initform '())))

(defmethod items ((shape compound-shape)) 
  (copy-list (slot-value shape 'items)))

(defmethod send-to-items ((shape compound-shape) 
			  message
			  &rest arguments)
  (dolist (item (items shape))
    (apply message item arguments))
  shape)

(defmethod check-item ((shape compound-shape) item)
  (error "Abstract method."))

(defmethod check-items ((shape compound-shape) item-list)
  (dolist (item item-list)
    (check-item shape item))
  shape)

(defmethod do-set-items ((shape compound-shape) value)
  (setf (slot-value shape 'items) (copy-list value))
  (send-to-items shape #'set-delegate shape))

(defmethod set-items ((shape compound-shape) value)
  (check-items shape value)
  (send-with-change shape 
                    'do-set-items 'set-items 
                    `(,value)))

(defmethod do-move ((shape compound-shape) dx dy)
  (send-to-items shape #'move dx dy)
  shape)

(defmethod do-rotate ((shape compound-shape) angle center)
  (send-to-items shape #'rotate angle center)
  shape)

(defmethod do-scale ((shape compound-shape) coeff center)
  (send-to-items shape #'scale coeff center)
  shape)


;;;
;;; T��da picture
;;;

(defclass picture (compound-shape)
  ())

(defmethod check-item ((pic picture) item)
  (unless (typep item 'shape)
    (error "Invalid picture element type."))
  pic)

(defmethod do-set-items ((shape picture) value)
  (call-next-method)
  (send-to-items shape 'set-window (window shape)))

(defmethod draw ((pic picture))
  (dolist (item (reverse (items pic)))
    (draw item))
  pic)

(defmethod set-window ((shape picture) value)
  (send-to-items shape 'set-window value)
  (call-next-method))

;; Pr�ce s my��

(defmethod solidp ((pic picture))
  nil)

(defmethod solid-subshapes ((shape picture))
  (mapcan 'solid-shapes (items shape)))

(defmethod contains-point-p ((pic picture) point)
  (find-if (lambda (item)
	     (contains-point-p item point))
	   (items pic)))


;;;
;;; T��da polygon
;;;

(defclass polygon (compound-shape)
  ((closedp :initform t)))

(defmethod check-item ((poly polygon) item)
  (unless (typep item 'point) 
    (error "Items of polygon should be points."))
  poly)

(defmethod closedp ((p polygon))
  (slot-value p 'closedp))

(defmethod do-set-closedp ((p polygon) value)
  (setf (slot-value p 'closedp) value))

(defmethod set-closedp ((p polygon) value)
  (send-with-change p 
                    'do-set-closedp 'set-closedp
                    `(,value)))

(defmethod set-mg-params ((poly polygon)) 
  (call-next-method)
  (mg:set-param (shape-mg-window poly) 
                :closedp
                (closedp poly))
  poly)

(defmethod polygon-coordinates ((p polygon))
  (let (coordinates)
    (dolist (point (reverse (items p)))
      (setf coordinates (cons (y point) coordinates)
            coordinates (cons (x point) coordinates)))
    coordinates))

(defmethod do-draw ((poly polygon)) 
  (mg:draw-polygon (shape-mg-window poly) 
                   (polygon-coordinates poly))
  poly)


;;
;; contains-point-p pro polygon vyu��v� funkci
;; mg:point-in-polygon-p knihovny micro-graphics.
;;

(defmethod contains-point-p ((poly polygon) point)
  (mg:point-in-polygon-p (x point) (y point) 
                         (closedp poly)
                         (filledp poly) 
                         (thickness poly)
                         (polygon-coordinates poly)))

;;;
;;; T��da window
;;;

(defclass window (omg-object)
  ((mg-window :initform (mg:display-window))
   (shape :initform nil)
   (background :initform :white)))

(defmethod mg-window ((window window)) 
  (slot-value window 'mg-window))

(defmethod shape ((w window))
  (slot-value w 'shape))

(defmethod do-set-shape ((w window) shape)
  (when shape
    (set-window shape w)
    (set-delegate shape w))
  (setf (slot-value w 'shape) shape)
  w)

(defmethod set-shape ((w window) shape)
  (send-with-change w 
                    'do-set-shape 'set-shape 
                    `(,shape)))

(defmethod background ((w window))
  (slot-value w 'background))

(defmethod do-set-background ((w window) color)
  (setf (slot-value w 'background) color))

(defmethod set-background ((w window) color)
  (send-with-change w 
                    'do-set-background 'set-background 
                    `(,color)))

(defmethod invalidate ((w window))
  (mg:invalidate (mg-window w))
  w)

(defmethod change ((w window) message changed-obj args)
  (call-next-method)
  (invalidate w))

(defmethod redraw ((window window))
  (let ((mgw (mg-window window)))
    (mg:set-param mgw :background (background window))
    (mg:clear mgw)
    (when (shape window)
      (draw (shape window))))
  window)


;; Klik�n�

(defmethod find-clicked-shape ((w window) position)
  (when (shape w)
    (find-if (lambda (shape) (contains-point-p shape position))
             (solid-shapes (shape w)))))

(defmethod mouse-down-inside-shape ((w window) shape button position)
  (mouse-down shape button position)
  w)

(defmethod mouse-down-no-shape ((w window) button position)
  w)

(defmethod window-mouse-down ((w window) button position)
  (let ((shape (find-clicked-shape w position)))
    (if shape
        (mouse-down-inside-shape w shape button position)
      (mouse-down-no-shape w button position))))


;; Inicializace

(defmethod install-display-callback ((w window))
  (mg:set-callback (mg-window w)
		   :display (lambda (mgw)
                              (declare (ignore mgw))
                              (redraw w)))
  w)

(defmethod install-mouse-down-callback ((w window))
  (mg:set-callback 
   (mg-window w) 
   :mouse-down (lambda (mgw button x y)
		 (declare (ignore mgw))
		 (window-mouse-down 
                  w
                  button 
                  (move (make-instance 'point) x y)))))

(defmethod install-callbacks ((w window))
  (install-display-callback w)
  (install-mouse-down-callback w)
  w)

(defmethod initialize-instance ((w window) &key)
  (call-next-method)
  (install-callbacks w)
  w)



;;;;;;;;;;;;;;
;;;;;;;;;;;;;;
;;;;;;;;;;;;;;
#|
;;ukol 8.1
;sender clicked button position
(defclass click-circle-window (window)
  ())

(defmethod ev-mouse-down ((w click-circle-window) sender clicked button position)
  (when (typep clicked 'circle)
    (progn
      (set-color clicked (random-color))
      (format t "~s~%~s~%~s~%[~s, ~s]~%" sender clicked button (x position) (y position))))
  (call-next-method))

;(defmethod mouse-down-no-shape ((w click-circle-window) button position)
;  (format t "Window clicked~%~s~%[~s, ~s]~%" button (x position) (y position))) 

;sender muze byt treba picture, clicked je konkretni kolecko v nem

;8.2
;((obj omg-object) sender msg orig-obj args)

(defclass lockable-window (window)
  ((lockedp :initform nil)))

(defmethod lockedp ((w lockable-window))
  (slot-value w 'lockedp))

(defmethod set-lockedp ((w lockable-window) value)
  (setf (slot-value w 'lockedp) value))

(defmethod ev-changing ((w lockable-window) sender msg orig-obj args)
  (if (lockedp w)
      (progn (format t "Zmena zakazana")
        nil)
    (call-next-method)))


;8.3. Vylep�ete t��du lockable-window tak, aby okna br�nila pouze zm�n�m objekt�
;dan�ch typ�. Zave�te vlastnost locked-types, kter� bude obsahovat seznam
;typ� (t��d) objekt�, kter�m budou zm�ny zak�z�ny, pokud je nastavena vlastnost
;lockedp na Pravda. Defaultn� hodnota vlastnosti bude (shape), tak�e defaultn�
;budou p�i lockedp rovn�m Pravda zak�z�ny zm�ny v�ech objekt�.

(defclass lockable-window-2 (window)
  ((lockedp :initform nil)
   (locked-types :initform nil)))

(defmethod lockedp ((w lockable-window-2))
  (slot-value w 'lockedp))

(defmethod set-lockedp ((w lockable-window-2) value)
  (setf (slot-value w 'lockedp) value))

(defmethod locked-types ((w lockable-window-2))
  (slot-value w 'locked-types))

(defmethod set-locked-types ((w lockable-window-2) value)
  (setf (slot-value w 'locked-types) value))


(defmethod ev-changing ((w lockable-window-2) sender msg orig-obj args)
  (if (lockedp w)
      (progn (format t "Zmena zakazana")
        nil)
    (if (or (find (type-of sender) (locked-types w))
        (progn (format t "Zmena pro objekt typu ~s zakazana ~s" (type-of sender) orig-obj)
          nil)
      (call-next-method))))
|#




