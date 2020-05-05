"
A RStringArray class is representing a external array of RChar (this is strings for R). 
The TRHelper trait should not be used here because is just a transition type that should not be public.
"
Class {
	#name : #RStringArray,
	#superclass : #FFIExternalArray,
	#pools : [
		'RLibTypes'
	],
	#category : #'RConnector-Core'
}

{ #category : #'as yet unclassified' }
RStringArray class >> externalNew: size [ 
	^ self externalNewType: RChar size: size
]

{ #category : #'class initialization' }
RStringArray class >> type [
	^ CHARSXP
]

{ #category : #'trait - copying' }
RStringArray >> at: index [
	^ (RObject new handle: (super at: index)) asRObject
]

{ #category : #'trait - copying' }
RStringArray >> at: index put: anObject [
	| shouldBeAnExternalAddressOrNot externalAddress |
	shouldBeAnExternalAddressOrNot := anObject getHandle.
	externalAddress := shouldBeAnExternalAddressOrNot isExternalAddress
		ifTrue: [ shouldBeAnExternalAddressOrNot ]
		ifFalse: [ shouldBeAnExternalAddressOrNot getHandle ].
	^ super at: index put: externalAddress
]
