"
A TRGlobals is a trait that defines global variables available in R.

"
Trait {
	#name : #TRGlobals,
	#category : #'RConnector-Core'
}

{ #category : #'trait - global variables' }
TRGlobals classSide >> rBaseEnv [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: #errorCode>
	^ self getRObjectFromGlobalVariable: #R_BaseEnv
]

{ #category : #'trait - global variables' }
TRGlobals classSide >> rClassSymbol [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: #errorCode>
	^ self getRObjectFromGlobalVariable: #rClassSymbol
]

{ #category : #'trait - global variables' }
TRGlobals classSide >> rEmptyEnv [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: #errorCode>
	^ self getRObjectFromGlobalVariable: #R_EmptyEnv
]

{ #category : #'trait - global variables' }
TRGlobals classSide >> rGlobalEnv [
	^ self getRObjectFromGlobalVariable: #R_GlobalEnv
]

{ #category : #'trait - global variables' }
TRGlobals classSide >> rNamesSymbol [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: #errorCode>
	^ self getRObjectFromGlobalVariable: #R_NamesSymbol
]

{ #category : #'trait - global variables' }
TRGlobals classSide >> rNilValue [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: #errorCode>
	^ self getRObjectFromGlobalVariable: #R_NilValue
]
