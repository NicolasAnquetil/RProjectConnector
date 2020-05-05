"
A RVector is is an abstract reprensentation of a vector in R. Its subclasses OrdreredCollection to use all the potential of the class. Some functions could be not working since the collection attached to the vector is a subclass of NBExternalArray instead of an Array.


Instance Variables
	handle:		a NBExternalHandle

handle
	- the handle represents (as in NBExternalObject) the pointer to the R external object. The array containing the data (is the vector elements) is included in the R external object and his pointer can be accessed by the firstPointer method (see subclasses for impl). This pointer should NOT be reallocated with the methods of NBExternalArray. A new RVector object  has to be created with the Rf_AllocVector primitive and the handles swapped (see growAtLast for impl).


"
Class {
	#name : #RVector,
	#superclass : #OrderedCollection,
	#traits : 'TRClassExtension + (TRHelpers - {#prim_attributeAt:})',
	#classTraits : 'TRHelpers classTrait + TRClassExtension classTrait',
	#instVars : [
		'handle'
	],
	#pools : [
		'RLibTypes'
	],
	#classInstVars : [
		'arrayType'
	],
	#category : #'RConnector-Core'
}

{ #category : #accessing }
RVector class >> arrayContentType [
	^ self subclassResponsibility
]

{ #category : #accessing }
RVector class >> arrayType [
	"This value has to be cached or be a real subclass for performances issues."

	^ FFIExternalArray
]

{ #category : #'as yet unclassified' }
RVector class >> createArrayFromPointer: pointerAddress size: aSize [
	^ self arrayType fromHandle: (ExternalAddress fromAddress: pointerAddress) type: self arrayContentType size: aSize
]

{ #category : #'instance creation' }
RVector class >> createNewObjectFrom: aRObject [
	| instance |
	instance := self basicNew handle: aRObject handle.
	instance setCollection: (self createArrayFromPointer: (aRObject perform: self firstPointer) size: aRObject prim_length).
	instance initialize.
	instance resetToExternalCollection.
	^ instance
]

{ #category : #'trait - function finding' }
RVector class >> getRObjectFromGlobalVariable: varName [
	^ RObject new handle: (self ffiGetGlobalVariable: varName)
]

{ #category : #'instance creation' }
RVector class >> new [
	"If the array is not initialized at size 1 first. Then some synchronization problems with the external array can appears..."
	^ self new: 1
]

{ #category : #'instance creation' }
RVector class >> new: size [
	| instance |
	self assert: size > 0 description: 'The initial size should not be zero!'.
	instance := self primNew: size.
	instance setCollection: (self createArrayFromPointer: instance firstPointer size: size).
	^ instance
]

{ #category : #'private - instance creation' }
RVector class >> primNew: size type: type [
	^ self subclassResponsibility  
]

{ #category : #accessing }
RVector class >> reset [
	self allSubclassesDo: [ :subclass | subclass resetArrayType ]
]

{ #category : #accessing }
RVector class >> resetArrayType [
	arrayType := nil
]

{ #category : #accessing }
RVector class >> type [
	^ self subclassResponsibility
]

{ #category : #adding }
RVector >> addFirst: anElement [
	self shouldNotImplement
]

{ #category : #adding }
RVector >> addLast: anElement [
	super addLast: anElement.
	self setLength: self size	"((self size) min: self capacity)"
]

{ #category : #converting }
RVector >> asObject [
	^ self collect: #value
]

{ #category : #converting }
RVector >> asRObject [
	^ self
]

{ #category : #accessing }
RVector >> firstPointer [
	^ self subclassResponsibility 
]

{ #category : #private }
RVector >> growAtLast [
	"overridden to create external objects"

	"We should recreate a new instance because there is no reallocation in the RAPI. So we swap the handles"

	"Protect and unprotect methods should be added too"

	| newArray newInstance size |
	size := array size * 2 max: 1.
	newInstance := self class primNew: size.
	self handle: newInstance handle.
	newArray := self class createArrayFromPointer: newInstance firstPointer size: size.
	newArray
		replaceFrom: firstIndex
		to: lastIndex
		with: array
		startingAt: firstIndex.
	array := newArray
]

{ #category : #accessing }
RVector >> handle [
	^ handle


]

{ #category : #accessing }
RVector >> handle: anHandle [
	handle := anHandle



]

{ #category : #initialization }
RVector >> initialize [
	firstIndex := 1.
	lastIndex := (self capacity)
]

{ #category : #initialization }
RVector >> initializeHandle [
	handle := ExternalAddress new

	
]

{ #category : #'private - primitive' }
RVector >> prim_attributeAt: attributeName [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: #errorCode>
	^ self nbCall: #(SEXP Rf_getAttrib(self, SEXP attributeName))
]

{ #category : #private }
RVector >> resetToExternalCollection [
	lastIndex := self prim_length
]

{ #category : #private }
RVector >> setLength: length [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        ffiCall: #(void SETLENGTH(self, int length))
]

{ #category : #private }
RVector >> species [
	^ OrderedCollection
]

{ #category : #'private - notused' }
RVector >> truelength [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(int TRUELENGTH(self))
]
