;;;;;;;;;DOKUMENTACE

#|
TRIDA SPINNER

VLASTNOSTI:

- counter-value - aktualne nastavena hodnota ve spinneru (default: 0)
  po nastaveni zasila udalost - counter-value-updated sender counter-value

- max-counter-value - maximalni hodnota, ktera pujde spinnerem nastavit (default: 100)

- min-counter-value - minimalni hodnota, ktera pujde spinnerem nastavit (default: 0)

- counter-step - krok, po kterem se hodnoty ve spinneru budou nastavovat (default: 1)

- value-visible-p - urcuje, jestli se bude hodnota vedle sipek vypisovat, nebo ne

ZPRAVY:

- update text - pokud je value-visible-p - t - nastavi zobrazovanou hodnotu na aktualni hodnotu pocitadle
                                         - nil - nastavi zobrazovanou hodnotu na prazdny retezec
              -uzivatel nepouziva

- ev-mouse-down - po kliknuti na horni nebo spodni sipku zvysi/snizi pocitadlo(pokud je to mozne)
                - pokud by se counter-value spinneru melo dostat nastavenym krokem
                  nad max-counter-value, nastavi se counter-value na max-counter-value, analogicky
                  pro min-counter-value




TRIDA TEST-PICTURE

ZPRAVY: 

- update-counter-text - nastavi hodnotu pocitadla provedenych zmen uvnitr v okne, uzivatel nepouziva

PRIJIMANE UDALOSTI:

- counter-value-updated sender new-value - udalost zasilana spinnerem v obrazku,
  prijima counter-value spinneru

- ev-button-click sender - udalost zasilana tlacitky - ovlada zobrazeni hodnoty vedle spinneru

|#

;pomocne procedury
(defun make-point (x y)
  (set-y (set-x (make-instance 'point) x) y))

(defun make-up-triangle ()
  (let ((p (make-instance 'polygon)))
    (set-filledp (set-closedp (set-items p (list (make-point 0 10)
                                                 (make-point 11 10)
                                                 (make-point 6 0))) t) t)
    p))

(defun make-down-triangle ()
    (let ((p (make-instance 'polygon)))
    (set-filledp (set-closedp (set-items p (list (make-point 0 0)
                                                 (make-point 11 0)
                                                 (make-point 6 10))) t) t)
    p))


;;;;;;spinner
(defclass spinner (picture)
  ((counter-value :initform 0)
   (max-counter-value :initform 100)
   (min-counter-value :initform 0)
   (counter-step :initform 1)
   (value-visible-p :initform t)))

(defmethod counter-value ((s spinner))
  (slot-value s 'counter-value))

(defmethod set-counter-value ((s spinner) val)
  (when (or (> val (max-counter-value s)) (< val (min-counter-value s)))
    (error "Value is not within bounds"))
  (when (not (eql val (counter-value s)))
      (setf (slot-value s 'counter-value) val)
      (update-text s)
      (send-event s 'ev-spinner-value-updated (counter-value s)))
  s)

;(defmethod change ((s spinner) message changed-obj args)
;  (update-text s)
;  (call-next-method))



(defmethod max-counter-value ((s spinner))
  (slot-value s 'max-counter-value))

(defmethod set-max-counter-value ((s spinner) val)
  (setf (slot-value s 'max-counter-value) val)
  s)

(defmethod min-counter-value ((s spinner))
  (slot-value s 'min-counter-value))

(defmethod set-min-counter-value ((s spinner) val)
  (setf (slot-value s 'min-counter-value) val)
  s)

(defmethod counter-step ((s spinner))
  (slot-value s 'counter-step))

(defmethod set-counter-step ((s spinner) val)
  (setf (slot-value s 'counter-step) val)
  s)


;;;
(defmethod value-visible-p ((s spinner))
  (slot-value s 'value-visible-p))

(defmethod set-value-visible-p ((s spinner) val)
  (setf (slot-value s 'value-visible-p) val)
  (update-text s))
;;;


(defmethod initialize-instance ((s spinner) &key)
  (call-next-method)
  (set-items s (list (make-up-triangle)
                     (move (make-down-triangle) 0 15)
                     (move (set-text (make-instance 'text-shape)
                                     (format nil "~s" (counter-value s))) 15 17))))

;pomocne metody
(defmethod up-arrow ((s spinner))
  (first (items s)))

(defmethod down-arrow ((s spinner))
  (second (items s)))

(defmethod counter-text ((s spinner))
  (third (items s)))

(defmethod update-text ((s spinner))
  ;(inc-change-level s)
  (if (value-visible-p s)
      (set-text (counter-text s) (format nil "~s" (counter-value s)))
    (set-text (counter-text s) ""))
  s)


(defmethod ev-mouse-down ((s spinner) sender clicked button position)
  (when (eql clicked (up-arrow s))
      (let ((newcount (+ (counter-value s) (counter-step s))))
        (if (> newcount (max-counter-value s))
            (set-counter-value s (max-counter-value s))
          (set-counter-value s newcount))
        (update-text s)))
  (when (eql clicked (down-arrow s))
    (let ((newcount (- (counter-value s) (counter-step s))))
      (if (< newcount (min-counter-value s))
          (set-counter-value s (min-counter-value s))
        (set-counter-value s newcount))
      (update-text s))))
    


;;;;test-picture
(defclass test-picture (picture)
  ((counter-changes :initform 0
                    :accessor counter-changes)))

(defmethod initialize-instance ((td test-picture) &key)
  (call-next-method)
  (set-items td (list (set-counter-value (set-counter-step (make-instance 'spinner) 6) 20)
                      (move (set-filledp (set-radius (make-instance 'circle) 20) t) 150 100)
                      (move (set-text (make-instance 'text-shape)
                                      (format nil "Number of counter changes: ~s" (counter-changes td)))
                            70 17)
                      (move (set-text (make-instance 'text-shape)
                                      "Spinner value visible") 5 170)
                      (move (set-button-text (make-instance 'button) "Yes") 10 195)
                      (move (set-button-text (make-instance 'button) "No") 70 195))))

;nastavi aktualni pocet do text-shapu
(defmethod update-counter-text ((td test-picture))
  (set-text (third (items td)) (format nil "Number of counter changes: ~s" (counter-changes td))))

;udalost zasilana spinnerem - nastavi radius circle podle hodnoty spinneru
(defmethod ev-spinner-value-updated ((td test-picture) sender new-value)
  (set-radius (second (items td)) new-value)
  (incf (counter-changes td))
  (update-counter-text td))

;udalost zasilana tlacitky - nastavuje viditelnost hodnoty vedle spinneru
(defmethod ev-button-click ((td test-picture) sender)
  (when (eql sender (fifth (items td)))
    (set-value-visible-p (first (items td)) t))
  (when (eql sender (sixth (items td)))
    (set-value-visible-p (first (items td)) nil)))