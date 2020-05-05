"
A RObject is a standard object linked to a R external element. It is the SEXP type of R (a binding is done in RLibType (to see for details)).
|----------------------------------------------------------------------------------------------------------|
| !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Warning!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! |
|  As a external library is used, you should NOT use method primitives directly      |
|  except if they are not predecessed by 'prim_'.                                                                    | 
| By the way, you can use them for debugging, but at your own risks!                         |
|----------------------------------------------------------------------------------------------------------|

The handles are freed at each startup of the image. So you have to recreate the object if you want to continue to use it.

Why this type is it need?
---------------------------------
It is this kind of object that is used to do some wrapping to the NativeBoost primitives. 
Some primitives use self inside their code so you can call them on any object, e.g. :
self nbCall: #(bool Rf_isEnvironment(self))

However, other primitives have in argument a other object of the type SEXP, e.g (it is a method for adding in first place an element):
self nbCall: #(SEXP Rf_lcons(SEXP anElement, self))

The type SEXP is inevitably needed because you can puy any element in a list. So you have to convert the R* instances in SEXP to use as argument of the primitive.
You should use: asPureRObject. It convert (almost) any subclass of Object into a RObject.

Of course in the other way, the result of some functions are SEXPs so RObjects. If you want to use them completly, you should use asRObject to transform them.
It will create a new R* object, depending of the result of method typeOf. See newFromRObject: for the implementation.


How to create functions?
---------------------------------
See RFunction and tests to create them.


Memory protection
--------------------------
R system do some garbage collect on the allocated items.
To avoid the garbage collection of the objects, use the method protect of the object.
It is not implemented for now but should be...






"
Class {
	#name : #RObject,
	#superclass : #FFIExternalObject,
	#traits : 'TRHelpers',
	#classTraits : 'TRHelpers classTrait',
	#pools : [
		'RLibTypes'
	],
	#category : #'RConnector-Core'
}

{ #category : #accessing }
RObject class >> creationType [
	^ self = RObject ifTrue: [ NILSXP ] ifFalse: [ self type ]
]

{ #category : #'trait - function finding' }
RObject class >> getRObjectFromGlobalVariable: varName [
	^ RObject new handle: (self ffiGetGlobalVariable: varName)
]

{ #category : #'instance creation' }
RObject class >> new [
	^ self new: 1
]

{ #category : #'instance creation' }
RObject class >> new: size [
	^ self primNew: size type: self creationType
]

{ #category : #'private - instance creation' }
RObject class >> primNew: size type: type [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: #errorCode>
	^ self nbCall: #(SEXP Rf_allocVector(int type, int size))
]

{ #category : #accessing }
RObject class >> type [
	^ self shouldNotImplement 
]
