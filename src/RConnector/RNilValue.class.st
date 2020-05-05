"
A RNilValue class is the representation of nil in R. There is only one instance in the system and it is 
self class R_NilValue.
"
Class {
	#name : #RNilValue,
	#superclass : #RObject,
	#classVars : [
		'Instance'
	],
	#category : #'RConnector-Core'
}

{ #category : #'trait - instance creation' }
RNilValue class >> createNewObjectFrom: aRObject [
	^ Instance
]

{ #category : #'class initialization' }
RNilValue class >> initializeInstance [
	Instance := self basicNew
		initialize;
		handle: self rNilValue handle;
		yourself
]

{ #category : #'instance creation' }
RNilValue class >> new [
	^ Instance 
]

{ #category : #'instance creation' }
RNilValue class >> new: aLength [
	"For upper compatibility"

	^ Instance
]

{ #category : #accessing }
RNilValue class >> type [
	^ NILSXP
]

{ #category : #converting }
RNilValue >> asRObject [
 	^ self
]

{ #category : #testing }
RNilValue >> ifNil: aBlock [
	^ aBlock value
]

{ #category : #testing }
RNilValue >> ifNotNil: aBlock [
	^ self
]

{ #category : #evaluating }
RNilValue >> value [
 	^ self class rNilValue
]
