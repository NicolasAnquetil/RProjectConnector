"
A RLangageExpression is a language based list.  It is like a linked chain and the results can be evaluated.
His type is LANGSXP under R.
A RLangageExpression as almost the same behaviour than a chained list under smallatalk.

You should use add* if you want to add sucessives elements to the list.
If you use first:, second: ,... the list is also created but with possible missing items.

You should not create a langagelist too long else you cannot access the elements (I don't implement the sequencial accessors).


Maybe it should extend the LinkedList class but it seems complicated to represents the cells of the list.


"
Class {
	#name : #RLangageExpression,
	#superclass : #RObject,
	#instVars : [
		'size'
	],
	#category : #'RConnector-Core'
}

{ #category : #'instance creation' }
RLangageExpression class >> newEmptyChainedList [
	^ self new
		reset;
		yourself
]

{ #category : #'private - instance creation' }
RLangageExpression class >> primNew: size type: type [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: #errorCode>
	^ self nbCall: #(#RLangageExpression #Rf_allocVector #(#int #type #, #int #size))
]

{ #category : #accessing }
RLangageExpression class >> type [ 
	^ LANGSXP 
]

{ #category : #adding }
RLangageExpression >> add: anElement [
	^ self addLast: anElement 
]

{ #category : #private }
RLangageExpression >> add: anElement direction: aBlock [
	"Mean to factorize code of the add function"
	size ifNil: [ size := 0 ] "lazy initializing but should not be coded like that..".
	size = 0
		ifTrue: [ self transfertHandleFrom: (self prim_firstAdd: anElement asPureRObject) ]
		ifFalse: [ self transfertHandleFrom: (aBlock value: anElement asPureRObject) ].
	size := size + 1.
	^ anElement
]

{ #category : #adding }
RLangageExpression >> addAll: aCollection [
	aCollection do: [ :item | self add: item asRObject ].
	^ aCollection
]

{ #category : #adding }
RLangageExpression >> addFirst: anElement [
	^ self add: anElement direction: [ :elem | self prim_addFirst: elem ]
]

{ #category : #adding }
RLangageExpression >> addLast: anElement [
	^ self add: anElement direction: [ :elem | self prim_addLast: (self prim_firstAdd: elem) ]
]

{ #category : #evaluating }
RLangageExpression >> eval [
	| res error |
	error := ExternalAddress gcallocate: ExternalAddress wordSize.
	self prim_length < 1
		ifTrue: [ CannotExecuteRemoteCall signal ].
	res := self prim_tryEval: self class rGlobalEnv error: error.
	res isNull ifTrue: [ REvaluationError signal: self prim_curErrorBuf ].
	res protect.
	^ res asRObject
]

{ #category : #accessing }
RLangageExpression >> first [
	^ self ffiCall: #(#SEXP #CAR #(#self))
]

{ #category : #adding }
RLangageExpression >> first: element [
    ^ self
        ffiCall: #(SEXP SETCAR(self, SEXP element))

]

{ #category : #accessing }
RLangageExpression >> fourth [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(SEXP CADDDR(self))

]

{ #category : #adding }
RLangageExpression >> fourth: anElement [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(SEXP SETCADDDR(self, SEXP anElement))

]

{ #category : #private }
RLangageExpression >> initialize [
	super initialize.
	size := 0.
]

{ #category : #'private - primitive' }
RLangageExpression >> prim_addFirst: anElement [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: #errorCode>
	^ self nbCall: #(SEXP Rf_lcons(SEXP anElement, self))

	
]

{ #category : #'private - primitive' }
RLangageExpression >> prim_addLast: anElement [
	"The element to append should be a list else the chained list is not null terminated and some problems can happens..."
 
	^ self ffiCall: #(SEXP Rf_listAppend (self, SEXP anElement))
]

{ #category : #'private - primitive' }
RLangageExpression >> prim_firstAdd: anElement [
	^ self ffiCall: #(#SEXP #Rf_lang1 #(#SEXP #anElement))
]

{ #category : #'private - primitive' }
RLangageExpression >> prim_tryEval: env error: errorOccurred [
	^ self ffiCall: #(#SEXP #R_tryEval #(#self #, #SEXP #env #, #int #* #errorOccurred))
]

{ #category : #private }
RLangageExpression >> reset [
	size := 0
]

{ #category : #accessing }
RLangageExpression >> second [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: #errorCode>
	^ self nbCall: #(SEXP CADR (self))
]

{ #category : #adding }
RLangageExpression >> second: element [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(SEXP SETCADR(self, SEXP element))

]

{ #category : #accessing }
RLangageExpression >> size [
	handle isNull ifTrue: [ ^ 0 ].
	^ self prim_length
]

{ #category : #accessing }
RLangageExpression >> tag [
	"tag is the name representing the element in a list"
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: #errorCode>
	^ self nbCall: #(SEXP TAG (self))
]

{ #category : #accessing }
RLangageExpression >> third [
	^ self ffiCall: #(#SEXP #CADDR #(#self))
]

{ #category : #adding }
RLangageExpression >> third: element [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(SEXP SETCADDR(self, SEXP element))

]

{ #category : #private }
RLangageExpression >> transfertHandleFrom: aRObject [
	self handle: aRObject handle

]
