"
A RLogical is a representation of a boolean under R.
"
Class {
	#name : #RLogical,
	#superclass : #RObject,
	#category : #'RConnector-Core'
}

{ #category : #'instance creation' }
RLogical class >> newFrom: aBoolean [
	^ self primNewFrom: aBoolean asBit
]

{ #category : #'private - instance creation' }
RLogical class >> primNewFrom: aBooleanAsInt [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: #errorCode>
	^ self nbCall: #(RLogical Rf_ScalarLogical(int aBooleanAsInt))
]

{ #category : #comparing }
RLogical >> = anElement [
	^ self value = anElement value value
]

{ #category : #converting }
RLogical >> asRLogical [
	^ self
]

{ #category : #comparing }
RLogical >> hash [
	^ self value hash
]

{ #category : #printing }
RLogical >> printOn: aStream [
	aStream << self value
]

{ #category : #evaluating }
RLogical >> value [
	self halt.
	^ self logical unpackFromArity: 2
]
