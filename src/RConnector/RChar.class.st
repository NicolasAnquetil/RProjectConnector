"
A RChar is the representation of a non mutable string in R. And yes that is a string and not a character...: http://www1.cuni.cz/~obo/r_surprises.html

"
Class {
	#name : #RChar,
	#superclass : #RObject,
	#category : #'RConnector-Core'
}

{ #category : #'trait - instance creation' }
RChar class >> createNewObjectFrom: aRObject [ 
	| instance  |
	instance := self new: aRObject char.
	instance handle: aRObject handle.
	^ instance
]

{ #category : #'trait - private - instance creation' }
RChar class >> primNew: aString [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: #errorCode>
	^ self nbCall: #(RChar Rf_mkChar(String aString))
]

{ #category : #'private - instance creation' }
RChar class >> primNew: size type: type [
	^ self primNew: size
]

{ #category : #accessing }
RChar class >> type [
	^ CHARSXP
]

{ #category : #comparing }
RChar >> = anElement [
	^ self value = anElement value
]

{ #category : #converting }
RChar >> asObject [
	^ self value
]

{ #category : #converting }
RChar >> asRChar [
	^ self
]

{ #category : #comparing }
RChar >> hash [
	^ self value hash
]

{ #category : #printing }
RChar >> printOn: aStream [
	aStream << ${.
	aStream << self value.
	aStream << $}
]

{ #category : #evaluating }
RChar >> value [
	^ self char
]
