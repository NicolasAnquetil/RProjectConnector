"
A RBoolVector is a RVector representing booleans

The array Type must be cached or a realsubclass for performance issues (Thx JB)
"
Class {
	#name : #RBoolVector,
	#superclass : #RVector,
	#category : #'RConnector-Core'
}

{ #category : #'trait - function finding' }
RBoolVector class >> arrayContentType [
	^ 'RLogical'
]

{ #category : #accessing }
RBoolVector class >> firstPointer [
	^ #logical
]

{ #category : #'private - instance creation' }
RBoolVector class >> primNew: size type: type [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: #errorCode>
	^ self nbCall: #(RBoolVector Rf_allocVector (int type, int size))
]

{ #category : #accessing }
RBoolVector class >> type [
	^ LGLSXP
]

{ #category : #accessing }
RBoolVector >> addLast: anElement [
	super addLast: anElement asRLogical.
	^ anElement
]

{ #category : #accessing }
RBoolVector >> firstPointer [
	^ self logical
]
