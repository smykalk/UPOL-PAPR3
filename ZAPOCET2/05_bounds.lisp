;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 05_bounds.lisp - p��klad ke kapitole 5
;;;;


#|

Roz���en� t��dy shape a jej�ch potomk� o metody left, top, right, bottom.

|#

(defmethod left ((shape shape))
  +1D++0 #| +1D++0 is double-float plus-infinity |#)

(defmethod top ((shape shape))
  +1D++0 #| +1D++0 is double-float plus-infinity |#)

(defmethod right ((shape shape))
  -1D++0 #| -1D++0 is double-float minus-infinity |#)

(defmethod bottom ((shape shape))
  -1D++0 #| -1D++0 is double-float minus-infinity |#)

(defmethod left ((shape point))
  (x shape))

(defmethod top ((shape point))
  (y shape))

(defmethod right ((shape point))
  (x shape))

(defmethod bottom ((shape point))
  (y shape))

(defmethod left ((shape circle))
  (- (x (center shape)) (radius shape)))

(defmethod top ((shape circle))
  (- (y (center shape)) (radius shape)))

(defmethod right ((shape circle))
  (+ (x (center shape)) (radius shape)))

(defmethod bottom ((shape circle))
  (+ (y (center shape)) (radius shape)))

(defmethod left ((shape compound-shape))
  (if (items shape)
      ;; reduce je v tomto p��pad� ekvivalentn� s apply,
      ;; ale bezpe�n�j��. Detaily nejsou podstatn�.
      (reduce 'min (mapcar 'left (items shape)))
    (call-next-method)))

(defmethod top ((shape compound-shape))
  (if (items shape)
      (reduce 'min (mapcar 'top (items shape)))
    (call-next-method)))

(defmethod right ((shape compound-shape))
  (if (items shape)
      (reduce 'max (mapcar 'right (items shape)))
    (call-next-method)))

(defmethod bottom ((shape compound-shape))
  (if (items shape)
      (reduce 'max (mapcar 'bottom (items shape)))
    (call-next-method)))

