Extension { #name : #OrderedDictionary }

{ #category : #'*RConnector' }
OrderedDictionary >> asRObject [
	^ RList newFromDictionary: self
]
