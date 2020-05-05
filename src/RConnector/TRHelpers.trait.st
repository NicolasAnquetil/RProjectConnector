"
A TRHelpers is a trait containing all the current function that can be used over any RObject.

The primitives should NOT be used directly unless you want to crash your image...

By the way, if you want to create a new primitive containing a String. Convert all 'char * ' into 'String'. because the String are null ternimated and 'char*' are not in every case
"
Trait {
	#name : #TRHelpers,
	#traits : 'TRLibrary + TRGlobals',
	#classTraits : 'TRLibrary classTrait + TRGlobals classTrait',
	#category : #'RConnector-Core'
}

{ #category : #'trait - instance creation' }
TRHelpers classSide >> createNewObjectFrom: aRObject [ 
	| instance  |
	instance := self new: aRObject prim_length.
	instance handle: aRObject handle.
	^ instance
]

{ #category : #'trait - library path' }
TRHelpers classSide >> ffiLibraryNameOrHandle [
	^ #R
]

{ #category : #'trait - function finding' }
TRHelpers classSide >> findClassOf: aRObject [
	| type  |
	type := aRObject prim_typeOf.
	^ RLibTypes implementationClassRelatedTo: type
]

{ #category : #'trait - function finding' }
TRHelpers classSide >> findFun: aStringOfFunctionName [
	^ self prim_findFun: (self prim_install: aStringOfFunctionName) option: self rGlobalEnv
]

{ #category : #'trait - function finding' }
TRHelpers classSide >> findVar: aStringOfFunctionName [
	^ self prim_findVar: (self prim_install: aStringOfFunctionName) option: self rGlobalEnv
]

{ #category : #'trait - function finding' }
TRHelpers classSide >> getRObjectFromGlobalVariable: varName [
	^ RObject new handle: (self nbGetGlobalVariable: varName)
]

{ #category : #'trait - instance creation' }
TRHelpers classSide >> newFromRObject: aRObject [
	| class |
	class := self findClassOf: aRObject.
	^ class createNewObjectFrom: aRObject 
]

{ #category : #'trait - private primitives' }
TRHelpers classSide >> prim_findFun: aNBSEXPfunction option: aNbSEXPoption [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(SEXP Rf_findFun(SEXP aNBSEXPfunction, SEXP aNbSEXPoption))
]

{ #category : #'trait - private primitives' }
TRHelpers classSide >> prim_findVar: aNBSEXPfunction option: aNbSEXPoption [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(SEXP Rf_findVar(SEXP aNBSEXPfunction, SEXP aNbSEXPoption))
]

{ #category : #'trait - private primitives' }
TRHelpers classSide >> prim_install: aString [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(SEXP Rf_install(String aString))
]

{ #category : #'trait - private primitives' }
TRHelpers classSide >> prim_isBasicClass: aString [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(int Rf_isBasicClass(String aString))
]

{ #category : #'trait - global variables' }
TRHelpers classSide >> rClassSymbol [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: #errorCode>
	^ self getRObjectFromGlobalVariable: #R_ClassSymbol
]

{ #category : #'trait - global variables' }
TRHelpers classSide >> rDimSymbol [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: #errorCode>
	^ self getRObjectFromGlobalVariable: #R_DimSymbol
]

{ #category : #'trait - converting' }
TRHelpers >> asPureRObject [
	^ RObject createNewObjectFrom: self 
]

{ #category : #'trait - converting' }
TRHelpers >> asRObject [
	^ self class newFromRObject: self 
]

{ #category : #'trait - converting' }
TRHelpers >> char [
	self isChar
		ifFalse: [ CannotBeConvertedToType signal ].
	^ self prim_char
]

{ #category : #'trait - variable definition' }
TRHelpers >> defineAsVarNamed: aRName [
	self assert: (aRName isKindOf: Symbol).	"Should be removed if the type is checked in the primitive"
	^ self defineAsVarNamed: aRName inEnv: self class rGlobalEnv 
]

{ #category : #'trait - variable definition' }
TRHelpers >> defineAsVarNamed: aRName inEnv: anEnvironment [
	^ self prim_defineAsVarNamed: aRName asRObject inEnv: anEnvironment
]

{ #category : #accessing }
TRHelpers >> dim [
	^ (self prim_attributeAt: self class rDimSymbol) asRObject
]

{ #category : #'trait - library path' }
TRHelpers >> ffiLibraryName [
 ^ self class ffiLibraryNameOrHandle
]

{ #category : #'trait - converting' }
TRHelpers >> int [
	(self typeOf = #INTSXP or: [ self isInteger ])
		ifFalse: [ CannotBeConvertedToType signal ].
	^ self prim_int
]

{ #category : #'trait - testing' }
TRHelpers >> isChar [
	^ self typeOf = #CHARSXP
  
]

{ #category : #'trait - testing' }
TRHelpers >> isComplex [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(bool Rf_isComplex(self))
]

{ #category : #'trait - testing' }
TRHelpers >> isEnvironment [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(bool Rf_isEnvironment(self))
]

{ #category : #'trait - testing' }
TRHelpers >> isExpression [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(bool Rf_isExpression(self))
]

{ #category : #'trait - testing' }
TRHelpers >> isInteger [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(bool Rf_isInteger(self))
]

{ #category : #'trait - testing' }
TRHelpers >> isList [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(bool Rf_isList(self))
]

{ #category : #'trait - testing' }
TRHelpers >> isLogical [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(bool Rf_isLogical(self))
]

{ #category : #'trait - testing' }
TRHelpers >> isMatrix [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(bool Rf_isMatrix(self))
]

{ #category : #'trait - testing' }
TRHelpers >> isNumber [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(bool Rf_isNumber(self))
]

{ #category : #'trait - testing' }
TRHelpers >> isNumeric [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(bool Rf_isNumeric(self))
]

{ #category : #'trait - testing' }
TRHelpers >> isObject [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(bool Rf_isObject(self))
]

{ #category : #'trait - testing' }
TRHelpers >> isPairList [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(bool Rf_isPairList(self))
]

{ #category : #'trait - testing' }
TRHelpers >> isRNull [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(bool Rf_isNull(self))
]

{ #category : #'trait - testing' }
TRHelpers >> isReal [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(bool Rf_isReal(self))
]

{ #category : #'trait - testing' }
TRHelpers >> isS4Object [
	"int (IS_S4_OBJECT)(SEXP x); -> bool because it is the same in C"
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(bool IS_S4_OBJECT(self))
]

{ #category : #'trait - testing' }
TRHelpers >> isString [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(bool Rf_isString(self))
]

{ #category : #'trait - testing' }
TRHelpers >> isSymbol [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(bool Rf_isSymbol(self))
]

{ #category : #'trait - testing' }
TRHelpers >> isValidString [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(bool Rf_isValidString(self))
]

{ #category : #'trait - testing' }
TRHelpers >> isVector [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(bool Rf_isVector(self))
]

{ #category : #'trait - testing' }
TRHelpers >> isVectorList [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(bool Rf_isVectorList(self))
]

{ #category : #'trait - converting' }
TRHelpers >> logical [
	self isLogical ifFalse: [ CannotBeConvertedToType signal ].
	^ self prim_logical
]

{ #category : #'private - primitive' }
TRHelpers >> prim_attributeAt: attributeName [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: #errorCode>
	^ self nbCall: #(SEXP Rf_getAttrib(self, SEXP attributeName))
]

{ #category : #'trait - private primitives' }
TRHelpers >> prim_char [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(String R_CHAR(self))
]

{ #category : #'trait - private primitives' }
TRHelpers >> prim_copyVectorFrom: anOldString [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(void Rf_copyVector(SEXP self, SEXP anOldString))
]

{ #category : #'trait - private primitives' }
TRHelpers >> prim_curErrorBuf [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(String R_curErrorBuf())
]

{ #category : #'trait - private primitives' }
TRHelpers >> prim_defineAsVarNamed: name inEnv: anEnvironment [ 
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(void Rf_defineVar(SEXP name, self, SEXP anEnvironment))
]

{ #category : #'trait - private primitives' }
TRHelpers >> prim_dimgets: val [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(SEXP Rf_dimgets(self, SEXP val))
]

{ #category : #'trait - private primitives' }
TRHelpers >> prim_dimnamesgets: val [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(SEXP Rf_dimnamesgets(self, SEXP val))
]

{ #category : #'trait - private primitives' }
TRHelpers >> prim_getArrayDimnames [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(SEXP Rf_GetArrayDimnames(self))
]

{ #category : #'trait - private primitives' }
TRHelpers >> prim_int [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ (self
        nbCall: #(ulong INTEGER(self))) 
]

{ #category : #'trait - private primitives' }
TRHelpers >> prim_length [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        ffiCall: #(int Rf_length(self))
]

{ #category : #'trait - private primitives' }
TRHelpers >> prim_list_ptr [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(ulong LIST_POINTER(self))
]

{ #category : #'trait - private primitives' }
TRHelpers >> prim_logical [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(ulong LOGICAL(self))
]

{ #category : #'trait - private primitives' }
TRHelpers >> prim_named [
	"int -> bool because it is the same in C"
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(bool NAMED(self))
]

{ #category : #'trait - private primitives' }
TRHelpers >> prim_ncols [
	"No type testing ...Should only use on the right type (Matrix)"
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(int Rf_ncols(self))
]

{ #category : #'trait - private primitives' }
TRHelpers >> prim_nrows [
"No type testing ...Should only use on the right type (Matrix)"
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(int Rf_nrows(self))
]

{ #category : #'trait - private primitives' }
TRHelpers >> prim_real [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(ulong REAL(self))
]

{ #category : #'trait - private primitives' }
TRHelpers >> prim_setVectorElement: element at: index [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(SEXP SET_VECTOR_ELT(self, int index, SEXP element))
]

{ #category : #'trait - private primitives' }
TRHelpers >> prim_stringElementAt: index [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(SEXP STRING_ELT(self, int index))
]

{ #category : #'trait - private primitives' }
TRHelpers >> prim_string_ptr [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(ulong STRING_PTR(self))
]

{ #category : #'trait - private primitives' }
TRHelpers >> prim_symbolValue [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(SEXP SYMVALUE(self))
]

{ #category : #'trait - private primitives' }
TRHelpers >> prim_typeOf [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(int TYPEOF(self))
]

{ #category : #'trait - private primitives' }
TRHelpers >> prim_vectorElementAt: index [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(SEXP VECTOR_ELT(self, int index))
]

{ #category : #'trait - private primitives' }
TRHelpers >> prim_vector_ptr [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	self error: 'Must not be used !'.
    ^ self
        nbCall: #(ulong VECTOR_PTR(self))
]

{ #category : #'trait - not used' }
TRHelpers >> prim_xlength [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(int Rf_xlength(self))
]

{ #category : #'trait - not used' }
TRHelpers >> print [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(void Rf_PrintValue(self))
]

{ #category : #'trait - memory protection' }
TRHelpers >> protect [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(SEXP Rf_protect(self))
]

{ #category : #accessing }
TRHelpers >> rClass [
	^ (self prim_attributeAt: self class rClassSymbol) asRObject
]

{ #category : #'trait - not used' }
TRHelpers >> raw [
    <primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
    ^ self
        nbCall: #(uchar RAW(self))
]

{ #category : #'trait - converting' }
TRHelpers >> real [
	self isReal ifFalse: [ CannotBeConvertedToType signal ].
	^ self prim_real
]

{ #category : #'trait - converting' }
TRHelpers >> string [
	self isString
		ifFalse: [ CannotBeConvertedToType signal ].
	^ self prim_string_ptr
]

{ #category : #'trait - accessing' }
TRHelpers >> typeOf [
	^ RLibTypes typeRelatedToNumber: self prim_typeOf

]

{ #category : #'trait - accessing' }
TRHelpers >> types [
	^ RObject selectors select: [ :s | ((s beginsWith: #is) and: [ self perform: s ] )] 
]

{ #category : #'trait - converting' }
TRHelpers >> vector [
	"A vector_ptr function exists but doesn't work on vectors..... So we use the string one."
	self isVector
		ifFalse: [ CannotBeConvertedToType signal ].
	^ self prim_string_ptr
]
