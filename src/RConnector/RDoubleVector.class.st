"
A RDoubleVector is a RVector representing doubles (not floats).

The array Type must be cached or a realsubclass for performance issues (Thx JB)
"
Class {
	#name : #RDoubleVector,
	#superclass : #RVector,
	#category : #'RConnector-Core'
}

{ #category : #'trait - function finding' }
RDoubleVector class >> arrayContentType [
	^ 'double'
]

{ #category : #accessing }
RDoubleVector class >> firstPointer [
	^ #real
]

{ #category : #'private - instance creation' }
RDoubleVector class >> primNew: size type: type [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: #errorCode>
	^ self nbCall: #(RDoubleVector Rf_allocVector (int type, int size))
]

{ #category : #accessing }
RDoubleVector class >> type [
	^ REALSXP
]

{ #category : #accessing }
RDoubleVector >> firstPointer [
	^ self real
]
