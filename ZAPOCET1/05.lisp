;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; Zdrojov� soubor k u�ebn�mu textu M. Krupka: Objektov� programov�n�
;;;;
;;;; Kapitola 5, D�di�nost
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

T��DA SHAPE
-----------

Potomky t��dy shape jsou v�echny t��dy grafick�ch objekt�. Sama nen� ur�ena k
vytv��en� p��m�ch instanc�.


NOV� VLASTNOSTI

window    Okno, ve kter�m je objekt um�st�n, nebo nil. Typicky ho instance 
          pou��vaj� p�i kreslen�. Nastavovat ho sm� pouze nad��zen� objekty
shape-mg-window 
          mg-window okna window.
color, thickness, filledp     
          Grafick� parametry: barva, tlou��ka pera, zda kreslit vypln�n�.


NOV� ZPR�VY

move object dx dy
rotate object angle center
scale object coeff center

Realizuj� geometrick� transformace objektu object. Ve t��d� shape ned�laj� 
nic. Potomci by je m�li p�epsat a p��slu�n� transformace implementovat.

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


T��DA POINT (SHAPE)
-------------------

Geometrick� bod s kart�zsk�mi a pol�rn�mi sou�adnicemi. Kresl� se jako
vypln�n� kole�ko.


NOV� VLASTNOSTI

x, y, r, phi  Kart�zsk� a pol�rn� sou�adnice.

NOV� ZPR�VY

set-r-phi point r phi

Soub�n� nastaven� obou pol�rn�ch sou�adnic.

P�EPSAN� METODY

move point dx dy
rotate point angle center
scale point coeff center

Implementuj� geometrick� transformace bodu.

set-mg-params point

Modifikuje zd�d�nou metodu tak, �e nastavuje :filledp na T.

do-draw point

Vykresl� bod jako vypln�n� kole�ko o polom�ru rovn�m nastaven� thickness.


T��DA CIRCLE (SHAPE)
--------------------

Kole�ka se st�edem (instance t��dy point) a polom�rem. St�edu lze nastavovat
sou�adnice a aplikovat na n�j transformace.

NOV� VLASTNOSTI

center   St�ed. Instance t��dy point. Jen ke �ten�.
radius   Polom�r.


P�EPSAN� METODY

move circle dx dy
rotate circle angle center
scale circle coeff center

Implementuj� geometrick� transformace kruhu.


T��DA COMPOUND-SHAPE (SHAPE)
----------------------------

P�edek t��d grafick�ch objekt�, slo�en�ch z jin�ch grafick�ch objekt�.

NOV� VLASTNOSTI

items   Seznam podobjekt�. P�i nastavov�n� otestuje validitu nastavovan�ch
        podobjekt� (zpr�vou check-items) a ulo�� kopii seznamu. P�i �ten� 
        rovn� vrac� kopii.


NOV� ZPR�VY

check-item shape item

Otestuje, zda objekt item m��e b�t podobjektem slo�en�ho objektu shape. Pokud
ne, vyvol� chybu. Ve t��d� compound-shape vyvol�v� chybu po��d, potomci metodu 
mus� p�epsat.

check-items shape items

Otestuje, zda seznam items m��e b�t seznamem podobjekt� objektu shape. Pokud
ne, vyvol� chybu. Ve t��d� compound-shape pos�l� zpr�vu check-item pro ka�d�
prvek seznamu items.

set-items shape value

Nastav� kopii seznamu value jako vlastnost items slo�en�ho objektu shape.
P�edt�m seznam prov��� zpr�vou check-items. Krom� vlastn�ho nastaven� vlastnosti 
items nastavuje v�em objekt�m v seznamu vlastnost window na (window shape).

send-to-items shape message &rest arguments

Lze pou��t, pokud chceme v�em podobjekt�m slo�en�ho objektu shape poslat
tut� zpr�vu se stejn�mi argumenty. Kl��ov� slovo &rest zat�m nen� nutn�
p�esn� ch�pat. Umo��uje p�ed�n� libovoln�ho po�tu argument�.


P�EPSAN� METODY

move shape dx dy
rotate shape angle center
scale shape coeff center

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


T��DA POLYGON (COMPOUND-SHAPE)
------------------------------

Grafick� objekt slo�en� z bod�. Vykresluje se jako polygon. Proti 
compound-shape m� novou vlastnost: closedp.

NOV� VLASTNOSTI

closedp  P�i filledp nastaven�m na false ur�uje, zda do polygonu pat�� i
         �se�ka spojuj�c� prvn� a posledn� bod.


P�EPSAN� METODY

check-item polygon item

Vyvol� chybu, pokud item nen� bod.

set-mg-params polygon

Vol� zd�d�nou metodu a pak nastavuje kreslic� parametr closedp.

do-draw polygon

Vykresl� polygon zavol�n�m mg:draw-polygon.


T��DA WINDOW (MG-OBJECT)
------------------------

Instance reprezentuj� okna knihovny micro-graphics. Okno se otev�e automaticky
p�i vytv��en� nov� instance. Oknu lze nastavit barvu pozad� a vykreslovan�
grafick� objekt.


NOV� VLASTNOSTI

shape      Grafick� objekt vykreslovan� do okna.
background Barva pozad� okna.
mg-window  Odkaz na okno knihovny micro-graphics. Jen ke �ten�.


NOV� ZPR�VY

redraw window

Vyma�e okno barvou pozad� (vlastnost background) a pak vykresl� do okna objekt
ulo�en� ve vlastnosti shape t�m, �e mu po�le zpr�vu draw. Nevolat p��mo, 
pou��vat zpr�vu invalidate.

|#


;;;
;;; T��da shape
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
;;; T��da point
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
;;; T��da circle
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
;;; T��da picture
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
;;; T��da window
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



