Extension { #name : #Symbol }

{ #category : #'*RConnector' }
Symbol >> asRObject [
	^ RSymbol newFromSymbol: self
]
