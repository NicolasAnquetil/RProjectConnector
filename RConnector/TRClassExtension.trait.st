"
A TRClassExtension is containing the methods needed to be implemented on a class not depending of a NBExternalObject that should represent a external object. Don't forget to implement the three methods on instance size and add a new instance named handle (if not existing)

"
Trait {
	#name : #TRClassExtension,
	#category : #'RConnector-Core'
}

{ #category : #'trait - deprecated' }
TRClassExtension classSide >> asExternalType: gen [
	^ FFIExternalObjectType objectClass: self
]

{ #category : #'trait - converting' }
TRClassExtension classSide >> asExternalTypeOn: gen [
	^ FFIExternalObjectType objectClass: self
]

{ #category : #'trait - private - instance creation' }
TRClassExtension classSide >> basicNew [
	^ super basicNew
		initializeHandle;
		yourself
]

{ #category : #'trait - private - instance creation' }
TRClassExtension classSide >> primNew: size [
	^ self primNew: size type: self type
]

{ #category : #accessing }
TRClassExtension >> handle [
	"Code to compile : ^ handle value"
	self explicitRequirement.		

]

{ #category : #accessing }
TRClassExtension >> handle: aUint [
	"Code to compile instead : handle value: aUint"
	self explicitRequirement.		


]

{ #category : #initialization }
TRClassExtension >> initializeHandle [
	"Code to compile instead : handle := NBExternalHandle new"
	self explicitRequirement.		

	
]
