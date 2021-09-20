#|
;;;;DOKUMENTACE

//////////////////////
Pro nove tridy grafickych objektu uzivatel musi nadefinovat vlastnost properties vracejici seznam
vlastnosti daneho objektu (viz. nize)
Pokud jde o slozeny graficky objekt, je zapotrebi jeste nadefinovat vlastnost(metodu) solidp
vracejici t

Pro bulls-eye tedy:

(defmethod solidp ((be bulls-eye))
  t)

(defmethod properties ((be bulls-eye))
  (append (call-next-method) '(window radius item-count squarep)))

//////////////////////
TRIDA INSPECTOR-WINDOW

VLASTNOSTI
----------

inspected-window - instance okna inspected-window, o jehoz obsahu se v inspectoru zobrazuji informace

inspected-item - konkretni objekt, o kterem se prave zobrazuji informace

Vlastnost shape by u tohoto objektu nemel uzivatel nastavovat, je nastavovana prislusnymi metodami
podle prohlizenych objektu

ZPETNA VOLANI
-------------

double-click - zpetne volani pro dvojite poklepani - obsluhovano stejne, jako obycejne kliknuti


//////////////////////
TRIDA INSPECTED-WINDOW

funguje stejne, jako instance klasickeho okna tridy window



|#

;;;Metody pro zjisteni vlastnosti jednotlivych objektu
(defmethod properties ((o omg-object))
  '())

(defmethod properties ((w window))
  (append (call-next-method) '(mg-window shape background)))

(defmethod properties ((s shape))
  (append (call-next-method) '(window color thickness filledp)))

(defmethod properties ((p point))
  (append (call-next-method) '(x y r phi)))

(defmethod properties ((c circle))
  (append (call-next-method) '(radius center)))

(defmethod properties ((p polygon))
  (append (call-next-method) '(closedp items)))

;;;Pomocna funkce pro text-shape
(defun make-text-shape (x y string)
  (move (set-text (make-instance 'text-shape) string) x y))


;;;Pomocna funkce, vraci seznam instanci text-shape, ktere obsahuji vzdy vlastnost a jeji hodnotu
(defun build-text (shape)
  (let ((text-shape-list '())
        (n 1))
    (setf text-shape-list
          (cons (make-text-shape 0 (* n 15) (format nil "Object: ~s   Class: ~s" shape (type-of shape))) 
                text-shape-list))   
    (dolist (prop (properties shape))
      (incf n)
      (setf text-shape-list 
            (cons (make-text-shape 0 (* n 15) (format nil "~s : ~s" prop (funcall prop shape))) 
                  text-shape-list)))
    (reverse text-shape-list)))


;;;Dotaz na zadani hodnoty od uzivatele
(defun value-dialog ()
  (multiple-value-list (capi:prompt-for-value "Zadejte novou hodnotu")))


;;;set tvar metody
(defun setter-name (prop)
  (values (find-symbol (format nil "SET-~a" prop))))

;;;
;;;trida inspector-window
;;;
(defclass inspector-window (window)
  ((inspected-window :initform nil)
   (inspected-item :initform nil)))

(defmethod initialize-instance ((w inspector-window) &key)
  (call-next-method)
  (install-callbacks w)
  w)

;obnoveni textu v okne pri zmene vlastnosti inspected item nebo zmene
;objektu, ktery je v inspected item
(defmethod update-text ((w inspector-window) inspected)
  (set-shape w (set-items (make-instance 'picture) (build-text inspected))))

(defmethod inspected-window ((w inspector-window))
  (slot-value w 'inspected-window))

(defmethod set-inspected-window ((w inspector-window) inspected)
  (setf (slot-value w 'inspected-window) inspected)
  (set-delegate inspected w)
  (set-inspected-item w inspected)
  w)

(defmethod inspected-item ((w inspector-window))
  (slot-value w 'inspected-item))

(defmethod set-inspected-item ((w inspector-window) inspected)
  (setf (slot-value w 'inspected-item) inspected)
  (update-text w inspected)
  w)

;Pri zmene objektu v prohlizenem okne se overi, zda se zmenil objekt, ktery si prohlizime
;v inspectoru, pokud ano, v inspektoru se text obnovi, aby ukazoval spravne hodnoty
(defmethod ev-change ((w inspector-window) sender message changed-obj args)
  (when (eql changed-obj (inspected-item w))
    (update-text w changed-obj))
  (call-next-method))

;klik do inspected-window nastavi do inspected-item budto shape, na ktery se kliklo, nebo
;v pripade kliku mimo tvar se nastavi okno
(defmethod ev-click-inside-inspected ((w inspector-window) iw clicked)
  (set-inspected-item w clicked))

;Dvojklik - podle toho, jestli se kliklo na shape, se zavolaji dve ruzne metody, stejne jako
;u normalniho kliknuti
(defmethod window-double-click ((w inspector-window) button position)
  (let ((shape (find-clicked-shape w position)))
    (if shape
        (mouse-double-click-inside-shape w shape button position)
      (mouse-double-click-no-shape w button position))))

;Dvojklik na text s vlastnosti otevre dialogove okno, do ktereho uzivatel zada novou hodnotu vlastnosti
;probiha overeni, jestli vlastnost neni read-only
(defmethod mouse-double-click-inside-shape ((w inspector-window) shape button pos)
  (when (> (position shape (items (shape w))) 0)
    (let ((index (- (position shape (items (shape w))) 1))
          (props (properties (inspected-item w)))
          (value (value-dialog)))
      (when (and (cadr value);uzivatel nezadal cancel
                 (has-method-p (inspected-item w)
                               (setter-name (nth index props))
                               (list value)));ma set-metodu
          (funcall (setter-name (nth index props)) (inspected-item w) (car value))))))

(defmethod mouse-double-click-no-shape ((w inspector-window) button pos)
  w) 



;;;DVOJKLIK - callback pro inspector-window

(defmethod install-double-click-callback ((w inspector-window))
  (mg:set-callback 
   (mg-window w) 
   :double-click (lambda (mgw button x y)
		 (declare (ignore mgw))
		 (window-double-click 
                  w
                  button 
                  (move (make-instance 'point) x y)))))



;;;trida inspected-window

(defclass inspected-window (window)
  ())

;kliknuti posle cil kliknuti delegatovi (inspector-window), ktery se postara o dalsi ulohy
(defmethod window-mouse-down ((w inspected-window) button position)
  (let ((shape (find-clicked-shape w position))) 
    (if shape
        (send-event w 'ev-click-inside-inspected shape)
      (send-event w 'ev-click-inside-inspected w))))
      

    
            





