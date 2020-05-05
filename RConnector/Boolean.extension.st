Extension { #name : #Boolean }

{ #category : #'*RConnector' }
Boolean >> asRLogical [
	^ RLogical newFrom: self
]

{ #category : #'*RConnector' }
Boolean >> asRObject [
	^ RLogical newFrom: self
]
