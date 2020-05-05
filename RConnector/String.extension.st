Extension { #name : #String }

{ #category : #'*RConnector' }
String >> asRChar [
	^ RChar primNew: self asString
]

{ #category : #'*RConnector' }
String >> asREval [
	^ self asREval: {}
]

{ #category : #'*RConnector' }
String >> asREval: aCollection [
	"Can be used to eval anything"
	^ self asRListEval: aCollection
]

{ #category : #'*RConnector' }
String >> asREvalToSt: aCollection [
	"Can be used to eval anything"

	^ (self asRListEval: aCollection) asObject
]

{ #category : #'*RConnector' }
String >> asRFunctionEval: aCollection [
	^ RFunction eval: self asString withParameters: aCollection
]

{ #category : #'*RConnector' }
String >> asRFunctionWith: aCollection [ 
	^ RFunction functionName: self asString parameters: aCollection.
]

{ #category : #'*RConnector' }
String >> asRListEval: aKindOfList [
	^ RFunction eval: self asString withListParameter: aKindOfList
]

{ #category : #'*RConnector' }
String >> asRObject [
	^ RStringVector newFromString: self
]

{ #category : #'*RConnector' }
String >> indexKeyToRList: aRList [
	^ aRList atKey: self 
]
