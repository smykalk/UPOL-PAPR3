;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Zdrojovı soubor k uèebnímu textu M. Krupka: Objektové programování
;;;;
;;;; Kapitola 8, knihovna OMG, verze 1.0
;;;;

#| 
Pøed naètením souboru naètìte knihovnu micro-graphics
Pokud pøi naèítání (kompilaci) dojde k chybì 
"Reader cannot find package MG",
znamená to, e knihovna micro-graphics není naètená.
|#

#|

DOKUMENTACE
-----------

TØÍDA OMG-OBJECT
----------------

Jejími potomky jsou všechny tøídy naší grafické knihovny. Není urèena k
vytváøení pøímıch instancí. Implementuje vlastnické vztahy mezi objekty:
delegáta, systém událostí, hlášení zmìn a základní události (ev-changing, 
ev-change, ev-mouse-down). Teorie kolem vlastnickıch vztahù je popsána 
v textu.

V rámci systému hlášení zmìn rozumí zprávám send-with-change, changing a 
change. Souèástí systému hlášení zmìn jsou události ev-changing a ev-change.


NOVÉ VLASTNOSTI

delegate     Obsahuje delegáta (neboli vlastníka) objektu. Povoleno nastavovat
             pouze vlastníkem (obvykle v momentì, kdy se objekt stává jeho
             souèástí).
change-level Poèítadlo s hodnotami 0 a více. Slouí k blokování hlášení zmìn
             v metodách change a changing. Jen ke ètení, ale dá se nastavovat 
             pomocí inc-change-level a dec-change-level.
             

NOVÉ ZPRÁVY

send-event object event &rest event-args

Zprávu posílá objekt object sám sobì, kdy chce odeslat událost event s
argumenty event-args. Ve tøídì omg-object dìlá metoda následující:
- zkontroluje, e objekt má delegáta (vlastnost delegate)
- zkontroluje, e delegát implementuje metodu pro událost event
- událost odešle (pøípadnì pod pøeloenım jménem)
- jako vısledek vrátí object nebo hodnotu vrácenou událostí.

change object message changed-obj msg-args

Zprávu posílá objekt sám sobì poté, co u nìj došlo ke zmìnì, kterou je tøeba
oznámit delegátovi (událostí ev-change). Ve tøídì omg-object metoda testuje,
není-li (poèítadlem change-level) u objektu potlaèeno posílání událostí ev-change
a ev-changing. Pokud není, pošle (pomocí zprávy send-event) událost ev-change.
Parametry:
- message      jméno zprávy, která zmìnu vyvolala
- changed-obj  objekt, u nìj došlo ke zmìnì (mùe se lišit od objektu object)
- msg-args     argumenty zprávy
Hodnoty tìchto parametrù se stanou argumenty události ev-change.

changing object message changed-obj msg-args

Zprávu posílá objekt sám sobì pøedtím, ne u nìj dojde ke zmìnì, kterou je 
tøeba oznámit delegátovi (událostí ev-changing). Ve tøídì omg-object metoda 
testuje, není-li (poèítadlem change-level) u objektu potlaèeno posílání událostí 
ev-change a ev-changing. Pokud není, pošle (pomocí zprávy send-event) událost
ev-changing.
Parametry:
- message      jméno zprávy, která zmìnu vyvolala
- changed-obj  objekt, u nìj dojde ke zmìnì (mùe se lišit od objektu object)
- msg-args     argumenty zprávy
Hodnoty tìchto parametrù se stanou argumenty události ev-changing.

send-with-change object msg reported-msg msg-args

Zaøídí poslání zprávy jménem msg objektu object s argumenty msg-args. Pøedtím
pomocí zprávy changing zaøídí odeslání události ev-changing a potom pomocí
zprávy change poslání události ev-change. Jako zprávu, která vyvolá (vyvolala)
zmìnu pouije zprávu reported-msg. Tedy, parametrem message události ev-change
a ev-changing bude parametr reported-msg. Parametrem changed-obj bude objekt
object a parametrem msg-args bude hodnota msg-args.
- Pokud ovšem událost ev-changing vrátí nil, znamená to, e delegát objektu
  si nepøeje, aby se zmìna provedla. Proto se zprávy msg a change nepošlou.
- Zpráva msg se posílá s inkrementovanım poèítadlem change-level, co zabrání
  generování dalších podøízenıch událostí o zmìnì. 

inc-change-level object
dec-change-level object

Inkrementace a dekrementace poèítadla change-level.


NOVÉ PØIJÍMANÉ UDÁLOSTI

ev-change   receiver sender message changed-obj args
ev-changing receiver sender message changed-obj args

Implementovány ve tøídì omg-object, aby jim kadı objekt rozumìl. V této tøídì
pouze pøeposílají událost delegátovi pomocí zprávy change (resp. changing).

ev-mouse-down receiver sender clicked-obj button position

Pøeposílá událost delegátovi.


NOVÉ ZASÍLANÉ UDÁLOSTI

ev-change   receiver sender message changing-obj args 
ev-changing receiver sender message changing-obj args

Tyto události posílá objekt delegátovi, kdy u nìj dochází ke zmìnì. Událost
ev-changing bezprostøednì pøed zmìnou, ev-change bezprostøednì po (viz zprávu
send-with-change). Kromì standardních parametrù receiver a sender
(spoleènıch všem událostem), jsou dalšími parametry:
- message: zpráva, v dùsledku jejího pøijetí ke zmìnì dochází
- changing-obj: pøíjemce této zprávy, tj, objekt, u nìj dochází ke zmìnì
- args: argumenty, se kterımi byla zpráva odeslána (bez pøíjemce)
Vyhodnocením seznamu (message changing-obj . args) by se zopakovalo poslání
zprávy.

ev-mouse-down receiver sender clicked-obj button position

Poslána, pokud objekt zjistí, e na nìj nebo na podøízenı objekt uivatel 
klikl. Parametr clicked-obj je objekt, na kterı se kliklo pùvodnì (mùe to 
bıt podobjekt odesílajícího objektu; pak se hodnoty sender a clicked-obj 
liší). button je :left, :center, nebo :right. position je bod (instance tøídy
point), na kterı se kliklo.



TØÍDA SHAPE (OMG-OBJECT)
------------------------

Potomky tøídy shape jsou všechny tøídy grafickıch objektù. Sama není urèena k
vytváøení pøímıch instancí.


NOVÉ VLASTNOSTI

window    Okno, ve kterém je objekt umístìn, nebo nil. Typicky ho instance 
          pouívají pøi kreslení. Nastavovat ho smí pouze nadøízené objekty
shape-mg-window 
          mg-window okna window.
color, thickness, filledp     
          Grafické parametry. Metody nastavující tyto hodnoty zajišují
          signalizaci zmìn událostmi ev-changing a ev-change a zasílají
          objektu pomocnou zprávu do-set-color (-thickness, -filledp).
          Dìlají to pøi inkrementovaném vnitøním poèítadle, take v rámci
          obsluhy tìchto pomocnıch zpráv objekt další události o zmìnách
          neposílá. Metody set-color, set-thickness, set-filledp nejsou urèeny
          k pøepisování. Pøepisujte metody do-set-color atd.
solidp    Zda objekt pøijímá zprávu mouse-down. Ve tøídì shape je vdy t.
solid-shapes
          Seznam podobjektù (vèetnì objektu samého) s nastavenou vlastností
          solidp. Je-li solidp Pravda u u tohoto objektu, je to jednoprvkovı
          seznam s objektem samotnım. Jinak je to hodnota vlastnosti
          solid-subshapes.
solid-subshapes
          Seznam podobjektù (mimo objektu samého) s nastavenou vlastností
          solidp. Zjišuje se jen u objektù, které mají vlastnost solidp nil.
          Pokud má objekt vlastnost solidp nastavenu na Pravda, musí mít 
          implementovánu metodu solid-subshapes. Ve tøídì shape vede k chybì.

NOVÉ ZPRÁVY

do-set-color object value
do-set-thickness object value
do-set-filledp object value

Nastavují hodnoty pøíslušnıch vlastností. Jsou volány z metod set-color,
set-thickness, set-filledp tøídy shape. Tyto metody mohou potomci pøepsat a
modifikovat tak jejich chování. Nejsou urèeny k volání. 

move object dx dy
rotate object angle center
scale object coeff center

Realizují geometrické transformace objektu object. Ve tøídì shape zaøídí
signalizaci zmìn a zasílají pøíslušné do-zprávy. Bìhem jejich vykonávání je
signalizace zmìn potlaèena vnitøním poèítadlem.

do-move object dx dy
do-rotate object angle center
do-scale object coeff center

Potomci tøídy shape pøepisují tyto metody a implementují v nich pøíslušné
geometrické transformace. Tyto zprávy nejsou urèeny k pøímému volání; jsou
volány z metod move, rotate, scale tøídy shape, které vytváøí správné 
prostøedí pro hlášení zmìn. Ve tøídì shape metody nedìlají nic.

draw shape

Vykreslí shape do jejího okna. Typicky voláno nadøízenım objektem. Ve tøídì 
shape zasílá zprávy set-mg-params a do-draw.

set-mg-params shape

Nastaví kreslicí parametry okna knihovny micro-graphics, ve kterém je objekt 
umístìn, tak, aby mohl bıt pozdìji vykreslen. Ve tøídì shape nastavuje 
parametry :foreground, :filledp, :thickness podle hodnot vlastností color,
filledp a thickness (poøadì). Zasílá se z metody draw tøídy shape. Není nutné
volat jindy. Potomci mohou pøepsat.

do-draw shape

Vykreslí objekt shape do jeho okna. Mùe poèítat s tím, e grafické parametry
okna knihovny micro-graphics jsou u nastaveny (metodou set-mg-params).
Zasílá se z metody draw tøídy shape. Není nutné volat jindy. Potomci mohou 
pøepsat. Ve tøídì shape nedìlá nic.

contains-point-p shape point

Vrací logickou hodnotu "shape obsahuje point". Ve tøídì shape vrací nil.

mouse-down object button position

Objekt obdrí tuto zprávu od okna poté, co do nìj uivatel klikl myší. 
button je :left, :center, nebo :right, position bod. Lze se
spolehnout, e bod position je opravdu uvnitø objektu. Zprávu dostávají
pouze objekty s nastavenou vlastností solidp. Metoda tøídy
shape posílá událost ev-mouse-down s argumentem clicked-obj rovnım 
object.


TØÍDA POINT (SHAPE)
-------------------

Geometrickı bod s kartézskımi a polárními souøadnicemi. Kreslí se jako
vyplnìné koleèko.


NOVÉ VLASTNOSTI

x, y, r, phi  Souøadnice. Nastavení vyvolá hlášení o zmìnì.

NOVÉ ZPRÁVY

set-r-phi point r phi

Soubìné nastavení obou polárních souøadnic. Vyvolává hlášení o zmìnì.

PØEPSANÉ METODY

do-move point dx dy
do-rotate point angle center
do-scale point coeff center

Implementují geometrické transformace bodu.

set-mg-params point

Modifikuje zdìdìnou metodu tak, e nastavuje :filledp na T.

do-draw point

Vykreslí bod jako vyplnìné koleèko o polomìru rovném nastavené thickness.

contains-point-p point point2

Vrací true právì kdy je vzdálenost bodù <= (thickness point).


TØÍDA CIRCLE (SHAPE)
--------------------

Koleèka se støedem (instance tøídy point) a polomìrem. Støedu lze nastavovat
souøadnice a aplikovat na nìj transformace.

NOVÉ VLASTNOSTI

center   Støed. Instance tøídy point. Jen ke ètení.
radius   Polomìr.


PØEPSANÉ METODY

do-move circle dx dy
do-rotate circle angle center
do-scale circle coeff center

Implementují geometrické transformace kruhu.

contains-point-p circle point

Je-li (filledp circle) true, vrací true právì kdy je vzdálenost bodu point
od støedu <= (radius circle). Je-li (filledp circle) false, vrací true právì 
kdy point leí na krunici s polomìrem (radius circle) a støedem (center 
circle) o tloušce (thickness circle).


TØÍDA COMPOUND-SHAPE (SHAPE)
----------------------------

Pøedek tøíd grafickıch objektù, sloenıch z jinıch grafickıch objektù.

NOVÉ VLASTNOSTI

items   Seznam podobjektù. Pøi nastavování otestuje validitu nastavovanıch
        podobjektù (zprávou check-items), pøipraví hlášení zmìny pøed a po 
        nastavení a pošle zprávu do-set-items s inkrementovanım poèítadlem
        pro zmìny. Pøi ètení vrací kopii seznamu.


NOVÉ ZPRÁVY

check-item shape item

Otestuje, zda objekt item mùe bıt podobjektem sloeného objektu shape. Pokud
ne, vyvolá chybu. Ve tøídì compound-shape vyvolává chybu poøád (abstraktní
metoda), potomci metodu musí pøepsat.

check-items shape items

Otestuje, zda seznam items mùe bıt seznamem podobjektù objektu shape. Pokud
ne, vyvolá chybu. Ve tøídì compound-shape posílá zprávu check-item pro kadı
prvek seznamu items.

do-set-items shape value

Nastaví kopii seznamu value jako vlastnost items sloeného objektu shape.
Seznam u je provìøenı zprávou check-items. Není urèeno k volání. Je voláno z
metody set-items tøídy compound-shape po nastavení prostøedí pro hlášení zmìn.
Ve tøídì compound shape kromì vlastního nastavení vlastnosti items nastavuje
všem objektùm v seznamu vlastnosti window a delegate.

send-to-items shape message &rest arguments

Lze pouít, pokud chceme všem podobjektùm sloeného objektu shape poslat
tuté zprávu se stejnımi argumenty.


PØEPSANÉ METODY

do-move shape dx dy
do-rotate shape angle center
do-scale shape coeff center

Pomocí zprávy send-to-items pøepošle zprávu move (nebo rotate, nebo scale) 
všem podobjektùm.


TØÍDA PICTURE (COMPOUND-SHAPE)
------------------------------

Sloenı grafickı objekt, kterı se vykresluje tak, e postupnì vykreslí všechny
podobjekty.


PØEPSANÉ VLASTNOSTI

window   Pøi nastavování automaticky nastaví toté okno i všem podobjektùm


PØEPSANÉ METODY

check-item picture item

Vyvolá chybu, pokud item není typu shape.

do-draw picture

Pošle zprávu draw všem podobjektùm (v opaèném poøadí, aby se vykreslily zezadu
dopøedu)

contains-point-p picture point

Prochází podobjekty a pøeposílá jim zprávu contains-point-p. Pokud pro nìkterı
podobjekt je vısledek true, vrátí true. Jinak false.


TØÍDA POLYGON (COMPOUND-SHAPE)
------------------------------

Grafickı objekt sloenı z bodù. Vykresluje se jako polygon. Proti 
compound-shape má novou vlastnost: closedp.

NOVÉ VLASTNOSTI

closedp  Pøi filledp nastaveném na false urèuje, zda do polygonu patøí i
         úseèka spojující první a poslední bod. Pøi nastavování nachystá
         prostøedí hlášení zmìn a vlastní nastavení provede zasláním zprávy
         do-set-closedp.


NOVÉ ZPRÁVY

do-set-closedp polygon value

Vlastní nastavení vlastnosti closedp. Voláno z metody set-closedp tøídy
polygon, která pøipravuje prostøedí pro hlášení zmìn. Nevolat pøímo, pouze
pøepisovat.

PØEPSANÉ METODY

check-item polygon item

Vyvolá chybu, pokud item není bod.

set-mg-params polygon

Volá zdìdìnou metodu a pak nastavuje kreslicí parametr closedp.

do-draw polygon

Vykreslí polygon zavoláním mg:draw-polygon.

contains-point-p polygon point

Vrací, zda polygon obsahuje bod point. Bere v úvahu vlastnosti closedp,
filledp, thickness.


TØÍDA WINDOW (OMG-OBJECT)
------------------------

Instance reprezentují okna knihovny micro-graphics. Okno se otevøe automaticky
pøi vytváøení nové instance. Oknu lze nastavit barvu pozadí a vykreslovanı
grafickı objekt.


NOVÉ VLASTNOSTI

shape      Grafickı objekt vykreslovanı do okna. Pøi nastavení se nachystá
           prostøedí na hlášení zmìn a pak se zavolá do-set-shape. Potom
           se okno oznaèí k pøekreslení zprávou invalidate.
background Barva pozadí okna. Pøi nastavení se nachystá prostøedí na hlášení
           zmìn a pak se zavolá do-set-background. Potom se okno oznaèí k 
           pøekreslení zprávou invalidate.
mg-window  Odkaz na okno knihovny micro-graphics. Jen ke ètení.


NOVÉ ZPRÁVY

do-set-shape window shape

Vlastní nastavení vlastnosti shape. Po nastavení vlastnosti se objektu shape
nastaví vlastnost window a delegate na window a událost ev-change.

do-set-background window color

Vlastní nastavení vlastnosti background.

invalidate window

Posílá se oknu, pokud je tøeba ho pøekreslit. Oznaèí okno k pøekreslení a 
nìkdy pozdìji okno dostane zprávu redraw.

change window message changed-obj args

Zavolá zdìdìnou metodu a pak invalidate.

redraw window

Vymae okno barvou pozadí (vlastnost background) a pak vykreslí do okna objekt
uloenı ve vlastnosti shape tím, e mu pošle zprávu draw. Nevolat pøímo, 
pouívat zprávu invalidate.

install-callbacks window

Posílá se oknu jako souèást inicializace. Slouí k instalaci zpìtnıch
volání knihovny micro-graphics. Ve tøídì window instaluje zpìtná volání
:display a :mouse-down pomocí zpráv install-display-callback a
install-mouse-down-callback.

install-display-callback window
install-mouse-down-callback window

Nainstalují pøíslušná zpìtná volání.

window-mouse-down window button position

Tuto zprávu okno dostane, pokud do nìj uivatel klikne myší. Parametr
button je :left, :center, nebo :right, position je bod, urèující pozici myši
pøi kliknutí. Metoda ve tøídì window zjistí, zda se kliklo dovnitø grafického
objektu v oknì, kterı má nastavenu vlastnost solidp na Pravda. Pokud ano, 
pošle si zprávu mouse-down-inside-shape, jinak si pošle zprávu
mouse-down-no-shape. Není urèeno k pøímému volání.


PØIJÍMANÉ UDÁLOSTI

ev-change

Ve tøídì window pošle oknu zprávu invalidate, aby se vyvolalo jeho
pøekreslení. Volá zdìdìnou metodu.
|#

;;;
;;; Tøída omg-object
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


;;Funkce has-method-p zjišuje, zda existuje metoda pro danou
;;zprávu a dané argumenty. Není nutné jí rozumìt.
(defun has-method-p (object message arguments)
  (and (fboundp message)              ;je se symbolem message 
                                      ;svázána zpráva (funkce)?
       (compute-applicable-methods    ;vypoète seznam metod
        (symbol-function message)     ;pro zprávu svázanou s message
        (cons object arguments))))    ;s danımi argumenty


;; posílání událostí: send-event

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


;; základní události

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
;;; Tøída shape
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


;;; Práce s myší

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
;;; Tøída point
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


;; Práce s myší

;; Pomocné funkce (vzdálenost bodù)

(defun sqr (x)
  (expt x 2))

(defun point-dist (pt1 pt2)
  (sqrt (+ (sqr (- (x pt1) (x pt2)))
           (sqr (- (y pt1) (y pt2))))))

(defmethod contains-point-p ((shape point) point)
  (<= (point-dist shape point) 
      (thickness shape)))


;;;
;;; Tøída circle
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


;; Práce s myší

(defmethod contains-point-p ((circle circle) point)
  (let ((dist (point-dist (center circle) point))
        (half-thickness (/ (thickness circle) 2)))
    (if (filledp circle)
        (<= dist (radius circle))
      (<= (- (radius circle) half-thickness)
          dist
          (+ (radius circle) half-thickness)))))


;;;
;;; Tøída compound-shape
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
;;; Tøída picture
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

;; Práce s myší

(defmethod solidp ((pic picture))
  nil)

(defmethod solid-subshapes ((shape picture))
  (mapcan 'solid-shapes (items shape)))

(defmethod contains-point-p ((pic picture) point)
  (find-if (lambda (item)
	     (contains-point-p item point))
	   (items pic)))


;;;
;;; Tøída polygon
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
;; contains-point-p pro polygon vyuívá funkci
;; mg:point-in-polygon-p knihovny micro-graphics.
;;

(defmethod contains-point-p ((poly polygon) point)
  (mg:point-in-polygon-p (x point) (y point) 
                         (closedp poly)
                         (filledp poly) 
                         (thickness poly)
                         (polygon-coordinates poly)))

;;;
;;; Tøída window
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


;; Klikání

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


;8.3. Vylepšete tøídu lockable-window tak, aby okna bránila pouze zmìnám objektù
;danıch typù. Zaveïte vlastnost locked-types, která bude obsahovat seznam
;typù (tøíd) objektù, kterım budou zmìny zakázány, pokud je nastavena vlastnost
;lockedp na Pravda. Defaultní hodnota vlastnosti bude (shape), take defaultnì
;budou pøi lockedp rovném Pravda zakázány zmìny všech objektù.

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




