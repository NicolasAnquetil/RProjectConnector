Extension { #name : #Dictionary }

{ #category : #'*RConnector' }
Dictionary >> asRObject [
	^ RList newFromDictionary: self
]
