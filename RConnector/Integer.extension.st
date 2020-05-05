Extension { #name : #Integer }

{ #category : #'*RConnector' }
Integer >> asRObject [
	^ RInt newFrom: self
]

{ #category : #'*RConnector' }
Integer >> indexKeyToRList: aRList [
	^ aRList atIndex: self 
]

{ #category : #'*RConnector' }
Integer >> of: aRList put: aValue [
	^ aRList atIndex: self put: aValue
]
