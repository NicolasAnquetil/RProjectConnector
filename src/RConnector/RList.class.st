"
A RList class is a representation of a list of type VECEXP under R.
It is a kind of PairList. You can access it by key or by index, that is why it is a subclass of OrderedDictionary


"
Class {
	#name : #RList,
	#superclass : #RVector,
	#type : #variable,
	#instVars : [
		'keys'
	],
	#category : #'RConnector-Core'
}

{ #category : #accessing }
RList class >> arrayContentType [
	^ 'RObject'
]

{ #category : #private }
RList class >> arrayType [
	^ RObjectArray 
]

{ #category : #'private - instance creation' }
RList class >> createNewObjectFrom: aRObject [
	^ super createNewObjectFrom: aRObject
]

{ #category : #'private - instance creation' }
RList class >> firstPointer [
	^ #vector
]

{ #category : #accessing }
RList class >> keyArrayType [
	^ RStringArray
]

{ #category : #'private - instance creation' }
RList class >> new: size [
	| instance |
	instance := super new: size.
	instance
		setKeyArray: (self keyArrayType fromHandle: (ExternalAddress fromAddress: instance firstKeyPointer) type: self arrayContentType size: size).
	^ instance
]

{ #category : #creating }
RList class >> newFromDictionary: aDictionary [
	| list |
	list := self new.
	aDictionary associationsDo: [ :assoc | list addAssociation: assoc ].
	^ list
]

{ #category : #'private - instance creation' }
RList class >> primNew: size type: type [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: #errorCode>
	^ self nbCall: #(RList Rf_allocVector (int type, int size))
]

{ #category : #accessing }
RList class >> type [
	^ VECSXP
]

{ #category : #adding }
RList >> addAssociation: anAssociation [
	self assert: anAssociation key isString description: 'The key must be a string to be valid'.
	self addAt: anAssociation key value: anAssociation value.
	^ anAssociation
]

{ #category : #adding }
RList >> addAt: key value: value [
	| keyIndex |
	keyIndex := self findIndexOfKey: key.
	keyIndex isZero
		ifTrue: [ 
			self add: value.
			keys at: lastIndex put: key asRChar ]
		ifFalse: [ self halt ].

]

{ #category : #accessing }
RList >> addLast: anElement [
	super addLast: anElement asPureRObject.
	^ anElement
]

{ #category : #accessing }
RList >> asObject [
	^ (self associations collect: [ :assoc | assoc key asObject -> assoc value asObject ]) asDictionary
]

{ #category : #accessing }
RList >> associations [
	^ self withIndexCollect: [ :value :index | (keys at: index) -> (value asRObject) ]
]

{ #category : #accessing }
RList >> at: index [
	<compilerOptions: #(#- #optionInlineIfNil)>
	index ifNil: [ NotFound signal ].
	^ index indexKeyToRList: self
]

{ #category : #accessing }
RList >> at: key ifAbsent: aBlock [ 
	"Answer the value associated with the key or, if key isn't found,
	answer the result of evaluating aBlock."

	^((self atIndex: (self findElementOrNil: key)) 
			ifNil: [aBlock] 
			ifNotNil: [:assoc | assoc]) value.
]

{ #category : #accessing }
RList >> at: index put: anElement [
	^ index of: self put: anElement
]

{ #category : #adding }
RList >> at: index putValue: anElement [
	(index between: 0 and: self size)
		ifFalse: [ ^ self errorSubscriptBounds: index ].
	self prim_setVectorElement: anElement asPureRObject at: index - 1
]

{ #category : #accessing }
RList >> atIndex: index [
	self ensureBoundsFrom: index to: index.
	^ (array at: index) asRObject
]

{ #category : #accessing }
RList >> atIndex: index put: aValue [
	self ensureBoundsFrom: index to: index.
	array at: index put: aValue asPureRObject.
	keys at: index put: '' asRChar.
	^ aValue
]

{ #category : #accessing }
RList >> atKey: aKey [
	| index |
	index := self findIndexOfKey: aKey.
	index isZero
		ifTrue: [ NotFound signalFor: aKey ].
	^ self at: index
]

{ #category : #accessing }
RList >> attributes [
	<compilerOptions: #(- #optionInlineIfNil)>
	"See CCompilationContext for the options"
	^ (self prim_attributeAt: self class rNamesSymbol) asRObject 
		ifNil: [ 
			self initializeAttributeField.
			(self prim_attributeAt: self class rNamesSymbol) asRObject ]
]

{ #category : #evaluating }
RList >> evalWithFunction: aString [
	^ #'do.call'
		asRFunctionEval:
			{aString.
			self} 
]

{ #category : #private }
RList >> findIndexOfKey: anObject [
	<compilerOptions: #(- #optionInlineIfNil)>
	anObject ifNil: [ NotFound signal ].
	^ keys indexOf: anObject asRChar
]

{ #category : #private }
RList >> findIndexOfValue: aString [ 
	^ array indexOf: aString 
]

{ #category : #accessing }
RList >> first: anElement [
	
	^ self at: 1 put: anElement

]

{ #category : #private }
RList >> firstKeyPointer [
	^ self attributes collector getHandle asInteger
]

{ #category : #private }
RList >> firstPointer [
	^ self vector
]

{ #category : #accessing }
RList >> growAtLast [
	"overridden to create external objects"

	"We should recreate a new instance because there is no reallocation in the RAPI. So we swap the handles"

	"Protect and unprotect methods should be added too"

	"Overridded to support the extend of the key collection"

	| size newKeyArray |
	super growAtLast.
	size := array size.
	newKeyArray := self class keyArrayType
		fromHandle: (ExternalAddress fromAddress: self firstKeyPointer)
		type: self class arrayContentType
		size: size.
	newKeyArray
		replaceFrom: firstIndex
		to: lastIndex
		with: keys
		startingAt: firstIndex.
	keys := newKeyArray
]

{ #category : #inspecting }
RList >> gtInspectorItemsIn: composite [
	^ (composite table)
		title: [ :anObject | self size asString, ' items' ];
		display: [ self associations ];
		children: [ :each | 
			(each value isDictionary) 
				ifTrue: [ each value associations ] 
				ifFalse: [ (each value isArray and: [ each value allSatisfy: #isDictionary ])
						ifTrue: [ each value collectWithIndex: [:x :i | i -> x ] ]
						ifFalse: [ #() ] ] ];
		column: 'Key' 
			evaluated: [:each | GTObjectPrinter new asTruncatedTextFrom: each key ];
		column: 'Value' 
			evaluated: [:each | GTObjectPrinter new asTruncatedTextFrom: each value ];
		selectionAct: [ :table |
			table rawSelection do: [ :assoc | self removeKey: assoc key ].
			table update ]
			entitled: 'Remove item(s)';
		selectionPopulate: #selection 
			entitled: 'Open key'
			with: [ :table | (table rawSelection collect: #key) gtInspectorInterestingObject ];
		beMultiple;
		withSmalltalkSearch;
		send: [ :selection | 
			(selection notNil and: [ selection size = 1 ]) 
				ifTrue: [ selection anyOne value ] 
				ifFalse: [ selection collect: #value ] ];
		showOnly: 50;
		helpMessage: 'Quick selection field. Given your INPUT, it executes: self select: [:each | INPUT ]'
]

{ #category : #private }
RList >> initialize [
	super initialize.
	keys := self attributes
]

{ #category : #accessing }
RList >> initializeAttributeField [
	| length |
	length := self prim_length.
	length isZero
		ifTrue: [ {} ]
		ifFalse: [ self prim_attributeAt: self class rNamesSymbol put: (RStringVector new: length) asPureRObject ]
]

{ #category : #accessing }
RList >> keys [
	^ self attributes
]

{ #category : #'private - primitive' }
RList >> prim_attributeAt: attributeName put: attributeValue [
	^ self ffiCall: #(#SEXP #Rf_setAttrib #(#self #, #SEXP #attributeName #, #SEXP #attributeValue))
]

{ #category : #'private - primitive' }
RList >> prim_attributes [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: #errorCode>
	^ self nbCall: #(SEXP ATTRIB(self))
]

{ #category : #'private - primitive' }
RList >> prim_getAttribute: attributeName [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: #errorCode>
	^ self nbCall: #(SEXP Rf_getAttrib(self, SEXP attributeName))
]

{ #category : #'private - primitive' }
RList >> prim_installlAttributeAt: attributeName put: attributeValue [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: #errorCode>

	^ self nbCall: #(SEXP Rf_installAttrib(self, SEXP attributeName, SEXP attributeValue))
]

{ #category : #accessing }
RList >> printOn: aStream [
	self
		withIndexDo: [ :value :index | 
			aStream << (keys at: index) asString.
			aStream << '->'.
			aStream << value asRObject asString.
			aStream << '.' ]
]

{ #category : #accessing }
RList >> second: anElement [
    ^ self at: 2 put: anElement

]

{ #category : #private }
RList >> setKeyArray: aCollection [ 
	keys := aCollection
]
