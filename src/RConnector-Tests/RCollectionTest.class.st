Class {
	#name : #RCollectionTest,
	#superclass : #RAbstractTest,
	#category : #'RConnector-Tests'
}

{ #category : #tests }
RCollectionTest >> testConversionRObjectToSubTypeOfRObject [
	| data  dataExternalArrayHandle rObject newData |
	data := RIntVector new.
	data
		addAll:
			{-1.
			1.
			0.
			51.
			-42}.
	dataExternalArrayHandle := data collector getHandle.
	rObject := data asPureRObject.
	newData := rObject asRObject.
	self assert: data int equals: newData collector getHandle asInteger.
	self assert: data int equals: dataExternalArrayHandle value.
	self assert:  newData collector  getHandle asInteger  equals: dataExternalArrayHandle value.
	
	
]

{ #category : #tests }
RCollectionTest >> testConversionRObjectToSubTypeOfRObject2 [
	| data dataExternalArrayHandle rObject newData |
	data := RIntVector new.
	dataExternalArrayHandle := data collector getHandle.
	rObject := data asPureRObject.
	newData := rObject asRObject.
	self assert: data int equals: newData collector getHandle asInteger.
	self assert: data int equals: dataExternalArrayHandle value.
	self assert: newData collector getHandle asInteger equals: dataExternalArrayHandle value
]

{ #category : #tests }
RCollectionTest >> testDoubleVectorSet [
	| vector |
	vector := RDoubleVector new: 1.
	vector add: 1.2.
	self assert: (vector at: 1) equals: 1.2
]

{ #category : #tests }
RCollectionTest >> testIntVectorSet [
	| vector |
	vector := RIntVector new: 1.
	vector add: 12.
	self assert: (vector at: 1) equals: 12
]

{ #category : #tests }
RCollectionTest >> testIntVectorSetOverFlowCapacity [
	| vector |
	vector := RIntVector new: 1.
	vector add: 12.
	vector add: 22.
	self assert: (vector at: 1) equals: 12.
	self assert: (vector at: 2) equals: 22.
	self assert: vector prim_length equals: 2."the true length for R"
	
]

{ #category : #tests }
RCollectionTest >> testIntVectorSetWithAddAll [
	| data |
	data := RIntVector new.
	data
		addAll:
			{-1.
			1.
			0.
			51.
			-42}.
	self assert: data prim_length equals: 5.
	self assert: data size equals: 5
]

{ #category : #tests }
RCollectionTest >> testStringAccess [
	| string |
	string := 'string' asRObject.
	self assert: (string isKindOf: RStringVector).
	self assert: string value equals: 'string'.
]

{ #category : #tests }
RCollectionTest >> testStringVectorAddChar [
	"A char under R is an equivalent of a smalltalk string"
	| vector |
	vector := RStringVector new.
	vector add: '1.2'.
	self assert: (vector at: 1) value equals: '1.2'
]

{ #category : #tests }
RCollectionTest >> testStringVectorAddSeveralChars [
	"A char under R is an equivalent of a smalltalk string"

	| vector |
	vector := RStringVector new.
	vector add: '1.2'.
	vector add: '12'.
	vector add: 'A String'.
	self assert: (vector at: 1) value equals: '1.2'.
	self assert: (vector at: 2) value equals: '12'.
	self assert: (vector at: 3) value equals: 'A String'
]
