;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 05_bulls-eye.lisp - příklad ke kapitole 5
;;;;

#|

DOKUMENTACE
-----------

(Jde o uživatelskou dokumentaci. U tříd dokumentujeme vlastnosti a zprávy, 
které jsou určeny uživateli. Interní části tříd nedokumentujeme.)

Třída bulls-eye je potomkem třídy picture. Zobrazuje daný počet soustředných
kruhů nebo čtverců střídavé barvy - terč. Vlastnosti terče lze nastavovat.

UPRAVENÉ ZDĚDĚNÉ VLASTNOSTI

items:      Nenastavovat, je určena pouze ke čtení.

NOVÉ VLASTNOSTI

center:     Geometrický střed, instance třídy point. Defaultně o souřadnicích
            148.5 a 105. Jen ke čtení.
radius:     Poloměr. Pokud je terč čtvercový, je poloměr polovina délky 
            úhlopříčky. Defaultní hodnota: 80.
item-count: Počet kruhů nebo čtverců. Defaultní hodnota je 7.
squarep:    Booleovská hodnota určující, zda je terč kruhový, nebo čtvercový.
            Default: nil.

UPRAVENÉ ZDĚDĚNÉ ZPRÁVY

žádné

NOVÉ ZPRÁVY

žádné.

OMEZENÍ (demonstrována dole v příkladech)

- Vlastnost items je pouze ke čtení a jakákoliv manipulace s jejími prvky má
nedefinované následky. Totéž platí pro vlastnost center.
- Instance si nepamatují své natočení (způsobené zprávou rotate)

|#


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Funkce na výpočet obsahu (procedurální)
;;;

(defun make-bulls-eye-square (radius)
  (let ((tl (make-instance 'point))
        (tr (make-instance 'point))
        (bl (make-instance 'point))
        (br (make-instance 'point))
        (half-side (/ radius (sqrt 2)))
        (result (make-instance 'polygon)))
    (set-items result
               (list (move tl (- half-side) (- half-side))
                     (move tr half-side (- half-side))
                     (move br half-side half-side)
                     (move bl (- half-side) half-side)))))

(defun make-bulls-eye-circle (radius)
  (set-radius (make-instance 'circle) radius))

(defun make-bulls-eye-elem (radius squarep)
  (if squarep 
      (make-bulls-eye-square radius)
    (make-bulls-eye-circle radius)))

(defun make-bulls-eye-items (x y radius count squarep)
  (let ((items '())
        (step (/ radius count))
	(blackp t)
        elem)
    (dotimes (i count)
      (setf elem (set-filledp 
                  (set-color 
                   (make-bulls-eye-elem (- radius (* i step)) squarep)
                   (if blackp :black :light-blue)) 
                  t))
      (move elem x y)
      (setf items (cons elem items)
            blackp (not blackp)))
    items))

;;;
;;; Vlastní třída bulls-eye
;;;

#|
Třída je implementována tak, že vlastnosti center, radius, item-count a squarep
jsou všechny uloženy ve slotech. Pokud uživatel některou z těchto vlastností
změní, hodnota příslušného slotu se aktualizuje a pak se zavolá obecná metoda
be-recompute-items, která vytvoří a nastaví nopvý seznam items na základě
hodnot slotů.

Možná by bylo lepší jiné řešení: všechny čtyři sloty zrušit a hodnoty vlastností 
zjišťovat ze struktury obrázku. Některé věci by se zjednodušily, např. by nebylo
nutné přepisovat metody move, scale, rotate.
|#

(defclass bulls-eye (picture)
  ((center :initform (make-instance 'point))
   (radius :initform 80) 
   (item-count :initform 7)
   (squarep :initform nil)))

;;;
;;; Vlastnosti
;;;

;; Vlastnost center je jen ke čtení
(defmethod center ((be bulls-eye))
  (slot-value be 'center))

(defmethod radius ((be bulls-eye))
  (slot-value be 'radius))

(defmethod set-radius ((be bulls-eye) value)
  (setf (slot-value be 'radius) value)
  (be-recompute-items be))

(defmethod item-count ((be bulls-eye))
  (slot-value be 'item-count))

(defmethod set-item-count ((be bulls-eye) value)
  (setf (slot-value be 'item-count) value)
  (be-recompute-items be))

(defmethod squarep ((be bulls-eye))
  (slot-value be 'squarep))

(defmethod set-squarep ((be bulls-eye) value)
  (setf (slot-value be 'squarep) value)
  (be-recompute-items be))

(defmethod be-recompute-items ((be bulls-eye))
  (set-items be 
             (make-bulls-eye-items (x (center be))
                                   (y (center be))
                                   (radius be)
                                   (item-count be)
                                   (squarep be))))

;;;
;;; Transformace
;;;

(defmethod move ((be bulls-eye) dx dy)
  (move (center be) dx dy)
  (call-next-method))

(defmethod rotate ((be bulls-eye) angle center)
  (rotate (center be) angle center)
  (call-next-method))

(defmethod scale ((be bulls-eye) coeff center)
  (scale (center be) coeff center)
  (setf (slot-value be 'radius) 
        (* (slot-value be 'radius) coeff))
  (call-next-method))



;;;
;;; Inicializace
;;;

(defmethod initialize-instance ((be bulls-eye) &key)
  (call-next-method)
  (move (center be) 148.5 105)
  (be-recompute-items be))

#|
;;; Testy 
;;; vyhodnocujte výrazy (F8) jeden po druhém nebo na přeskáčku

(setf w (make-instance 'window))
(setf be (make-instance 'bulls-eye))
(set-shape w be)
(redraw w)

(set-radius be 100)
(redraw w)

(set-item-count be 5)
(redraw w)

(set-squarep be t)
(redraw w)
(set-squarep be nil)
(redraw w)

;; Ukázka omezení:

(set-color (first (items be)) :red)
(redraw w)

(set-radius be 80)
(redraw w)

(rotate be (/ pi 4) (center be))
(redraw w)

(set-item-count be 4)
(redraw w)

|#

