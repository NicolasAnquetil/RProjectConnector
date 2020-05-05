Class {
	#name : #REvalTest,
	#superclass : #RCollectionTest,
	#category : #'RConnector-Tests'
}

{ #category : #tests }
REvalTest >> testAccessAllAttributesOfAList [
	"
	x = c(1,  2,  3 )
	attributes(arima(x))
	$names
	 [1] coef sigma2 var.coef mask loglik aic arma
	 [8] residuals call series code n.cond model
	$class
	[1] Arima"

	| arima attribs |
	arima := RFunction
		eval: 'arima'
		withParameters:
			{(RIntVector new
				addAll:
						{1.
							2.
							3};
				yourself)}.
	self assert: (arima isKindOf: RList).
	self assert: arima isObject.
	attribs := arima attributes.
	self assert: (attribs isKindOf: RStringVector).
	self assert: attribs first value equals: 'coef'.
	self assert: attribs second value equals: 'sigma2'.
	self assert: (attribs at: 3) value equals: 'var.coef'.
	self assert: (attribs at: 4) value equals: 'mask'.
	self assert: (attribs at: 5) value equals: 'loglik'.
	self assert: (attribs at: 6) value equals: 'aic'.
	self assert: (attribs at: 7) value equals: 'arma'.
	self assert: (attribs at: 8) value equals: 'residuals'
]

{ #category : #tests }
REvalTest >> testAccessAnExistingKeyOfAList [
	"
	x = c(1,  2,  3 )
	arima(x)$coef"

	| arima |
	arima := RFunction
		eval: 'arima'
		withParameters:
			{(RIntVector new
				addAll:
						{1.
							2.
							3};
				yourself)}.
	self assert: (arima isKindOf: RList).
	self assert: arima isObject.
	self assert: ((arima at: 'coef') isKindOf: RDoubleVector).
	self assert: ((arima at: 'coef') first closeTo: 2.0)
]

{ #category : #tests }
REvalTest >> testAccessFirstOfAList [
	"
	x = c(1,  2,  3 )
	arima(x)$coef"

	| arima |
	arima := RFunction
		eval: 'arima'
		withParameters:
			{(RIntVector new
				addAll:
						{1.
							2.
							3};
				yourself)}.
	self assert: (arima isKindOf: RList).
	self assert: arima isObject.
	self assert: (arima first isKindOf: RDoubleVector).
	self assert: (arima first first closeTo: 2.0)
]

{ #category : #tests }
REvalTest >> testAccessTheClassNameOfAList [
	"
	x = c(1,  2,  3 )
	attributes(arima(x))
	$names
	 [1] coef sigma2 var.coef mask loglik aic arma
	 [8] residuals call series code n.cond model
	$class
	[1] Arima"

	| arima attribs |
	arima := RFunction
		eval: 'arima'
		withParameters:
			{(RIntVector new
				addAll:
						{1.
							2.
							3};
				yourself)}.
	self assert: (arima isKindOf: RList).
	self assert: arima isObject.
	attribs := arima rClass.
	self assert: (attribs isKindOf: RStringVector).
	self assert: attribs first value equals: 'Arima'
]
