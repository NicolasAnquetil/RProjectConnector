Extension { #name : #Float }

{ #category : #'*RConnector' }
Float >> asRObject [
	^ RDoubleVector newFrom: {self}
]
