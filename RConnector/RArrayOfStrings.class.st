Class {
	#name : #RArrayOfStrings,
	#superclass : #FFIExternalArray,
	#pools : [
		'RLibTypes'
	],
	#category : #'RConnector-Core'
}

{ #category : #'instance creation' }
RArrayOfStrings class >> externalNew: size [ 
	^ self externalNewType: 'void*' size: size
]
