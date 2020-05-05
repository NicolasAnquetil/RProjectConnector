"
A RSession class is a class checking that the R sesssion is well initialized. Indeed before any action in the R lib, Rf_initEmbedded should be ran. Nethertheless, this action is automaticaly done at statup (see startUp impl) but the remaining pointers from the last session are still be there. 

The method invalidateOldHandles should be implemented to do that.

"
Class {
	#name : #RSession,
	#superclass : #Object,
	#traits : 'TRLibrary',
	#classTraits : 'TRLibrary classTrait',
	#classVars : [
		'RSession'
	],
	#pools : [
		'RLibTypes'
	],
	#category : #'RConnector-Core'
}

{ #category : #private }
RSession class >> Rf_endEmbeddedR [
	"Seems to crashes the image when launched. So it is not used at shutdown."
	^ self prim_endEmbeddedR: 0
]

{ #category : #private }
RSession class >> checkLibs [
	 self isExistsRf_initEmbeddedR ifFalse: [ Error signal: 'The R lib cannot be used. Please install the libraries in the Pharo.exe folder' ]
]

{ #category : #private }
RSession class >> checkSession [ 
	(RSession ~~ Smalltalk session)
		ifTrue: [ 
			RSession := Smalltalk session.
			RLibTypes initialize.
			self initEmbeddedR: #('R' '--no-save' 'silent') ]
]

{ #category : #private }
RSession class >> checkWorking [
	(self unif_rand between: 0 and: 1)
		ifFalse: [ Error signal: 'Should not be false' ]
]

{ #category : #private }
RSession class >> initEmbeddedR: parameters [
	| externalArray |
	externalArray := (RArrayOfStrings externalNew: parameters size) autoRelease.
	parameters withIndexDo: [ :string :index | externalArray at: index put: (ExternalAddress fromString: string) ].
	self prim_initEmbeddedRargc: parameters size argv: externalArray
]

{ #category : #'class initialization' }
RSession class >> initialize [
	Smalltalk addToStartUpList: self.
	
]

{ #category : #'system startup' }
RSession class >> invalidateOldHandles [
	self flag: 'To implement'.
]

{ #category : #testing }
RSession class >> isExistsRf_initEmbeddedR [
	^ [ (Alien lookupOrNil: 'Rf_initEmbeddedR' inLibrary: #R) isNotNil ]
		on: PrimitiveFailed
		do: [ self error: 'Please check that you use the right libraries!' ]
]

{ #category : #'private - primitives' }
RSession class >> prim_endEmbeddedR: arg [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(int  Rf_endEmbeddedR( int arg ))
]

{ #category : #'private - primitives' }
RSession class >> prim_initEmbeddedRargc: argc argv: argv [
   
    ^ self
        ffiCall: #(int Rf_initEmbeddedR(int argc, RArrayOfStrings argv))
]

{ #category : #'private - primitives' }
RSession class >> prim_install: aLibName [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(SEXP Rf_install(String aLibName))
]

{ #category : #'system startup' }
RSession class >> startUp [
	[ self checkLibs.
	self checkSession.
	self checkWorking.
	self invalidateOldHandles. ] on: Error do: [ :e | self error: 'The R session is not well initialized at startUp...' ]
]

{ #category : #'stats functions' }
RSession class >> unif_rand [
 
    ^ self
        ffiCall: #( double unif_rand(void) )
        module: #R
]
