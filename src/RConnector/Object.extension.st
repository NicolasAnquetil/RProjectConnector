Extension { #name : #Object }

{ #category : #'*RConnector' }
Object >> asPureRObject [
	^ self asRObject asPureRObject
]

{ #category : #'*RConnector' }
Object >> ffiGetGlobalVariable: variableName [
	^ self ffiGetGlobalVariable: variableName module: self ffiLibraryNameOrHandle
]

{ #category : #'*RConnector' }
Object >> ffiGetGlobalVariable: variableName module: aModule [
	^ (ExternalAddress loadSymbol: variableName module: aModule)
		unpackFromArity: 2
]
