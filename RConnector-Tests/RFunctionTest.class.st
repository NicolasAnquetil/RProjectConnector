"
A RFunctionTest is a test of some basic R functions.

"
Class {
	#name : #RFunctionTest,
	#superclass : #RAbstractTest,
	#category : #'RConnector-Tests'
}

{ #category : #tests }
RFunctionTest >> test1Plus1Equals2 [
	| res |
	res := RFunction
		eval: '+'
		withParameters:
			{1.
			1}.
	self assert: (res isKindOf: RIntVector).
	self assert: res first equals: 2
]

{ #category : #tests }
RFunctionTest >> test2Div1Equals2 [
	"lm(x ~ y)"

	| res |
	res := RFunction
		eval: '/'
		withParameters:
			{2.
			1}.
	self assert: (res isKindOf: RDoubleVector).
	self assert: res size equals: 1.
	self assert: res first equals: 2.
]

{ #category : #tests }
RFunctionTest >> testADefinedVariableShouldBeAbleToBeGet [
	| var |
	var := RIntVector new
		addAll:
				{1.
					2.
					3};
		yourself.
	var defineAsVarNamed: #var.
	self assert: (RObject findVar: 'var') asRObject equals: var
]

{ #category : #tests }
RFunctionTest >> testCorrelationXXShouldGiveOne [
	| rnorm  abs  res  |
	rnorm := RFunction eval:  'rnorm' withParameters: { 500 . 0 . 1 }.
	abs := RFunction eval: 'abs' withParameters: { rnorm }.
	res := RFunction eval: 'cor' withParameters: { abs . abs }.
	self assert: (res isKindOf: RDoubleVector ).
	self assert: res prim_length equals: 1.
	self assert: res size equals: 1.
	self assert: (res first closeTo: 1)
	
	
	
]

{ #category : #tests }
RFunctionTest >> testExecuteFunctionInAShorterWayShouldWork [
	| res |
	res := (#arima
		asRFunctionWith:
			{{1.
			2.
			3}}) eval.
	self assert: (res isKindOf: RList)
]

{ #category : #tests }
RFunctionTest >> testFunctionAbsFromSmalltalkCollectionShouldGiveAnAbsoluteArrayOfFloats [
	| res abs data |
	data := RIntVector new.
	data addAll: {-1. 1. 0. 51.-42}.
	abs := RFunction functionName: 'abs' parameters: {data}.
	res := abs eval.
	self assert: (res isKindOf: RIntVector).
	self assert: res prim_length equals: 5.
	self assert: res size equals: 5.
	self assert: res asOrderedCollection equals: {-1. 1. 0. 51.-42} abs asOrderedCollection.
]

{ #category : #tests }
RFunctionTest >> testFunctionCombinaisonAbsRnormShouldGiveAnArrayOfFloats [
"What we want in R: x <- abs(rnorm(500, 50, 30))"
	|  res res2 rnorm abs |
	rnorm := RFunction functionName: 'rnorm' parameters: { 500 . 50 . 30 }.
	res := rnorm eval.
	abs := RFunction functionName: 'abs' parameters: { res }.
	res2 := abs eval.
	self assert: (res2 isKindOf: RDoubleVector ).
	self assert: res2 size equals: 500.
	self deny: (res2 first = 0)	
	
	
]

{ #category : #tests }
RFunctionTest >> testLinearRegression [
	"lm(x ~ y)"

	| x y expr lm |
	x := RIntVector new
		addAll:
				{1.
					2.
					3};
		yourself.
	y := RIntVector new
		addAll:
				{4.
					5.
					6};
		yourself.
	x defineAsVarNamed: #x.
	y defineAsVarNamed: #y.
	expr := (RFunction functionName: 'as.formula' parameters: {'x~y'}) eval.	"Because x~y seems not to be a formula..."
	lm := RFunction eval: 'lm' withParameters: {expr}.
	self assert: (lm isKindOf: RList).
	self assert: ((lm at: 'coefficients') isKindOf: RVector)
]

{ #category : #tests }
RFunctionTest >> testRnormShouldGiveAnArrayOfFloats [
	| function res  |
	function := RFunction functionName: 'rnorm' parameters: { 10 }.
	res := function eval.
	self assert: (res isKindOf: RDoubleVector ).
	self assert: res prim_length equals: 10.
	self assert: res size equals: 10.
	
	
	
]

{ #category : #tests }
RFunctionTest >> testSeqShouldGiveAnArrayOfInt [
	| function res  |
	function := RFunction functionName: 'seq' parameters: { 1 . 10 }.
	res := function eval.
	self assert: (res isKindOf: RIntVector ).
	self assert: res size equals: 10.
	self assert: res asOrderedCollection equals: (1 to: 10 ) asOrderedCollection.
	
	
	
]

{ #category : #tests }
RFunctionTest >> testTimeSerieCreationWithParameters [
	| res |
	res := RFunction
		eval: 'ts'
		withListParameter:
			{('data'
				->
					{1.
					2.
					3.
					1.
					2.
					3}).
			('frequency' -> 3)}.
	self assert: (res isKindOf: RVector).
	self assert: res prim_length equals: 6.
	self assert: res size equals: 6.
	self assert: res first equals: 1
]
