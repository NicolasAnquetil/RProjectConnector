Class {
	#name : #RFunctionUtils,
	#superclass : #Object,
	#category : #'RConnector-Utils'
}

{ #category : #'as yet unclassified' }
RFunctionUtils class >> recordAsPdfNamed: aString operations: aBlockClosure [
	[ 
	'pdf' asREval: {aString}.
	aBlockClosure value ]
		ensure: [ 'dev.off' asREval: {} ]
]

{ #category : #'as yet unclassified' }
RFunctionUtils >> seeClassSide [
]
