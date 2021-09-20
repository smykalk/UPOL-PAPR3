#|

DOKUMENTACE
-----------

TRIDA SEMAPHORE
---------------
Instance jsou semafory, ktere se budou vykreslovat do okna micro-graphics.
Instance se inicializuji jako semafor pro vozidla do leveho horniho rohu (x=0, y=0).

VLASTNOSTI
----------
semaphore-type     Urcuje typ semaforu, mozne typy jsou specifikovany 
                   v globalni promenne *semaphore-types* (v zakladu :pedestrian nebo :vehicle)

phase-count        Pocet fazi daneho semaforu, pouze pro cteni

semaphore-phase    Cislo faze, ve ktere se dany semafor nachazi, faze jsou specifikovany
                   v globalni promenne *semaphore-types*


ZPRAVY
------
next-phase semaphore     Presune semafor do dalsi faze




TRIDA CROSSROADS
---------------- 
Instance predstavuji obrazky krizovatky, jejich obsahem mohou byt semafory a dalsi graficke objekty.

VLASTNOSTI
----------
semaphores   Vrati seznam semaforu, ktere dana krizovatka obsahuje, pouze pro cteni

crossroads-phase    Cislo faze, ve ktere se dana krizovatka nachazi, faze jsou urceny programem

phase-count   Pocet fazi dane krizovatky, urceno programem, pouze pro cteni

program      Program dane krizovatky ve tvaru napr. ((0 2 1) (0 1 2)) - Druhy semafor krizovatky
             v jeji nulte fazi je ve druhe fazi.


ZPRAVY
------
next-phase cr    Presune krizovatku do dalsi faze

set-semaphores-by-program cr   Nastavi faze semaforu krizovatky podle jeji aktualni faze, pouziti
                               pri zmene typu semaforu v krizovatce (jeho faze se po zmene typu
                               nastavi na 0)
                             


|#

;;;;
;;;;TRIDA SEMAPHORE
;;;;

;  (:typ semaforu (barvy jednotlivych svetel) ((faze 1) (faze 2) ....))
(defvar *semaphore-types*
  '(:vehicle (:red :orange :green) ((t nil nil) (t t nil) (nil nil t) (nil t nil))
    :pedestrian (:red :green) ((t nil) (nil t))))


(defclass semaphore (picture)
  ((semaphore-type :initform nil)
   (semaphore-phase :initform nil)))

;;;;pomocne metody pro "ram"(polygon ohranicujici semafor) a svetla semaforu
(defmethod sem-frame ((sem semaphore))
  (car (items sem)))

(defmethod sem-lights ((sem semaphore))
  (cdr (items sem)))

;;;;typ semaforu nastavitelny podle obsahu globalni promenne *semaphore-types*
(defmethod semaphore-type ((sem semaphore))
  (slot-value sem 'semaphore-type))

(defmethod set-semaphore-type ((sem semaphore) value)
  (when (eql (find value *semaphore-types*) nil)
    (error "Unknown type of semaphore!"))
  (let ((dx (if (not (null (items sem)))
                (x (car (items (car (items sem)))))
              0))
        (dy (if (not (null (items sem)))
                (y (car (items (car (items sem)))))
              0)))
  (setf (slot-value sem 'semaphore-type) value)
  (set-items sem (build-semaphore value))
  (set-semaphore-phase sem 0)
  (move sem dx dy))
  sem)

;;;;pocet fazi semaforu - pocita se z fazi v glob. promenne *semaphore-types*
(defmethod phase-count ((sem semaphore))
  (length (phases (semaphore-type sem))))

;;;;
(defmethod semaphore-phase ((sem semaphore))
  (slot-value sem 'semaphore-phase))

(defmethod set-semaphore-phase ((sem semaphore) value)
  (when (or (< value 0) (> value (- (phase-count sem) 1)))
    (error "Incorrect value! (must be between ~a and ~a)" 0 (- (phase-count sem) 1)))
  (setf (slot-value sem 'semaphore-phase) value)
  (update-semaphore sem)
  sem)

(defmethod next-phase ((sem semaphore))
  (if (<= (+ (semaphore-phase sem) 1) (- (phase-count sem) 1))
      (set-semaphore-phase sem (+ (semaphore-phase sem) 1))
    (set-semaphore-phase sem 0))
  sem)

;;;;
(defmethod update-semaphore ((sem semaphore))
  (let ((phase (nth (semaphore-phase sem) (phases (semaphore-type sem))))
        (n 0))
    (dolist (value phase)
      (set-onp (nth n (sem-lights sem)) value)
      (incf n)))
  sem)
  
;;;;
(defmethod initialize-instance ((sem semaphore) &key)
  (call-next-method)
  (set-semaphore-type sem :vehicle)
  sem)




;;;;POMOCNE FUNKCE

(defun phases (key)
  (caddr (member key *semaphore-types*)))

(defun lights (key)
  (cadr (member key *semaphore-types*)))

;vytvori "ram" semaforu
(defun build-frame (key)
  (let ((poly (make-instance 'polygon))
        (nlights (length (lights key))))
    (set-items poly (list (set-y (set-x (make-instance 'point) 0) 0)
                          (set-y (set-x (make-instance 'point) 24) 0)
                          (set-y (set-x (make-instance 'point) 24) (+ (* nlights 22) 1))
                          (set-y (set-x (make-instance 'point) 0) (+ (* nlights 22) 1))))
    poly))

;vytvori seznam svetel semaforu
(defun build-lights (key)
  (let ((n 0)
        (light-list '()))
    (dolist (light (lights key))
      (setf light-list (cons (move (move (set-on-color (set-radius (make-instance 'light) 10) light) 12 12) 0 (* n 21)) light-list))
      (incf n))
    (reverse light-list)))

;vytvori seznam prvku semaforu (polygon + svetla)
(defun build-semaphore (key)
  (cons (build-frame key) (build-lights key)))




;;;;
;;;;TRIDA CROSSROADS
;;;;

(defclass crossroads (picture)
  ((crossroads-phase :initform 0)
   (program :initform '())))


(defmethod semaphores ((cr crossroads))
  (find-semaphores cr (items cr)))

(defmethod find-semaphores ((cr crossroads) items)
  (let ((semaphores-list '()))
    (dolist (item items)
      (when (typep item 'semaphore)
        (setf semaphores-list (append semaphores-list (cons item nil))))
      (when (and (typep item 'picture) (not (typep item 'crossroads)))
        (setf semaphores-list (append semaphores-list (find-semaphores cr (items item))))))
    semaphores-list))

;faze krizovatky
(defmethod crossroads-phase ((cr crossroads))
  (slot-value cr 'crossroads-phase))

(defmethod set-crossroads-phase ((cr crossroads) value)
   (if (or (> value (- (phase-count cr) 1)) (< value 0))
      (error "Incorrect value (must be between 0 and ~a)" (- (phase-count cr) 1))
    (setf (slot-value cr 'crossroads-phase) value))
   (set-semaphores-by-program cr)
   cr)


;pocet fazi
(defmethod phase-count ((cr crossroads))
  (length (program cr)))

(defmethod next-phase ((cr crossroads))
  (if (<= (+ (crossroads-phase cr) 1) (- (phase-count cr) 1))
      (setf (slot-value cr 'crossroads-phase) (incf (slot-value cr 'crossroads-phase)))
    (setf (slot-value cr 'crossroads-phase) 0))
  (set-semaphores-by-program cr)
  cr)


;program krizovatky
(defmethod program ((cr crossroads))
  (slot-value cr 'program))

(defmethod set-program ((cr crossroads) value)
  (check-program cr value)
  (setf (slot-value cr 'program) value)
  (set-crossroads-phase cr 0)
  (set-semaphores-by-program cr)
  cr)

(defmethod check-program ((cr crossroads) value)
  (dolist (phase value)
    (unless (eql (length phase) (length (semaphores cr)))
      (error "The length of a phase doesn't match the amount of semaphores"))
    (let ((n 0))
      (dolist (sem-phase phase)
        (when (> sem-phase (- (phase-count (nth n (semaphores cr))) 1))
          (error 
           "Incorrect value (the program contains a phase value that is greater than a certain semaphore's phase count)" 
           sem-phase (phase-count (nth n (semaphores cr)))))
        (incf n))))
  cr)

;nastaveni semaforu podle aktualni faze programu
(defmethod set-semaphores-by-program ((cr crossroads))
  (check-program cr (program cr))
  (let ((phase (crossroads-phase cr))
        (n 0))
    (dolist (sem-phase (nth phase (program cr)))
      (set-semaphore-phase (nth n (semaphores cr)) sem-phase)
      (incf n)))
  cr)
    




#|
;;;;TESTOVACI VYRAZY

(setf w (make-instance 'window))
(setf cr (make-instance 'crossroads))
(set-shape w cr)
(set-window cr w)

(setf p1 (set-closedp (make-instance 'polygon) nil)
      p2 (set-closedp (make-instance 'polygon) nil)
      p3 (set-closedp (make-instance 'polygon) nil)
      p4 (set-closedp (make-instance 'polygon) nil))

(set-items p1 (list (set-y (set-x (make-instance 'point) 0) 80)
                    (set-y (set-x (make-instance 'point) 115) 80)
                    (set-y (set-x (make-instance 'point) 115) 0)))

(set-items p2 (list (set-y (set-x (make-instance 'point) 298) 80)
                    (set-y (set-x (make-instance 'point) 170) 80)
                    (set-y (set-x (make-instance 'point) 170) 0)))
                    

(set-items p3 (list (set-y (set-x (make-instance 'point) 0) 135)
                    (set-y (set-x (make-instance 'point) 115) 135)
                    (set-y (set-x (make-instance 'point) 115) 205)))

(set-items p4 (list (set-y (set-x (make-instance 'point) 298) 135)
                    (set-y (set-x (make-instance 'point) 170) 135)
                    (set-y (set-x (make-instance 'point) 170) 205)))

(setf sem1 (make-instance 'semaphore)
      sem2 (make-instance 'semaphore)
      sem3 (make-instance 'semaphore)
      sem4 (make-instance 'semaphore)
      sem5 (make-instance 'semaphore))

(set-semaphore-type sem5 :pedestrian)

(move sem1 120 10)
(move sem2 80 50)
(move sem3 120 140)
(move sem4 190 50)

(setf x (list p1 p2 p3 p4 sem1 sem2 sem3 sem4 sem5))

(set-items cr x)

(set-program cr (list (list 2 0 2 0 1)
                      (list 3 1 3 1 1)
                      (list 0 2 0 2 0)
                      (list 1 3 1 3 0)))

(redraw w)
(next-phase cr)

(setf pic3 (make-instance 'picture) pic2 (make-instance 'picture) pic (make-instance 'picture))

(set-items pic3 (list (make-instance 'semaphore) (make-instance 'semaphore)))
(set-items pic2 (list (make-instance 'semaphore) pic3 (make-instance 'semaphore)))
(set-items pic (list (make-instance 'semaphore) (make-instance 'semaphore) pic2))

|#