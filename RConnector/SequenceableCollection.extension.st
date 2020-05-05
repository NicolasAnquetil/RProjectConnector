Extension { #name : #SequenceableCollection }

{ #category : #'*RConnector' }
SequenceableCollection >> asRObject [
	(self anySatisfy: #isFloat)
		ifTrue: [ ^ RDoubleVector newFrom: self ].
	(self anySatisfy: #isInteger)
		ifTrue: [ ^ RIntVector newFrom: self ].
	(self allSatisfy: #isString)
		ifTrue: [ ^ RStringVector newFrom: self ].
	(self allSatisfy: [ :item | item isKindOf: Boolean ])
		ifTrue: [ ^ RBoolVector newFrom: self ].
	^ CannotBeConvertedToType signal
]
