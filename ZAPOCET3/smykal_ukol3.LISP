;;;ukol 10.1

[true add "OR" :value {(arg1) true}]
[false add "OR" :value {(arg1) arg1}]

#|
[[true or true] name]
[[true or false] name]
[[false or true] name]
[[false or false] name]
|#

[true add "NOT" :value false]
[false add "NOT" :value true]

#|
[[true not] name]
[[false not] name]
|#


;;;ukol 10.2

[object add "IS-NIHIL" :value false]
[nihil set-is-nihil true]

#|
[[object is-nihil] name]
[[nihil is-nihil] name]
|#


;;;ukol 10.3

[lobby add "PAIR" :value [object clone]]
[pair set-name "PAIR"]
[pair add "CAR"]
[pair add "CDR"]
[pair add "CONS" :value {(arg1 arg2) [self set-car arg1] [self set-cdr arg2]}]

#|
[[pair cons 1 :arg2 2] name]
[[pair cons 1 :arg2 2] car]
[[pair cons 1 :arg2 2] car]
|#

[lobby add "EMPTY-LIST" :value [pair clone]]
[empty-list set-name "EMPTY-LIST"]
[empty-list set-cdr nihil]
[empty-list set-car nihil]

[lobby add "LIST" :value [pair clone]]
[list set-name "LIST"]

#|
[list cons 1 :arg2 [[list clone] cons 2 :arg2 [[list clone] cons 3 :arg2 empty-list]]]
[list car]
[[[list cdr] cdr] car]
[[[[list cdr] cdr] cdr] name]
|#

;;;ukol 10.4

[object add "IS-LIST" :value false]

[pair add "IS-LIST" :value {() [[self is empty-list] if-true true
                                :else [[self cdr] is-list]]}]

#|
[pair cons 1 :arg2 2]
[list cons 1 :arg2 [[list clone] cons 2 :arg2 [[list clone] cons 3 :arg2 empty-list]]]
[[pair is-list] name]
[[list is-list] name]
[[empty-list is-list] name]
|#



;;;ukol 10.5

[empty-list add "LENGTH" :value [0 esoteric]]

[list add "LENGTH" :value {() [[[self cdr] is empty-list] if-true [1 esoteric]
                               :else [[1 esoteric] + [[self cdr] length]]]}]

#|
[list cons 1 :arg2 [[list clone] cons 2 :arg2 [[list clone] cons 3 :arg2 empty-list]]]
[[empty-list length] name]
[[list length] name]
|#


;;;ukol 10.6
[list add "APPEND" :value {(arg1) [[[self cdr] is empty-list] 
                                   if-true {() [self set-cdr arg1]}
                                   :else {() [[self cdr] append arg1]}]}]

#|
[list cons 1 :arg2 [[list clone] cons 2 :arg2 [[list clone] cons 3 :arg2 empty-list]]]
[list append [[list clone] cons 4 :arg2 [[list clone] cons 5 :arg2 empty-list]]]
[[[[list cdr] cdr] cdr] car]
|#

[empty-list add "FIND" :value nihil]

[list add "FIND" :value {(arg1) [[self is empty-list] if-true nihil
                         :else [[[self car] equals arg1] if-true [self car]
                                :else {() [[self cdr] find arg1]}]]}]


#|
[list cons [1 esoteric] :arg2 [[list clone] cons [2 esoteric] :arg2 empty-list]]
[[list find [2 esoteric]] name]
[[[list find [2 esoteric]] equals [2 esoteric]] name]
[[list find 3] name]
|#



;;;ukol 10.9

[zero add "*" :value {(arg1) self}]
[one add "*" :value {(arg1) arg1}]
[[one succ] add "*" :value {(arg1) [self + [[arg1 super] * self]]}]

#|
[[[3 esoteric] * [2 esoteric]] name]
|#

[zero add "-" :value {(arg1) [[[arg1 name] is 0]
                              if-true {() self}
                              :else {}]}]

[one add "-" :value {(arg1) [[arg1 is self] if-true {() zero}
                             :else {() [[[arg1 name] is 0] if-true {() self}
                                        :else {}]}]}]

[[one succ] add "-" :value {(arg1) [[arg1 is self] if-true {() zero}
                                    :else {() [[[arg1 name] is 0] if-true {() self}
                                               :else {() [[self super] - [arg1 super]]}]}]}]

#|
[[[5 esoteric] - [3 esoteric]] name]
|#


;;;10.10
[object add "ERROR" :value (lambda (self arg1 &key)
                             (declare (ignore self))
                             (error arg1))]

;nevim, jestli chapu spravne

#|
[object error "Something went wrong."]
|#