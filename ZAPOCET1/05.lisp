;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Zdrojovı soubor k uèebnímu textu M. Krupka: Objektové programování
;;;;
;;;; Kapitola 5, Dìdiènost
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

TØÍDA SHAPE
-----------

Potomky tøídy shape jsou všechny tøídy grafickıch objektù. Sama není urèena k
vytváøení pøímıch instancí.


NOVÉ VLASTNOSTI

window    Okno, ve kterém je objekt umístìn, nebo nil. Typicky ho instance 
          pouívají pøi kreslení. Nastavovat ho smí pouze nadøízené objekty
shape-mg-window 
          mg-window okna window.
color, thickness, filledp     
          Grafické parametry: barva, tlouška pera, zda kreslit vyplnìné.


NOVÉ ZPRÁVY

move object dx dy
rotate object angle center
scale object coeff center

Realizují geometrické transformace objektu object. Ve tøídì shape nedìlají 
nic. Potomci by je mìli pøepsat a pøíslušné transformace implementovat.

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


TØÍDA POINT (SHAPE)
-------------------

Geometrickı bod s kartézskımi a polárními souøadnicemi. Kreslí se jako
vyplnìné koleèko.


NOVÉ VLASTNOSTI

x, y, r, phi  Kartézské a polární souøadnice.

NOVÉ ZPRÁVY

set-r-phi point r phi

Soubìné nastavení obou polárních souøadnic.

PØEPSANÉ METODY

move point dx dy
rotate point angle center
scale point coeff center

Implementují geometrické transformace bodu.

set-mg-params point

Modifikuje zdìdìnou metodu tak, e nastavuje :filledp na T.

do-draw point

Vykreslí bod jako vyplnìné koleèko o polomìru rovném nastavené thickness.


TØÍDA CIRCLE (SHAPE)
--------------------

Koleèka se støedem (instance tøídy point) a polomìrem. Støedu lze nastavovat
souøadnice a aplikovat na nìj transformace.

NOVÉ VLASTNOSTI

center   Støed. Instance tøídy point. Jen ke ètení.
radius   Polomìr.


PØEPSANÉ METODY

move circle dx dy
rotate circle angle center
scale circle coeff center

Implementují geometrické transformace kruhu.


TØÍDA COMPOUND-SHAPE (SHAPE)
----------------------------

Pøedek tøíd grafickıch objektù, sloenıch z jinıch grafickıch objektù.

NOVÉ VLASTNOSTI

items   Seznam podobjektù. Pøi nastavování otestuje validitu nastavovanıch
        podobjektù (zprávou check-items) a uloí kopii seznamu. Pøi ètení 
        rovnì vrací kopii.


NOVÉ ZPRÁVY

check-item shape item

Otestuje, zda objekt item mùe bıt podobjektem sloeného objektu shape. Pokud
ne, vyvolá chybu. Ve tøídì compound-shape vyvolává chybu poøád, potomci metodu 
musí pøepsat.

check-items shape items

Otestuje, zda seznam items mùe bıt seznamem podobjektù objektu shape. Pokud
ne, vyvolá chybu. Ve tøídì compound-shape posílá zprávu check-item pro kadı
prvek seznamu items.

set-items shape value

Nastaví kopii seznamu value jako vlastnost items sloeného objektu shape.
Pøedtím seznam provìøí zprávou check-items. Kromì vlastního nastavení vlastnosti 
items nastavuje všem objektùm v seznamu vlastnost window na (window shape).

send-to-items shape message &rest arguments

Lze pouít, pokud chceme všem podobjektùm sloeného objektu shape poslat
tuté zprávu se stejnımi argumenty. Klíèové slovo &rest zatím není nutné
pøesnì chápat. Umoòuje pøedání libovolného poètu argumentù.


PØEPSANÉ METODY

move shape dx dy
rotate shape angle center
scale shape coeff center

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


TØÍDA POLYGON (COMPOUND-SHAPE)
------------------------------

Grafickı objekt sloenı z bodù. Vykresluje se jako polygon. Proti 
compound-shape má novou vlastnost: closedp.

NOVÉ VLASTNOSTI

closedp  Pøi filledp nastaveném na false urèuje, zda do polygonu patøí i
         úseèka spojující první a poslední bod.


PØEPSANÉ METODY

check-item polygon item

Vyvolá chybu, pokud item není bod.

set-mg-params polygon

Volá zdìdìnou metodu a pak nastavuje kreslicí parametr closedp.

do-draw polygon

Vykreslí polygon zavoláním mg:draw-polygon.


TØÍDA WINDOW (MG-OBJECT)
------------------------

Instance reprezentují okna knihovny micro-graphics. Okno se otevøe automaticky
pøi vytváøení nové instance. Oknu lze nastavit barvu pozadí a vykreslovanı
grafickı objekt.


NOVÉ VLASTNOSTI

shape      Grafickı objekt vykreslovanı do okna.
background Barva pozadí okna.
mg-window  Odkaz na okno knihovny micro-graphics. Jen ke ètení.


NOVÉ ZPRÁVY

redraw window

Vymae okno barvou pozadí (vlastnost background) a pak vykreslí do okna objekt
uloenı ve vlastnosti shape tím, e mu pošle zprávu draw. Nevolat pøímo, 
pouívat zprávu invalidate.

|#


;;;
;;; Tøída shape
;;;

(defclass shape ()
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

(defmethod set-color ((shape shape) value) 
  (setf (slot-value shape 'color) value)
  shape)

(defmethod thickness ((shape shape)) 
  (slot-value shape 'thickness)) 

(defmethod set-thickness ((shape shape) value) 
  (setf (slot-value shape 'thickness) value)
  shape) 

(defmethod filledp ((shape shape))
  (slot-value shape 'filledp))

(defmethod set-filledp ((shape shape) value)
  (setf (slot-value shape 'filledp) value)
  shape)

(defmethod move ((shape shape) dx dy)
  shape)

(defmethod rotate ((shape shape) angle center)
  shape)

(defmethod scale ((shape shape) coeff center)
  shape)

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

(defmethod set-x ((point point) value)
  (unless (typep value 'number)
    (error "x coordinate of a point should be a number"))
  (setf (slot-value point 'x) value)
  point)

(defmethod set-y ((point point) value)
  (unless (typep value 'number)
    (error "y coordinate of a point should be a number"))
  (setf (slot-value point 'y) value)
  point)

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

(defmethod set-r-phi ((point point) r phi) 
  (set-x point (* r (cos phi)))
  (set-y point (* r (sin phi)))
  point)

(defmethod set-r ((point point) value) 
  (set-r-phi point value (phi point)))

(defmethod set-phi ((point point) value) 
  (set-r-phi point (r point) value))

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

(defmethod move ((pt point) dx dy)
  (set-x pt (+ (x pt) dx))
  (set-y pt (+ (y pt) dy))
  pt)

(defmethod rotate ((pt point) angle center)
  (let ((cx (x center))
        (cy (y center)))
    (move pt (- cx) (- cy))
    (set-phi pt (+ (phi pt) angle))
    (move pt cx cy)
    pt))

(defmethod scale ((pt point) coeff center)
  (let ((cx (x center))
        (cy (y center)))
    (move pt (- cx) (- cy))
    (set-r pt (* (r pt) coeff))
    (move pt cx cy)
    pt))


;;;
;;; Tøída circle
;;;

(defclass circle (shape) 
  ((center :initform (make-instance 'point)) 
   (radius :initform 1)))

(defmethod radius ((c circle))
  (slot-value c 'radius))

(defmethod set-radius ((c circle) value)
  (when (< value 0)
    (error "Circle radius should be a non-negative number"))
  (setf (slot-value c 'radius) value)
  c)

(defmethod center ((c circle))
  (slot-value c 'center))

(defmethod do-draw ((c circle))
  (mg:draw-circle (shape-mg-window c)
                  (x (center c))
                  (y (center c))
                  (radius c))
  c)

(defmethod move ((c circle) dx dy)
  (move (center c) dx dy)
  c)

(defmethod rotate ((c circle) angle center)
  (rotate (center c) angle center)
  c)

(defmethod scale ((c circle) coeff center)
  (scale (center c) coeff center)
  (set-radius c (* (radius c) coeff))
  c)


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
  (error "Method should be rewritten."))

(defmethod check-items ((shape compound-shape) item-list)
  (dolist (item item-list)
    (check-item shape item))
  shape)

(defmethod set-items ((shape compound-shape) value)
  (check-items shape value)
  (setf (slot-value shape 'items) (copy-list value))
  shape)

(defmethod move ((shape compound-shape) dx dy)
  (send-to-items shape 'move dx dy)
  shape)

(defmethod rotate ((shape compound-shape) angle center)
  (send-to-items shape 'rotate angle center)
  shape)

(defmethod scale ((shape compound-shape) coeff center)
  (send-to-items shape 'scale coeff center)
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

(defmethod set-items ((pic picture) items)
  (call-next-method)
  (send-to-items pic 'set-window (window pic)))

(defmethod draw ((pic picture))
  (dolist (item (reverse (items pic)))
    (draw item))
  pic)

(defmethod set-window ((shape picture) value)
  (send-to-items shape 'set-window value)
  (call-next-method))


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

(defmethod set-closedp ((p polygon) value)
  (setf (slot-value p 'closedp) value)
  p)

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


;;;
;;; Tøída window
;;;

(defclass window ()
  ((mg-window :initform (mg:display-window))
   (shape :initform nil)
   (background :initform :white)))

(defmethod mg-window ((window window))
  (slot-value window 'mg-window))

(defmethod shape ((w window))
  (slot-value w 'shape))

(defmethod set-shape ((w window) shape)
  (when shape
    (set-window shape w))
  (setf (slot-value w 'shape) shape)
  w)

(defmethod background ((w window))
  (slot-value w 'background))

(defmethod set-background ((w window) color)
  (setf (slot-value w 'background) color)
  w)

(defmethod redraw ((window window))
  (let ((mgw (mg-window window)))
    (mg:set-param mgw :background (background window))
    (mg:clear mgw)
    (when (shape window)
      (draw (shape window))))
  window)



